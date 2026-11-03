// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/mock_master_repository.dart';
import 'data/repositories/mock_order_repository.dart';
import 'models/masters_model.dart';
import 'models/orders_model.dart';
import 'router.dart';

void main() {
  final masterRepository = MockMasterRepository();
  final orderRepository = MockOrderRepository();

  runApp(
    MultiProvider(
      providers: [
        // Fault simulation repositories provided for profile switcher
        Provider<MockMasterRepository>.value(value: masterRepository),
        Provider<MockOrderRepository>.value(value: orderRepository),

        // Domain models with DI & cascade .load()
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
