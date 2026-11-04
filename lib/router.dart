// lib/router.dart
import 'package:go_router/go_router.dart';
import 'package:home_services/widgets/app_shell.dart';
import 'package:home_services/screens/login_screen.dart';
import 'package:home_services/screens/services_catalog_screen.dart';
import 'package:home_services/screens/master_list_screen.dart';
import 'package:home_services/screens/master_detail_screen.dart';
import 'package:home_services/screens/order_history_screen.dart';
import 'package:home_services/screens/order_detail_screen.dart';
import 'package:home_services/screens/favorites_screen.dart';
import 'package:home_services/screens/user_profile_screen.dart';
import 'package:home_services/screens/create_order_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Auth Route
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Create Order Screen Route
    GoRoute(
      path: '/create-order',
      builder: (context, state) {
        final masterId = state.uri.queryParameters['masterId'];
        return CreateOrderScreen(masterId: masterId);
      },
    ),

    // StatefulShellRoute for Persistent Tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Catalog
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const ServicesCatalogScreen(),
            ),
          ],
        ),

        // Branch 1: Masters list & Master detail
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/masters',
              builder: (context, state) => const MasterListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return MasterDetailScreen(masterId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Order history & Order detail
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrderHistoryScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return OrderDetailScreen(orderId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 3: Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),

        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const UserProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
