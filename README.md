# Venstoque - App de Gestão de Vendas e Estoque

Este é um aplicativo completo em Flutter para gestão de pequenos negócios, integrado com Supabase.

## Funcionalidades

- **Dashboard**: Resumo de vendas, contas a receber e gráfico de categorias.
- **Gestão de Estoque**: Cadastro de produtos, controle de saldo e histórico de entradas.
- **Vendas**: Fluxo de venda com carrinho de compras e seleção de clientes.
- **Contas a Receber**: Controle de parcelas e pagamentos pendentes.
- **Clientes**: Cadastro rápido e atalho para WhatsApp.

## Pré-requisitos

- Flutter SDK (>= 3.0.0)
- Conta no [Supabase](https://supabase.com/)

## Configuração do Banco de Dados (Supabase)

No Editor SQL do Supabase, execute o seguinte script para criar as tabelas:

    CREATE TABLE clientes (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      nome TEXT NOT NULL,
      celular TEXT,
      referencia TEXT,
      bairro TEXT,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );

    CREATE TABLE produtos (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      tipo TEXT NOT NULL,
      modelo TEXT NOT NULL,
      complemento TEXT,
      fornecedor TEXT,
      preco_custo NUMERIC DEFAULT 0,
      valor_venda NUMERIC DEFAULT 0,
      quantidade_estoque INTEGER DEFAULT 0
    );

    CREATE TABLE vendas (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      cliente_id UUID REFERENCES clientes(id),
      data_venda TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      valor_total NUMERIC DEFAULT 0,
      tipo_pagamento TEXT, -- a_vista, parcelado, fiado
      status TEXT DEFAULT 'concluida'
    );

    CREATE TABLE itens_venda (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      venda_id UUID REFERENCES vendas(id),
      produto_id UUID REFERENCES produtos(id),
      quantidade INTEGER NOT NULL,
      preco_unitario NUMERIC NOT NULL,
      custo_unitario NUMERIC NOT NULL
    );

    CREATE TABLE parcelas (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      venda_id UUID REFERENCES vendas(id),
      numero_parcela INTEGER,
      valor NUMERIC NOT NULL,
      data_vencimento DATE NOT NULL,
      data_pagamento DATE,
      status TEXT DEFAULT 'pendente' -- pendente, pago
    );

    CREATE TABLE entradas_estoque (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      produto_id UUID REFERENCES produtos(id),
      quantidade_comprada INTEGER NOT NULL,
      custo_unitario NUMERIC NOT NULL,
      fornecedor TEXT,
      data_entrada TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );

## Instalação

1. Clone o repositório.
2. No arquivo `lib/main.dart`, substitua `SUA_URL_DO_SUPABASE` e `SUA_ANON_KEY` pelas suas credenciais encontradas em Project Settings > API no painel do Supabase.
3. Rode os comandos:
    flutter pub get
    flutter run

## Estrutura de Pastas

- `lib/models`: Classes de dados.
- `lib/services`: Integração direta com Supabase.
- `lib/providers`: Lógica de negócio e estado da aplicação.
- `lib/screens`: Telas da interface.
- `lib/utils`: Constantes e formatadores (Moeda R$).
