
# Estrutura do Projeto Venstoque

**pubspec.yaml**: Arquivo de configuração do projeto. Deve conter as dependências: `supabase_flutter` para conexão com o backend, `provider` para gerência de estado, `intl` para formatação de moeda brasileira e datas, `fl_chart` para os gráficos do dashboard e `google_fonts` para a identidade visual.

**README.md**: Documentação contendo o guia de configuração do banco de dados Supabase. Deve incluir os comandos SQL para criação das tabelas (`clientes`, `produtos`, `vendas`, `itens_venda`, `parcelas`, `entradas_estoque`) e as políticas de RLS (Row Level Security).

**lib/main.dart**: O ponto de entrada do app. Realiza a inicialização do `Supabase.initialize` com a URL e Anon Key. Configura o `MultiProvider` que engloba o app com `AuthProvider`, `StockProvider`, `CustomerProvider` e `SaleProvider`. Define o `MaterialApp` com o tema personalizado (cores verde esmeralda e cinza escuro) e a rota inicial para o Dashboard ou Login.

**lib/models/cliente_model.dart**: Classe que reflete a tabela `clientes`. Atributos: `id`, `nome`, `celular`, `referencia`, `bairro`. Inclui os métodos `fromMap` e `toMap` para conversão de dados do Supabase.

**lib/models/produto_model.dart**: Representa a tabela `produtos`. Campos: `id`, `tipo`, `modelo`, `complemento`, `fornecedor`, `precoCusto`, `valorVenda`, `quantidadeEstoque`. Inclui um getter `isLowStock` que retorna verdadeiro se a quantidade for menor ou igual a 3, facilitando alertas na UI.

**lib/models/venda_model.dart**: Modelo para a tabela `vendas`. Contém `id`, `clienteId`, `dataVenda`, `valorTotal`, `tipoPagamento` (Enum: a_vista, parcelado, fiado) e `status`.

**lib/models/item_venda_model.dart**: Modelo de ligação. Atributos: `id`, `vendaId`, `produtoId`, `quantidade`, `precoUnitario`, `custoUnitario`. Importante para manter o histórico de lucro mesmo se o preço do produto mudar no futuro.

**lib/models/parcela_model.dart**: Representa a tabela `parcelas`. Atributos: `id`, `vendaId`, `numeroParcela`, `valor`, `dataVencimento`, `dataPagamento`, `status` (pendente ou pago).

**lib/models/entrada_estoque_model.dart**: Modelo para registro de compras. Atributos: `id`, `produtoId`, `quantidadeComprada`, `custoUnitario`, `fornecedor`, `dataEntrada`.

**lib/services/supabase_service.dart**: Classe singleton que expõe a instância do `SupabaseClient`. Contém métodos genéricos de CRUD simplificados para reutilização em outros services.

**lib/services/sale_service.dart**: **Arquivo Coração do App**. Contém a lógica de transação para registrar vendas.

1. `createSale`: Método que insere a `venda` e retorna o ID.
2. `saveSaleItems`: Insere a lista de `itens_venda`.
3. `decrementStock`: Para cada item vendido, chama um RPC (Stored Procedure) ou comando `update` para subtrair a quantidade da tabela `produtos`.
4. `generateInstallments`: Se o pagamento não for 'a_vista', insere as linhas na tabela `parcelas`.
Tudo envelopado em um bloco `try-catch` que garante a integridade dos dados.

**lib/services/stock_service.dart**: Gerencia a lógica de inventário.

1. `fetchProductStock`: Busca saldo atual.
2. `registerEntry`: Realiza o fluxo solicitado: Insere em `entradas_estoque` e, em seguida, atualiza o registro do produto na tabela `produtos` somando a nova quantidade e atualizando o `preco_custo` e `fornecedor` conforme a última compra.

**lib/providers/sale_provider.dart**: Gerencia o estado da "Carrinho de Vendas". Mantém uma lista temporária de `ItemVendaModel`, o cliente selecionado e o cálculo em tempo real do valor total. Possui o método `confirmSale` que invoca o `SaleService`.

**lib/providers/stock_provider.dart**: Mantém o estado da lista de produtos e histórico de entradas. Notifica a UI quando um novo produto é adicionado ou quando uma entrada de estoque é concluída.

**lib/providers/customer_provider.dart**: Gerencia a lista de clientes, permitindo busca filtrada por nome ou bairro e atualização do estado após cadastros rápidos.

**lib/screens/dashboard/dashboard_screen.dart**: Tela inicial com cards informais. Utiliza `FutureBuilder` para buscar: Total Vendido (Sum de vendas no mês), Lucro Estimado (venda - custo nos itens_venda) e Total a Receber (Sum de parcelas pendentes). Exibe gráficos de pizza com o `fl_chart` para os "Top 3 Tipos de Produtos".

**lib/screens/stock/stock_management_screen.dart**: Tela com `DefaultTabController`.

- Aba 1 (Saldo): Lista de produtos com busca. Se `quantidadeEstoque <= 0`, exibe tag vermelha; se baixo, laranja.
- Aba 2 (Histórico): Lista cronológica de `entradas_estoque`.
- FAB: Abre a tela de Cadastro de Entrada.

**lib/screens/stock/register_entry_screen.dart**: Formulário para registrar compras. Inclui um `DropdownSearch` para selecionar produtos existentes. Campos: Quantidade, Custo, Fornecedor. Ao preencher o custo, exibe um campo sugerindo novo "Valor de Venda" se o custo for superior ao atual.

**lib/screens/sales/new_sale_screen.dart**: **Tela Principal de Operação**. Implementada como um `PageView` ou `Stepper`:

- Passo 1: Seleção do Cliente (com busca dinâmica).
- Passo 2: Adição de produtos ao carrinho com seletor de quantidade e busca por nome/modelo.
- Passo 3: Escolha do pagamento. Se selecionado "Parcelado" ou "Fiado", habilita o botão para "Gerenciar Parcelas".
- Botão Finalizar: Dispara o processo do `SaleProvider`.

**lib/screens/sales/installment_setup_screen.dart**: Tela dinâmica onde o usuário define o número de parcelas. Gera automaticamente uma lista de campos de data e valor. O usuário pode ajustar manualmente cada vencimento antes de salvar a venda.

**lib/screens/sales/receivables_screen.dart**: Tela de Contas a Receber. Lista todas as parcelas com status 'pendente'. Botão de "Check" para cada linha que, ao ser clicado, chama o `SaleService` para atualizar o status para 'pago' e gravar a `data_pagamento`.

**lib/screens/customers/customer_list_screen.dart**: Visualização em lista dos clientes com atalho para WhatsApp (usando `url_launcher`) e botão para novo cadastro.

**lib/screens/customers/customer_form_screen.dart**: Formulário simples com validação para cadastrar ou editar Clientes (Nome, Celular, Referência, Bairro).

**lib/widgets/inventory_item_card.dart**: Componente visual para a lista de estoque. Mostra Nome do Modelo, Tipo e um Badge colorido indicando o nível de estoque.

**lib/widgets/sale_item_tile.dart**: Widget para exibir o item dentro do carrinho de compras, permitindo aumentar/diminuir quantidade ou remover com swipe (Dismissible).

**lib/widgets/summary_card.dart**: Widget reutilizável para o Dashboard. Recebe título, valor, ícone e cor de fundo.

**lib/utils/formatters.dart**: Funções utilitárias para formatar dinheiro (`R$ 0,00`) usando `NumberFormat.currency` e datas para o padrão brasileiro (`dd/mm/yyyy`).

**lib/utils/constants.dart**: Define as cores da marca Venstoque, estilos de texto constantes e nomes das tabelas do Supabase para evitar erros de digitação.

**lib/utils/validators.dart**: Contém lógicas de validação de formulários (CPF/CNPJ se necessário, campos obrigatórios, celular).
