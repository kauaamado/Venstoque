import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/customer_provider.dart';
import 'providers/stock_provider.dart';
import 'providers/sale_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/stock/stock_management_screen.dart';
import 'screens/sales/new_sale_screen.dart';
import 'screens/sales/receivables_screen.dart';
import 'screens/customers/customer_list_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  // INFORME SUAS CREDENCIAIS DO SUPABASE AQUI
  await Supabase.initialize(
    url:'SUA_URL_DO_SUPABASE',
    anonKey:'SUA_ANON_KEY_DO_SUPABASE',
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const VenstoqueApp());
}

class VenstoqueApp extends StatelessWidget {
  const VenstoqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
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
