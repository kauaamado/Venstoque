create schema if not exists app_private;
revoke all on schema app_private from public, anon, authenticated;

alter table public.clientes
  add column row_version bigint not null default 1,
  add column updated_at timestamptz not null default now(),
  add column deleted_at timestamptz;

alter table public.produtos
  add column row_version bigint not null default 1,
  add column updated_at timestamptz not null default now(),
  add column deleted_at timestamptz;

alter table public.vendas
  add column row_version bigint not null default 1,
  add column updated_at timestamptz not null default now(),
  add column deleted_at timestamptz;

alter table public.itens_venda
  add column row_version bigint not null default 1,
  add column updated_at timestamptz not null default now(),
  add column deleted_at timestamptz,
  add column empresa_id uuid;

alter table public.parcelas
  add column row_version bigint not null default 1,
  add column updated_at timestamptz not null default now(),
  add column deleted_at timestamptz;

do $$
begin
  if exists (
    select 1
    from public.itens_venda i
    left join public.vendas v on v.id = i.venda_id
    where v.id is null
  ) then
    raise exception 'Existem itens_venda sem uma venda válida.'
      using errcode = '23503';
  end if;
end
$$;

update public.itens_venda i
set empresa_id = v.empresa_id
from public.vendas v
where v.id = i.venda_id;

create function app_private.set_item_tenant()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  sale_empresa_id uuid;
begin
  select v.empresa_id
  into sale_empresa_id
  from public.vendas v
  where v.id = new.venda_id;

  if sale_empresa_id is null then
    raise exception 'Venda inválida para o item.' using errcode = '23503';
  end if;

  if new.empresa_id is not null and new.empresa_id <> sale_empresa_id then
    raise exception 'O item e a venda devem pertencer à mesma empresa.'
      using errcode = '23514';
  end if;

  new.empresa_id := sale_empresa_id;
  return new;
end
$$;

revoke all on function app_private.set_item_tenant()
from public, anon, authenticated;

create trigger itens_venda_set_tenant
before insert or update of venda_id, empresa_id
on public.itens_venda
for each row
execute function app_private.set_item_tenant();

alter table public.itens_venda
  alter column empresa_id set not null,
  add constraint itens_venda_empresa_id_fkey
    foreign key (empresa_id) references public.empresas(id);

create index clientes_empresa_id_id_idx
  on public.clientes (empresa_id, id);
create index clientes_empresa_ativo_id_idx
  on public.clientes (empresa_id, ativo, id)
  where deleted_at is null;
create index produtos_empresa_id_id_idx
  on public.produtos (empresa_id, id);
create index produtos_empresa_ativo_id_idx
  on public.produtos (empresa_id, ativo, id)
  where deleted_at is null;
create index vendas_empresa_id_id_idx
  on public.vendas (empresa_id, id);
create index vendas_empresa_data_id_idx
  on public.vendas (empresa_id, data_venda desc, id desc)
  where deleted_at is null;
create index vendas_cliente_id_idx
  on public.vendas (cliente_id);
create index itens_venda_empresa_id_id_idx
  on public.itens_venda (empresa_id, id);
create index itens_venda_venda_id_idx
  on public.itens_venda (venda_id);
create index itens_venda_produto_id_idx
  on public.itens_venda (produto_id);
create index parcelas_empresa_id_id_idx
  on public.parcelas (empresa_id, id);
create index parcelas_venda_id_idx
  on public.parcelas (venda_id);
create index parcelas_venda_pendente_idx
  on public.parcelas (venda_id)
  where status = 'pendente' and deleted_at is null;

create function app_private.set_sync_metadata()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
begin
  if (to_jsonb(new) - array['row_version', 'updated_at'])
      is distinct from
      (to_jsonb(old) - array['row_version', 'updated_at']) then
    new.row_version := old.row_version + 1;
    new.updated_at := statement_timestamp();
  else
    new.row_version := old.row_version;
    new.updated_at := old.updated_at;
  end if;

  return new;
end
$$;

revoke all on function app_private.set_sync_metadata()
from public, anon, authenticated;

create table app_private.sync_changes (
  change_id bigint generated always as identity primary key,
  empresa_id uuid not null references public.empresas(id),
  entity text not null
    check (entity in ('clientes', 'produtos', 'vendas', 'itens_venda', 'parcelas')),
  record_id uuid not null,
  operation text not null check (operation in ('insert', 'update', 'delete')),
  row_version bigint not null check (row_version > 0),
  snapshot jsonb not null,
  changed_at timestamptz not null default now()
);

create index sync_changes_empresa_change_idx
  on app_private.sync_changes (empresa_id, change_id);

create function app_private.capture_sync_change()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  changed_row record;
  change_operation text;
begin
  if tg_op = 'UPDATE' and new.row_version = old.row_version then
    return new;
  end if;

  if tg_op = 'DELETE' then
    changed_row := old;
    change_operation := 'delete';
  else
    changed_row := new;
    change_operation := case
      when tg_op = 'INSERT' then 'insert'
      when old.deleted_at is null and new.deleted_at is not null then 'delete'
      else 'update'
    end;
  end if;

  insert into app_private.sync_changes (
    empresa_id,
    entity,
    record_id,
    operation,
    row_version,
    snapshot
  ) values (
    changed_row.empresa_id,
    tg_table_name,
    changed_row.id,
    change_operation,
    changed_row.row_version,
    to_jsonb(changed_row)
  );

  if tg_op = 'DELETE' then
    return old;
  end if;

  return new;
end
$$;

revoke all on function app_private.capture_sync_change()
from public, anon, authenticated;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'clientes',
    'produtos',
    'vendas',
    'itens_venda',
    'parcelas'
  ] loop
    execute format(
      'create trigger %I_sync_metadata before update on public.%I '
      'for each row execute function app_private.set_sync_metadata()',
      table_name,
      table_name
    );
    execute format(
      'create trigger %I_sync_change after insert or update or delete '
      'on public.%I for each row '
      'execute function app_private.capture_sync_change()',
      table_name,
      table_name
    );
  end loop;
end
$$;

create table app_private.sync_mutations (
  empresa_id uuid not null references public.empresas(id),
  operation_id uuid not null,
  command_type text not null,
  command jsonb not null,
  state text not null default 'processing'
    check (state in ('processing', 'completed', 'failed')),
  result jsonb,
  error jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (empresa_id, operation_id)
);

alter table app_private.sync_changes enable row level security;
alter table app_private.sync_mutations enable row level security;

create policy sync_changes_select_tenant
on app_private.sync_changes
for select
to authenticated
using (
  (select auth.uid()) is not null
  and empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
);

create policy sync_mutations_select_tenant
on app_private.sync_mutations
for select
to authenticated
using (
  (select auth.uid()) is not null
  and empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
);

create policy sync_mutations_insert_tenant
on app_private.sync_mutations
for insert
to authenticated
with check (
  (select auth.uid()) is not null
  and empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
);

create policy sync_mutations_update_tenant
on app_private.sync_mutations
for update
to authenticated
using (
  (select auth.uid()) is not null
  and empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
)
with check (
  (select auth.uid()) is not null
  and empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
);

revoke all on app_private.sync_changes, app_private.sync_mutations
from public, anon, authenticated;
grant usage on schema app_private to authenticated;
grant select on app_private.sync_changes to authenticated;
grant select, insert, update on app_private.sync_mutations to authenticated;

create function app_private.assert_tenant(p_empresa_id uuid)
returns void
language plpgsql
stable
security invoker
set search_path = pg_catalog
as $$
begin
  if auth.uid() is null then
    raise exception 'Sessão autenticada obrigatória.' using errcode = '42501';
  end if;

  if nullif(auth.jwt()->'app_metadata'->>'empresa_id', '')::uuid
      is distinct from p_empresa_id then
    raise exception 'Empresa não autorizada.' using errcode = '42501';
  end if;
end
$$;

revoke all on function app_private.assert_tenant(uuid) from public, anon;
grant execute on function app_private.assert_tenant(uuid) to authenticated;

create function public.sync_begin(p_empresa_id uuid)
returns jsonb
language plpgsql
stable
security invoker
set search_path = pg_catalog
as $$
declare
  current_cursor bigint;
  offline_cutoff timestamptz := (
    (timezone('America/Sao_Paulo', now())::date - interval '12 months')
    at time zone 'America/Sao_Paulo'
  );
begin
  perform app_private.assert_tenant(p_empresa_id);

  select coalesce(max(sc.change_id), 0)
  into current_cursor
  from app_private.sync_changes sc
  where sc.empresa_id = p_empresa_id;

  return jsonb_build_object(
    'cursor', current_cursor,
    'cutoff', offline_cutoff,
    'bootstrap_page_max', 500,
    'batch_max', 200
  );
end
$$;

create function public.sync_bootstrap_page(
  p_empresa_id uuid,
  p_entity text,
  p_after_id uuid default null,
  p_limit integer default 200
)
returns table(record_id uuid, row_version bigint, snapshot jsonb)
language plpgsql
stable
security invoker
set search_path = pg_catalog
as $$
declare
  page_limit integer := greatest(1, least(coalesce(p_limit, 200), 500));
  first_id constant uuid :=
    '00000000-0000-0000-0000-000000000000'::uuid;
  offline_cutoff timestamptz := (
    (timezone('America/Sao_Paulo', now())::date - interval '12 months')
    at time zone 'America/Sao_Paulo'
  );
begin
  perform app_private.assert_tenant(p_empresa_id);

  if p_entity = 'clientes' then
    return query
    select c.id, c.row_version, to_jsonb(c)
    from public.clientes c
    where c.empresa_id = p_empresa_id
      and c.deleted_at is null
      and c.id > coalesce(p_after_id, first_id)
      and (
        c.ativo is true
        or exists (
          select 1
          from public.vendas v
          where v.cliente_id = c.id
            and v.empresa_id = p_empresa_id
            and v.deleted_at is null
            and (
              v.data_venda >= offline_cutoff
              or exists (
                select 1
                from public.parcelas pending
                where pending.venda_id = v.id
                  and pending.status = 'pendente'
                  and pending.deleted_at is null
              )
            )
        )
      )
    order by c.id
    limit page_limit;
  elsif p_entity = 'produtos' then
    return query
    select p.id, p.row_version, to_jsonb(p)
    from public.produtos p
    where p.empresa_id = p_empresa_id
      and p.deleted_at is null
      and p.id > coalesce(p_after_id, first_id)
      and (
        p.ativo is true
        or exists (
          select 1
          from public.itens_venda i
          join public.vendas v on v.id = i.venda_id
          where i.produto_id = p.id
            and i.deleted_at is null
            and v.empresa_id = p_empresa_id
            and v.deleted_at is null
            and (
              v.data_venda >= offline_cutoff
              or exists (
                select 1
                from public.parcelas pending
                where pending.venda_id = v.id
                  and pending.status = 'pendente'
                  and pending.deleted_at is null
              )
            )
        )
      )
    order by p.id
    limit page_limit;
  elsif p_entity = 'vendas' then
    return query
    select v.id, v.row_version, to_jsonb(v)
    from public.vendas v
    where v.empresa_id = p_empresa_id
      and v.deleted_at is null
      and v.id > coalesce(p_after_id, first_id)
      and (
        v.data_venda >= offline_cutoff
        or exists (
          select 1
          from public.parcelas pending
          where pending.venda_id = v.id
            and pending.status = 'pendente'
            and pending.deleted_at is null
        )
      )
    order by v.id
    limit page_limit;
  elsif p_entity = 'itens_venda' then
    return query
    select i.id, i.row_version, to_jsonb(i)
    from public.itens_venda i
    join public.vendas v on v.id = i.venda_id
    where i.empresa_id = p_empresa_id
      and i.deleted_at is null
      and v.deleted_at is null
      and i.id > coalesce(p_after_id, first_id)
      and (
        v.data_venda >= offline_cutoff
        or exists (
          select 1
          from public.parcelas pending
          where pending.venda_id = v.id
            and pending.status = 'pendente'
            and pending.deleted_at is null
        )
      )
    order by i.id
    limit page_limit;
  elsif p_entity = 'parcelas' then
    return query
    select pa.id, pa.row_version, to_jsonb(pa)
    from public.parcelas pa
    join public.vendas v on v.id = pa.venda_id
    where pa.empresa_id = p_empresa_id
      and pa.deleted_at is null
      and v.deleted_at is null
      and pa.id > coalesce(p_after_id, first_id)
      and (
        v.data_venda >= offline_cutoff
        or exists (
          select 1
          from public.parcelas pending
          where pending.venda_id = v.id
            and pending.status = 'pendente'
            and pending.deleted_at is null
        )
      )
    order by pa.id
    limit page_limit;
  else
    raise exception 'Entidade de bootstrap inválida.' using errcode = '22023';
  end if;
end
$$;

create function public.sync_pull_changes(
  p_empresa_id uuid,
  p_after_change_id bigint default 0,
  p_limit integer default 200
)
returns table(
  change_id bigint,
  entity text,
  record_id uuid,
  operation text,
  row_version bigint,
  snapshot jsonb,
  changed_at timestamptz
)
language plpgsql
stable
security invoker
set search_path = pg_catalog
as $$
begin
  perform app_private.assert_tenant(p_empresa_id);

  return query
  select
    sc.change_id,
    sc.entity,
    sc.record_id,
    sc.operation,
    sc.row_version,
    sc.snapshot,
    sc.changed_at
  from app_private.sync_changes sc
  where sc.empresa_id = p_empresa_id
    and sc.change_id > greatest(coalesce(p_after_change_id, 0), 0)
  order by sc.change_id
  limit greatest(1, least(coalesce(p_limit, 200), 500));
end
$$;

create function public.sync_history_page(
  p_empresa_id uuid,
  p_before timestamptz default null,
  p_before_id uuid default null,
  p_limit integer default 100
)
returns table(record_id uuid, data_venda timestamptz, snapshot jsonb)
language plpgsql
stable
security invoker
set search_path = pg_catalog
as $$
declare
  offline_cutoff timestamptz := (
    (timezone('America/Sao_Paulo', now())::date - interval '12 months')
    at time zone 'America/Sao_Paulo'
  );
  cursor_date timestamptz := least(coalesce(p_before, offline_cutoff), offline_cutoff);
  cursor_id uuid := coalesce(
    p_before_id,
    'ffffffff-ffff-ffff-ffff-ffffffffffff'::uuid
  );
begin
  perform app_private.assert_tenant(p_empresa_id);

  if p_before is null and p_before_id is not null then
    raise exception 'Cursor de histórico incompleto.' using errcode = '22023';
  end if;

  return query
  select
    v.id,
    v.data_venda,
    jsonb_build_object(
      'venda', to_jsonb(v),
      'itens', coalesce(
        (
          select jsonb_agg(to_jsonb(i) order by i.id)
          from public.itens_venda i
          where i.venda_id = v.id
            and i.deleted_at is null
        ),
        '[]'::jsonb
      ),
      'parcelas', coalesce(
        (
          select jsonb_agg(to_jsonb(pa) order by pa.numero_parcela, pa.id)
          from public.parcelas pa
          where pa.venda_id = v.id
            and pa.deleted_at is null
        ),
        '[]'::jsonb
      )
    )
  from public.vendas v
  where v.empresa_id = p_empresa_id
    and v.deleted_at is null
    and v.data_venda < offline_cutoff
    and (
      p_before is null
      or (v.data_venda, v.id) < (cursor_date, cursor_id)
    )
  order by v.data_venda desc, v.id desc
  limit greatest(1, least(coalesce(p_limit, 100), 200));
end
$$;

create function public.create_sale_graph(
  p_empresa_id uuid,
  p_operation_id uuid,
  p_cliente_id uuid,
  p_data_venda timestamptz,
  p_valor_total numeric,
  p_valor_entrada numeric,
  p_desconto numeric,
  p_tipo_pagamento text,
  p_observacoes text,
  p_legacy_id bigint,
  p_itens jsonb,
  p_parcelas jsonb
)
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  sale_id uuid := gen_random_uuid();
  item jsonb;
  installment jsonb;
  product record;
  command_payload jsonb;
  existing_command_type text;
  existing_command jsonb;
  existing_state text;
  existing_result jsonb;
  inserted_mutation boolean := false;
  item_total numeric;
  installment_total numeric;
  item_id uuid;
  installment_id uuid;
  item_results jsonb := '[]'::jsonb;
  installment_results jsonb := '[]'::jsonb;
  final_result jsonb;
begin
  perform app_private.assert_tenant(p_empresa_id);

  if p_operation_id is null then
    raise exception 'operation_id obrigatório.' using errcode = '22023';
  end if;

  command_payload := jsonb_build_object(
    'cliente_id', p_cliente_id,
    'data_venda', p_data_venda,
    'valor_total', p_valor_total,
    'valor_entrada', coalesce(p_valor_entrada, 0),
    'desconto', coalesce(p_desconto, 0),
    'tipo_pagamento', p_tipo_pagamento,
    'observacoes', p_observacoes,
    'legacy_id', p_legacy_id,
    'itens', p_itens,
    'parcelas', coalesce(p_parcelas, '[]'::jsonb)
  );

  insert into app_private.sync_mutations (
    empresa_id,
    operation_id,
    command_type,
    command
  ) values (
    p_empresa_id,
    p_operation_id,
    'create_sale_graph',
    command_payload
  )
  on conflict do nothing
  returning true into inserted_mutation;

  select sm.command_type, sm.command, sm.state, sm.result
  into existing_command_type, existing_command, existing_state, existing_result
  from app_private.sync_mutations sm
  where sm.empresa_id = p_empresa_id
    and sm.operation_id = p_operation_id
  for update;

  if not coalesce(inserted_mutation, false) then
    if existing_command_type <> 'create_sale_graph'
        or existing_command is distinct from command_payload then
      raise exception 'operation_id já utilizado por outro comando.'
        using errcode = '23505';
    end if;

    if existing_state = 'completed' and existing_result is not null then
      return existing_result;
    end if;

    raise exception 'Operação idempotente ainda está em processamento.'
      using errcode = '55P03';
  end if;

  if p_cliente_id is null
      or p_data_venda is null
      or p_valor_total is null
      or p_valor_total < 0
      or coalesce(p_valor_entrada, 0) < 0
      or coalesce(p_valor_entrada, 0) > p_valor_total
      or coalesce(p_desconto, 0) < 0
      or p_tipo_pagamento not in ('a_vista', 'parcelado', 'fiado') then
    raise exception 'Dados da venda inválidos.' using errcode = '22023';
  end if;

  if jsonb_typeof(p_itens) <> 'array'
      or jsonb_array_length(p_itens) = 0
      or jsonb_typeof(coalesce(p_parcelas, '[]'::jsonb)) <> 'array' then
    raise exception 'Itens ou parcelas inválidos.' using errcode = '22023';
  end if;

  if p_tipo_pagamento = 'a_vista'
      and jsonb_array_length(coalesce(p_parcelas, '[]'::jsonb)) <> 0 then
    raise exception 'Venda à vista não pode conter parcelas.' using errcode = '22023';
  end if;

  if p_tipo_pagamento <> 'a_vista'
      and jsonb_array_length(coalesce(p_parcelas, '[]'::jsonb)) = 0 then
    raise exception 'Venda a prazo precisa de ao menos uma parcela.'
      using errcode = '22023';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_itens) element
    group by element->>'produto_id'
    having count(*) > 1
  ) then
    raise exception 'Há produtos duplicados na venda.' using errcode = '22023';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(coalesce(p_parcelas, '[]'::jsonb)) element
    group by element->>'numero_parcela'
    having count(*) > 1
  ) then
    raise exception 'Há números de parcela duplicados.' using errcode = '22023';
  end if;

  if not exists (
    select 1
    from public.clientes c
    where c.id = p_cliente_id
      and c.empresa_id = p_empresa_id
      and c.ativo is true
      and c.deleted_at is null
  ) then
    raise exception 'Cliente inválido.' using errcode = '23503';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_itens) element
    where nullif(element->>'produto_id', '') is null
      or nullif(element->>'quantidade', '') is null
      or (element->>'quantidade')::integer <= 0
      or nullif(element->>'preco_unitario', '') is null
      or (element->>'preco_unitario')::numeric < 0
      or nullif(element->>'custo_unitario', '') is null
      or (element->>'custo_unitario')::numeric < 0
  ) then
    raise exception 'Item inválido.' using errcode = '22023';
  end if;

  select coalesce(
    sum(
      (element->>'quantidade')::integer
      * (element->>'preco_unitario')::numeric
    ),
    0
  )
  into item_total
  from jsonb_array_elements(p_itens) element;

  if round(item_total - coalesce(p_desconto, 0), 2)
      <> round(p_valor_total, 2) then
    raise exception 'O total da venda diverge dos itens e do desconto.'
      using errcode = '23514';
  end if;

  if p_tipo_pagamento = 'a_vista'
      and round(coalesce(p_valor_entrada, 0), 2) <> round(p_valor_total, 2) then
    raise exception 'Venda à vista deve estar integralmente paga.'
      using errcode = '23514';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(coalesce(p_parcelas, '[]'::jsonb)) element
    where nullif(element->>'numero_parcela', '') is null
      or (element->>'numero_parcela')::integer <= 0
      or nullif(element->>'valor', '') is null
      or (element->>'valor')::numeric < 0
      or nullif(element->>'data_vencimento', '') is null
      or element->>'status' not in ('pendente', 'pago')
      or (
        element->>'status' = 'pago'
        and nullif(element->>'data_pagamento', '') is null
      )
      or (
        element->>'status' = 'pendente'
        and nullif(element->>'data_pagamento', '') is not null
      )
  ) then
    raise exception 'Parcela inválida.' using errcode = '22023';
  end if;

  select coalesce(sum((element->>'valor')::numeric), 0)
  into installment_total
  from jsonb_array_elements(coalesce(p_parcelas, '[]'::jsonb)) element;

  if p_tipo_pagamento <> 'a_vista'
      and round(installment_total, 2)
          <> round(p_valor_total - coalesce(p_valor_entrada, 0), 2) then
    raise exception 'O total das parcelas diverge do saldo da venda.'
      using errcode = '23514';
  end if;

  for product in
    select
      p.id,
      p.empresa_id,
      p.ativo,
      p.deleted_at,
      p.quantidade_estoque,
      (element->>'quantidade')::integer as requested_quantity
    from jsonb_array_elements(p_itens) element
    join public.produtos p on p.id = (element->>'produto_id')::uuid
    order by p.id
    for update of p
  loop
    if product.empresa_id <> p_empresa_id
        or product.ativo is not true
        or product.deleted_at is not null
        or product.quantidade_estoque < product.requested_quantity then
      raise exception 'Produto ou estoque inválido.' using errcode = '23514';
    end if;
  end loop;

  if jsonb_array_length(p_itens) <> (
    select count(*)
    from jsonb_array_elements(p_itens) element
    join public.produtos p on p.id = (element->>'produto_id')::uuid
  ) then
    raise exception 'Produto inexistente.' using errcode = '23503';
  end if;

  insert into public.vendas (
    id,
    empresa_id,
    cliente_id,
    data_venda,
    valor_total,
    valor_entrada,
    desconto,
    tipo_pagamento,
    observacoes,
    legacy_id
  ) values (
    sale_id,
    p_empresa_id,
    p_cliente_id,
    p_data_venda,
    p_valor_total,
    coalesce(p_valor_entrada, 0),
    coalesce(p_desconto, 0),
    p_tipo_pagamento,
    p_observacoes,
    p_legacy_id
  );

  for item in
    select value
    from jsonb_array_elements(p_itens)
  loop
    item_id := gen_random_uuid();

    insert into public.itens_venda (
      id,
      venda_id,
      produto_id,
      quantidade,
      preco_unitario,
      custo_unitario
    ) values (
      item_id,
      sale_id,
      (item->>'produto_id')::uuid,
      (item->>'quantidade')::integer,
      (item->>'preco_unitario')::numeric,
      (item->>'custo_unitario')::numeric
    );

    update public.produtos
    set quantidade_estoque = quantidade_estoque - (item->>'quantidade')::integer
    where id = (item->>'produto_id')::uuid
      and empresa_id = p_empresa_id;

    item_results := item_results || jsonb_build_array(
      jsonb_build_object(
        'produto_id', item->>'produto_id',
        'item_id', item_id,
        'row_version', 1
      )
    );
  end loop;

  for installment in
    select value
    from jsonb_array_elements(coalesce(p_parcelas, '[]'::jsonb))
  loop
    installment_id := gen_random_uuid();

    insert into public.parcelas (
      id,
      empresa_id,
      venda_id,
      numero_parcela,
      valor,
      data_vencimento,
      data_pagamento,
      status
    ) values (
      installment_id,
      p_empresa_id,
      sale_id,
      (installment->>'numero_parcela')::integer,
      (installment->>'valor')::numeric,
      (installment->>'data_vencimento')::date,
      nullif(installment->>'data_pagamento', '')::date,
      installment->>'status'
    );

    installment_results := installment_results || jsonb_build_array(
      jsonb_build_object(
        'numero_parcela', (installment->>'numero_parcela')::integer,
        'parcela_id', installment_id,
        'row_version', 1
      )
    );
  end loop;

  final_result := jsonb_build_object(
    'operation_id', p_operation_id,
    'venda_id', sale_id,
    'row_version', 1,
    'itens', item_results,
    'parcelas', installment_results
  );

  update app_private.sync_mutations sm
  set state = 'completed',
      result = final_result,
      updated_at = now()
  where sm.empresa_id = p_empresa_id
    and sm.operation_id = p_operation_id;

  return final_result;
end
$$;

create function public.sync_apply_batch(
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
  entity_name text;
  action_name text;
  target_id uuid;
  payload jsonb;
  base_row_version bigint;
  command_type text;
  stored_command jsonb;
  stored_state text;
  stored_result jsonb;
  inserted_mutation boolean;
  resulting_version bigint;
  current_version bigint;
  current_deleted_at timestamptz;
  parcel_status text;
  parcel_payment_date date;
  one_result jsonb;
  safe_message text;
begin
  perform app_private.assert_tenant(p_empresa_id);

  if jsonb_typeof(p_commands) <> 'array'
      or jsonb_array_length(p_commands) > 200 then
    raise exception 'Lote inválido ou maior que 200 comandos.'
      using errcode = '22023';
  end if;

  for command_item in
    select value
    from jsonb_array_elements(p_commands)
  loop
    begin
      inserted_mutation := false;
      current_operation_id := nullif(
        command_item->>'operation_id',
        ''
      )::uuid;
      entity_name := command_item->>'entity';
      action_name := command_item->>'operation';
      target_id := nullif(command_item->>'record_id', '')::uuid;
      payload := coalesce(command_item->'data', '{}'::jsonb);
      base_row_version := nullif(
        command_item->>'base_row_version',
        ''
      )::bigint;

      if current_operation_id is null
          or jsonb_typeof(payload) <> 'object'
          or entity_name is null
          or action_name is null then
        raise exception 'Comando incompleto.' using errcode = '22023';
      end if;

      insert into app_private.sync_mutations (
        empresa_id,
        operation_id,
        command_type,
        command
      ) values (
        p_empresa_id,
        current_operation_id,
        'sync_apply',
        command_item
      )
      on conflict do nothing
      returning true into inserted_mutation;

      select sm.command_type, sm.command, sm.state, sm.result
      into command_type, stored_command, stored_state, stored_result
      from app_private.sync_mutations sm
      where sm.empresa_id = p_empresa_id
        and sm.operation_id = current_operation_id
      for update;

      if not coalesce(inserted_mutation, false) then
        if command_type <> 'sync_apply'
            or stored_command is distinct from command_item then
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

      if entity_name = 'clientes' and action_name = 'insert' then
        target_id := coalesce(target_id, gen_random_uuid());

        if nullif(btrim(payload->>'nome'), '') is null then
          raise exception 'Nome do cliente obrigatório.' using errcode = '22023';
        end if;

        insert into public.clientes (
          id,
          empresa_id,
          nome,
          celular,
          referencia,
          observacoes,
          ativo,
          legacy_id
        ) values (
          target_id,
          p_empresa_id,
          btrim(payload->>'nome'),
          payload->>'celular',
          payload->>'referencia',
          payload->>'observacoes',
          coalesce((payload->>'ativo')::boolean, true),
          nullif(payload->>'legacy_id', '')::integer
        )
        returning row_version into resulting_version;
      elsif entity_name = 'clientes' and action_name = 'update' then
        if target_id is null or base_row_version is null then
          raise exception 'ID e versão base são obrigatórios.'
            using errcode = '22023';
        end if;

        if payload ? 'nome' and nullif(btrim(payload->>'nome'), '') is null then
          raise exception 'Nome do cliente obrigatório.' using errcode = '22023';
        end if;

        update public.clientes
        set nome = case when payload ? 'nome' then btrim(payload->>'nome') else nome end,
            celular = case when payload ? 'celular' then payload->>'celular' else celular end,
            referencia = case when payload ? 'referencia' then payload->>'referencia' else referencia end,
            observacoes = case when payload ? 'observacoes' then payload->>'observacoes' else observacoes end,
            ativo = case when payload ? 'ativo' then (payload->>'ativo')::boolean else ativo end
        where id = target_id
          and empresa_id = p_empresa_id
          and deleted_at is null
          and row_version = base_row_version
        returning row_version into resulting_version;

        if not found then
          raise exception 'Registro ausente ou versão conflitante.'
            using errcode = '40001';
        end if;
      elsif entity_name = 'clientes' and action_name = 'delete' then
        if target_id is null then
          raise exception 'ID do cliente obrigatório.' using errcode = '22023';
        end if;

        select c.row_version, c.deleted_at
        into current_version, current_deleted_at
        from public.clientes c
        where c.id = target_id
          and c.empresa_id = p_empresa_id
        for update;

        if not found then
          resulting_version := null;
        elsif current_deleted_at is not null then
          resulting_version := current_version;
        else
          if base_row_version is null or current_version <> base_row_version then
            raise exception 'Registro ausente ou versão conflitante.'
              using errcode = '40001';
          end if;

          update public.clientes
          set ativo = false,
              deleted_at = now()
          where id = target_id
            and empresa_id = p_empresa_id
          returning row_version into resulting_version;
        end if;
      elsif entity_name = 'produtos' and action_name = 'insert' then
        target_id := coalesce(target_id, gen_random_uuid());

        if nullif(btrim(payload->>'nome'), '') is null
            or coalesce((payload->>'preco_custo')::numeric, 0) < 0
            or coalesce((payload->>'valor_venda')::numeric, 0) < 0
            or coalesce((payload->>'quantidade_estoque')::integer, 0) < 0 then
          raise exception 'Dados do produto inválidos.' using errcode = '22023';
        end if;

        insert into public.produtos (
          id,
          empresa_id,
          nome,
          categoria,
          fornecedor,
          preco_custo,
          valor_venda,
          quantidade_estoque,
          ativo
        ) values (
          target_id,
          p_empresa_id,
          btrim(payload->>'nome'),
          payload->>'categoria',
          payload->>'fornecedor',
          coalesce((payload->>'preco_custo')::numeric, 0),
          coalesce((payload->>'valor_venda')::numeric, 0),
          coalesce((payload->>'quantidade_estoque')::integer, 0),
          coalesce((payload->>'ativo')::boolean, true)
        )
        returning row_version into resulting_version;
      elsif entity_name = 'produtos' and action_name = 'update' then
        if target_id is null or base_row_version is null then
          raise exception 'ID e versão base são obrigatórios.'
            using errcode = '22023';
        end if;

        if (payload ? 'nome' and nullif(btrim(payload->>'nome'), '') is null)
            or (payload ? 'preco_custo' and (payload->>'preco_custo')::numeric < 0)
            or (payload ? 'valor_venda' and (payload->>'valor_venda')::numeric < 0)
            or (
              payload ? 'quantidade_estoque'
              and (payload->>'quantidade_estoque')::integer < 0
            ) then
          raise exception 'Dados do produto inválidos.' using errcode = '22023';
        end if;

        update public.produtos
        set nome = case when payload ? 'nome' then btrim(payload->>'nome') else nome end,
            categoria = case when payload ? 'categoria' then payload->>'categoria' else categoria end,
            fornecedor = case when payload ? 'fornecedor' then payload->>'fornecedor' else fornecedor end,
            preco_custo = case when payload ? 'preco_custo' then (payload->>'preco_custo')::numeric else preco_custo end,
            valor_venda = case when payload ? 'valor_venda' then (payload->>'valor_venda')::numeric else valor_venda end,
            quantidade_estoque = case when payload ? 'quantidade_estoque' then (payload->>'quantidade_estoque')::integer else quantidade_estoque end,
            ativo = case when payload ? 'ativo' then (payload->>'ativo')::boolean else ativo end
        where id = target_id
          and empresa_id = p_empresa_id
          and deleted_at is null
          and row_version = base_row_version
        returning row_version into resulting_version;

        if not found then
          raise exception 'Registro ausente ou versão conflitante.'
            using errcode = '40001';
        end if;
      elsif entity_name = 'produtos' and action_name = 'delete' then
        if target_id is null then
          raise exception 'ID do produto obrigatório.' using errcode = '22023';
        end if;

        select p.row_version, p.deleted_at
        into current_version, current_deleted_at
        from public.produtos p
        where p.id = target_id
          and p.empresa_id = p_empresa_id
        for update;

        if not found then
          resulting_version := null;
        elsif current_deleted_at is not null then
          resulting_version := current_version;
        else
          if base_row_version is null or current_version <> base_row_version then
            raise exception 'Registro ausente ou versão conflitante.'
              using errcode = '40001';
          end if;

          update public.produtos
          set ativo = false,
              deleted_at = now()
          where id = target_id
            and empresa_id = p_empresa_id
          returning row_version into resulting_version;
        end if;
      elsif entity_name = 'parcelas' and action_name = 'update' then
        if target_id is null or base_row_version is null then
          raise exception 'ID e versão base são obrigatórios.'
            using errcode = '22023';
        end if;

        select
          case when payload ? 'status' then payload->>'status' else pa.status end,
          case
            when payload ? 'data_pagamento'
              then nullif(payload->>'data_pagamento', '')::date
            else pa.data_pagamento
          end
        into parcel_status, parcel_payment_date
        from public.parcelas pa
        where pa.id = target_id
          and pa.empresa_id = p_empresa_id
          and pa.deleted_at is null
          and pa.row_version = base_row_version
        for update;

        if not found then
          raise exception 'Registro ausente ou versão conflitante.'
            using errcode = '40001';
        end if;

        if parcel_status not in ('pendente', 'pago')
            or (parcel_status = 'pago' and parcel_payment_date is null)
            or (parcel_status = 'pendente' and parcel_payment_date is not null) then
          raise exception 'Estado de pagamento inválido.' using errcode = '22023';
        end if;

        update public.parcelas
        set status = parcel_status,
            data_pagamento = parcel_payment_date
        where id = target_id
          and empresa_id = p_empresa_id
          and row_version = base_row_version
        returning row_version into resulting_version;
      else
        raise exception 'Comando não suportado.' using errcode = '22023';
      end if;

      one_result := jsonb_build_object(
        'operation_id', current_operation_id,
        'status', 'success',
        'entity', entity_name,
        'operation', action_name,
        'record_id', target_id,
        'row_version', resulting_version
      );

      update app_private.sync_mutations sm
      set state = 'completed',
          result = one_result,
          updated_at = now()
      where sm.empresa_id = p_empresa_id
        and sm.operation_id = current_operation_id;

      results := results || jsonb_build_array(one_result);
    exception
      when others then
        safe_message := case sqlstate
          when '22023' then 'Dados ou comando inválidos.'
          when '22P02' then 'Dados ou identificador inválidos.'
          when '23503' then 'Dependência inexistente.'
          when '23505' then 'operation_id já utilizado.'
          when '23514' then 'Regra de integridade violada.'
          when '40001' then 'Conflito de versão.'
          when '55P03' then 'Operação ainda em processamento.'
          else 'Comando rejeitado pelo banco.'
        end;

        results := results || jsonb_build_array(
          jsonb_build_object(
            'operation_id', command_item->>'operation_id',
            'status', 'error',
            'code', sqlstate,
            'message', safe_message
          )
        );
    end;
  end loop;

  return results;
end
$$;

revoke execute on function public.sync_begin(uuid) from public, anon;
revoke execute on function public.sync_bootstrap_page(uuid, text, uuid, integer)
from public, anon;
revoke execute on function public.sync_pull_changes(uuid, bigint, integer)
from public, anon;
revoke execute on function public.sync_history_page(
  uuid,
  timestamptz,
  uuid,
  integer
) from public, anon;
revoke execute on function public.create_sale_graph(
  uuid,
  uuid,
  uuid,
  timestamptz,
  numeric,
  numeric,
  numeric,
  text,
  text,
  bigint,
  jsonb,
  jsonb
) from public, anon;
revoke execute on function public.sync_apply_batch(uuid, jsonb)
from public, anon;

grant execute on function public.sync_begin(uuid) to authenticated;
grant execute on function public.sync_bootstrap_page(uuid, text, uuid, integer)
to authenticated;
grant execute on function public.sync_pull_changes(uuid, bigint, integer)
to authenticated;
grant execute on function public.sync_history_page(
  uuid,
  timestamptz,
  uuid,
  integer
) to authenticated;
grant execute on function public.create_sale_graph(
  uuid,
  uuid,
  uuid,
  timestamptz,
  numeric,
  numeric,
  numeric,
  text,
  text,
  bigint,
  jsonb,
  jsonb
) to authenticated;
grant execute on function public.sync_apply_batch(uuid, jsonb)
to authenticated;
