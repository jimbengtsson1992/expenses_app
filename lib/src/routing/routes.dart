import 'package:expenses/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:expenses/src/features/transactions/presentation/expense_detail_screen.dart';
import 'package:expenses/src/features/transactions/presentation/transactions_list_screen.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
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
    TypedStatefulShellBranch<TransactionsBranch>(
      routes: [
        TypedGoRoute<TransactionsListRoute>(
          path: '/transactions',
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

class TransactionsBranch extends StatefulShellBranchData {
  const TransactionsBranch();
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
class TransactionsListRoute extends GoRouteData with $TransactionsListRoute {
  const TransactionsListRoute({this.category, this.filterType, this.account});

  final String? category;
  final String? filterType;
  final String? account;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    Account? initialAccount;
    if (account != null) {
      try {
        initialAccount = Account.values.firstWhere((a) => a.displayName == account || a.name == account);
      } catch (_) {}
    }

    return NoTransitionPage(
      child: TransactionsListScreen(
        initialCategory: category,
        filterType: filterType,
        initialAccount: initialAccount,
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
