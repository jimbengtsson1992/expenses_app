import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/expense.dart';
import 'expenses_repository.dart';

part 'expenses_providers.g.dart';

@riverpod
Future<List<Expense>> expensesList(Ref ref) async {
  final repository = ref.watch(expensesRepositoryProvider);
  return repository.getExpenses();
}

@riverpod
Future<List<Expense>> expensesForMonth(Ref ref, DateTime month) async {
  final expenses = await ref.watch(expensesListProvider.future);
  return expenses.where((e) => 
    e.date.year == month.year && 
    e.date.month == month.month
  ).toList();
}

@riverpod
Future<Expense?> expenseById(Ref ref, String id) async {
  final expenses = await ref.watch(expensesListProvider.future);
  try {
    return expenses.firstWhere((e) => e.id == id);
  } catch (e) {
    return null;
  }
}
