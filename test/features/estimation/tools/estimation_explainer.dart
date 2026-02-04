import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';
import 'package:expenses/src/features/estimation/application/recurring_detection_service.dart';
import 'package:expenses/src/features/shared/domain/excluded_from_estimates.dart';

class EstimationExplainer {
  final RecurringDetectionService _recurringService;
  final List<Transaction> _allTransactions;
  final DateTime _targetDate; // using first day of target month
  final DateTime _now;

  EstimationExplainer({
    required RecurringDetectionService recurringService,
    required List<Transaction> allTransactions,
    required int targetYear,
    required int targetMonth,
    DateTime? now,
  })  : _recurringService = recurringService,
        _allTransactions = allTransactions,
        _targetDate = DateTime(targetYear, targetMonth),
        _now = now ?? DateTime.now();

  String explain(Category category, Subcategory subcategory, {bool showDetails = false}) {
    final buffer = StringBuffer();
    
    // Setup Context
    final targetYear = _targetDate.year;
    final targetMonth = _targetDate.month;
    
    buffer.writeln('\n========================================');
    buffer.writeln('ESTIMATE DEBUG REPORT: ${category.name}/${subcategory.name}');
    buffer.writeln('Period: $targetYear-${targetMonth.toString().padLeft(2, '0')}');
    buffer.writeln('========================================\n');

    // Filter history
    final history = _allTransactions.where((t) {
      final txMonthEnd = DateTime(t.date.year, t.date.month + 1, 0);
      return txMonthEnd.isBefore(_targetDate);
    }).toList();

    // 1. Analyze Recurring
    final cleanHistory = history.where((t) => !t.excludeFromOverview).toList();
    
    final recurring = _recurringService.detectRecurringPatterns(
      cleanHistory,
      forYear: targetYear,
      forMonth: targetMonth,
    );

    final matchingRecurring = recurring.where((r) => 
      r.category == category && 
      (r.subcategory == subcategory)
    ).toList();

    double recurringTotal = 0;
    if (matchingRecurring.isNotEmpty) {
      buffer.writeln('RECURRING PATTERNS FOUND:');
      for (final r in matchingRecurring) {
        buffer.writeln('  - Pattern: "${r.descriptionPattern}"');
        buffer.writeln('    Avg Amount: ${r.averageAmount.toStringAsFixed(2)}');
        buffer.writeln('    Typical Day: ${r.typicalDayOfMonth}');
        buffer.writeln('    Source Transactions:');
        
        final matches = history.where((t) {
            final desc = t.description.toUpperCase();
            final pat = r.descriptionPattern.toUpperCase();
            return desc.contains(pat);
        }).toList();
        
        matches.sort((a, b) => b.date.compareTo(a.date));
        for (final m in matches.take(5)) {
             buffer.writeln('      ${m.date.toString().substring(0, 10)}: ${m.amount} - ${m.description}');
        }
        if (matches.isEmpty) {
            buffer.writeln('      (No fuzzy matches found - likely strict auto-detect normalization)');
        }
        buffer.writeln('');
        
        recurringTotal += r.averageAmount;
      }
    } else {
      buffer.writeln('No recurring patterns found for this subcategory.');
    }
    buffer.writeln('Total Recurring Estimate: ${recurringTotal.toStringAsFixed(2)}\n');

    // 2. Analyze Historical Average (Variable logic)
    final subHistory = history.where((t) => 
      t.category == category && 
      t.subcategory == subcategory && 
      !t.excludeFromOverview 
      // && !excludedFromEstimates (renovation etc) - implemented below to match logic
    ).toList();
    
    // Group by month
    final monthlyTotals = <String, double>{};
    final monthlyTransactions = <String, List<Transaction>>{};

    for (final t in subHistory) {
         if (isExcludedFromEstimates(t.category, t.subcategory)) continue;
         
         final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
         monthlyTotals.update(key, (v) => v + t.amount.abs(), ifAbsent: () => t.amount.abs());
         
         if (showDetails) {
            monthlyTransactions.putIfAbsent(key, () => []);
            monthlyTransactions[key]!.add(t);
         }
    }

    if (monthlyTotals.isEmpty) {
      buffer.writeln('No historical data found.');
      if (showDetails && subHistory.isEmpty) {
         buffer.writeln('  (No transactions found for this subcategory in history)');
      } else if (showDetails) {
         buffer.writeln('  (Transactions exist but were all filtered out by excludedFromEstimates or excludeFromOverview)');
      }
    } else {
      double totalSum = 0;
      monthlyTotals.values.forEach((v) => totalSum += v);
      final average = totalSum / monthlyTotals.length;

      buffer.writeln('HISTORICAL DATA:');
      buffer.writeln('  Total in History: ${totalSum.toStringAsFixed(2)}');
      buffer.writeln('  Months with data: ${monthlyTotals.length}');
      buffer.writeln('  Historical Average: ${average.toStringAsFixed(2)}');
      
      buffer.writeln('  Monthly Breakdown (Last 12 months with data):');
      final sortedKeys = monthlyTotals.keys.toList()..sort();
      for (final key in sortedKeys.reversed.take(12)) {
         buffer.writeln('    $key: ${monthlyTotals[key]!.toStringAsFixed(2)}');
      }

      buffer.writeln('\n  Top 5 Contributing Transactions:');
      subHistory.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
      for (final t in subHistory.take(5)) {
        buffer.writeln('    ${t.date.toString().substring(0, 10)}: ${t.amount} - ${t.description}');
      }
      
      // 3. Calculate Variable Estimate
      final anyRecurringForSub = recurring.any((r) => 
        r.category == category && 
        (r.subcategory ?? Subcategory.unknown) == subcategory
      );

      double variableEst = 0;
      if (!anyRecurringForSub) { // Variable logic applies
        final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day; 
        final currentDay = (targetYear == _now.year && targetMonth == _now.month) ? _now.day : daysInMonth;
        // If it's a future month, remainingRatio is 1.0 (start of month effectively) -> wait, logic in service:
        // final currentDay = (year == now.year && month == now.month) ? now.day : daysInMonth;
        // final remainingRatio = (daysInMonth - currentDay) / daysInMonth;
        // If future month: currentDay = daysInMonth -> remainingRatio = 0?
        // Wait, check service logic again.
        
        // Service logic:
        // final currentDay = (year == now.year && month == now.month) ? now.day : daysInMonth;
        // final remainingRatio = (daysInMonth - currentDay) / daysInMonth;
        
        // If it's a PAST month, currentDay = daysInMonth, ratio = 0. Estimate = 0. Correct (we use actuals).
        // If it's a FUTURE month, we shouldn't be using this logic usually? 
        // Service says:
        /*
            // Check if month is incomplete (current or future month)
            final monthEnd = DateTime(year, month + 1, 0);
            if (monthEnd.isBefore(now) && !(year == now.year && month == now.month)) {
              return null; // Month is complete
            }
        */
        // If it is FUTURE month (monthEnd is after now), but it is NOT current month.
        // Then currentDay = daysInMonth. Ratio = 0.
        // So variable estimate is 0 for future months? That seems wrong for forecasting?
        // Let's check `estimation_service.dart` again.
        
        double remainingRatio = 0.0;
        if (targetYear > _now.year || (targetYear == _now.year && targetMonth > _now.month)) {
            // Future month: We usually want full forecast?
            // The service logic:
            // final currentDay = (year == now.year && month == now.month) ? now.day : daysInMonth;
            // final remainingRatio = (daysInMonth - currentDay) / daysInMonth;
            
            // If future, currentDay = daysInMonth. Ratio = 0.
            // This suggests the estimation service returns 0 for variable expenses in future months.
            // That might be a bug or intended behavior (only estimate current incomplete month).
            // Creating a faithful reproduction of CURRENT logic for now.
             final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;
             final currentDay = daysInMonth;
             remainingRatio = (daysInMonth - currentDay) / daysInMonth;
        } else if (targetYear == _now.year && targetMonth == _now.month) {
             final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;
             final currentDay = _now.day;
             remainingRatio = (daysInMonth - currentDay) / daysInMonth;
        } else {
             // Past
             final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;
             final currentDay = daysInMonth;
             remainingRatio = (daysInMonth - currentDay) / daysInMonth;
        }
        
        variableEst = average * remainingRatio;
        
        buffer.writeln('\nVARIABLE ESTIMATE CALCULATION:');
        buffer.writeln('  Logic: No recurring patterns found, using historical average pro-rated.');
        if (remainingRatio == 0 && (targetYear > _now.year || (targetYear == _now.year && targetMonth > _now.month))) {
             buffer.writeln('  WARNING: Future month variable estimate is 0 due to service logic (currentDay=daysInMonth).');
        }
        
        buffer.writeln('  Days in Month: $daysInMonth');
        buffer.writeln('  Current Day: $currentDay');
        buffer.writeln('  Remaining Ratio: ${remainingRatio.toStringAsFixed(4)}');
        buffer.writeln('  Calculation: ${average.toStringAsFixed(2)} * $remainingRatio = ${variableEst.toStringAsFixed(2)}');
      } else {
        buffer.writeln('\nVARIABLE ESTIMATE CALCULATION:');
        buffer.writeln('  Logic: Skipped because recurring patterns exist for this subcategory.');
      }
      
      buffer.writeln('\n========================================');
      buffer.writeln('FINAL ESTIMATE: ${(recurringTotal + variableEst).toStringAsFixed(2)}');
      buffer.writeln('========================================');
      
      if (showDetails) {
        buffer.writeln('\n--- DETAILED TRANSACTION LIST ---');
        final sortedMonthKeys = monthlyTransactions.keys.toList()..sort();
        for (final key in sortedMonthKeys) {
            buffer.writeln('Month $key: Total ${monthlyTotals[key]!.toStringAsFixed(2)}');
            final txs = monthlyTransactions[key]!;
            txs.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
            for (final t in txs) {
                buffer.writeln('  ${t.date.toString().substring(0, 10)}: ${t.amount} - ${t.description}');
            }
        }
      }
    }
    
    return buffer.toString();
  }
}
