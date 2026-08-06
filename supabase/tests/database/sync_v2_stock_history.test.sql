begin;

create extension if not exists pgtap with schema extensions;
select plan(22);

select has_function(
  'public',
  'sync_apply_stock_batch',
  array['uuid', 'jsonb'],
  'RPC de lote de estoque existe'
);
select has_function(
  'public',
  'sync_history_period_page',
  array['uuid', 'date', 'date', 'timestamp with time zone', 'uuid', 'integer'],
  'RPC de histórico remoto existe'
);
select ok(
  has_function_privilege(
    'authenticated',
    'public.sync_apply_stock_batch(uuid, jsonb)',
    'EXECUTE'
  ),
  'lote de estoque liberado somente para autenticado'
);
select ok(
  has_function_privilege(
    'authenticated',
    'public.sync_history_period_page(uuid, date, date, timestamptz, uuid, integer)',
    'EXECUTE'
  ),
  'histórico remoto liberado somente para autenticado'
);

insert into public.empresas (id, nome_fantasia)
values ('30000000-0000-4000-8000-000000000001', 'Empresa de teste');
insert into public.clientes (id, empresa_id, nome, ativo)
values (
  '31000000-0000-4000-8000-000000000001',
  '30000000-0000-4000-8000-000000000001',
  'Cliente histórico',
  true
);
insert into public.produtos (
  id, empresa_id, nome, preco_custo, valor_venda, quantidade_estoque, ativo
) values (
  '32000000-0000-4000-8000-000000000001',
  '30000000-0000-4000-8000-000000000001',
  'Produto de estoque',
  5,
  10,
  10,
  true
);
insert into public.vendas (
  id, empresa_id, cliente_id, data_venda, valor_total, valor_entrada,
  desconto, tipo_pagamento
) values (
  '33000000-0000-4000-8000-000000000001',
  '30000000-0000-4000-8000-000000000001',
  '31000000-0000-4000-8000-000000000001',
  (timezone('America/Sao_Paulo', now())::date - interval '13 months')::timestamptz,
  10,
  0,
  0,
  'parcelado'
);
insert into public.itens_venda (
  id, venda_id, produto_id, quantidade, preco_unitario, custo_unitario
) values (
  '34000000-0000-4000-8000-000000000001',
  '33000000-0000-4000-8000-000000000001',
  '32000000-0000-4000-8000-000000000001',
  1,
  10,
  5
);
insert into public.parcelas (
  id, empresa_id, venda_id, numero_parcela, valor, data_vencimento, status
) values (
  '35000000-0000-4000-8000-000000000001',
  '30000000-0000-4000-8000-000000000001',
  '33000000-0000-4000-8000-000000000001',
  1,
  10,
  current_date - 400,
  'pendente'
);

set local role authenticated;
set local "request.jwt.claims" =
  '{"sub":"aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa","role":"authenticated","app_metadata":{"empresa_id":"30000000-0000-4000-8000-000000000001"}}';

select is(
  (
    select jsonb_array_length(public.sync_apply_stock_batch(
      '30000000-0000-4000-8000-000000000001',
      '[{"operation_id":"36000000-0000-4000-8000-000000000001","produto_id":"32000000-0000-4000-8000-000000000001","quantidade_delta":3}]'::jsonb
    ))
  ),
  1,
  'lote de estoque aceita movimento'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '32000000-0000-4000-8000-000000000001'
  ),
  13,
  'movimento atualiza somente o delta'
);
select is(
  (
    select jsonb_array_length(public.sync_apply_stock_batch(
      '30000000-0000-4000-8000-000000000001',
      '[{"operation_id":"36000000-0000-4000-8000-000000000001","produto_id":"32000000-0000-4000-8000-000000000001","quantidade_delta":3}]'::jsonb
    ))
  ),
  1,
  'replay do movimento e idempotente'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '32000000-0000-4000-8000-000000000001'
  ),
  13,
  'replay nao duplica estoque'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '32000000-0000-4000-8000-000000000001'
  ),
  13,
  'estoque permanece consistente antes do ajuste'
);
select is(
  (
    select (public.sync_apply_stock_batch(
      '30000000-0000-4000-8000-000000000001',
      '[{"operation_id":"36000000-0000-4000-8000-000000000002","produto_id":"32000000-0000-4000-8000-000000000001","quantidade_delta":-2}]'::jsonb
    )->0->>'status')
  ),
  'success',
  'ajuste negativo respeita o saldo existente'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '32000000-0000-4000-8000-000000000001'
  ),
  11,
  'ajuste negativo aplica somente o delta'
);
select is(
  (
    select (public.sync_apply_stock_batch(
      '30000000-0000-4000-8000-000000000001',
      '[{"operation_id":"36000000-0000-4000-8000-000000000003","produto_id":"32000000-0000-4000-8000-000000000001","quantidade_delta":-100}]'::jsonb
    )->0->>'status')
  ),
  'error',
  'ajuste que deixaria estoque negativo e rejeitado por registro'
);
select is(
  (
    select quantidade_estoque
    from public.produtos
    where id = '32000000-0000-4000-8000-000000000001'
  ),
  11,
  'rejeicao nao altera estoque'
);

select is(
  (
    select count(*)
    from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      (timezone('America/Sao_Paulo', now())::date - interval '14 months')::date,
      (timezone('America/Sao_Paulo', now())::date - interval '13 months')::date,
      null,
      null,
      50
    )
  ),
  1::bigint,
  'histórico remoto retorna a venda no intervalo'
);
select ok(
  (
    select bool_and(next_before is null and next_before_id is null)
    from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      (timezone('America/Sao_Paulo', now())::date - interval '14 months')::date,
      (timezone('America/Sao_Paulo', now())::date - interval '13 months')::date,
      null,
      null,
      1
    )
  ),
  'última página não retorna cursor'
);
select ok(
  (
    select snapshot ? 'cliente'
    from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      (timezone('America/Sao_Paulo', now())::date - interval '14 months')::date,
      (timezone('America/Sao_Paulo', now())::date - interval '13 months')::date,
      null,
      null,
      50
    )
  ),
  'histórico inclui dados de exibição do cliente'
);
select ok(
  (
    select snapshot->'itens'->0 ? 'produto'
    from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      (timezone('America/Sao_Paulo', now())::date - interval '14 months')::date,
      (timezone('America/Sao_Paulo', now())::date - interval '13 months')::date,
      null,
      null,
      50
    )
  ),
  'histórico inclui dados de exibição do produto'
);
select throws_ok(
  $$
    select * from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      current_date - 100,
      current_date - 1,
      null,
      null,
      50
    )
  $$,
  '22023',
  null,
  'histórico rejeita intervalo que cruza o cutoff'
);
select throws_ok(
  $$
    select * from public.sync_history_period_page(
      '30000000-0000-4000-8000-000000000001',
      current_date - 200,
      current_date - 110,
      null,
      null,
      50
    )
  $$,
  '22023',
  null,
  'histórico rejeita intervalo maior que 90 dias'
);
select throws_ok(
  $$
    select * from public.sync_history_period_page(
      '40000000-0000-4000-8000-000000000004',
      current_date - 20,
      current_date - 10,
      null,
      null,
      50
    )
  $$,
  '42501',
  null,
  'histórico rejeita tenant divergente'
);
select throws_ok(
  $$
    select * from public.sync_apply_stock_batch(
      '40000000-0000-4000-8000-000000000004',
      '[]'::jsonb
    )
  $$,
  '42501',
  null,
  'estoque rejeita tenant divergente'
);
select is(
  (
    select count(*)
    from app_private.sync_mutations
    where operation_id in (
      '36000000-0000-4000-8000-000000000001',
      '36000000-0000-4000-8000-000000000002',
      '36000000-0000-4000-8000-000000000003'
    )
  ),
  2::bigint,
  'movimentos aceitos deixam rastreabilidade idempotente'
);

select * from finish();
rollback;
