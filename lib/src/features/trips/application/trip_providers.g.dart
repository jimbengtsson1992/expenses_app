// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All transactions tagged to [tripId], across all periods.

@ProviderFor(tripTransactions)
final tripTransactionsProvider = TripTransactionsFamily._();

/// All transactions tagged to [tripId], across all periods.

final class TripTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          FutureOr<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $FutureProvider<List<Transaction>> {
  /// All transactions tagged to [tripId], across all periods.
  TripTransactionsProvider._({
    required TripTransactionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripTransactionsHash();

  @override
  String toString() {
    return r'tripTransactionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Transaction>> create(Ref ref) {
    final argument = this.argument as String;
    return tripTransactions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripTransactionsHash() => r'4bbb37737e03e592a869142864465bb078ddefa4';

/// All transactions tagged to [tripId], across all periods.

final class TripTransactionsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Transaction>>, String> {
  TripTransactionsFamily._()
    : super(
        retry: null,
        name: r'tripTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// All transactions tagged to [tripId], across all periods.

  TripTransactionsProvider call(String tripId) =>
      TripTransactionsProvider._(argument: tripId, from: this);

  @override
  String toString() => r'tripTransactionsProvider';
}
