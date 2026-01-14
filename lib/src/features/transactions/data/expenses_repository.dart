import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';

import '../domain/transaction.dart';
import '../domain/transaction_type.dart';
import '../domain/account.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';
import '../application/categorization_service.dart';
import 'user_rules_repository.dart';

part 'expenses_repository.g.dart';

@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref, ref.read(categorizationServiceProvider));
}

class ExpensesRepository {
  ExpensesRepository(this._ref, this._categorizationService);
  final Ref _ref;
  final CategorizationService _categorizationService;

  // Known account markers to filter transfers
  static final _startParams = DateTime(2025, 1, 1);

  Future<List<Transaction>> getExpenses() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/data/') && (key.endsWith('.csv') || key.endsWith('.CSV')))
        .toList();

    // Load User Rules via FutureProvider to ensure they are ready
    final rulesRepo = await _ref.read(userRulesRepositoryProvider.future);

    final allExpenses = <Transaction>[];
    // Registry to track ID collisions across all files
    final Map<String, int> idRegistry = {};

    for (final path in filePaths) {
      final content = await rootBundle.loadString(path);
      final filename = path.split('/').last;
      
      if (filename.toUpperCase().contains('PERSONKONTO') || filename.toUpperCase().contains('SPARKONTO')) {
        allExpenses.addAll(_parseNordeaCsv(content, filename, idRegistry, rulesRepo));
      } else {
        // Assume SAS/Transaction export
        allExpenses.addAll(_parseSasAmexCsv(content, filename, idRegistry, rulesRepo));
      }
    }

    // Sort by date descending
    allExpenses.sort((a, b) => b.date.compareTo(a.date));
    return allExpenses;
  }

  // Generate a deterministic stable ID
  String _generateStableId(
    DateTime date, 
    double amount, 
    String description, 
    Account sourceAccount,
    Map<String, int> idRegistry,
  ) {
    // strict ISO string might include time if not careful, ensure we use what we have
    // Use a clean format for the key
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final rawKey = '${dateStr}_${amount.toStringAsFixed(2)}_${description}_${sourceAccount.name}';
    
    final bytes = utf8.encode(rawKey);
    final hash = sha256.convert(bytes).toString().substring(0, 16); // Shorten for readability/space

    // Check collision
    if (idRegistry.containsKey(hash)) {
      final count = idRegistry[hash]! + 1;
      idRegistry[hash] = count;
      return '${hash}_$count';
    } else {
      idRegistry[hash] = 0;
      return hash;
    }
  }

  List<Transaction> _parseNordeaCsv(
    String content, 
    String filename, 
    Map<String, int> idRegistry,
    UserRulesRepository rulesRepo,
  ) {
    // Nordea: Semi-colon separated.
    // Format: Bokföringsdag;Belopp;Avsändare;Mottagare;Namn;Rubrik;Saldo;Valuta;
    // Commas for decimals.
    final rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(content);
    final expenses = <Transaction>[];

    // Determine Source Account Name from filename

    Account sourceAccount = Account.values.firstWhere(
      (account) => 
          account.accountNumber != null && 
          filename.replaceAll(' ', '').contains(account.accountNumber!.replaceAll(' ', '')), // flexible match
      orElse: () => Account.unknown,
    );
    // Double check with simpler containment if flexible match fails or just use a standard contains?
    // Filenames usually look like "1127 25 18949.csv". 
    // Let's stick to the previous logic's robustness but using the loop.
    if (sourceAccount == Account.unknown) {
       try {
           sourceAccount = Account.values.firstWhere((a) => a.accountNumber != null && filename.contains(a.accountNumber!));
       } catch (_) {}
    }

    // Skip header (row 0)
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 6) continue;

      final dateStr = row[0].toString(); // 2025/12/30
      final amountStr = row[1].toString(); // 2000,00 or -1414,00
      final description = row[5].toString(); // Rubrik

      // Date Parse
      final date = DateFormat('yyyy/MM/dd').parse(dateStr);
      if (date.isBefore(_startParams)) continue;

      // Filter Transfers - No longer filter them out completely
      // if (_isInternalTransfer(description)) continue;

      // Determine exclusion
      final excludeFromOverview = _isInternalTransfer(description);

      // Filter SAS Payments (to avoid dupe)
      if (description.contains('Betalning BG 595-4300 SAS EUROBONUS')) continue;

      // Amount Parse
      final amount = double.tryParse(amountStr.replaceAll(',', '.')) ?? 0;
      
      // Determine transaction type: positive = income, negative = expense
      final type = amount >= 0 ? TransactionType.income : TransactionType.expense;
      
       // Generate ID
      final id = _generateStableId(date, amount, description, sourceAccount, idRegistry);

      // Categorize Priority:
      // 1. Specific Override (ID based)
      // 2. User Rule (Description based)
      // 3. Fallback to Service (Hardcoded)
      
      Category category;
      Subcategory subcategory;

      final override = rulesRepo.getOverride(id);
      if (override != null) {
        category = override.$1;
        subcategory = override.$2;
      } else {
        final rule = rulesRepo.getRule(description);
        if (rule != null) {
          category = rule.$1;
          subcategory = rule.$2;
        } else {
          final result = _categorizationService.categorize(description, amount);
          category = result.$1;
          subcategory = result.$2;
        }
      }

      expenses.add(Transaction(
        id: id,
        date: date,
        amount: amount,
        description: description,
        category: category,
        subcategory: subcategory,
        sourceAccount: sourceAccount,
        sourceFilename: filename,
        type: type,
        excludeFromOverview: excludeFromOverview,
        rawCsvData: row.join(';'),
      ));
    }
    return expenses;
  }

  List<Transaction> _parseSasAmexCsv(
    String content, 
    String filename, 
    Map<String, int> idRegistry,
    UserRulesRepository rulesRepo,
  ) {
    // SAS Amex: Semicolon separated.
    // Section "Köp/uttag" starts around line 26/27.
    // Headers: Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp
    // 2026-01-08;2026-01-09;WILLYS GOTEBORG HVIT;GOTEBORG;SEK;0;130.97
    
    final rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(content);
    final expenses = <Transaction>[];
    const sourceAccount = Account.sasAmex;
    
    bool isInTransactionSection = false;

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final firstCol = row[0].toString();
      
      // Skip the "Totalt övriga händelser" section (contains payments which we want to filter)
      if (firstCol.contains('Totalt övriga')) {
        // Skip until we find the next section
        while (i < rows.length && !(rows[i][0].toString().contains('Köp') || rows[i][0].toString() == 'Datum')) {
          i++;
        }
        if (i >= rows.length) break;
        continue;
      }
      
      // Detect start of section
      if (firstCol == 'Datum' && row.length > 6 && row[2].toString() == 'Specifikation') {
        isInTransactionSection = true;
        continue;
      }
      
      // Check for next section or end
      if (isInTransactionSection) {
         if (firstCol.isEmpty && row.length > 2 && row[2].toString().startsWith('Summa')) {
           isInTransactionSection = false;
           break;
         }
         // Date check to ensure it's a data row
         if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(firstCol)) continue;

         final dateStr = firstCol;
         final description = row[2].toString();
         final amountStr = row[6].toString(); // Belopp

         final date = DateFormat('yyyy-MM-dd').parse(dateStr);
         if (date.isBefore(_startParams)) continue;

         // Filter SAS Invoice Payments (usually inbound to card, but appearing here?)
         // In SAS file, "BETALT BG DATUM" means we paid the bill. It's a "credit" to the account (negative value in file?).
         // File analysis: 
         // 2025-01-13... BETALT BG DATUM ... -28278.52
         // 2026-01-08... WILLYS ... 130.97
         // Wait. Willys is 130.97 (Positive). Payment is -28278 (Negative).
         // So for Amex: Positive = Expense. Negative = Payment.
         // We should INVERT this to match standard (Expense = Negative).
         // AND we should filter out the Payments entirely if they are just transfers from our bank.
         
         if (description.contains('BETALT BG DATUM')) continue;

         // Parse amount
         // "130.97" is standard dot decimal? CSV parser handles it?
         // In file view: "130.97". CSV converter might treat as num or string.
         double amount = 0;
         if (row[6] is num) {
           amount = (row[6] as num).toDouble();
         } else {
           amount = double.tryParse(amountStr.replaceAll(',', '')) ?? 0; // handle 1,000.00? File looked simple.
         }

         // Invert amount: 130 (Cost) -> -130 (Expense)
         amount = -amount;

         // Generate ID
         final id = _generateStableId(date, amount, description, sourceAccount, idRegistry);

          // Categorize Priority
          Category category;
          Subcategory subcategory;

          final override = rulesRepo.getOverride(id);
          if (override != null) {
            category = override.$1;
            subcategory = override.$2;
          } else {
            final rule = rulesRepo.getRule(description);
            if (rule != null) {
              category = rule.$1;
               subcategory = rule.$2;
            } else {
               final result = _categorizationService.categorize(description, amount);
               category = result.$1;
               subcategory = result.$2;
            }
          }

         expenses.add(Transaction(
           id: id,
           date: date,
           amount: amount,
           description: description,
           category: category,
           subcategory: subcategory,
           sourceAccount: sourceAccount,
           sourceFilename: filename,
           type: TransactionType.expense, // SAS Amex transactions are always expenses
           rawCsvData: row.join(';'),
         ));
      }
    }
    return expenses;
  }

  bool _isInternalTransfer(String description) {
    // Check if any of known accounts is in description
    for (final acc in Account.values) {
       final accNum = acc.accountNumber;
       if (accNum == null) continue;

       // Remove spaces from acc for matching? "3016 28 91261" vs "30162891261"?
       // File has spaces usually.
       if (description.contains(accNum)) return true;
       // Also check without spaces just in case
       if (description.replaceAll(' ', '').contains(accNum.replaceAll(' ', ''))) return true;
    }
    
    if (description.toLowerCase().contains('överföring') || description.toLowerCase().contains('lån')) return true;
    if (description.toLowerCase().contains('autogiro avanza bank')) return true;

    return false;
  }
}
