import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common_widgets/scaffold_with_bottom_nav_bar.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/expenses_list_screen.dart';
import '../features/expenses/presentation/expense_detail_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _shellNavigatorExpensesKey = GlobalKey<NavigatorState>(debugLabel: 'expenses');

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboardKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExpensesKey,
            routes: [
              GoRoute(
                path: '/expenses',
                pageBuilder: (context, state) => const NoTransitionPage(child: ExpensesListScreen()),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    parentNavigatorKey: _rootNavigatorKey, // Overlay over bottom nav
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ExpenseDetailScreen(expenseId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
