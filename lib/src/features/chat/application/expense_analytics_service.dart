import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/domain/excluded_from_estimates.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction_type.dart';
import '../domain/expense_analytics.dart';

part 'expense_analytics_service.g.dart';

@riverpod
Future<ExpenseAnalytics> expenseAnalytics(Ref ref) async {
  final transactions = await ref.watch(expensesListProvider.future);
  // Filter out excluded transactions and those excluded from estimates
  final filtered = transactions
      .where(
        (t) =>
            !t.excludeFromOverview &&
            !isExcludedFromEstimates(t.category, t.subcategory),
      )
      .toList();
  return ExpenseAnalyticsService().analyze(filtered);
}

/// Analytics for transactions that are excluded from regular estimates
/// (one-time/unusual expenses like kitchen renovations, loans)
@riverpod
Future<ExpenseAnalytics> excludedExpenseAnalytics(Ref ref) async {
  final transactions = await ref.watch(expensesListProvider.future);
  // Only include transactions that are excluded from estimates
  final excluded = transactions
      .where(
        (t) =>
            !t.excludeFromOverview &&
            isExcludedFromEstimates(t.category, t.subcategory),
      )
      .toList();
  return ExpenseAnalyticsService().analyze(excluded);
}

class ExpenseAnalyticsService {
  ExpenseAnalytics analyze(List<Transaction> transactions) {
    final filtered = transactions;

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
      final subcategoryBreakdown = <Subcategory, double>{};

      for (final t in entry.value) {
        if (t.type == TransactionType.income) {
          income += t.amount.abs();
        } else {
          expenses += t.amount.abs();
          final amount = t.amount.abs();
          categoryBreakdown.update(
            t.category,
            (v) => v + amount,
            ifAbsent: () => amount,
          );
          subcategoryBreakdown.update(
            t.subcategory,
            (v) => v + amount,
            ifAbsent: () => amount,
          );
        }
      }

      monthSummaries.add(
        MonthSummary(
          year: year,
          month: month,
          income: income,
          expenses: expenses,
          categoryBreakdown: categoryBreakdown,
          subcategoryBreakdown: subcategoryBreakdown,
        ),
      );
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

    // Generate compact transaction list for LLM context
    // Format: YYYY-MM-DD;Amount;Category;Subcategory;Description
    final compactTransactions = filtered.map((t) {
      final date = '${t.date.year}-${t.date.month}-${t.date.day}';
      final amount = t.amount.round();
      final cat = t.category.displayName;
      final sub = t.subcategory.displayName;
      final desc = t.description.replaceAll(';', ','); // Escape delimiters
      return '$date;$amount;$cat;$sub;$desc';
    }).toList();

    return ExpenseAnalytics(
      monthSummaries: monthSummaries,
      categoryTotals: categoryTotals,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      compactTransactions: compactTransactions,
    );
  }
}
