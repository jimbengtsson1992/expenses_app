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
