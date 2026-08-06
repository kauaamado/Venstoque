import 'dart:convert';
import 'dart:io';

import 'package:supabase/supabase.dart';

import 'legacy_migration_core.dart';

const _defaultInput = 'lib/data/db.json';
const _defaultEnvironment = '.env.migration';
const _defaultReport = 'build/legacy_migration_report.json';
const _pageSize = 500;

Future<void> main(List<String> arguments) async {
  try {
    final options = _CliOptions.parse(arguments);
    final source = await _readSource(options.inputPath);
    final plan = buildLegacyMigrationPlan(source);
    final environment = await _readEnvironment(options.environmentPath);
    final client = SupabaseClient(
      _requiredEnvironment(environment, 'SUPABASE_URL'),
      _requiredEnvironment(environment, 'SUPABASE_SERVICE_ROLE_KEY'),
    );
    final runner = LegacyMigrationRunner(
      _SupabaseLegacyMigrationGateway(client),
    );
    final report = await runner.run(
      plan: plan,
      empresaId: options.empresaId,
      apply: options.apply,
    );
    await _writeReport(options.reportPath, report.toJson());
    stdout.writeln(
      options.apply
          ? 'Migração concluída. Relatório: ${options.reportPath}'
          : 'Validação concluída sem escrita. Relatório: ${options.reportPath}',
    );
  } on LegacyMigrationExecutionException catch (error) {
    await _writeReport(
        _reportPathFromArguments(arguments), error.report.toJson());
    stderr.writeln(error.message);
    exitCode = 1;
  } on LegacyMigrationException catch (error) {
    stderr.writeln('Migração não executada: ${error.message}');
    exitCode = 2;
  } on FileSystemException catch (error) {
    stderr.writeln(
        'Não foi possível acessar um arquivo da migração: ${error.message}');
    exitCode = 2;
  } on FormatException {
    stderr.writeln('O arquivo de dados ou ambiente possui formato inválido.');
    exitCode = 2;
  } catch (error) {
    stderr.writeln(
        'A migração foi interrompida. Consulte o relatório e o erro do Supabase.');
    stderr.writeln(error.runtimeType);
    exitCode = 1;
  }
}

String _reportPathFromArguments(List<String> arguments) {
  for (var index = 0; index < arguments.length; index++) {
    final argument = arguments[index];
    if (argument == '--report' && index + 1 < arguments.length) {
      return arguments[index + 1];
    }
    if (argument.startsWith('--report=')) {
      return argument.substring('--report='.length);
    }
  }
  return _defaultReport;
}

class _CliOptions {
  const _CliOptions({
    required this.apply,
    required this.empresaId,
    required this.inputPath,
    required this.environmentPath,
    required this.reportPath,
  });

  final bool apply;
  final String empresaId;
  final String inputPath;
  final String environmentPath;
  final String reportPath;

  static _CliOptions parse(List<String> arguments) {
    var apply = false;
    var dryRun = false;
    String? empresaId;
    var inputPath = _defaultInput;
    var environmentPath = _defaultEnvironment;
    var reportPath = _defaultReport;

    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments[index];
      switch (argument) {
        case '--apply':
          apply = true;
          break;
        case '--dry-run':
          dryRun = true;
          break;
        case '--empresa-id':
          empresaId = _nextValue(arguments, ++index, '--empresa-id');
          break;
        case '--input':
          inputPath = _nextValue(arguments, ++index, '--input');
          break;
        case '--env':
          environmentPath = _nextValue(arguments, ++index, '--env');
          break;
        case '--report':
          reportPath = _nextValue(arguments, ++index, '--report');
          break;
        case '--help':
        case '-h':
          _printUsage();
          exit(0);
        default:
          if (argument.startsWith('--empresa-id=')) {
            empresaId = argument.substring('--empresa-id='.length);
          } else if (argument.startsWith('--input=')) {
            inputPath = argument.substring('--input='.length);
          } else if (argument.startsWith('--env=')) {
            environmentPath = argument.substring('--env='.length);
          } else if (argument.startsWith('--report=')) {
            reportPath = argument.substring('--report='.length);
          } else {
            throw LegacyMigrationException(
                'Argumento não reconhecido. Use --help.');
          }
      }
    }

    if (apply && dryRun) {
      throw LegacyMigrationException(
          'Use apenas uma opção: --dry-run ou --apply.');
    }
    if (empresaId == null || !_isUuid(empresaId)) {
      throw LegacyMigrationException('Informe um UUID válido em --empresa-id.');
    }
    return _CliOptions(
      apply: apply,
      empresaId: empresaId,
      inputPath: inputPath,
      environmentPath: environmentPath,
      reportPath: reportPath,
    );
  }
}

class _SupabaseLegacyMigrationGateway implements LegacyMigrationGateway {
  _SupabaseLegacyMigrationGateway(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchClientes(String empresaId) =>
      _fetchPages(
        (from, to) => _client
            .from('clientes')
            .select()
            .eq('empresa_id', empresaId)
            .order('id')
            .range(from, to),
      );

  @override
  Future<List<Map<String, dynamic>>> fetchProdutos(String empresaId) =>
      _fetchPages(
        (from, to) => _client
            .from('produtos')
            .select()
            .eq('empresa_id', empresaId)
            .order('id')
            .range(from, to),
      );

  @override
  Future<List<Map<String, dynamic>>> fetchVendas(String empresaId) =>
      _fetchPages(
        (from, to) => _client
            .from('vendas')
            .select()
            .eq('empresa_id', empresaId)
            .order('id')
            .range(from, to),
      );

  @override
  Future<List<Map<String, dynamic>>> fetchItensVenda(String empresaId) =>
      _fetchPages(
        (from, to) => _client
            .from('itens_venda')
            .select('*, vendas!inner(empresa_id)')
            .eq('vendas.empresa_id', empresaId)
            .order('id')
            .range(from, to),
      );

  @override
  Future<List<Map<String, dynamic>>> fetchParcelas(String empresaId) =>
      _fetchPages(
        (from, to) => _client
            .from('parcelas')
            .select()
            .eq('empresa_id', empresaId)
            .order('id')
            .range(from, to),
      );

  @override
  Future<List<Map<String, dynamic>>> insertClientes(
    List<Map<String, dynamic>> payload,
  ) =>
      _insert('clientes', payload, 'id, legacy_id');

  @override
  Future<List<Map<String, dynamic>>> insertProdutos(
    List<Map<String, dynamic>> payload,
  ) =>
      _insert('produtos', payload, 'id, nome, categoria, fornecedor');

  @override
  Future<List<Map<String, dynamic>>> insertVendas(
    List<Map<String, dynamic>> payload,
  ) =>
      _insert('vendas', payload, 'id, legacy_id');

  @override
  Future<List<Map<String, dynamic>>> insertItensVenda(
    List<Map<String, dynamic>> payload,
  ) =>
      _insert('itens_venda', payload, 'id');

  @override
  Future<List<Map<String, dynamic>>> insertParcelas(
    List<Map<String, dynamic>> payload,
  ) =>
      _insert('parcelas', payload, 'id');

  Future<List<Map<String, dynamic>>> _fetchPages(
    Future<dynamic> Function(int from, int to) fetch,
  ) async {
    final rows = <Map<String, dynamic>>[];
    for (var from = 0;; from += _pageSize) {
      final response = await fetch(from, from + _pageSize - 1);
      final page = List<Map<String, dynamic>>.from(response as List);
      rows.addAll(page);
      if (page.length < _pageSize) return rows;
    }
  }

  Future<List<Map<String, dynamic>>> _insert(
    String table,
    List<Map<String, dynamic>> payload,
    String select,
  ) async {
    if (payload.isEmpty) return const [];
    final response = await _client.from(table).insert(payload).select(select);
    return List<Map<String, dynamic>>.from(response as List);
  }
}

Future<Map<String, dynamic>> _readSource(String path) async {
  final content = await File(path).readAsString();
  final value = jsonDecode(content);
  if (value is! Map) {
    throw const FormatException('A raiz do JSON deve ser um objeto.');
  }
  return Map<String, dynamic>.from(value);
}

Future<Map<String, String>> _readEnvironment(String path) async {
  final environment = <String, String>{};
  final lines = await File(path).readAsLines();
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final separator = line.indexOf('=');
    if (separator <= 0) {
      throw const FormatException('Linha de ambiente inválida.');
    }
    final key = line.substring(0, separator).trim();
    var value = line.substring(separator + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }
    environment[key] = value;
  }
  return environment;
}

String _requiredEnvironment(Map<String, String> environment, String key) {
  final value = environment[key]?.trim();
  if (value == null || value.isEmpty) {
    throw LegacyMigrationException(
        'A variável $key é obrigatória em .env.migration.');
  }
  return value;
}

Future<void> _writeReport(String path, Map<String, dynamic> report) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(report));
}

String _nextValue(List<String> arguments, int index, String option) {
  if (index >= arguments.length || arguments[index].startsWith('--')) {
    throw LegacyMigrationException('A opção $option exige um valor.');
  }
  return arguments[index];
}

bool _isUuid(String value) => RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);

void _printUsage() {
  stdout.writeln('Uso: dart run tool/migrate_legacy.dart '
      '--empresa-id <UUID> [--dry-run | --apply] '
      '[--input caminho] [--env caminho] [--report caminho]');
}
