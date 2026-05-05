import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../domain/transaction.dart';
import '../domain/account.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';
import '../application/categorization_service.dart';
import 'user_rules_repository.dart';

enum MastercardSection { none, other, purchases }

class TransactionCsvParser {
  TransactionCsvParser(this._categorizationService, this._userRulesRepository);

  final CategorizationService _categorizationService;
  final UserRulesRepository _userRulesRepository;

  static final _startParams = DateTime(2024, 12, 1);
  static final _nordeaDateFormat = DateFormat('yyyy/MM/dd');
  static final _isoDashFormat = DateFormat('yyyy-MM-dd');
  static final _dateRowPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  List<Transaction> parseNordeaCsv(
    String content,
    String filename,
    Map<String, int> idRegistry,
  ) {
    // Nordea: Semicolon-separated. Format: Bokföringsdag;Belopp;Avsändare;Mottagare;Namn;Rubrik;Saldo;Valuta
    // Commas for decimals.
    final rows = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(content);
    final expenses = <Transaction>[];

    final sourceAccount = Account.values.firstWhere(
      (account) =>
          account.accountNumber != null &&
          filename
              .replaceAll(' ', '')
              .contains(account.accountNumber!.replaceAll(' ', '')),
      orElse: () => Account.unknown,
    );

    // Skip header (row 0)
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 6) continue;

      final dateStr = row[0].toString(); // 2025/12/30
      final amountStr = row[1].toString(); // 2000,00 or -1414,00
      final description = row[5].toString(); // Rubrik

      final date = _nordeaDateFormat.parse(dateStr);
      if (date.isBefore(_startParams)) continue;

      final amount = double.tryParse(amountStr.replaceAll(',', '.')) ?? 0;

      // Filter Transfers - No longer filter them out completely
      // if (_isInternalTransfer(description)) continue;

      final id = _generateStableId(date, amount, description, sourceAccount, idRegistry);

      final excludeFromOverview =
          shouldExcludeFromOverview(description, amount, date) ||
          _userRulesRepository.isExcluded(id);

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
          final result = _categorizationService.categorize(description, amount, date);
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
          excludeFromOverview: excludeFromOverview,
          rawCsvData: row.join(';'),
        ),
      );
    }
    return expenses;
  }

  List<Transaction> parseSasMastercardCsv(
    String content,
    String filename,
    Map<String, int> idRegistry,
  ) {
    final rows = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(content);
    final expenses = <Transaction>[];
    const sourceAccount = Account.sasMastercard;

    MastercardSection currentSection = MastercardSection.none;

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final firstCol = row[0].toString();

      if (firstCol.contains('Totalt övriga')) {
        currentSection = MastercardSection.other;
        continue;
      }

      if (firstCol.contains('Köp/uttag')) {
        currentSection = MastercardSection.purchases;
        continue;
      }

      if (firstCol == 'Datum' && row.length > 6 && row[2].toString() == 'Specifikation') {
        continue;
      }

      if (row.length > 2 && row[2].toString().startsWith('Summa')) {
        continue;
      }

      if (!_dateRowPattern.hasMatch(firstCol)) continue;

      final section = currentSection == MastercardSection.none
          ? MastercardSection.purchases
          : currentSection;

      final description = row[2].toString();
      final amountStr = row[6].toString(); // Belopp

      final date = _isoDashFormat.parse(firstCol);
      if (date.isBefore(_startParams)) continue;

      double rawAmount = 0;
      if (row[6] is num) {
        rawAmount = (row[6] as num).toDouble();
      } else {
        rawAmount = double.tryParse(amountStr.replaceAll(',', '')) ?? 0;
      }

      if (section == MastercardSection.other) {
        // In "Totalt övriga händelser": negative = payment (skip), positive = fee (keep).
        if (rawAmount < 0) continue;
      }

      // "BETALT BG DATUM" is an explicit payment marker in addition to the negative-amount guard.
      if (description.contains('BETALT BG DATUM')) continue;

      // Mastercard CSV: positive = expense/fee, negative = refund. Invert to our convention.
      final amount = -rawAmount;

      final id = _generateStableId(date, amount, description, sourceAccount, idRegistry);

      final excludeFromOverview =
          shouldExcludeFromOverview(description, amount, date) ||
          _userRulesRepository.isExcluded(id);

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
          final result = _categorizationService.categorize(description, amount, date);
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
          excludeFromOverview: excludeFromOverview,
          rawCsvData: row.join(';'),
        ),
      );
    }
    return expenses;
  }

  List<Transaction> parseCarPayCsv(
    String content,
    String filename,
    Map<String, int> idRegistry,
  ) {
    final rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(content);
    final expenses = <Transaction>[];
    const sourceAccount = Account.carPay;

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 4) continue;

      final dateStr = row[0].toString();
      if (!_dateRowPattern.hasMatch(dateStr)) continue;

      final date = _isoDashFormat.parse(dateStr);
      if (date.isBefore(_startParams)) continue;

      final description = row[1].toString();
      final amountStr = row[3].toString();

      double rawAmount = 0;
      if (row[3] is num) {
        rawAmount = (row[3] as num).toDouble();
      } else {
        rawAmount = double.tryParse(amountStr) ?? 0;
      }

      final amount = -rawAmount;

      final id = _generateStableId(date, amount, description, sourceAccount, idRegistry);

      final excludeFromOverview =
          shouldExcludeFromOverview(description, amount, date) ||
          _userRulesRepository.isExcluded(id);

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
          final result = _categorizationService.categorize(description, amount, date);
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
          excludeFromOverview: excludeFromOverview,
          rawCsvData: row.join(';'),
        ),
      );
    }
    return expenses;
  }

  String _generateStableId(
    DateTime date,
    double amount,
    String description,
    Account sourceAccount,
    Map<String, int> idRegistry,
  ) {
    final rawKey =
        '${_isoDashFormat.format(date)}_${amount.toStringAsFixed(2)}_${description}_${sourceAccount.name}';

    final bytes = utf8.encode(rawKey);
    final hash = sha256.convert(bytes).toString().substring(0, 16);

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

    final upperDesc = description.toUpperCase();

    // Jollyroom refund and payment (approx 1889 SEK)
    if (description.contains('Jollyroom AB') && (amount.abs() - 1889.0).abs() < 0.01) {
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

    // Mastercard: 2025-11-12;2025-11-13;JINX DYNASTY;GOTEBORG;SEK;0;1485
    // Parsed amount is -1485.0
    if (description.contains('JINX DYNASTY') &&
        (amount - -1485.0).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 12) {
      return true;
    }

    if (description.contains('95561384521')) { // Louise Avanza
      return true;
    }

    if (description.contains('95580391031')) { // Shared Avanza (Savings account)
      return true;
    }

    if (description.contains('95580675161')) { // Shared Avanza (ISK)
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

    if (upperDesc.contains('AVANZA')) {
      return true;
    }

    // NK MAN GBG Exclusions
    // Kortköp 251221 NK MAN GBG;688,72 | Amount -2299.00
    if (description.contains('Kortköp 251221 NK MAN GBG') &&
        (amount - -2299.00).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 22) {
      return true;
    }

    // Insättning kort 260117 NK MAN GBG;4073,22 | Amount 2299.00
    if (description.contains('Insättning kort 260117 NK MAN GBG') &&
        (amount - 2299.00).abs() < 0.01 &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 18) {
      return true;
    }

    // Exclude Swish between Jim and Louise
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

    // Exclude Swish inbetalning JÜRSS, JENNY
    if (description.contains('Swish inbetalning JÜRSS, JENNY') &&
        (amount - 169.0).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 21) {
      return true;
    }

    // Exclude FOODIE | Amount -169.0
    if (description.contains('FOODIE') &&
        (amount - -169.0).abs() < 0.01 &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 21) {
      return true;
    }

    return false;
  }

  bool isInternalTransfer(String description) {
    for (final acc in Account.values) {
      final accNum = acc.accountNumber;
      if (accNum == null) continue;

      // Strip spaces from both sides to handle "3016 28 91261" vs "30162891261"
      if (description.contains(accNum)) return true;
      if (description.replaceAll(' ', '').contains(accNum.replaceAll(' ', ''))) return true;
    }

    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('överföring')) return true;
    if (lowerDesc.contains('lån') && !lowerDesc.contains('omsättning lån')) return true;
    if (lowerDesc.contains('autogiro avanza bank')) return true;

    return false;
  }
}
