// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_analytics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseAnalytics)
final expenseAnalyticsProvider = ExpenseAnalyticsProvider._();

final class ExpenseAnalyticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExpenseAnalytics>,
          ExpenseAnalytics,
          FutureOr<ExpenseAnalytics>
        >
    with $FutureModifier<ExpenseAnalytics>, $FutureProvider<ExpenseAnalytics> {
  ExpenseAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseAnalyticsHash();

  @$internal
  @override
  $FutureProviderElement<ExpenseAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExpenseAnalytics> create(Ref ref) {
    return expenseAnalytics(ref);
  }
}

String _$expenseAnalyticsHash() => r'69b78682b2259db8ef8a6ff2c97654e77f7e3d35';
