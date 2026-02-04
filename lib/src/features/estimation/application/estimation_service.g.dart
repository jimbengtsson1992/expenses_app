// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(estimationService)
final estimationServiceProvider = EstimationServiceProvider._();

final class EstimationServiceProvider
    extends
        $FunctionalProvider<
          EstimationService,
          EstimationService,
          EstimationService
        >
    with $Provider<EstimationService> {
  EstimationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'estimationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$estimationServiceHash();

  @$internal
  @override
  $ProviderElement<EstimationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EstimationService create(Ref ref) {
    return estimationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EstimationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EstimationService>(value),
    );
  }
}

String _$estimationServiceHash() => r'948d23b3937043ed486b2f1a16a38bd3903d374f';
