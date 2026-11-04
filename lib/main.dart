// lib/main.dart
// Composition Root switching Mock Repositories to HTTP REST Backend Repositories (L5)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/auth_api.dart';
import 'data/repositories/http_master_repository.dart';
import 'data/repositories/http_order_repository.dart';
import 'data/token_store.dart';
import 'models/masters_model.dart';
import 'models/orders_model.dart';
import 'router.dart';

// Base URL for Android Emulator (10.0.2.2) or Desktop / Localhost (http://localhost:8080)
const String apiBase = 'http://10.0.2.2:8080';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokens = TokenStore();
  final loggedIn = await tokens.read() != null;

  initRouter(initialLocation: loggedIn ? '/catalog' : '/login');

  final masterRepository = HttpMasterRepository(
    apiBase,
    tokens,
    onUnauthorized: () => router.go('/login'),
  );

  final orderRepository = HttpOrderRepository(
    apiBase,
    tokens,
    onUnauthorized: () => router.go('/login'),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthApi>(create: (_) => AuthApi(apiBase, tokens)),
        ChangeNotifierProvider(
          create: (_) => MastersModel(masterRepository)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersModel(orderRepository)..load(),
        ),
      ],
      child: const HomeServicesApp(),
    ),
  );
}

class HomeServicesApp extends StatelessWidget {
  const HomeServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ПрофиСервис — Поиск мастеров',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
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
      routerConfig: router,
    );
  }
}
