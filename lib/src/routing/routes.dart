import 'package:expenses/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:expenses/src/features/expenses/presentation/expense_detail_screen.dart';
import 'package:expenses/src/features/expenses/presentation/expenses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/scaffold_with_bottom_nav_bar.dart';

part 'routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<BottomNavigationShell>(
  branches: [
    TypedStatefulShellBranch<DashboardBranch>(
      routes: [
        TypedGoRoute<DashboardRoute>(path: '/dashboard'),
      ],
    ),
    TypedStatefulShellBranch<ExpensesBranch>(
      routes: [
        TypedGoRoute<ExpensesListRoute>(
          path: '/expenses',
          routes: [
            TypedGoRoute<ExpenseDetailRoute>(path: 'detail/:id'),
          ],
        ),
      ],
    ),
  ],
)
class BottomNavigationShell extends StatefulShellRouteData {
  const BottomNavigationShell();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
  }
  
  static const String $restorationScopeId = 'bottom_navigation_shell';
}

class DashboardBranch extends StatefulShellBranchData {
  const DashboardBranch();
}

class ExpensesBranch extends StatefulShellBranchData {
  const ExpensesBranch();
}

@immutable
class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: DashboardScreen());
  }
}

@immutable
class ExpensesListRoute extends GoRouteData with $ExpensesListRoute {
  const ExpensesListRoute({this.category, this.filterType});

  final String? category;
  final String? filterType;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: ExpensesListScreen(
        initialCategory: category,
        filterType: filterType,
      ),
    );
  }
}

@immutable
class ExpenseDetailRoute extends GoRouteData with $ExpenseDetailRoute {
  const ExpenseDetailRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ExpenseDetailScreen(expenseId: id);
  }
}
