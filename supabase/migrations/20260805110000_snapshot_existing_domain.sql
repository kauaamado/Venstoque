-- Baseline somente para o banco local criado do zero pelos testes.
-- Em um projeto remoto que já contém todo o domínio, esta migration é um no-op.
do $$
declare
  existing_tables integer;
begin
  select count(*)
  into existing_tables
  from pg_catalog.pg_class c
  join pg_catalog.pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'public'
    and c.relname = any (
      array[
        'empresas',
        'clientes',
        'produtos',
        'vendas',
        'itens_venda',
        'parcelas'
      ]
    )
    and c.relkind in ('r', 'p');

  if existing_tables = 6 then
    return;
  end if;

  if existing_tables <> 0 then
    raise exception
      'Baseline do domínio incompleta: esperadas 0 ou 6 tabelas, encontradas %.',
      existing_tables;
  end if;

  create table public.empresas (
    id uuid primary key default gen_random_uuid(),
    nome_fantasia varchar not null,
    created_at timestamptz default now()
  );

  create table public.clientes (
    id uuid primary key default gen_random_uuid(),
    empresa_id uuid not null references public.empresas(id),
    nome varchar not null,
    celular varchar,
    referencia varchar,
    observacoes text,
    ativo boolean default true,
    legacy_id integer,
    created_at timestamptz default now()
  );

  create table public.produtos (
    id uuid primary key default gen_random_uuid(),
    empresa_id uuid not null references public.empresas(id),
    nome varchar not null,
    categoria varchar,
    fornecedor varchar,
    preco_custo numeric not null default 0.00,
    valor_venda numeric not null default 0.00,
    quantidade_estoque integer not null default 0,
    ativo boolean default true,
    created_at timestamptz default now()
  );

  create table public.vendas (
    id uuid primary key default gen_random_uuid(),
    empresa_id uuid not null references public.empresas(id),
    cliente_id uuid not null references public.clientes(id),
    data_venda timestamptz default now(),
    valor_total numeric not null,
    valor_entrada numeric default 0.00,
    desconto numeric default 0.00,
    tipo_pagamento varchar not null,
    observacoes text,
    legacy_id integer,
    created_at timestamptz default now()
  );

  create table public.itens_venda (
    id uuid primary key default gen_random_uuid(),
    venda_id uuid not null references public.vendas(id) on delete cascade,
    produto_id uuid not null references public.produtos(id),
    quantidade integer not null,
    preco_unitario numeric not null,
    custo_unitario numeric not null
  );

  create table public.parcelas (
    id uuid primary key default gen_random_uuid(),
    empresa_id uuid not null references public.empresas(id),
    venda_id uuid not null references public.vendas(id) on delete cascade,
    numero_parcela integer not null,
    valor numeric not null,
    data_vencimento date not null,
    data_pagamento date,
    status varchar default 'pendente'
  );

  alter table public.empresas enable row level security;
  alter table public.clientes enable row level security;
  alter table public.produtos enable row level security;
  alter table public.vendas enable row level security;
  alter table public.itens_venda enable row level security;
  alter table public.parcelas enable row level security;

  create policy "Visualizar empresa atual"
  on public.empresas
  for select
  to authenticated
  using (
    id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  );

  create policy "Isolar clientes por empresa"
  on public.clientes
  for all
  to authenticated
  using (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  )
  with check (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  );

  create policy "Isolar produtos por empresa"
  on public.produtos
  for all
  to authenticated
  using (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  )
  with check (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  );

  create policy "Isolar vendas por empresa"
  on public.vendas
  for all
  to authenticated
  using (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  )
  with check (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  );

  create policy "Isolar itens atraves da venda"
  on public.itens_venda
  for all
  to authenticated
  using (
    venda_id in (
      select id
      from public.vendas
      where empresa_id = (
        ((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid
      )
    )
  )
  with check (
    venda_id in (
      select id
      from public.vendas
      where empresa_id = (
        ((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid
      )
    )
  );

  create policy "Isolar parcelas por empresa"
  on public.parcelas
  for all
  to authenticated
  using (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  )
  with check (
    empresa_id = (((select auth.jwt())->'app_metadata'->>'empresa_id')::uuid)
  );

  grant select on public.empresas to authenticated;

  grant select, insert, update, delete
  on public.clientes,
     public.produtos,
     public.vendas,
     public.itens_venda,
     public.parcelas
  to authenticated;
end
$$;
