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
import 'screens/customers/customer_list_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sales/new_sale_screen.dart';
import 'screens/sales/receivables_screen.dart';
import 'screens/stock/stock_management_screen.dart';
import 'services/local_database.dart';
import 'services/sync_service.dart';
import 'utils/constants.dart';

const String _syncTestEmpresaId = '07039448-04c1-4ecd-94f0-65176475868c';

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

  runApp(VenstoqueApp(isar: isar));
}

class VenstoqueApp extends StatelessWidget {
  const VenstoqueApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(
            isar,
            empresaId: _syncTestEmpresaId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StockProvider(
            isar,
            empresaId: _syncTestEmpresaId,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SaleProvider(
            isar,
            empresaId: _syncTestEmpresaId,
          ),
        ),
        Provider<SyncService>(
          create: (_) => SyncService(
            isar,
            empresaId: _syncTestEmpresaId,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Venstoque',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
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
        ),
        home: const MainNavigation(),
      ),
    );
  }
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
