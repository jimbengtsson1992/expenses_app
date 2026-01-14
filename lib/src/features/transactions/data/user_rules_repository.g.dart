// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rules_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRulesRepository)
final userRulesRepositoryProvider = UserRulesRepositoryProvider._();

final class UserRulesRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserRulesRepository>,
          UserRulesRepository,
          FutureOr<UserRulesRepository>
        >
    with
        $FutureModifier<UserRulesRepository>,
        $FutureProvider<UserRulesRepository> {
  UserRulesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRulesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRulesRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<UserRulesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserRulesRepository> create(Ref ref) {
    return userRulesRepository(ref);
  }
}

String _$userRulesRepositoryHash() =>
    r'408e2892b6a7ee7565815311ce1109b6b09fc212';
