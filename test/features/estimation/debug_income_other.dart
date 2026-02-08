// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:expenses/src/features/transactions/data/transaction_csv_parser.dart';
import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/data/user_rules_repository.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';

class FakeUserRulesRepository extends Fake implements UserRulesRepository {
  @override
  (Category, Subcategory)? getOverride(String id) => null;

  @override
  (Category, Subcategory)? getRule(String description) => null;

  @override
  bool isExcluded(String id) => false;
}

void main() async {
  test('Analyze Income/Other Transactions', () async {
    final categorizationService = CategorizationService();
    final userRulesRepository = FakeUserRulesRepository();
    final parser = TransactionCsvParser(
      categorizationService,
      userRulesRepository,
    );

    final dataDir = Directory(
      '/Users/jimbengtsson/Documents/src/expenses/assets/data',
    );
    if (!await dataDir.exists()) {
      print('Data directory not found!');
      return;
    }

    final idRegistry = <String, int>{};
    final allTransactions = [];

    await for (final file in dataDir.list()) {
      if (file is File && file.path.endsWith('.csv')) {
        final content = await file.readAsString();
        final filename = file.uri.pathSegments.last;

        try {
          if (filename.contains('transactions')) {
            // Amex/SAS usually starts with 'transactions-'
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

    // Filter for Income / Other
    final incomeOther = allTransactions
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.category == Category.income &&
              t.subcategory == Subcategory.other &&
              !t.excludeFromOverview,
        )
        .toList();

    // Group by month
    final monthlyTotals = <String, double>{};
    final monthlyTransactions = <String, List<dynamic>>{};

    for (final t in incomeOther) {
      final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      monthlyTotals.update(
        key,
        (v) => v + t.amount.abs(),
        ifAbsent: () => t.amount.abs(),
      );
      monthlyTransactions.putIfAbsent(key, () => []);
      monthlyTransactions[key]!.add(t);
    }

    print('\n--- Monthly Totals for Income/Other ---');
    final sortedKeys = monthlyTotals.keys.toList()..sort();
    for (final key in sortedKeys) {
      print('$key: ${monthlyTotals[key]!.toStringAsFixed(2)}');

      // Print transactions for that month
      print('  Transactions:');
      final txs = monthlyTransactions[key]!;
      txs.sort((a, b) => (b.amount.abs() as double).compareTo(a.amount.abs()));
      for (final t in txs) {
        print(
          '    ${t.date.toString().substring(0, 10)}: ${t.amount} - ${t.description}',
        );
      }
    }
  });
}
