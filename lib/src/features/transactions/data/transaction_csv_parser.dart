import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../domain/transaction.dart';
import '../domain/transaction_type.dart';
import '../domain/account.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';
import '../application/categorization_service.dart';
import 'user_rules_repository.dart';

enum AmexSection {
  none,
  other,
  purchases,
}


class TransactionCsvParser {
  TransactionCsvParser(this._categorizationService, this._userRulesRepository);

  final CategorizationService _categorizationService;
  final UserRulesRepository _userRulesRepository;

  static final _startParams = DateTime(2025, 1, 1);

  List<Transaction> parseNordeaCsv(
    String content,
    String filename,
    Map<String, int> idRegistry,
  ) {
    // Nordea: Semi-colon separated.
    // Format: Bokföringsdag;Belopp;Avsändare;Mottagare;Namn;Rubrik;Saldo;Valuta;
    // Commas for decimals.
    final rows = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(content);
    final expenses = <Transaction>[];

    // Determine Source Account Name from filename

    Account sourceAccount = Account.values.firstWhere(
      (account) =>
          account.accountNumber != null &&
          filename
              .replaceAll(' ', '')
              .contains(
                account.accountNumber!.replaceAll(' ', ''),
              ), // flexible match
      orElse: () => Account.unknown,
    );
    // Double check with simpler containment if flexible match fails or just use a standard contains?
    // Filenames usually look like "1127 25 18949.csv".
    // Let's stick to the previous logic's robustness but using the loop.
    if (sourceAccount == Account.unknown) {
      try {
        sourceAccount = Account.values.firstWhere(
          (a) => a.accountNumber != null && filename.contains(a.accountNumber!),
        );
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

      // Amount Parse
      final amount = double.tryParse(amountStr.replaceAll(',', '.')) ?? 0;

      // Filter Transfers - No longer filter them out completely
      // if (_isInternalTransfer(description)) continue;

      // Determine exclusion
      final excludeFromOverview = shouldExcludeFromOverview(
        description,
        amount,
        date,
      );

      // Filter SAS Payments (to avoid dupe)
      if (description.contains('Betalning BG 595-4300 SAS EUROBONUS')) continue;

      // Determine transaction type: positive = income, negative = expense
      final type = amount >= 0
          ? TransactionType.income
          : TransactionType.expense;

      // Generate ID
      final id = _generateStableId(
        date,
        amount,
        description,
        sourceAccount,
        idRegistry,
      );

      // Categorize Priority:
      // 1. Specific Override (ID based)
      // 2. User Rule (Description based)
      // 3. Fallback to Service (Hardcoded)

      Category category;
      Subcategory subcategory;

      final override = _userRulesRepository.getOverride(id);
      if (override != null) {
        category = override.$1;
        subcategory = override.$2;
      } else {
        final rule = _userRulesRepository.getRule(description);
        if (rule != null) {
          category = rule.$1;
          subcategory = rule.$2;
        } else {
          final result = _categorizationService.categorize(
            description,
            amount,
            date,
          );
          category = result.$1;
          subcategory = result.$2;
        }
      }

      expenses.add(
        Transaction(
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
        ),
      );
    }
    return expenses;
  }

  List<Transaction> parseSasAmexCsv(
    String content,
    String filename,
    Map<String, int> idRegistry,
  ) {
    final rows = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(content);
    final expenses = <Transaction>[];
    const sourceAccount = Account.sasAmex;

    AmexSection currentSection = AmexSection.none;

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final firstCol = row[0].toString();

      // Detect Section Headers
      if (firstCol.contains('Totalt övriga')) {
        // This section contains Payments (negative) and Fees (positive)
        // We want to enter this section but filter carefully.
        // The headers "Datum;..." will follow, which triggers the actual data reading.
        // We just need to know we are "approaching/in" this section's context.
        // Actually, the loop below detects 'Datum' to start reading.
        // We can set a flag here that says "Next data block is Other".
        currentSection = AmexSection.other;
        continue;
      }

      if (firstCol.contains('Köp/uttag')) {
        currentSection = AmexSection.purchases;
        continue;
      }

      // Detect start of data table headers
      if (firstCol == 'Datum' &&
          row.length > 6 &&
          row[2].toString() == 'Specifikation') {
        // Headers found. The section flag should already be set by the title above it.
        // If not (first section might not have title? No, usually does), default to purchases?
        // In the file provided:
        // Line 1: Transaktionsexport...
        // Line 3: Totalt övriga händelser
        // Line 4: Datum...
        // Line 26: Köp/uttag
        // Line 27: Datum...
        continue;
      }

      // Check for End of Section (Sum lines)
      if (row.length > 2 && row[2].toString().startsWith('Summa')) {
        // End of current block data
        // currentSection = AmexSection.none; // Optional, or just leave it until next title
        continue;
      }

      // Date check to ensure it's a data row
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(firstCol)) continue;

      // If we haven't identified a section, assume Purchases if unidentified?
      // Or just proceed.
      // safely default to purchases if unknown?
      final section = currentSection == AmexSection.none
          ? AmexSection.purchases
          : currentSection;

      // ---------------------------------------------------------
      // DATA ROW PARSING
      // ---------------------------------------------------------

      final dateStr = firstCol;
      final description = row[2].toString();
      final amountStr = row[6].toString(); // Belopp

      final date = DateFormat('yyyy-MM-dd').parse(dateStr);
      if (date.isBefore(_startParams)) continue;

      // Parse amount
      double rawAmount = 0;
      if (row[6] is num) {
        rawAmount = (row[6] as num).toDouble();
      } else {
        rawAmount =
            double.tryParse(amountStr.replaceAll(',', '')) ?? 0;
      }

      // Filter Logic based on Section
      if (section == AmexSection.other) {
        // In "Totalt övriga händelser":
        // Negative values are Payments (e.g. -28000). Skip these.
        // Positive values are Fees (e.g. 2335). Keep these.
        if (rawAmount < 0) continue;
      }

      // Standard Filter: "BETALT BG DATUM" is an explicit payment marker too.
      // Usually negative in 'other', but good to keep as safety.
      if (description.contains('BETALT BG DATUM')) continue;

      // Invert amount:
      // Amex File: Positive = Cost (e.g. 130). We want Negative (-130).
      // Amex File: Positive Fee (2335). We want Negative (-2335).
      // Amex File: Negative Refund/Payment (-100). We want Positive (100).
      final amount = -rawAmount;

      // Generate ID
      final id = _generateStableId(
        date,
        amount,
        description,
        sourceAccount,
        idRegistry,
      );

      // Categorize Priority
      Category category;
      Subcategory subcategory;

      // Determine exclusion
      final excludeFromOverview = shouldExcludeFromOverview(
        description,
        amount,
        date,
      );

      final override = _userRulesRepository.getOverride(id);
      if (override != null) {
        category = override.$1;
        subcategory = override.$2;
      } else {
        final rule = _userRulesRepository.getRule(description);
        if (rule != null) {
          category = rule.$1;
          subcategory = rule.$2;
        } else {
          final result = _categorizationService.categorize(
            description,
            amount,
            date,
          );
          category = result.$1;
          subcategory = result.$2;
        }
      }

      expenses.add(
        Transaction(
          id: id,
          date: date,
          amount: amount,
          description: description,
          category: category,
          subcategory: subcategory,
          sourceAccount: sourceAccount,
          sourceFilename: filename,
          type: TransactionType.expense,
          excludeFromOverview: excludeFromOverview,
          rawCsvData: row.join(';'),
        ),
      );
    }
    return expenses;
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
    final rawKey =
        '${dateStr}_${amount.toStringAsFixed(2)}_${description}_${sourceAccount.name}';

    final bytes = utf8.encode(rawKey);
    final hash = sha256
        .convert(bytes)
        .toString()
        .substring(0, 16); // Shorten for readability/space

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

  bool shouldExcludeFromOverview(
    String description,
    double amount,
    DateTime date,
  ) {
    if (isInternalTransfer(description)) return true;

    // User requested exclusions
    // Jollyroom refund and payment (approx 1889 SEK)
    if (description.contains('Jollyroom AB') &&
        (amount.abs() - 1889.0).abs() < 0.01) {
      return true;
    }

    // Nordea: 2025/11/12;1485,00;;1127 25 18949;;Swish inbetalning ANDERSSON,ERIK;5685,72;SEK;
    if (description.contains('Swish inbetalning ANDERSSON,ERIK') &&
        (amount - 1485.0).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 12) {
      return true;
    }

    // Amex: 2025-11-12;2025-11-13;JINX DYNASTY;GOTEBORG;SEK;0;1485
    // Parsed amount is -1485.0
    if (description.contains('JINX DYNASTY') &&
        (amount - -1485.0).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 12) {
      return true;
    }

    if (description.contains('95561384521')) {
      // Louise Avanza
      return true;
    }

    // Nordea: 2025/11/16;-25000,00;...;Aktiekapital 1110 31 04004;...
    if (description.contains('Aktiekapital 1110 31 04004') &&
        (amount - -25000.00).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 16) {
      return true;
    }

    if (description.contains('Nordea LIV 1896 80 27633')) {
      return true;
    }

    if (description.toUpperCase().contains('AVANZA')) {
      return true;
    }

    // Exclude Swish between Jim and Louise
    // "Swish inbetalning RAGNAR,LOUISE", "Swish inbetalning Bengtsson,Jim", etc.
    // Case insensitive matching and flexible spacing (handled by contains)
    final upperDesc = description.toUpperCase();
    if (upperDesc.contains('SWISH INBETALNING RAGNAR,LOUISE') ||
        upperDesc.contains('SWISH INBETALNING RAGNAR, LOUISE') ||
        upperDesc.contains('SWISH INBETALNING BENGTSSON,JIM') ||
        upperDesc.contains('SWISH INBETALNING BENGTSSON, JIM') ||
        upperDesc.contains('SWISH BETALNING RAGNAR,LOUISE') ||
        upperDesc.contains('SWISH BETALNING RAGNAR, LOUISE') ||
        upperDesc.contains('SWISH BETALNING BENGTSSON,JIM') ||
        upperDesc.contains('SWISH BETALNING BENGTSSON, JIM')) {
      return true;
    }

    return false;
  }

  bool isInternalTransfer(String description) {
    // Check if any of known accounts is in description
    for (final acc in Account.values) {
      final accNum = acc.accountNumber;
      if (accNum == null) continue;

      // Remove spaces from acc for matching? "3016 28 91261" vs "30162891261"?
      // File has spaces usually.
      if (description.contains(accNum)) return true;
      // Also check without spaces just in case
      if (description
          .replaceAll(' ', '')
          .contains(accNum.replaceAll(' ', ''))) {
        return true;
      }
    }

    if (description.toLowerCase().contains('överföring')) return true;
    if (description.toLowerCase().contains('lån') &&
        !description.toLowerCase().contains('omsättning lån')) {
      return true;
    }
    if (description.toLowerCase().contains('autogiro avanza bank')) return true;

    return false;
  }
}
