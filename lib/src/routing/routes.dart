import 'package:expenses/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:expenses/src/features/transactions/presentation/transaction_detail_screen.dart';
import 'package:expenses/src/features/transactions/presentation/transactions_list_screen.dart';
import 'package:expenses/src/features/chat/presentation/chat_screen.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/scaffold_with_bottom_nav_bar.dart';

part 'routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<BottomNavigationShell>(
  branches: [
    TypedStatefulShellBranch<DashboardBranch>(
      routes: [TypedGoRoute<DashboardRoute>(path: '/dashboard')],
    ),
    TypedStatefulShellBranch<TransactionsBranch>(
      routes: [
        TypedGoRoute<TransactionsListRoute>(
          path: '/transactions',
          routes: [TypedGoRoute<ExpenseDetailRoute>(path: 'detail/:id')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatBranch>(
      routes: [TypedGoRoute<ChatRoute>(path: '/chat')],
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

class ChatBranch extends StatefulShellBranchData {
  const ChatBranch();
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
  const TransactionsListRoute({
    this.category,
    this.filterType,
    this.account,
    this.excludeFromOverview,
  });

  final Category? category;
  final TransactionType? filterType;
  final Account? account;
  final bool? excludeFromOverview;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: TransactionsListScreen(
        initialCategory: category,
        filterType: filterType,
        initialAccount: account,
        initialExcludeFromOverview: excludeFromOverview,
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
    return TransactionDetailScreen(expenseId: id);
  }
}

@immutable
class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: ChatScreen());
  }
}
