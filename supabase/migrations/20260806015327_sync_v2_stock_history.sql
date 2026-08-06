create function public.sync_apply_stock_batch(
  p_empresa_id uuid,
  p_commands jsonb
)
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  command_item jsonb;
  results jsonb := '[]'::jsonb;
  current_operation_id uuid;
  produto_id uuid;
  quantidade_delta integer;
  produto record;
  stored_command jsonb;
  stored_state text;
  stored_result jsonb;
  inserted_mutation boolean;
  new_quantity integer;
  result_item jsonb;
  safe_message text;
begin
  perform app_private.assert_tenant(p_empresa_id);

  if jsonb_typeof(p_commands) <> 'array'
      or jsonb_array_length(p_commands) > 200 then
    raise exception 'Lote de estoque inválido ou maior que 200 comandos.'
      using errcode = '22023';
  end if;

  for command_item in
    select value from jsonb_array_elements(p_commands)
  loop
    begin
      current_operation_id := nullif(command_item->>'operation_id', '')::uuid;
      produto_id := nullif(command_item->>'produto_id', '')::uuid;
      quantidade_delta := nullif(command_item->>'quantidade_delta', '')::integer;

      if current_operation_id is null
          or produto_id is null
          or quantidade_delta is null
          or quantidade_delta = 0 then
        raise exception 'Movimento de estoque inválido.' using errcode = '22023';
      end if;

      insert into app_private.sync_mutations (
        empresa_id, operation_id, command_type, command
      ) values (
        p_empresa_id, current_operation_id, 'sync_stock_batch', command_item
      ) on conflict do nothing returning true into inserted_mutation;

      select sm.command, sm.state, sm.result
      into stored_command, stored_state, stored_result
      from app_private.sync_mutations sm
      where sm.empresa_id = p_empresa_id
        and sm.operation_id = current_operation_id
      for update;

      if not coalesce(inserted_mutation, false) then
        if stored_command is distinct from command_item then
          raise exception 'operation_id já utilizado por outro comando.'
            using errcode = '23505';
        end if;
        if stored_state = 'completed' and stored_result is not null then
          results := results || jsonb_build_array(stored_result);
          continue;
        end if;
        raise exception 'Operação idempotente ainda está em processamento.'
          using errcode = '55P03';
      end if;

      select p.id, p.quantidade_estoque, p.row_version, p.ativo, p.deleted_at
      into produto
      from public.produtos p
      where p.id = produto_id
        and p.empresa_id = p_empresa_id
      for update;

      if not found then
        raise exception 'Produto inexistente.' using errcode = '23503';
      end if;
      if produto.ativo is not true or produto.deleted_at is not null then
        raise exception 'Produto inativo.' using errcode = '23514';
      end if;

      if (command_item ? 'preco_custo'
          and (command_item->>'preco_custo')::numeric < 0)
          or (command_item ? 'valor_venda'
          and (command_item->>'valor_venda')::numeric < 0) then
        raise exception 'Preço de produto inválido.' using errcode = '22023';
      end if;

      new_quantity := produto.quantidade_estoque + quantidade_delta;
      if new_quantity < 0 then
        raise exception 'Estoque resultante inválido.' using errcode = '23514';
      end if;

      update public.produtos
      set quantidade_estoque = new_quantity,
          preco_custo = case
            when command_item ? 'preco_custo'
              then (command_item->>'preco_custo')::numeric
            else preco_custo
          end,
          valor_venda = case
            when command_item ? 'valor_venda'
              then (command_item->>'valor_venda')::numeric
            else valor_venda
          end,
          fornecedor = case
            when command_item ? 'fornecedor' then command_item->>'fornecedor'
            else fornecedor
          end
      where id = produto_id and empresa_id = p_empresa_id;

      result_item := jsonb_build_object(
        'operation_id', current_operation_id,
        'status', 'success',
        'produto_id', produto_id,
        'quantidade_estoque', new_quantity,
        'row_version', produto.row_version + 1
      );

      update app_private.sync_mutations sm
      set state = 'completed', result = result_item, updated_at = now()
      where sm.empresa_id = p_empresa_id and sm.operation_id = current_operation_id;

      results := results || jsonb_build_array(result_item);
    exception
      when others then
        safe_message := case sqlstate
          when '22023' then 'Dados ou comando inválidos.'
          when '22P02' then 'Dados ou identificador inválidos.'
          when '23503' then 'Produto inexistente.'
          when '23505' then 'operation_id já utilizado.'
          when '23514' then 'Regra de estoque violada.'
          when '55P03' then 'Operação ainda em processamento.'
          else 'Movimento de estoque rejeitado pelo banco.'
        end;

        if current_operation_id is not null then
          update app_private.sync_mutations sm
          set state = 'failed',
              error = jsonb_build_object('code', sqlstate, 'message', safe_message),
              updated_at = now()
          where sm.empresa_id = p_empresa_id and sm.operation_id = current_operation_id;
        end if;

        results := results || jsonb_build_array(jsonb_build_object(
          'operation_id', command_item->>'operation_id',
          'status', 'error',
          'code', sqlstate,
          'message', safe_message
        ));
    end;
  end loop;

  return results;
end
$$;

create function public.sync_history_period_page(
  p_empresa_id uuid,
  p_from date,
  p_to date,
  p_before timestamptz default null,
  p_before_id uuid default null,
  p_limit integer default 50
)
returns table(
  record_id uuid,
  data_venda timestamptz,
  snapshot jsonb,
  next_before timestamptz,
  next_before_id uuid
)
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  cutoff_date date := timezone('America/Sao_Paulo', now())::date - interval '12 months';
  cursor_date timestamptz;
  cursor_id uuid;
  page_limit integer := greatest(1, least(coalesce(p_limit, 50), 100));
begin
  perform app_private.assert_tenant(p_empresa_id);

  if p_from is null or p_to is null or p_from > p_to then
    raise exception 'Intervalo histórico inválido.' using errcode = '22023';
  end if;
  if p_to >= cutoff_date then
    raise exception 'O histórico remoto deve ser anterior aos últimos 12 meses.'
      using errcode = '22023';
  end if;
  if p_to - p_from > 90 then
    raise exception 'O intervalo histórico não pode exceder 90 dias.'
      using errcode = '22023';
  end if;
  if p_before is null and p_before_id is not null then
    raise exception 'Cursor de histórico incompleto.' using errcode = '22023';
  end if;

  cursor_date := coalesce(
    p_before,
    cutoff_date::timestamp at time zone 'America/Sao_Paulo'
  );
  cursor_id := coalesce(
    p_before_id,
    'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid
  );

  return query
  with page as (
    select
      v.id,
      v.data_venda,
      jsonb_build_object(
        'venda', jsonb_build_object(
          'id', v.id,
          'empresa_id', v.empresa_id,
          'cliente_id', v.cliente_id,
          'data_venda', v.data_venda,
          'valor_total', v.valor_total,
          'valor_entrada', v.valor_entrada,
          'desconto', v.desconto,
          'tipo_pagamento', v.tipo_pagamento,
          'observacoes', v.observacoes,
          'legacy_id', v.legacy_id,
          'row_version', v.row_version
        ),
        'cliente', (
          select jsonb_build_object('id', c.id, 'nome', c.nome, 'celular', c.celular)
          from public.clientes c
          where c.id = v.cliente_id and c.empresa_id = p_empresa_id
        ),
        'itens', coalesce((
          select jsonb_agg(jsonb_build_object(
            'id', i.id,
            'venda_id', i.venda_id,
            'produto_id', i.produto_id,
            'quantidade', i.quantidade,
            'preco_unitario', i.preco_unitario,
            'custo_unitario', i.custo_unitario,
            'row_version', i.row_version,
            'produto', (
              select jsonb_build_object('id', p.id, 'nome', p.nome, 'categoria', p.categoria)
              from public.produtos p
              where p.id = i.produto_id and p.empresa_id = p_empresa_id
            )
          ) order by i.id)
          from public.itens_venda i
          where i.venda_id = v.id
            and i.empresa_id = p_empresa_id
            and i.deleted_at is null
        ), '[]'::jsonb),
        'parcelas', coalesce((
          select jsonb_agg(jsonb_build_object(
            'id', pa.id,
            'empresa_id', pa.empresa_id,
            'venda_id', pa.venda_id,
            'numero_parcela', pa.numero_parcela,
            'valor', pa.valor,
            'data_vencimento', pa.data_vencimento,
            'data_pagamento', pa.data_pagamento,
            'status', pa.status,
            'row_version', pa.row_version
          ) order by pa.numero_parcela, pa.id)
          from public.parcelas pa
          where pa.venda_id = v.id
            and pa.empresa_id = p_empresa_id
            and pa.deleted_at is null
        ), '[]'::jsonb)
      ) as snapshot
    from public.vendas v
    where v.empresa_id = p_empresa_id
      and v.deleted_at is null
      and v.data_venda >= p_from::timestamp at time zone 'America/Sao_Paulo'
      and v.data_venda < (p_to + 1)::timestamp at time zone 'America/Sao_Paulo'
      and (p_before is null or (v.data_venda, v.id) < (cursor_date, cursor_id))
    order by v.data_venda desc, v.id desc
    limit page_limit + 1
  ), numbered as (
    select
      page.*,
      row_number() over (order by page.data_venda desc, page.id desc) as row_number,
      count(*) over () as total_count
    from page
  ), visible as (
    select * from numbered where row_number <= page_limit
  ), next_cursor as (
    select visible.data_venda, visible.id
    from visible
    order by visible.data_venda desc, visible.id desc
    offset page_limit - 1
    limit 1
  )
  select
    visible.id,
    visible.data_venda,
    visible.snapshot,
    case when visible.total_count > page_limit
      then (select next_cursor.data_venda from next_cursor)
      else null
    end,
    case when visible.total_count > page_limit
      then (select next_cursor.id from next_cursor)
      else null
    end
  from visible
  order by visible.data_venda desc, visible.id desc;
end
$$;

revoke execute on function public.sync_apply_stock_batch(uuid, jsonb)
from public, anon;
revoke execute on function public.sync_history_period_page(
  uuid, date, date, timestamptz, uuid, integer
) from public, anon;

grant execute on function public.sync_apply_stock_batch(uuid, jsonb)
to authenticated;
grant execute on function public.sync_history_period_page(
  uuid, date, date, timestamptz, uuid, integer
) to authenticated;
