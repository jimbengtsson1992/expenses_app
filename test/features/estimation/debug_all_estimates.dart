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
import 'tools/estimation_explainer.dart';

class FakeUserRulesRepository extends Fake implements UserRulesRepository {
  @override
  (Category, Subcategory)? getOverride(String id) => null;

  @override
  (Category, Subcategory)? getRule(String description) => null;

  @override
  bool isExcluded(String id) => false;
}

void main() async {
  test('Generate All Estimates Report', () async {
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

    // 3. Define Context (Matching debug_estimate_explanation.dart)
    const targetYear = 2026;
    const targetMonth = 2;
    // Hardcoded "now" for consistency, but you can change this
    final now = DateTime(2026, 2, 4);

    final explainer = EstimationExplainer(
      recurringService: recurringService,
      allTransactions: allTransactions,
      targetYear: targetYear,
      targetMonth: targetMonth,
      now: now,
    );

    final outputFile = File('test/features/estimation/debug_report.txt');
    final sink = outputFile.openWrite();

    sink.writeln('ESTIMATION DEBUG REPORT');
    sink.writeln('Generated at: ${DateTime.now()}');
    sink.writeln(
      'Period: $targetYear-${targetMonth.toString().padLeft(2, '0')}',
    );
    sink.writeln(
      '=================================================================\n',
    );

    // 4. Iterate Categories
    for (final category in Category.values) {
      sink.writeln(
        '#################################################################',
      );
      sink.writeln('CATEGORY: ${category.name.toUpperCase()}');
      sink.writeln(
        '#################################################################',
      );

      // Find subcategories present in data (history or current)
      // or just iterate all subcategories that MIGHT be relevant?
      // Better to iterate all distinct subcategories found in transactions for this category,
      // plus any that might be recurring but haven't happened yet?
      // For simplicity, let's just find all subcategories that HAVE data in this category.

      final categoryTxs = allTransactions
          .where((t) => t.category == category)
          .toList();
      final distinctSubcategories = categoryTxs
          .map((t) => t.subcategory)
          .toSet()
          .toList();

      // Also add any generally known subcategories if you want to see "No history" for them?
      // Probably not, that would be spammy. Just show ones with data.

      // Sort subcategories by name/enum index for stability
      distinctSubcategories.sort((a, b) => a.name.compareTo(b.name));

      if (distinctSubcategories.isEmpty) {
        sink.writeln('No transactions found for this category.');
      }

      for (final sub in distinctSubcategories) {
        // Generate explanation
        final report = explainer.explain(
          category,
          sub,
          showDetails: false,
        ); // Default summary
        sink.writeln(report);

        // Check if we want details for specific ones?
        // The tool allows passing showDetails=true.
        // Current constraint: "I want to primary use the output in the same was as debug_estimate_explanation.dart... Only if I need to dig into details will I use [detailed]"
        // So we default to false. Users can edit this script or we can add args later.
      }
      sink.writeln('\n');
    }

    await sink.close();
    print('Report generated at: ${outputFile.absolute.path}');
  });
}
