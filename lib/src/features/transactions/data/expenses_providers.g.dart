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

String _$expensesListHash() => r'68b9a791a2a1d6bd0f840c8cc7afd38cab3b754c';

@ProviderFor(expensesForMonth)
final expensesForMonthProvider = ExpensesForMonthFamily._();

final class ExpensesForMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          FutureOr<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $FutureProvider<List<Transaction>> {
  ExpensesForMonthProvider._({
    required ExpensesForMonthFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'expensesForMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesForMonthHash();

  @override
  String toString() {
    return r'expensesForMonthProvider'
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
    final argument = this.argument as DateTime;
    return expensesForMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesForMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesForMonthHash() => r'05a981bebe75a0d9e6905e1f6b3a31d6f2b01070';

final class ExpensesForMonthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Transaction>>, DateTime> {
  ExpensesForMonthFamily._()
    : super(
        retry: null,
        name: r'expensesForMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpensesForMonthProvider call(DateTime month) =>
      ExpensesForMonthProvider._(argument: month, from: this);

  @override
  String toString() => r'expensesForMonthProvider';
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
