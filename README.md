# Venstoque

Aplicativo Flutter, em português do Brasil, para gestão de clientes, produtos,
estoque, vendas e contas a receber. A aplicação segue uma arquitetura
offline-first: a interface trabalha com o banco local Isar e o `SyncService`
sincroniza os dados com o Supabase.

## Funcionalidades

- Dashboard com resumo mensal, contas a receber e distribuição do estoque.
- Cadastro e gerenciamento local de clientes e produtos.
- Registro offline de vendas, itens e parcelas em uma transação atômica.
- Atualização de estoque durante vendas e entradas de produtos.
- Histórico de vendas e visão financeira por cliente.
- Controle de parcelas, pagamentos parciais e quitação de compras.
- Abertura de conversas e envio de recibos pelo WhatsApp.
- Autenticação por e-mail e senha com restauração da sessão.
- Isolamento dos dados por empresa.
- Sincronização automática no início, ao retornar ao aplicativo e sob demanda.
- Indicador visual de sincronização e pull-to-refresh nas telas principais.

## Arquitetura

O fluxo principal é:

```text
Screen/Widget -> Provider -> Isar -> SyncService -> Supabase
```

- A UI lê e grava exclusivamente no Isar por meio dos providers.
- O Isar mantém IDs locais autoincrementais e os UUIDs remotos em
  `supabaseId`.
- Alterações pendentes são preservadas localmente quando a rede falha.
- O push respeita a ordem clientes, produtos, vendas, itens e parcelas.
- O pull considera o Supabase a fonte da verdade para registros sem alterações
  locais pendentes.
- O tenant é obtido de `currentUser.appMetadata['empresa_id']`.

O suporte offline atual é destinado a Android, iOS e desktop. A execução web
não faz parte do escopo da camada Isar nesta versão.

## Tecnologias principais

- Flutter e Dart.
- Provider com `ChangeNotifier`.
- Isar Community 3.3.2.
- Supabase Auth e PostgREST.
- Material 3, `intl`, `fl_chart`, `google_fonts` e `url_launcher`.

## Pré-requisitos

- Flutter compatível com Dart `>=3.0.0 <4.0.0`.
- Projeto Supabase de desenvolvimento configurado.
- Usuário cadastrado no Supabase Auth.
- Android, iOS ou desktop para testar a persistência local.

## Configuração do Supabase

O banco remoto deve possuir as seguintes tabelas:

- `empresas`: `id`, `nome_fantasia`.
- `clientes`: `id`, `empresa_id`, `nome`, `celular`, `referencia`,
  `observacoes`, `ativo`, `legacy_id`.
- `produtos`: `id`, `empresa_id`, `nome`, `categoria`, `fornecedor`,
  `preco_custo`, `valor_venda`, `quantidade_estoque`, `ativo`.
- `vendas`: `id`, `empresa_id`, `cliente_id`, `data_venda`, `valor_total`,
  `valor_entrada`, `desconto`, `tipo_pagamento`, `observacoes`, `legacy_id`.
- `itens_venda`: `id`, `venda_id`, `produto_id`, `quantidade`,
  `preco_unitario`, `custo_unitario`.
- `parcelas`: `id`, `empresa_id`, `venda_id`, `numero_parcela`, `valor`,
  `data_vencimento`, `data_pagamento`, `status`.

As políticas RLS devem permitir somente o acesso aos registros da empresa do
usuário autenticado. Configure o UUID da empresa em `app_metadata`, usando uma
operação administrativa do Supabase:

```json
{
  "empresa_id": "00000000-0000-4000-8000-000000000000"
}
```

Não use `user_metadata` para autorizar o tenant, pois esse conteúdo pode ser
alterado pelo próprio usuário. A chave anônima no aplicativo também não
substitui políticas RLS adequadas.

## Migração de dados legados

O importador em `tool/migrate_legacy.dart` serve apenas para trazer o export
legado ao ambiente de desenvolvimento. Ele usa uma chave `service_role` fora do
aplicativo, valida os dados antes de escrever e pode ser retomado após falhas.

1. Copie `.env.migration.example` para `.env.migration` e preencha as
   credenciais do projeto de desenvolvimento. Nunca use a chave de produção.
2. Execute a validação, sem escrita:

```sh
dart run tool/migrate_legacy.dart \
  --empresa-id 00000000-0000-4000-8000-000000000000 \
  --dry-run
```

3. Revise `build/legacy_migration_report.json`. Somente então execute o mesmo
   comando com `--apply` no lugar de `--dry-run`.

O arquivo de dados e a chave de migração são ignorados pelo Git. Não execute a
migração enquanto o aplicativo estiver sincronizando o mesmo tenant.

## Variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto:

```dotenv
SUPABASE_URL=https://SEU-PROJETO.supabase.co
SUPABASE_ANON_KEY=SUA_CHAVE_ANONIMA
```

O `.env` é ignorado pelo Git. Nunca adicione ao repositório a URL real, a chave
anônima, a chave `service_role`, senhas ou outras credenciais.

## Instalação e execução

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Se o projeto estiver sendo executado com FVM, prefixe os comandos Flutter com
`fvm`, por exemplo: `fvm flutter run`.

O comando do `build_runner` deve ser repetido sempre que uma collection do Isar
for alterada.

## Verificação

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test -j 1
```

Para uma prova manual completa:

1. Entre com um usuário que tenha `app_metadata.empresa_id` válido.
2. Crie clientes, produtos e uma venda com a internet desligada.
3. Confirme que os dados aparecem imediatamente nas telas.
4. Restabeleça a internet e execute a sincronização pelo indicador da AppBar.
5. Confira os UUIDs e relacionamentos no Supabase e no Isar Inspector.
6. Reinicie o aplicativo e confirme a restauração da sessão e dos dados.

Não execute testes de mutação ou reconciliação contra produção.

## Estrutura do projeto

- `lib/models/local/`: collections e schemas do Isar.
- `lib/models/`: DTOs utilizados pela UI e relatórios de sincronização.
- `lib/providers/`: estado, regras de negócio locais, autenticação e
  sincronização.
- `lib/services/`: abertura do Isar, autenticação e comunicação com Supabase.
- `lib/screens/`: telas agrupadas por domínio.
- `lib/widgets/`: componentes visuais reutilizáveis.
- `lib/utils/`: cores, formatadores, busca e feedback de sincronização.
- `test/`: testes de models, providers, autenticação, navegação e widgets.

## Segurança e dados

- Não faça commit do `.env` ou de credenciais.
- Não use uma chave `service_role` dentro do aplicativo.
- Mantenha o RLS habilitado e validado em todas as tabelas remotas.
- Dados locais pendentes não devem ser apagados durante uma falha de sync.
- Migrações e testes de carga devem usar o ambiente Supabase de desenvolvimento.
