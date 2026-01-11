import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../domain/expense.dart';
import '../application/categorization_service.dart';

part 'expenses_repository.g.dart';

@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref.read(categorizationServiceProvider));
}

class ExpensesRepository {
  ExpensesRepository(this._categorizationService);
  final CategorizationService _categorizationService;
  final _uuid = const Uuid();

  // Known account markers to filter transfers
  static const _myAccounts = [
    '1127 25 18949',
    '3016 28 91261', 
    '3016 05 24377', 
    '3016 28 91415',
    'RAGNAR,LOUISE', // Filter transfers to/from Louise by name for now
  ];
  
  static final _startParams = DateTime(2025, 1, 1);

  Future<List<Expense>> getExpenses() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final filePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/data/') && (key.endsWith('.csv') || key.endsWith('.CSV')))
        .toList();

    final allExpenses = <Expense>[];

    for (final path in filePaths) {
      final content = await rootBundle.loadString(path);
      final filename = path.split('/').last;
      
      if (filename.toUpperCase().contains('PERSONKONTO') || filename.toUpperCase().contains('SPARKONTO')) {
        allExpenses.addAll(_parseNordeaCsv(content, filename));
      } else {
        // Assume SAS/Transaction export
        allExpenses.addAll(_parseSasAmexCsv(content, filename));
      }
    }

    // Sort by date descending
    allExpenses.sort((a, b) => b.date.compareTo(a.date));
    return allExpenses;
  }

  List<Expense> _parseNordeaCsv(String content, String filename) {
    // Nordea: Semi-colon separated.
    // Format: Bokföringsdag;Belopp;Avsändare;Mottagare;Namn;Rubrik;Saldo;Valuta;
    // Commas for decimals.
    final rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(content);
    final expenses = <Expense>[];

    // Determine Source Account Name from filename
    String sourceName = 'Nordea';
    if (filename.contains('1127 25 18949')) {
      sourceName = 'Jim Personkonto';
    } else if (filename.contains('3016 28 91261')) {
      sourceName = 'Jim Sparkonto';
    } else if (filename.contains('3016 05 24377')) {
      sourceName = 'Gemensamt';
    } else if (filename.contains('3016 28 91415')) {
      sourceName = 'Gemensamt Spar';
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

      // Filter Transfers
      if (_isInternalTransfer(description)) continue;
      // Filter SAS Payments (to avoid dupe)
      if (description.contains('Betalning BG 595-4300 SAS EUROBONUS')) continue;

      // Amount Parse
      final amount = double.tryParse(amountStr.replaceAll(',', '.')) ?? 0;
      
      // Categorize
      final category = _categorizationService.categorize(description, amount);

      expenses.add(Expense(
        id: _uuid.v4(),
        date: date,
        amount: amount,
        description: description,
        category: category,
        sourceAccount: sourceName,
        sourceFilename: filename,
      ));
    }
    return expenses;
  }

  List<Expense> _parseSasAmexCsv(String content, String filename) {
    // SAS Amex: Comma separated.
    // Section "Köp/uttag" starts around line 26/27.
    // Headers: Datum,Bokfört,Specifikation,Ort,Valuta,Utl. belopp,Belopp
    // 2026-01-08,2026-01-09,WILLYS GOTEBORG HVIT,GOTEBORG,SEK,0,130.97
    
    final rows = const CsvToListConverter(fieldDelimiter: ',', eol: '\n').convert(content);
    final expenses = <Expense>[];
    const sourceName = 'SAS Amex';
    
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

         // Categorize
         final category = _categorizationService.categorize(description, -amount); // pass positive for categorize check? logic uses >0 check.

         expenses.add(Expense(
           id: _uuid.v4(),
           date: date,
           amount: amount,
           description: description,
           category: category,
           sourceAccount: sourceName,
           sourceFilename: filename,
         ));
      }
    }
    return expenses;
  }

  bool _isInternalTransfer(String description) {
    if (!description.toLowerCase().contains('överföring') && !description.toLowerCase().contains('lån')) return false;
    
    // Check if any of known accounts is in description
    for (final acc in _myAccounts) {
       // Remove spaces from acc for matching? "3016 28 91261" vs "30162891261"?
       // File has spaces usually.
       if (description.contains(acc)) return true;
       // Also check without spaces just in case
       if (description.replaceAll(' ', '').contains(acc.replaceAll(' ', ''))) return true;
    }
    return false;
  }
}
