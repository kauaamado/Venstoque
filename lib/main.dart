import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar_community/isar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/customer_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/sync_controller.dart';
import 'screens/customers/customer_list_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/new_sale_screen.dart';
import 'screens/sales/receivables_screen.dart';
import 'screens/stock/stock_management_screen.dart';
import 'services/local_database.dart';
import 'services/sync_service.dart';
import 'services/tenant_resolver.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await dotenv.load(fileName: ".env");

  // INFORME SUAS CREDENCIAIS DO SUPABASE AQUI
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final devLoginEmail = dotenv.env['DEV_LOGIN_EMAIL']?.trim();
  final devLoginPassword = dotenv.env['DEV_LOGIN_PASSWORD'];
  if (devLoginEmail != null &&
      devLoginEmail.isNotEmpty &&
      devLoginPassword != null &&
      devLoginPassword.isNotEmpty) {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: devLoginEmail,
        password: devLoginPassword,
      );
    } catch (error) {
      debugPrint('Erro no login automático de desenvolvimento: $error');
    }
  }

  final isar = await LocalDatabase.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(VenstoqueBootstrap(isar: isar));
}

class VenstoqueBootstrap extends StatefulWidget {
  const VenstoqueBootstrap({super.key, required this.isar});

  final Isar isar;

  @override
  State<VenstoqueBootstrap> createState() => _VenstoqueBootstrapState();
}

class _VenstoqueBootstrapState extends State<VenstoqueBootstrap> {
  late TenantResolution _resolution;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _resolveTenant();
  }

  void _resolveTenant() {
    _resolution = TenantResolver.resolve(
      Supabase.instance.client.auth.currentUser,
    );
  }

  Future<void> _retry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);
    try {
      if (Supabase.instance.client.auth.currentSession != null) {
        await Supabase.instance.client.auth.refreshSession();
      }
    } catch (error) {
      debugPrint('Erro ao atualizar a sessão: $error');
    } finally {
      if (mounted) {
        setState(() {
          _resolveTenant();
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final empresaId = _resolution.empresaId;
    if (empresaId != null) {
      return VenstoqueApp(isar: widget.isar, empresaId: empresaId);
    }

    return MaterialApp(
      title: 'Venstoque',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: _buildDarkTheme(),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Não foi possível identificar sua empresa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _resolution.message ?? 'Tente novamente mais tarde.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isRetrying ? null : _retry,
                    icon: _isRetrying
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        ChangeNotifierProvider<SyncController>(
          lazy: false,
          create: (context) =>
              SyncController(context.read<SyncService>())..start(),
        ),
      ],
      child: MaterialApp(
        title: 'Venstoque',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: _buildDarkTheme(),
        home: const MainNavigation(),
      ),
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
