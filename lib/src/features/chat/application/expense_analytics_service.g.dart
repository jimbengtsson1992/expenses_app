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

String _$expenseAnalyticsHash() => r'96377bfed77cd6f0051a5dac93b6529f2cac01dd';

/// Analytics for transactions that are excluded from regular estimates
/// (one-time/unusual expenses like kitchen renovations, loans)

@ProviderFor(excludedExpenseAnalytics)
final excludedExpenseAnalyticsProvider = ExcludedExpenseAnalyticsProvider._();

/// Analytics for transactions that are excluded from regular estimates
/// (one-time/unusual expenses like kitchen renovations, loans)

final class ExcludedExpenseAnalyticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExpenseAnalytics>,
          ExpenseAnalytics,
          FutureOr<ExpenseAnalytics>
        >
    with $FutureModifier<ExpenseAnalytics>, $FutureProvider<ExpenseAnalytics> {
  /// Analytics for transactions that are excluded from regular estimates
  /// (one-time/unusual expenses like kitchen renovations, loans)
  ExcludedExpenseAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excludedExpenseAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excludedExpenseAnalyticsHash();

  @$internal
  @override
  $FutureProviderElement<ExpenseAnalytics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExpenseAnalytics> create(Ref ref) {
    return excludedExpenseAnalytics(ref);
  }
}

String _$excludedExpenseAnalyticsHash() =>
    r'9cabc9b7657511197f3d0f045880aeee06b70117';
