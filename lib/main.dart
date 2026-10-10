// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/services_catalog_screen.dart';
import 'screens/master_list_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/create_order_screen.dart';

void main() {
  runApp(const HomeServicesApp());
}

class HomeServicesApp extends StatelessWidget {
  const HomeServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПрофиСервис — Поиск мастеров',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Seed color matching the home services domain (reliable blue)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

// Minimal navigation wrapper for L2 demonstration
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ServicesCatalogScreen(),
    MasterListScreen(),
    OrderHistoryScreen(),
    FavoritesScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Каталог',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Мастера',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Заказы',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Избранное',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
      // Floating Action Button to demonstrate Create Order form
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Заказать услугу'),
            )
          : null,
    );
  }
}
