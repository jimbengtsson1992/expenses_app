// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$bottomNavigationShell];

RouteBase get $bottomNavigationShell => StatefulShellRouteData.$route(
  restorationScopeId: BottomNavigationShell.$restorationScopeId,
  factory: $BottomNavigationShellExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/dashboard',
          factory: $DashboardRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/transactions',
          factory: $TransactionsListRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail/:id',
              factory: $ExpenseDetailRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/chat', factory: $ChatRoute._fromState),
      ],
    ),
  ],
);

extension $BottomNavigationShellExtension on BottomNavigationShell {
  static BottomNavigationShell _fromState(GoRouterState state) =>
      const BottomNavigationShell();
}

mixin $DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  @override
  String get location => GoRouteData.$location('/dashboard');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TransactionsListRoute on GoRouteData {
  static TransactionsListRoute _fromState(GoRouterState state) =>
      TransactionsListRoute(
        category: _$convertMapValue(
          'category',
          state.uri.queryParameters,
          _$CategoryEnumMap._$fromName,
        ),
        filterType: _$convertMapValue(
          'filter-type',
          state.uri.queryParameters,
          _$TransactionTypeEnumMap._$fromName,
        ),
        account: _$convertMapValue(
          'account',
          state.uri.queryParameters,
          _$AccountEnumMap._$fromName,
        ),
        excludeFromOverview: _$convertMapValue(
          'exclude-from-overview',
          state.uri.queryParameters,
          _$boolConverter,
        ),
      );

  TransactionsListRoute get _self => this as TransactionsListRoute;

  @override
  String get location => GoRouteData.$location(
    '/transactions',
    queryParams: {
      if (_self.category != null)
        'category': _$CategoryEnumMap[_self.category!],
      if (_self.filterType != null)
        'filter-type': _$TransactionTypeEnumMap[_self.filterType!],
      if (_self.account != null) 'account': _$AccountEnumMap[_self.account!],
      if (_self.excludeFromOverview != null)
        'exclude-from-overview': _self.excludeFromOverview!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$CategoryEnumMap = {
  Category.housing: 'housing',
  Category.food: 'food',
  Category.shopping: 'shopping',
  Category.entertainment: 'entertainment',
  Category.health: 'health',
  Category.fees: 'fees',
  Category.transport: 'transport',
  Category.income: 'income',
  Category.other: 'other',
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};

const _$AccountEnumMap = {
  Account.jimPersonkonto: 'jim-personkonto',
  Account.jimSparkonto: 'jim-sparkonto',
  Account.louisePersonkonto: 'louise-personkonto',
  Account.louiseSparkonto: 'louise-sparkonto',
  Account.louiseVardagskonto: 'louise-vardagskonto',
  Account.gemensamt: 'gemensamt',
  Account.gemensamtSpar: 'gemensamt-spar',
  Account.sasAmex: 'sas-amex',
  Account.unknown: 'unknown',
};

mixin $ExpenseDetailRoute on GoRouteData {
  static ExpenseDetailRoute _fromState(GoRouterState state) =>
      ExpenseDetailRoute(id: state.pathParameters['id']!);

  ExpenseDetailRoute get _self => this as ExpenseDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/transactions/detail/${Uri.encodeComponent(_self.id)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => const ChatRoute();

  @override
  String get location => GoRouteData.$location('/chat');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}
