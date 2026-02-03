// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expensesList)
final expensesListProvider = ExpensesListProvider._();

final class ExpensesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          FutureOr<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $FutureProvider<List<Transaction>> {
  ExpensesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expensesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expensesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Transaction>> create(Ref ref) {
    return expensesList(ref);
  }
}

String _$expensesListHash() => r'64029c7d02276e084e6afb6c8bea997a81498263';

@ProviderFor(expensesForPeriod)
final expensesForPeriodProvider = ExpensesForPeriodFamily._();

final class ExpensesForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          FutureOr<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $FutureProvider<List<Transaction>> {
  ExpensesForPeriodProvider._({
    required ExpensesForPeriodFamily super.from,
    required DatePeriod super.argument,
  }) : super(
         retry: null,
         name: r'expensesForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesForPeriodHash();

  @override
  String toString() {
    return r'expensesForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Transaction>> create(Ref ref) {
    final argument = this.argument as DatePeriod;
    return expensesForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesForPeriodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesForPeriodHash() => r'987728f01c85357acb99544d68bbc19e1bcb9faa';

final class ExpensesForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Transaction>>, DatePeriod> {
  ExpensesForPeriodFamily._()
    : super(
        retry: null,
        name: r'expensesForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpensesForPeriodProvider call(DatePeriod period) =>
      ExpensesForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'expensesForPeriodProvider';
}

@ProviderFor(expenseById)
final expenseByIdProvider = ExpenseByIdFamily._();

final class ExpenseByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transaction?>,
          Transaction?,
          FutureOr<Transaction?>
        >
    with $FutureModifier<Transaction?>, $FutureProvider<Transaction?> {
  ExpenseByIdProvider._({
    required ExpenseByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'expenseByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expenseByIdHash();

  @override
  String toString() {
    return r'expenseByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Transaction?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Transaction?> create(Ref ref) {
    final argument = this.argument as String;
    return expenseById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expenseByIdHash() => r'a79b131235be5b65ac6eac8246a04add127428fb';

final class ExpenseByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Transaction?>, String> {
  ExpenseByIdFamily._()
    : super(
        retry: null,
        name: r'expenseByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpenseByIdProvider call(String id) =>
      ExpenseByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'expenseByIdProvider';
}
