// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses/src/features/transactions/data/transaction_csv_parser.dart';
import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/data/user_rules_repository.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/estimation/application/recurring_detection_service.dart';

class FakeUserRulesRepository extends Fake implements UserRulesRepository {
  @override
  (Category, Subcategory)? getOverride(String id) => null;

  @override
  (Category, Subcategory)? getRule(String description) => null;

  @override
  bool isExcluded(String id) => false;
}

void main() async {
  test('Debug Estimate Explanation', () async {
    // 1. Setup Services
    final categorizationService = CategorizationService();
    final userRulesRepository = FakeUserRulesRepository();
    final parser = TransactionCsvParser(
      categorizationService,
      userRulesRepository,
    );
    final recurringService = RecurringDetectionService();

    // 2. Load Data
    final dataDir = Directory(
      '/Users/jimbengtsson/Documents/src/expenses/assets/data',
    );
    if (!await dataDir.exists()) {
      print('Data directory not found!');
      return;
    }

    final idRegistry = <String, int>{};
    final allTransactions = <Transaction>[];

    await for (final file in dataDir.list()) {
      if (file is File && file.path.endsWith('.csv')) {
        final content = await file.readAsString();
        final filename = file.uri.pathSegments.last;
        try {
          if (filename.contains('transactions')) {
            allTransactions.addAll(
              parser.parseSasAmexCsv(content, filename, idRegistry),
            );
          } else {
            allTransactions.addAll(
              parser.parseNordeaCsv(content, filename, idRegistry),
            );
          }
        } catch (e) {
          print('Error parsing $filename: $e');
        }
      }
    }

    // 3. Define Context
    const targetYear = 2026;
    const targetMonth = 2;
    // Current day based on runtime of test, but here we hardcode "now" for consistency with previous run or just use consistent date.
    // In previous run "now" was DateTime(2026, 2, 4).
    final now = DateTime(2026, 2, 4);

    final history = allTransactions.where((t) {
      final txMonthEnd = DateTime(t.date.year, t.date.month + 1, 0);
      return txMonthEnd.isBefore(DateTime(targetYear, targetMonth));
    }).toList();

    // target category
    const targetCategory = Category.income;
    const targetSubcategory = Subcategory.other;

    print('\n========================================');
    print(
      'ESTIMATE DEBUG REPORT: ${targetCategory.name}/${targetSubcategory.name}',
    );
    print('Period: $targetYear-${targetMonth.toString().padLeft(2, '0')}');
    print('========================================\n');

    // 4. Analyze Recurring
    // FIX HYPOTHESIS: Filter excluded transactions from history
    final cleanHistory = history.where((t) => !t.excludeFromOverview).toList();

    final recurring = recurringService.detectRecurringPatterns(
      cleanHistory,
      forYear: targetYear,
      forMonth: targetMonth,
    );

    final matchingRecurring = recurring
        .where(
          (r) =>
              r.category == targetCategory &&
              (r.subcategory == targetSubcategory),
        )
        .toList();

    double recurringTotal = 0;
    if (matchingRecurring.isNotEmpty) {
      print('RECURRING PATTERNS FOUND:');
      for (final r in matchingRecurring) {
        print('  - Pattern: "${r.descriptionPattern}"');
        print('    Avg Amount: ${r.averageAmount.toStringAsFixed(2)}');
        print('    Typical Day: ${r.typicalDayOfMonth}');
        print('    Source Transactions:');

        // Find matching transactions to verify why they were detected
        final matches = history.where((t) {
          final desc = t.description.toUpperCase();
          final pat = r.descriptionPattern.toUpperCase();
          return desc.contains(pat);
        }).toList();

        matches.sort((a, b) => b.date.compareTo(a.date));
        for (final m in matches.take(5)) {
          print(
            '      ${m.date.toString().substring(0, 10)}: ${m.amount} - ${m.description}',
          );
        }
        if (matches.isEmpty) {
          print(
            '      (No fuzzy matches found - likely strict auto-detect normalization)',
          );
        }
        print('');

        recurringTotal += r.averageAmount;
      }
    } else {
      print('No recurring patterns found for this subcategory.');
    }
    print('Total Recurring Estimate: ${recurringTotal.toStringAsFixed(2)}\n');

    // 5. Analyze Historical Average (Variable logic)
    // Filter history for this subcategory
    final subHistory = history
        .where(
          (t) =>
              t.category == targetCategory &&
              t.subcategory == targetSubcategory &&
              !t.excludeFromOverview, // && !excludedFromEstimates (renovation etc)
        )
        .toList();

    // Group by month
    final monthlyTotals = <String, double>{};
    for (final t in subHistory) {
      final key = '${t.date.year}-${t.date.month}';
      monthlyTotals.update(
        key,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
    }

    if (monthlyTotals.isEmpty) {
      print('No historical data found.');
    } else {
      double totalSum = 0;
      for (final v in monthlyTotals.values) {
        totalSum += v;
      }
      final average = totalSum / monthlyTotals.length;

      print('HISTORICAL DATA:');
      print('  Total in History: ${totalSum.toStringAsFixed(2)}');
      print('  Months with data: ${monthlyTotals.length}');
      print('  Historical Average: ${average.toStringAsFixed(2)}');

      // Breakdown of months
      print('  Monthly Breakdown (Last 12 months with data):');
      final sortedKeys = monthlyTotals.keys.toList()..sort();
      for (final key in sortedKeys.reversed.take(12)) {
        print('    $key: ${monthlyTotals[key]!.toStringAsFixed(2)}');
      }

      print('\n  Top 5 Contributing Transactions:');
      subHistory.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
      for (final t in subHistory.take(5)) {
        print(
          '    ${t.date.toString().substring(0, 10)}: ${t.amount} - ${t.description}',
        );
      }

      // 6. Calculate Variable Estimate

      // Does ANY recurring pattern exist for income/other?
      final anyRecurringForSub = recurring.any(
        (r) =>
            r.category == targetCategory && r.subcategory == targetSubcategory,
      );

      double variableEst = 0;
      if (!anyRecurringForSub) {
        // Variable logic applies
        final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day; // 28
        final currentDay = now.day; // 4
        final remainingRatio = (daysInMonth - currentDay) / daysInMonth;

        variableEst = average * remainingRatio;

        print('\nVARIABLE ESTIMATE CALCULATION:');
        print(
          '  Logic: No recurring patterns found, using historical average pro-rated.',
        );
        print('  Note: Income variable estimate applies to remaining days?');

        print('  Days in Month: $daysInMonth');
        print('  Current Day: $currentDay');
        print('  Remaining Ratio: ${remainingRatio.toStringAsFixed(4)}');
        print(
          '  Calculation: ${average.toStringAsFixed(2)} * $remainingRatio = ${variableEst.toStringAsFixed(2)}',
        );
      } else {
        print('\nVARIABLE ESTIMATE CALCULATION:');
        print(
          '  Logic: Skipped because recurring patterns exist for this subcategory.',
        );
      }

      print('\n========================================');
      print(
        'FINAL ESTIMATE: ${(recurringTotal + variableEst).toStringAsFixed(2)}',
      );
      print('========================================');
    }
  });
}
