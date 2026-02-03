// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_period_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DatePeriodNotifier)
final datePeriodProvider = DatePeriodNotifierProvider._();

final class DatePeriodNotifierProvider
    extends $NotifierProvider<DatePeriodNotifier, DatePeriod> {
  DatePeriodNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'datePeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$datePeriodNotifierHash();

  @$internal
  @override
  DatePeriodNotifier create() => DatePeriodNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatePeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatePeriod>(value),
    );
  }
}

String _$datePeriodNotifierHash() =>
    r'd195bbd424a59baa3d5f712fae2f7f91d0244ac6';

abstract class _$DatePeriodNotifier extends $Notifier<DatePeriod> {
  DatePeriod build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DatePeriod, DatePeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DatePeriod, DatePeriod>,
              DatePeriod,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
