// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentDate)
final currentDateProvider = CurrentDateProvider._();

final class CurrentDateProvider
    extends $NotifierProvider<CurrentDate, DateTime> {
  CurrentDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDateHash();

  @$internal
  @override
  CurrentDate create() => CurrentDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentDateHash() => r'6180da710aba4749973c406d44d37b8c062d1bc5';

abstract class _$CurrentDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DashboardIncludeRenovationAndLoan)
final dashboardIncludeRenovationAndLoanProvider =
    DashboardIncludeRenovationAndLoanProvider._();

final class DashboardIncludeRenovationAndLoanProvider
    extends $NotifierProvider<DashboardIncludeRenovationAndLoan, bool> {
  DashboardIncludeRenovationAndLoanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardIncludeRenovationAndLoanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$dashboardIncludeRenovationAndLoanHash();

  @$internal
  @override
  DashboardIncludeRenovationAndLoan create() =>
      DashboardIncludeRenovationAndLoan();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dashboardIncludeRenovationAndLoanHash() =>
    r'1b63dc29fd39f80c19dd3b4c6b196ddf4565b4a3';

abstract class _$DashboardIncludeRenovationAndLoan extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
