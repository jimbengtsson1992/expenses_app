// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_detection_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recurringDetectionService)
final recurringDetectionServiceProvider = RecurringDetectionServiceProvider._();

final class RecurringDetectionServiceProvider
    extends
        $FunctionalProvider<
          RecurringDetectionService,
          RecurringDetectionService,
          RecurringDetectionService
        >
    with $Provider<RecurringDetectionService> {
  RecurringDetectionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringDetectionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringDetectionServiceHash();

  @$internal
  @override
  $ProviderElement<RecurringDetectionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecurringDetectionService create(Ref ref) {
    return recurringDetectionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringDetectionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurringDetectionService>(value),
    );
  }
}

String _$recurringDetectionServiceHash() =>
    r'4473d358b639106e745fd071f06bc244f025949a';
