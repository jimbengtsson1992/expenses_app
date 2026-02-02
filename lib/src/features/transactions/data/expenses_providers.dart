import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/transaction.dart';
import 'expenses_repository.dart';

part 'expenses_providers.g.dart';

@riverpod
Future<List<Transaction>> expensesList(Ref ref) async {
  final repository = ref.watch(expensesRepositoryProvider);
  final expenses = await repository.getExpenses();
  return expenses
      .where((e) => e.date.isAfter(DateTime(2024, 11, 30)))
      .toList();
}

@riverpod
Future<List<Transaction>> expensesForMonth(Ref ref, DateTime month) async {
  final expenses = await ref.watch(expensesListProvider.future);
  return expenses
      .where((e) => e.date.year == month.year && e.date.month == month.month)
      .toList();
}

@riverpod
Future<Transaction?> expenseById(Ref ref, String id) async {
  final expenses = await ref.watch(expensesListProvider.future);
  try {
    return expenses.firstWhere((e) => e.id == id);
  } catch (e) {
    return null;
  }
}
