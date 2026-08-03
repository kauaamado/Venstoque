# AGENTS.md

Este arquivo orienta agentes de IA que trabalham no Venstoque. Use o código do
repositório como fonte de verdade. `README.md` e `context.md` contêm partes de uma
especificação inicial e podem estar desatualizados em relação à implementação.

## Projeto

Venstoque é um aplicativo Flutter, em português do Brasil, para gestão de
clientes, produtos, estoque, vendas e contas a receber de um pequeno negócio.

- Package Dart: `venstoque`.
- SDK declarado: Dart `>=3.0.0 <4.0.0`.
- Backend atual: Supabase, acessado diretamente pelo app.
- Estado: `provider` com `ChangeNotifier`.
- UI: Material 3, tema escuro e orientação retrato.
- Locale: `pt_BR` para datas e moeda.
- Plataformas presentes: Android, iOS, web, Linux, macOS e Windows.
- Não há autenticação, multi-tenancy, banco local ou sincronização offline
  implementados atualmente.

Não presuma que Isar, `SyncService`, `empresa_id`, RLS ou funcionamento
offline-first já existam. Se uma tarefa pedir essas capacidades, trate-a como
uma mudança arquitetural e avalie o impacto antes de implementar.

## Estrutura real

- `lib/main.dart`: inicializa locale, Supabase, providers, tema e navegação.
- `lib/models/`: modelos e conversão entre objetos Dart e mapas do Supabase.
- `lib/services/`: cliente Supabase e fluxos de venda e estoque.
- `lib/providers/`: estado dos domínios de clientes, estoque e vendas.
- `lib/screens/`: telas agrupadas por domínio.
- `lib/widgets/`: componentes visuais reutilizáveis.
- `lib/utils/constants.dart`: cores e nomes de tabelas.
- `lib/utils/formatters.dart`: moeda, datas e abertura do WhatsApp.
- `assets/venstoque-logo.png`: identidade visual do aplicativo.
- `test/widget_test.dart`: teste do template Flutter, atualmente incompatível
  com o app real.

## Arquitetura e fluxo de dados

O fluxo predominante é:

`Screen/Widget -> Provider -> Service -> Supabase -> Model`

- Widgets consomem providers com `context.read`, `context.watch` ou `Consumer`.
- Providers mantêm estado, controlam carregamento, notificam listeners e chamam
  services.
- Services concentram queries e mutações do Supabase.
- `SupabaseService` é singleton e expõe `Supabase.instance.client`.
- Modelos usam propriedades Dart em `camelCase` e convertem as colunas
  `snake_case` em `fromMap` e `toMap`.
- Use as constantes de `AppTables` para tabelas já mapeadas.

Existem acessos legados ao Supabase diretamente em providers e no dashboard.
Não adicione novas queries em widgets. Ao alterar um acesso legado, considere
extraí-lo para um service quando isso couber no escopo da tarefa.

## Domínio e persistência

As tabelas referenciadas no código são:

- `clientes`
- `produtos`
- `vendas`
- `itens_venda`
- `parcelas`
- `estoque`
- `historico` (possui constante, mas pode não estar em uso)

Regras e formatos observados:

- Tipos de pagamento: `a_vista`, `parcelado` e `fiado`.
- Status usados por vendas/parcelas: `pendente` e `pago`.
- Datas são persistidas em ISO 8601 e exibidas no padrão brasileiro.
- Valores do Supabase podem chegar como diferentes subtipos de `num`; converta
  para `double` ou `int` de forma defensiva.
- `ItemVendaModel.produtoNome` serve apenas à UI e não é persistido.
- `EstoqueModel.toMap()` não envia `complemento` nem `novoValorVenda`; o novo
  preço é atualizado em `produtos` pelo `StockService`.

Não renomeie tabelas, colunas ou valores persistidos apenas para melhorar o
estilo Dart. Alterações desse tipo exigem migração coordenada no Supabase e
compatibilidade com dados existentes.

### Consistência de vendas e estoque

`SaleService.processSale` e `StockService.registerProductEntry` fazem múltiplas
operações sequenciais no Supabase. Isso não é uma transação atômica: uma falha
intermediária pode deixar venda, itens, parcelas ou saldo parcialmente gravados.

Ao trabalhar nesses fluxos:

- preserve a ordem das operações existentes;
- considere concorrência, repetição da requisição e estoque negativo;
- não descreva um `try/catch` como garantia de rollback;
- prefira RPC/função no banco quando a tarefa exigir atomicidade real;
- não teste mutações contra produção por padrão.

## Configuração e segredos

`lib/main.dart` importa `lib/api.dart`. Esse arquivo é local, ignorado pelo Git,
e deve definir:

```dart
const apiUrl = '...';
const apiAnonKey = '...';
```

- Nunca faça commit de URL, anon key, service-role key ou outras credenciais.
- Não remova `lib/api.dart` do `.gitignore`.
- Use valores fictícios em exemplos e documentação.
- A anon key no cliente não substitui políticas RLS adequadas no Supabase.

## Convenções de código

- Mantenha textos de interface em português do Brasil.
- Siga `flutter_lints` e o estilo dos arquivos próximos.
- Classes: `PascalCase`; membros: `camelCase`; arquivos: `snake_case`.
- Preserve null safety e evite `!` quando uma validação explícita for possível.
- Prefira widgets pequenos e reutilizáveis para padrões visuais repetidos.
- Preserve o tema escuro e reutilize `AppColors` para cores da marca.
- Use `AppFormatters` para moeda e datas apresentadas ao usuário.
- Em providers assíncronos, restaure flags de carregamento em `finally` e chame
  `notifyListeners()` nos momentos necessários.
- Não silencie erros novos. Propague-os quando a tela precisar informar falha ao
  usuário; mensagens visíveis devem ser claras e em português.
- Antes de usar `BuildContext` depois de um `await`, verifique `mounted`.
- Evite comentários que apenas repetem o código ou referências temporárias como
  “novo”, “mudança aqui” e “supondo que”.
- Não edite `.dart_tool/`, `build/`, APKs ou outros artefatos gerados como parte
  de uma mudança de código-fonte.

## Dependências principais

- `supabase_flutter`: backend.
- `provider`: gerenciamento de estado.
- `intl`: datas e moeda em `pt_BR`.
- `fl_chart`: gráficos do dashboard.
- `google_fonts`: tipografia do tema.
- `url_launcher`: abertura do WhatsApp.

Antes de adicionar uma dependência, verifique se o SDK ou os pacotes atuais já
resolvem o problema. Ao alterar `pubspec.yaml`, execute `flutter pub get` e
mantenha `pubspec.lock` coerente.

## Verificação

Para mudanças comuns em Dart/Flutter, execute:

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Use `dart format lib test` para corrigir a formatação. Se dependências mudarem,
execute `flutter pub get` antes das verificações.

`test/widget_test.dart` ainda testa o contador do template Flutter e não
representa o `VenstoqueApp`. Sua falha é uma limitação preexistente, não evidência
de regressão. Ao alterar bootstrap ou navegação, substitua-o por um teste útil e
isole a dependência do Supabase quando necessário.

Se o Flutter tentar escrever no SDK fora do workspace e o ambiente impedir a
operação, informe o comando e o erro. Não modifique o SDK para contornar a
restrição do ambiente.

## Git e entrega

- Preserve alterações do usuário que não pertençam à tarefa.
- Revise `git diff` antes de concluir.
- Não inclua credenciais, artefatos gerados ou mudanças não relacionadas.
- Não crie branch, commit, push ou pull request sem solicitação do usuário.
- Quando um commit for solicitado, siga o padrão já usado no histórico do
  projeto, preferencialmente Conventional Commits (`feat:`, `fix:`, `chore:`,
  `docs:` ou `test:`).

Checklist final:

1. Confirme que a implementação segue o código real, não apenas a documentação.
2. Revise impactos em telas, providers, services, modelos e esquema Supabase.
3. Considere estados de carregamento, vazio, erro e sucesso.
4. Formate e execute análise/testes possíveis.
5. Informe falhas preexistentes ou verificações bloqueadas pelo ambiente.
