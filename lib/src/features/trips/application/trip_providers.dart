import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../transactions/domain/transaction.dart';

part 'trip_providers.g.dart';

/// All transactions tagged to [tripId], across all periods.
@riverpod
Future<List<Transaction>> tripTransactions(Ref ref, String tripId) async {
  final all = await ref.watch(expensesListProvider.future);
  return all.where((t) => t.tripId == tripId).toList();
}

/// Groups trip-tagged transactions by [Transaction.tripId], dropping untagged
/// ones. Input order is preserved within each group (date-desc from the
/// repository). Pass a period-filtered list to get per-period groups.
Map<String, List<Transaction>> groupByTrip(Iterable<Transaction> transactions) {
  final groups = <String, List<Transaction>>{};
  for (final t in transactions) {
    final tripId = t.tripId;
    if (tripId == null) continue;
    groups.putIfAbsent(tripId, () => []).add(t);
  }
  return groups;
}
