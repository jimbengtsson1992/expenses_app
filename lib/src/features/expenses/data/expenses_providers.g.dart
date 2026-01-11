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
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
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
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
    return expensesList(ref);
  }
}

String _$expensesListHash() => r'4046517df5f462a20dfa863efec5aa71460c8c95';

@ProviderFor(expensesForMonth)
final expensesForMonthProvider = ExpensesForMonthFamily._();

final class ExpensesForMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          FutureOr<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $FutureProvider<List<Expense>> {
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
  $FutureProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Expense>> create(Ref ref) {
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

String _$expensesForMonthHash() => r'2a8b9c753344c9c420b329d7e66b89d52e5d75a4';

final class ExpensesForMonthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Expense>>, DateTime> {
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
        $FunctionalProvider<AsyncValue<Expense?>, Expense?, FutureOr<Expense?>>
    with $FutureModifier<Expense?>, $FutureProvider<Expense?> {
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
  $FutureProviderElement<Expense?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Expense?> create(Ref ref) {
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

String _$expenseByIdHash() => r'60eea03fb6fe5d172e34b841ed002788876f2b5c';

final class ExpenseByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Expense?>, String> {
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
