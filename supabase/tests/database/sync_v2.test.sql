begin;

create extension if not exists pgtap with schema extensions;
select plan(76);

select has_table(
  'app_private',
  'sync_changes',
  'sync_changes existe no schema privado'
);
select has_table(
  'app_private',
  'sync_mutations',
  'sync_mutations existe no schema privado'
);
select hasnt_table(
  'public',
  'sync_changes',
  'sync_changes nao e exposta na Data API'
);
select hasnt_table(
  'public',
  'sync_mutations',
  'sync_mutations nao e exposta na Data API'
);
select col_type_is(
  'public',
  'clientes',
  'row_version',
  'bigint',
  'row_version usa bigint'
);
select col_not_null(
  'public',
  'clientes',
  'row_version',
  'row_version e obrigatoria'
);
select col_has_default(
  'public',
  'clientes',
  'row_version',
  'row_version tem default'
);
select col_type_is(
  'public',
  'parcelas',
  'updated_at',
  'timestamp with time zone',
  'updated_at usa timestamptz'
);
select col_type_is(
  'public',
  'parcelas',
  'deleted_at',
  'timestamp with time zone',
  'deleted_at usa timestamptz'
);
select col_type_is(
  'public',
  'itens_venda',
  'empresa_id',
  'uuid',
  'item recebeu empresa_id'
);
select has_index(
  'app_private',
  'sync_changes',
  'sync_changes_empresa_change_idx',
  'indice de cursor existe'
);
select policies_are(
  'app_private',
  'sync_changes',
  array['sync_changes_select_tenant'],
  'sync_changes tem policy minima'
);
select policies_are(
  'app_private',
  'sync_mutations',
  array[
    'sync_mutations_insert_tenant',
    'sync_mutations_select_tenant',
    'sync_mutations_update_tenant'
  ],
  'sync_mutations tem policies de tenant'
);
select has_trigger(
  'public',
  'produtos',
  'produtos_sync_metadata',
  'trigger de versao existe'
);
select has_trigger(
  'public',
  'produtos',
  'produtos_sync_change',
  'trigger de change log existe'
);
select has_trigger(
  'public',
  'itens_venda',
  'itens_venda_set_tenant',
  'trigger de tenant do item existe'
);

insert into public.empresas (id, nome_fantasia)
values
  ('10000000-0000-4000-8000-000000000001', 'Empresa A'),
  ('20000000-0000-4000-8000-000000000002', 'Empresa B');

insert into public.clientes (id, empresa_id, nome, ativo)
values
  (
    '11000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000001',
    'Cliente A',
    true
  ),
  (
    '21000000-0000-4000-8000-000000000002',
    '20000000-0000-4000-8000-000000000002',
    'Cliente B',
    true
  ),
  (
    '11000000-0000-4000-8000-000000000010',
    '10000000-0000-4000-8000-000000000001',
    'Cliente antigo sem pendencia',
    false
  ),
  (
    '11000000-0000-4000-8000-000000000020',
    '10000000-0000-4000-8000-000000000001',
    'Cliente antigo com pendencia',
    false
  );

insert into public.produtos (
  id,
  empresa_id,
  nome,
  preco_custo,
  valor_venda,
  quantidade_estoque,
  ativo
)
values
  (
    '12000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000001',
    'Produto A',
    5,
    10,
    5,
    true
  ),
  (
    '22000000-0000-4000-8000-000000000002',
    '20000000-0000-4000-8000-000000000002',
    'Produto B',
    5,
    10,
    3,
    true
  ),
  (
    '12000000-0000-4000-8000-000000000010',
    '10000000-0000-4000-8000-000000000001',
    'Produto antigo sem pendencia',
    5,
    10,
    1,
    false
  ),
  (
    '12000000-0000-4000-8000-000000000020',
    '10000000-0000-4000-8000-000000000001',
    'Produto antigo com pendencia',
    5,
    10,
    1,
    false
  );

insert into public.vendas (
  id,
  empresa_id,
  cliente_id,
  data_venda,
  valor_total,
  valor_entrada,
  tipo_pagamento
)
values
  (
    '13000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000001',
    '11000000-0000-4000-8000-000000000001',
    now(),
    10,
    10,
    'a_vista'
  ),
  (
    '13000000-0000-4000-8000-000000000002',
    '10000000-0000-4000-8000-000000000001',
    '11000000-0000-4000-8000-000000000001',
    now(),
    10,
    10,
    'a_vista'
  ),
  (
    '13000000-0000-4000-8000-000000000010',
    '10000000-0000-4000-8000-000000000001',
    '11000000-0000-4000-8000-000000000010',
    now() - interval '18 months',
    10,
    10,
    'a_vista'
  ),
  (
    '13000000-0000-4000-8000-000000000020',
    '10000000-0000-4000-8000-000000000001',
    '11000000-0000-4000-8000-000000000020',
    now() - interval '15 months',
    20,
    0,
    'parcelado'
  );

insert into public.itens_venda (
  id,
  venda_id,
  produto_id,
  quantidade,
  preco_unitario,
  custo_unitario
)
values
  (
    '14000000-0000-4000-8000-000000000001',
    '13000000-0000-4000-8000-000000000001',
    '12000000-0000-4000-8000-000000000001',
    1,
    10,
    5
  ),
  (
    '14000000-0000-4000-8000-000000000010',
    '13000000-0000-4000-8000-000000000010',
    '12000000-0000-4000-8000-000000000010',
    1,
    10,
    5
  ),
  (
    '14000000-0000-4000-8000-000000000020',
    '13000000-0000-4000-8000-000000000020',
    '12000000-0000-4000-8000-000000000020',
    1,
    20,
    5
  );

insert into public.parcelas (
  id,
  empresa_id,
  venda_id,
  numero_parcela,
  valor,
  data_vencimento,
  data_pagamento,
  status
)
values
  (
    '17000000-0000-4000-8000-000000000010',
    '10000000-0000-4000-8000-000000000001',
    '13000000-0000-4000-8000-000000000010',
    1,
    10,
    current_date - 500,
    current_date - 500,
    'pago'
  ),
  (
    '17000000-0000-4000-8000-000000000020',
    '10000000-0000-4000-8000-000000000001',
    '13000000-0000-4000-8000-000000000020',
    1,
    10,
    current_date + 10,
    null,
    'pendente'
  ),
  (
    '17000000-0000-4000-8000-000000000021',
    '10000000-0000-4000-8000-000000000001',
    '13000000-0000-4000-8000-000000000020',
    2,
    10,
    current_date - 20,
    current_date - 20,
    'pago'
  );

select is(
  (
    select empresa_id
    from public.itens_venda
    where id = '14000000-0000-4000-8000-000000000001'
  ),
  '10000000-0000-4000-8000-000000000001'::uuid,
  'empresa_id do item e derivada da venda'
);
select throws_ok(
  $$
    update public.itens_venda
    set empresa_id = '20000000-0000-4000-8000-000000000002'
    where id = '14000000-0000-4000-8000-000000000001'
  $$,
  '23514',
  null,
  'tenant divergente no item e rejeitado'
);

update public.produtos
set nome = 'Produto A atualizado'
where id = '12000000-0000-4000-8000-000000000001';

select is(
  (
    select row_version
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000001'
  ),
  2::bigint,
  'alteracao real incrementa row_version'
);
select is(
  (
    select operation
    from app_private.sync_changes
    where entity = 'produtos'
      and record_id = '12000000-0000-4000-8000-000000000001'
    order by change_id desc
    limit 1
  ),
  'update',
  'update gera sync_change'
);

create temp table no_op_state as
select
  p.row_version,
  (
    select count(*)
    from app_private.sync_changes sc
    where sc.entity = 'produtos'
      and sc.record_id = p.id
  ) as change_count
from public.produtos p
where p.id = '12000000-0000-4000-8000-000000000001';

update public.produtos
set nome = nome
where id = '12000000-0000-4000-8000-000000000001';

select is(
  (
    select row_version
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000001'
  ),
  (select row_version from no_op_state),
  'no-op nao incrementa row_version'
);
select is(
  (
    select count(*)
    from app_private.sync_changes
    where entity = 'produtos'
      and record_id = '12000000-0000-4000-8000-000000000001'
  ),
  (select change_count from no_op_state),
  'no-op nao gera change log'
);

update public.produtos
set deleted_at = now()
where id = '22000000-0000-4000-8000-000000000002';

select is(
  (
    select operation
    from app_private.sync_changes
    where entity = 'produtos'
      and record_id = '22000000-0000-4000-8000-000000000002'
    order by change_id desc
    limit 1
  ),
  'delete',
  'soft delete gera operacao delete'
);

set local role authenticated;
set local "request.jwt.claims" =
  '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated","app_metadata":{"empresa_id":"10000000-0000-4000-8000-000000000001"}}';

select is(
  (select count(*) from public.produtos),
  3::bigint,
  'RLS isola os tenants'
);
select ok(
  not exists (
    select 1
    from app_private.sync_changes
    where empresa_id = '20000000-0000-4000-8000-000000000002'
  ),
  'RLS tambem isola o change log'
);
select throws_ok(
  $$
    select *
    from public.sync_begin('20000000-0000-4000-8000-000000000002')
  $$,
  '42501',
  null,
  'RPC rejeita outro tenant'
);

set local "request.jwt.claims" = '{}';
select throws_ok(
  $$
    select *
    from public.sync_begin('10000000-0000-4000-8000-000000000001')
  $$,
  '42501',
  null,
  'RPC rejeita sessao ausente'
);
set local "request.jwt.claims" =
  '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated","app_metadata":{"empresa_id":"10000000-0000-4000-8000-000000000001"}}';

select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'clientes',
      null,
      500
    )
    where record_id = '11000000-0000-4000-8000-000000000001'
  ),
  1::bigint,
  'bootstrap inclui cliente ativo'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'clientes',
      null,
      500
    )
    where record_id = '11000000-0000-4000-8000-000000000010'
  ),
  0::bigint,
  'bootstrap exclui cliente inativo somente historico antigo'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'clientes',
      null,
      500
    )
    where record_id = '11000000-0000-4000-8000-000000000020'
  ),
  1::bigint,
  'bootstrap preserva cliente com parcela pendente'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'produtos',
      null,
      500
    )
    where record_id = '12000000-0000-4000-8000-000000000010'
  ),
  0::bigint,
  'bootstrap exclui produto inativo somente historico antigo'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'produtos',
      null,
      500
    )
    where record_id = '12000000-0000-4000-8000-000000000020'
  ),
  1::bigint,
  'bootstrap preserva produto do grafo pendente'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'vendas',
      null,
      500
    )
    where record_id = '13000000-0000-4000-8000-000000000010'
  ),
  0::bigint,
  'bootstrap exclui venda antiga quitada'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'vendas',
      null,
      500
    )
    where record_id = '13000000-0000-4000-8000-000000000020'
  ),
  1::bigint,
  'bootstrap preserva venda antiga pendente'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'itens_venda',
      null,
      500
    )
    where record_id = '14000000-0000-4000-8000-000000000020'
  ),
  1::bigint,
  'bootstrap preserva itens do grafo pendente'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'parcelas',
      null,
      500
    )
    where (snapshot->>'venda_id')::uuid =
      '13000000-0000-4000-8000-000000000020'
  ),
  2::bigint,
  'bootstrap preserva todo o conjunto de parcelas do grafo pendente'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'vendas',
      null,
      1
    )
  ),
  1::bigint,
  'bootstrap respeita limite'
);
select is(
  (
    select count(*)
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'vendas',
      '13000000-0000-4000-8000-000000000001',
      10
    )
    where record_id = '13000000-0000-4000-8000-000000000001'
  ),
  0::bigint,
  'cursor do bootstrap nao repete o ultimo registro'
);
select throws_ok(
  $$
    select *
    from public.sync_bootstrap_page(
      '10000000-0000-4000-8000-000000000001',
      'invalida',
      null,
      10
    )
  $$,
  '22023',
  null,
  'bootstrap rejeita entidade desconhecida'
);

create temp table history_first as
select *
from public.sync_history_page(
  '10000000-0000-4000-8000-000000000001',
  null,
  null,
  1
);

create temp table history_second as
select *
from public.sync_history_page(
  '10000000-0000-4000-8000-000000000001',
  (select data_venda from history_first),
  (select record_id from history_first),
  1
);

select is(
  (select count(*) from history_first),
  1::bigint,
  'historico retorna primeira pagina'
);
select is(
  (select count(*) from history_second),
  1::bigint,
  'historico retorna segunda pagina'
);
select isnt(
  (select record_id from history_first),
  (select record_id from history_second),
  'cursor composto do historico nao repete registros'
);

create temp table sale_count_before as
select count(*) as value
from public.vendas;

select lives_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000001',
      '11000000-0000-4000-8000-000000000001',
      '2026-08-05T10:00:00-03:00',
      20,
      0,
      0,
      'fiado',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":2,"preco_unitario":10,"custo_unitario":5}]',
      '[{"numero_parcela":1,"valor":20,"data_vencimento":"2026-09-05","data_pagamento":null,"status":"pendente"}]'
    )
  $$,
  'grafo de venda e criado atomicamente'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000001'
  ),
  3,
  'estoque e baixado'
);
select is(
  (
    select data_vencimento
    from public.parcelas
    where venda_id = (
      select (result->>'venda_id')::uuid
      from app_private.sync_mutations
      where operation_id = '15000000-0000-4000-8000-000000000001'
    )
  ),
  '2026-09-05'::date,
  'vencimento preserva a data civil'
);
select is(
  (
    select jsonb_array_length(result->'itens')
    from app_private.sync_mutations
    where operation_id = '15000000-0000-4000-8000-000000000001'
  ),
  1,
  'resultado devolve IDs dos itens'
);
select is(
  (
    select jsonb_array_length(result->'parcelas')
    from app_private.sync_mutations
    where operation_id = '15000000-0000-4000-8000-000000000001'
  ),
  1,
  'resultado devolve IDs das parcelas'
);
select is(
  (
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000001',
      '11000000-0000-4000-8000-000000000001',
      '2026-08-05T10:00:00-03:00',
      20,
      0,
      0,
      'fiado',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":2,"preco_unitario":10,"custo_unitario":5}]',
      '[{"numero_parcela":1,"valor":20,"data_vencimento":"2026-09-05","data_pagamento":null,"status":"pendente"}]'
    )
  ),
  (
    select result
    from app_private.sync_mutations
    where operation_id = '15000000-0000-4000-8000-000000000001'
  ),
  'operation_id repetido retorna o resultado anterior'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000001',
      '11000000-0000-4000-8000-000000000001',
      '2026-08-05T10:00:00-03:00',
      10,
      10,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '23505',
  null,
  'operation_id nao pode ser reutilizado com outro payload'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000010',
      '11000000-0000-4000-8000-000000000099',
      now(),
      10,
      10,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '23503',
  null,
  'cliente invalido reverte a venda'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000011',
      '11000000-0000-4000-8000-000000000001',
      now(),
      -10,
      0,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":-1,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '22023',
  null,
  'item invalido reverte a venda'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000012',
      '11000000-0000-4000-8000-000000000001',
      now(),
      10,
      0,
      0,
      'fiado',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[{"numero_parcela":1,"valor":10,"data_vencimento":"2026-09-05","status":"cancelada"}]'
    )
  $$,
  '22023',
  null,
  'parcela invalida reverte venda e estoque'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000001'
  ),
  3,
  'falha de parcela preserva o estoque'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000002',
      '11000000-0000-4000-8000-000000000001',
      now(),
      40,
      40,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":4,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '23514',
  null,
  'lock e verificacao impedem estoque negativo'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000013',
      '11000000-0000-4000-8000-000000000001',
      now(),
      9,
      9,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '23514',
  null,
  'total divergente dos itens e rejeitado'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000014',
      '11000000-0000-4000-8000-000000000001',
      now(),
      20,
      20,
      0,
      'a_vista',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5},{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[]'
    )
  $$,
  '22023',
  null,
  'produto duplicado no payload e rejeitado'
);
select throws_ok(
  $$
    select public.create_sale_graph(
      '10000000-0000-4000-8000-000000000001',
      '15000000-0000-4000-8000-000000000015',
      '11000000-0000-4000-8000-000000000001',
      now(),
      10,
      0,
      0,
      'parcelado',
      null,
      null,
      '[{"produto_id":"12000000-0000-4000-8000-000000000001","quantidade":1,"preco_unitario":10,"custo_unitario":5}]',
      '[{"numero_parcela":1,"valor":5,"data_vencimento":"2026-09-05","status":"pendente"},{"numero_parcela":1,"valor":5,"data_vencimento":"2026-10-05","status":"pendente"}]'
    )
  $$,
  '22023',
  null,
  'numero de parcela duplicado e rejeitado'
);
select is(
  (select count(*) from public.vendas),
  (select value + 1 from sale_count_before),
  'falhas nao deixam vendas parciais'
);

select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000001',
          'entity', 'clientes',
          'operation', 'insert',
          'record_id', '11000000-0000-4000-8000-000000000030',
          'data', jsonb_build_object(
            'nome', 'Cliente do lote',
            'celular', '21999999999'
          )
        )
      )
    )->0->>'status'
  ),
  'success',
  'lote insere cliente'
);
select is(
  (
    select empresa_id
    from public.clientes
    where id = '11000000-0000-4000-8000-000000000030'
  ),
  '10000000-0000-4000-8000-000000000001'::uuid,
  'insert do lote injeta tenant'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000002',
          'entity', 'produtos',
          'operation', 'insert',
          'record_id', '12000000-0000-4000-8000-000000000030',
          'data', jsonb_build_object(
            'nome', 'Produto do lote',
            'preco_custo', 4,
            'valor_venda', 8,
            'quantidade_estoque', 2
          )
        )
      )
    )->0->>'status'
  ),
  'success',
  'lote insere produto'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000030'
  ),
  2,
  'produto inserido preserva estoque'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000003',
          'entity', 'clientes',
          'operation', 'update',
          'record_id', '11000000-0000-4000-8000-000000000030',
          'base_row_version', 1,
          'data', jsonb_build_object('nome', 'Cliente atualizado')
        )
      )
    )->0->>'row_version'
  ),
  '2',
  'update correto incrementa versao'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000004',
          'entity', 'clientes',
          'operation', 'update',
          'record_id', '11000000-0000-4000-8000-000000000030',
          'base_row_version', 1,
          'data', jsonb_build_object('nome', 'Sobrescrita indevida')
        )
      )
    )->0->>'code'
  ),
  '40001',
  'versao obsoleta retorna conflito'
);
select is(
  (
    select nome
    from public.clientes
    where id = '11000000-0000-4000-8000-000000000030'
  ),
  'Cliente atualizado',
  'conflito nao sobrescreve o servidor'
);

create temp table sale_parcel as
select id, row_version
from public.parcelas
where venda_id = (
  select (result->>'venda_id')::uuid
  from app_private.sync_mutations
  where operation_id = '15000000-0000-4000-8000-000000000001'
);

select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000005',
          'entity', 'parcelas',
          'operation', 'update',
          'record_id', (select id from sale_parcel),
          'base_row_version', (select row_version from sale_parcel),
          'data', jsonb_build_object(
            'status', 'pago',
            'data_pagamento', '2026-09-01'
          )
        )
      )
    )->0->>'status'
  ),
  'success',
  'lote registra pagamento de parcela'
);
select is(
  (
    select status || ':' || data_pagamento::text
    from public.parcelas
    where id = (select id from sale_parcel)
  ),
  'pago:2026-09-01',
  'pagamento preserva status e data'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000006',
          'entity', 'produtos',
          'operation', 'delete',
          'record_id', '12000000-0000-4000-8000-000000000030',
          'base_row_version', 1,
          'data', '{}'::jsonb
        )
      )
    )->0->>'status'
  ),
  'success',
  'delete versionado e aceito'
);
select ok(
  (
    select deleted_at is not null and ativo is false
    from public.produtos
    where id = '12000000-0000-4000-8000-000000000030'
  ),
  'delete gera tombstone e desativa produto'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000006',
          'entity', 'produtos',
          'operation', 'delete',
          'record_id', '12000000-0000-4000-8000-000000000030',
          'base_row_version', 1,
          'data', '{}'::jsonb
        )
      )
    )->0->>'status'
  ),
  'success',
  'repeticao identica retorna resultado idempotente'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000007',
          'entity', 'produtos',
          'operation', 'delete',
          'record_id', '12000000-0000-4000-8000-000000000030',
          'data', '{}'::jsonb
        )
      )
    )->0->>'status'
  ),
  'success',
  'novo delete de tombstone tambem e idempotente'
);
select is(
  jsonb_array_length(
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000008',
          'entity', 'parcelas',
          'operation', 'invalida',
          'record_id', '17000000-0000-4000-8000-000000000020',
          'data', '{}'::jsonb
        ),
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000009',
          'entity', 'clientes',
          'operation', 'update',
          'record_id', '11000000-0000-4000-8000-000000000030',
          'base_row_version', 2,
          'data', jsonb_build_object('nome', 'Cliente independente')
        )
      )
    )
  ),
  2,
  'lote retorna um resultado por comando'
);
select is(
  (
    select nome
    from public.clientes
    where id = '11000000-0000-4000-8000-000000000030'
  ),
  'Cliente independente',
  'falha independente nao desfaz comando valido'
);
select is(
  (
    public.sync_apply_batch(
      '10000000-0000-4000-8000-000000000001',
      jsonb_build_array(
        jsonb_build_object(
          'operation_id', '16000000-0000-4000-8000-000000000001',
          'entity', 'clientes',
          'operation', 'insert',
          'record_id', '11000000-0000-4000-8000-000000000031',
          'data', jsonb_build_object('nome', 'Outro cliente')
        )
      )
    )->0->>'code'
  ),
  '23505',
  'operation_id do lote nao aceita outro payload'
);
select is(
  (
    select count(*)
    from app_private.sync_mutations
    where operation_id = '16000000-0000-4000-8000-000000000008'
  ),
  0::bigint,
  'comando com falha permanece disponivel para retry'
);
select ok(
  not exists (
    select 1
    from public.sync_pull_changes(
      '10000000-0000-4000-8000-000000000001',
      0,
      500
    )
    where (snapshot->>'empresa_id')::uuid <>
      '10000000-0000-4000-8000-000000000001'
  ),
  'pull nunca retorna outro tenant'
);

select * from finish();
rollback;
