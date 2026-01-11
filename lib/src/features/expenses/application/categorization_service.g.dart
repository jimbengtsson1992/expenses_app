// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorization_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categorizationService)
final categorizationServiceProvider = CategorizationServiceProvider._();

final class CategorizationServiceProvider
    extends
        $FunctionalProvider<
          CategorizationService,
          CategorizationService,
          CategorizationService
        >
    with $Provider<CategorizationService> {
  CategorizationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorizationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorizationServiceHash();

  @$internal
  @override
  $ProviderElement<CategorizationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategorizationService create(Ref ref) {
    return categorizationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategorizationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategorizationService>(value),
    );
  }
}

String _$categorizationServiceHash() =>
    r'4dfba4389630aeacc100a0e1d6e3fe816393278e';
