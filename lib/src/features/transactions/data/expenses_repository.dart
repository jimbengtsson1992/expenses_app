import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/transaction.dart';
import '../application/categorization_service.dart';
import 'user_rules_repository.dart';
import 'transaction_csv_parser.dart';

part 'expenses_repository.g.dart';

@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref, ref.read(categorizationServiceProvider));
}

class ExpensesRepository {
  ExpensesRepository(this._ref, this._categorizationService);
  final Ref _ref;
  final CategorizationService _categorizationService;

  Future<List<Transaction>> getExpenses() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final filePaths = manifest
        .listAssets()
        .where(
          (String key) =>
              key.startsWith('assets/data/') &&
              (key.endsWith('.csv') || key.endsWith('.CSV')),
        )
        .toList();

    // Load User Rules via FutureProvider to ensure they are ready
    final rulesRepo = await _ref.read(userRulesRepositoryProvider.future);
    final parser = TransactionCsvParser(_categorizationService, rulesRepo);

    final allExpenses = <Transaction>[];
    // Registry to track ID collisions across all files
    final Map<String, int> idRegistry = {};

    for (final path in filePaths) {
      final content = await rootBundle.loadString(path);
      final filename = path.split('/').last;

      if (filename.toUpperCase().contains('PERSONKONTO') ||
          filename.toUpperCase().contains('SPARKONTO') ||
          filename.toUpperCase().contains('VARDAGSKONTO')) {
        allExpenses.addAll(
          parser.parseNordeaCsv(content, filename, idRegistry),
        );
      } else {
        // Assume SAS/Transaction export
        allExpenses.addAll(
          parser.parseSasAmexCsv(content, filename, idRegistry),
        );
      }
    }

    // Sort by date descending
    allExpenses.sort((a, b) => b.date.compareTo(a.date));
    return allExpenses;
  }
}
