import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_controller.dart';
import 'models/sync_report.dart';
import 'providers/customer_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/sync_controller.dart';
import 'screens/auth/access_blocked_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/customers/customer_list_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/new_sale_screen.dart';
import 'screens/sales/receivables_screen.dart';
import 'screens/stock/stock_management_screen.dart';
import 'screens/sync/initial_sync_screen.dart';
import 'services/auth_gateway.dart';
import 'services/local_database.dart';
import 'services/sync_gateway.dart';
import 'services/sync_service.dart';
import 'services/session_coordinator.dart';
import 'services/tenant_resolver.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final isar = await LocalDatabase.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(VenstoqueBootstrap(isar: isar));
}

class VenstoqueBootstrap extends StatelessWidget {
  const VenstoqueBootstrap({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(SupabaseAuthGateway())..start(),
      child: AuthGate(isar: isar),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;
    if (user == null) {
      return const _VenstoqueMaterialApp(home: LoginScreen());
    }

    final resolution = TenantResolver.resolve(user);
    final empresaId = resolution.empresaId;
    if (empresaId == null) {
      return _VenstoqueMaterialApp(
        home: AccessBlockedScreen(
          message: resolution.message ?? 'Tente novamente mais tarde.',
          errorMessage: auth.errorMessage,
          isLoading: auth.isLoading,
          onRetry: () async {
            await auth.refreshSession();
          },
          onSignOut: () async {
            await auth.signOut();
          },
        ),
      );
    }

    return VenstoqueApp(
      key: ValueKey(empresaId),
      isar: isar,
      empresaId: empresaId,
    );
  }
}

class VenstoqueApp extends StatelessWidget {
  const VenstoqueApp({
    super.key,
    required this.isar,
    required this.empresaId,
  });

  final Isar isar;
  final String empresaId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(
            isar,
            empresaId: empresaId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StockProvider(
            isar,
            empresaId: empresaId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SaleProvider(
            isar,
            empresaId: empresaId,
          ),
        ),
        Provider<SyncService>(
          create: (_) => SyncService(
            isar,
            empresaId: empresaId,
          ),
        ),
        Provider<SyncGateway>(
          create: (context) => context.read<SyncService>(),
        ),
        ChangeNotifierProvider<SyncController>(
          lazy: false,
          create: (context) =>
              SyncController(context.read<SyncGateway>())..start(),
        ),
        Provider<SessionCoordinator>(
          create: (context) => SessionCoordinator(
            isar: isar,
            tenantId: empresaId,
            syncGateway: context.read<SyncGateway>(),
            authController: context.read<AuthController>(),
          ),
        ),
      ],
      child: const _VenstoqueMaterialApp(home: BootstrapGate()),
    );
  }
}

class _VenstoqueMaterialApp extends StatelessWidget {
  const _VenstoqueMaterialApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venstoque',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: _buildDarkTheme(),
      home: home,
    );
  }
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
  );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class BootstrapGate extends StatefulWidget {
  const BootstrapGate({super.key});

  @override
  State<BootstrapGate> createState() => _BootstrapGateState();
}

class _BootstrapGateState extends State<BootstrapGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = context.read<SyncController>();
      if (context.read<CustomerProvider>().customers.isNotEmpty ||
          context.read<StockProvider>().products.isNotEmpty) {
        setState(() => _ready = true);
        return;
      }
      unawaited(controller.syncNow().then((report) {
        if (!mounted) return;
        if (report.outcome == SyncOutcome.success ||
            context.read<CustomerProvider>().customers.isNotEmpty ||
            context.read<StockProvider>().products.isNotEmpty) {
          setState(() => _ready = true);
        }
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SyncController>();
    final customers = context.watch<CustomerProvider>();
    final stock = context.watch<StockProvider>();
    if (_ready || customers.customers.isNotEmpty || stock.products.isNotEmpty) {
      return const MainNavigation();
    }
    final message = switch (controller.status) {
      SyncStatus.syncing => 'Baixando clientes, produtos e vendas...',
      SyncStatus.offline =>
        'Sem conexão. Conecte-se e tente novamente para preparar o uso offline.',
      SyncStatus.partialFailure =>
        'A preparação encontrou pendências. Você pode tentar novamente.',
      _ => 'Verificando a sessão e preparando o banco local...',
    };
    return InitialSyncScreen(
      isSyncing: controller.isSyncing,
      statusMessage: message,
      lastReport: controller.lastReport,
      onRetry: () {
        unawaited(controller.syncNow().then((report) {
          if (!mounted) return;
          if (report.outcome == SyncOutcome.success ||
              customers.customers.isNotEmpty ||
              stock.products.isNotEmpty) {
            setState(() => _ready = true);
          }
        }));
      },
    );
  }
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const StockManagementScreen(),
    const NewSaleScreen(),
    const ReceivablesScreen(),
    const CustomerListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.inventory), label: 'Estoque'),
          NavigationDestination(
              icon: Icon(Icons.add_shopping_cart, color: AppColors.primary),
              label: 'Vender'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Receber'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Clientes'),
        ],
      ),
    );
  }
}
