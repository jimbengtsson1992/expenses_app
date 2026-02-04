// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_estimate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monthlyEstimate)
final monthlyEstimateProvider = MonthlyEstimateFamily._();

final class MonthlyEstimateProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyEstimate?>,
          MonthlyEstimate?,
          FutureOr<MonthlyEstimate?>
        >
    with $FutureModifier<MonthlyEstimate?>, $FutureProvider<MonthlyEstimate?> {
  MonthlyEstimateProvider._({
    required MonthlyEstimateFamily super.from,
    required DatePeriod super.argument,
  }) : super(
         retry: null,
         name: r'monthlyEstimateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyEstimateHash();

  @override
  String toString() {
    return r'monthlyEstimateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlyEstimate?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyEstimate?> create(Ref ref) {
    final argument = this.argument as DatePeriod;
    return monthlyEstimate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyEstimateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyEstimateHash() => r'2973fc6be75be6ad66fdc999630693538adcbc68';

final class MonthlyEstimateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MonthlyEstimate?>, DatePeriod> {
  MonthlyEstimateFamily._()
    : super(
        retry: null,
        name: r'monthlyEstimateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlyEstimateProvider call(DatePeriod period) =>
      MonthlyEstimateProvider._(argument: period, from: this);

  @override
  String toString() => r'monthlyEstimateProvider';
}
