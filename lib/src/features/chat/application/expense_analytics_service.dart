import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/transaction_type.dart';
import '../domain/expense_analytics.dart';

part 'expense_analytics_service.g.dart';

@riverpod
Future<ExpenseAnalytics> expenseAnalytics(Ref ref) async {
  final transactions = await ref.watch(expensesListProvider.future);
  return ExpenseAnalyticsService().analyze(transactions);
}

class ExpenseAnalyticsService {
  ExpenseAnalytics analyze(List<Transaction> transactions) {
    // Filter out excluded transactions
    final filtered = transactions.where((t) => !t.excludeFromOverview).toList();

    // Group by month
    final monthlyData = <String, List<Transaction>>{};
    for (final t in filtered) {
      final key = '${t.date.year}-${t.date.month}';
      monthlyData.putIfAbsent(key, () => []).add(t);
    }

    // Build month summaries
    final monthSummaries = <MonthSummary>[];
    for (final entry in monthlyData.entries) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      double income = 0;
      double expenses = 0;
      final categoryBreakdown = <Category, double>{};

      for (final t in entry.value) {
        if (t.type == TransactionType.income) {
          income += t.amount.abs();
        } else {
          expenses += t.amount.abs();
          categoryBreakdown.update(
            t.category,
            (v) => v + t.amount.abs(),
            ifAbsent: () => t.amount.abs(),
          );
        }
      }

      monthSummaries.add(MonthSummary(
        year: year,
        month: month,
        income: income,
        expenses: expenses,
        categoryBreakdown: categoryBreakdown,
      ));
    }

    // Calculate totals
    double totalIncome = 0;
    double totalExpenses = 0;
    final categoryTotals = <Category, double>{};

    for (final t in filtered) {
      if (t.type == TransactionType.income) {
        totalIncome += t.amount.abs();
      } else {
        totalExpenses += t.amount.abs();
        categoryTotals.update(
          t.category,
          (v) => v + t.amount.abs(),
          ifAbsent: () => t.amount.abs(),
        );
      }
    }

    return ExpenseAnalytics(
      monthSummaries: monthSummaries,
      categoryTotals: categoryTotals,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
    );
  }
}
