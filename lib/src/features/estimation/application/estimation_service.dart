import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction_type.dart';
import '../../dashboard/domain/date_period.dart';
import '../../shared/domain/excluded_from_estimates.dart';
import '../domain/monthly_estimate.dart';
import 'recurring_detection_service.dart';

part 'estimation_service.g.dart';

@riverpod
EstimationService estimationService(Ref ref) {
  return EstimationService(ref.watch(recurringDetectionServiceProvider));
}

class EstimationService {
  final RecurringDetectionService _recurringService;

  EstimationService(this._recurringService);

  /// Calculate estimate for an incomplete month
  MonthlyEstimate? calculateEstimate(
    DatePeriod period,
    List<Transaction> allTransactions,
    DateTime now,
  ) {
    // Only works for month periods
    return period.map(
      month: (p) => _calculateMonthEstimate(p.year, p.month, allTransactions, now),
      year: (_) => null,
    );
  }

  MonthlyEstimate? _calculateMonthEstimate(
    int year,
    int month,
    List<Transaction> allTransactions,
    DateTime now,
  ) {
    // Check if month is incomplete (current or future month)
    final monthEnd = DateTime(year, month + 1, 0);
    if (monthEnd.isBefore(now) && !(year == now.year && month == now.month)) {
      return null; // Month is complete
    }

    // Split transactions
    final currentMonth = allTransactions.where((t) =>
        t.date.year == year && t.date.month == month).toList();
    final history = allTransactions.where((t) {
      if (t.excludeFromOverview) return false;
      final txMonthEnd = DateTime(t.date.year, t.date.month + 1, 0);
      return txMonthEnd.isBefore(DateTime(year, month));
    }).toList();

    // Get recurring patterns
    final recurring = _recurringService.detectRecurringPatterns(
      history,
      forYear: year,
      forMonth: month,
    );

    // Classify recurring as completed or pending
    final completedRecurring = <RecurringStatus>[];
    final pendingRecurring = <RecurringStatus>[];
    
    // Create a pool of transactions to match against (consumable)
    final matchingPool = currentMonth.toList();

    for (final r in recurring) {
      final matchIndex = matchingPool.indexWhere((t) => 
          t.description.toUpperCase().contains(r.descriptionPattern.toUpperCase()));

      if (matchIndex != -1) {
        completedRecurring.add(r);
        matchingPool.removeAt(matchIndex);
      } else {
        pendingRecurring.add(r);
      }
    }

    // Calculate actuals
    double actualIncome = 0;
    double actualExpenses = 0;
    final categoryActuals = <Category, double>{};
    final subcategoryActuals = <Category, Map<Subcategory, double>>{};

    for (final t in currentMonth) {
      if (t.excludeFromOverview) continue;
      // Exclude renovation/loan from estimates
      if (isExcludedFromEstimates(t.category, t.subcategory)) continue;
      
      if (t.type == TransactionType.income) {
        actualIncome += t.amount.abs();
      } else {
        actualExpenses += t.amount.abs();
      }
      categoryActuals.update(
        t.category,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
      subcategoryActuals.putIfAbsent(t.category, () => {});
      subcategoryActuals[t.category]!.update(
        t.subcategory,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
    }

    // Calculate historical averages per category and subcategory
    final categoryAverages = _calculateCategoryAverages(history);
    final subcategoryAverages = _calculateSubcategoryAverages(history);

    // For variable categories, pro-rate based on day of month
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final currentDay = (year == now.year && month == now.month) ? now.day : daysInMonth;
    final remainingRatio = (daysInMonth - currentDay) / daysInMonth;

    // Build category estimates
    final categoryEstimates = <Category, CategoryEstimate>{};
    for (final cat in Category.values) {
      final actual = categoryActuals[cat] ?? 0;
      final historicalAvg = categoryAverages[cat] ?? 0;

      final subEstimates = <Subcategory, SubcategoryEstimate>{};
      final catSubActuals = subcategoryActuals[cat] ?? {};
      final catSubAverages = subcategoryAverages[cat] ?? {};

      // Calculate pending recurring subcategories for this category
      final catPendingRecurring =
          pendingRecurring.where((r) => r.category == cat);

      // Include all subcategories with actuals, historical data, or pending recurring
      final allSubs = {...catSubActuals.keys, ...catSubAverages.keys};
      for (final r in catPendingRecurring) {
        allSubs.add(r.subcategory ?? Subcategory.unknown);
      }

      for (final sub in allSubs) {
        final subActual = catSubActuals[sub] ?? 0;
        final subHistAvg = catSubAverages[sub] ?? 0;

        double subEstimated = subActual;
        // Add pending recurring for this subcategory
        for (final r in catPendingRecurring.where(
            (r) => (r.subcategory ?? Subcategory.unknown) == sub)) {
          subEstimated += r.averageAmount;
        }
        // Add variable estimate if no recurring for this subcategory
        if (!recurring.any((r) =>
            r.category == cat &&
            (r.subcategory ?? Subcategory.unknown) == sub)) {
          subEstimated += subHistAvg * remainingRatio;
        }

        if (subActual > 0 || subEstimated > 0 || subHistAvg > 0) {
          subEstimates[sub] = SubcategoryEstimate(
            subcategory: sub,
            actual: subActual,
            estimated: subEstimated,
            historicalAverage: subHistAvg,
          );
        }
      }

      // Calculate category estimate from sum of sub estimates
      final estimated =
          subEstimates.values.fold(0.0, (sum, e) => sum + e.estimated);

      if (actual > 0 || estimated > 0 || historicalAvg > 0) {
        categoryEstimates[cat] = CategoryEstimate(
          category: cat,
          actual: actual,
          estimated: estimated,
          historicalAverage: historicalAvg,
          subcategoryEstimates: subEstimates,
        );
      }
    }

    // Calculate totals from category estimates to ensure consistency
    // between top-level values and per-category breakdown
    final finalEstimatedIncome = categoryEstimates[Category.income]?.estimated ?? actualIncome;
    final finalEstimatedExpenses = categoryEstimates.entries
        .where((e) => e.key != Category.income)
        .fold(0.0, (sum, e) => sum + e.value.estimated);

    return MonthlyEstimate(
      actualIncome: actualIncome,
      actualExpenses: actualExpenses,
      estimatedIncome: finalEstimatedIncome,
      estimatedExpenses: finalEstimatedExpenses,
      categoryEstimates: categoryEstimates,
      pendingRecurring: pendingRecurring,
      completedRecurring: completedRecurring,
    );
  }



  /// Calculate average monthly amounts per category from history
  Map<Category, double> _calculateCategoryAverages(List<Transaction> history) {
    if (history.isEmpty) return {};

    // Group by month
    final monthlyTotals = <String, Map<Category, double>>{};
    for (final t in history) {
      if (t.excludeFromOverview) continue;
      if (isExcludedFromEstimates(t.category, t.subcategory)) continue;
      final key = '${t.date.year}-${t.date.month}';
      monthlyTotals.putIfAbsent(key, () => {});
      monthlyTotals[key]!.update(
        t.category,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
    }

    if (monthlyTotals.isEmpty) return {};

    // Calculate averages
    final averages = <Category, double>{};
    final monthCount = monthlyTotals.length;

    for (final cat in Category.values) {
      double total = 0;
      for (final monthly in monthlyTotals.values) {
        total += monthly[cat] ?? 0;
      }
      if (total > 0) {
        averages[cat] = total / monthCount;
      }
    }

    return averages;
  }

  /// Calculate average monthly amounts per subcategory from history
  Map<Category, Map<Subcategory, double>> _calculateSubcategoryAverages(List<Transaction> history) {
    if (history.isEmpty) return {};

    // Group by month
    final monthlyTotals = <String, Map<Category, Map<Subcategory, double>>>{};
    for (final t in history) {
      if (t.excludeFromOverview) continue;
      if (isExcludedFromEstimates(t.category, t.subcategory)) continue;
      final key = '${t.date.year}-${t.date.month}';
      monthlyTotals.putIfAbsent(key, () => {});
      monthlyTotals[key]!.putIfAbsent(t.category, () => {});
      monthlyTotals[key]![t.category]!.update(
        t.subcategory,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
    }

    if (monthlyTotals.isEmpty) return {};

    // Calculate averages
    final averages = <Category, Map<Subcategory, double>>{};
    final monthCount = monthlyTotals.length;

    // Collect all category/subcategory combinations
    final allCombos = <Category, Set<Subcategory>>{};
    for (final monthly in monthlyTotals.values) {
      for (final catEntry in monthly.entries) {
        allCombos.putIfAbsent(catEntry.key, () => {});
        allCombos[catEntry.key]!.addAll(catEntry.value.keys);
      }
    }

    for (final catEntry in allCombos.entries) {
      final cat = catEntry.key;
      averages[cat] = {};
      for (final sub in catEntry.value) {
        double total = 0;
        for (final monthly in monthlyTotals.values) {
          total += monthly[cat]?[sub] ?? 0;
        }
        if (total > 0) {
          averages[cat]![sub] = total / monthCount;
        }
      }
    }

    return averages;
  }
}
