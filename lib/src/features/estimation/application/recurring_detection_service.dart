import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/domain/transaction.dart';
import '../domain/known_recurring.dart';
import '../domain/monthly_estimate.dart';

part 'recurring_detection_service.g.dart';

@riverpod
RecurringDetectionService recurringDetectionService(Ref ref) {
  return RecurringDetectionService();
}

class RecurringDetectionService {
  /// Minimum number of occurrences required to detect a recurring pattern.
  static const int minOccurrencesForRecurring = 3;

  /// Maximum allowed variance in transaction amounts (10%).
  static const double maxAmountVarianceRatio = 0.10;

  /// Maximum allowed variance in day of month (±3 days).
  static const int maxDayVariance = 3;

  /// Detects recurring transactions from historical data.
  /// Combines known patterns with auto-detected fixed-amount transactions.
  List<RecurringStatus> detectRecurringPatterns(
    List<Transaction> history, {
    int? forYear,
    int? forMonth,
  }) {
    final results = <RecurringStatus>[];

    // 1. Process known recurring patterns (always included if active)
    for (final pattern in knownRecurringPatterns) {
      // Check if pattern is active for the target month
      if (forYear != null && forMonth != null) {
        if (!pattern.isActiveForMonth(forYear, forMonth)) {
          continue;
        }
      }

      // Find all historical transactions matching this pattern
      final matching = history
          .where((t) => pattern.matches(t.description))
          .toList();

      if (matching.isNotEmpty) {
        final avgAmount =
            matching.map((t) => t.amount.abs()).reduce((a, b) => a + b) /
            matching.length;
        final typicalDay =
            pattern.typicalDayOfMonth ?? _calculateTypicalDay(matching);

        // Calculate typical frequency (transactions per month)
        final frequency = _calculateMonthlyFrequencyMode(matching);

        // Add one result for each expected occurrence
        for (var i = 0; i < frequency; i++) {
          results.add(
            RecurringStatus(
              descriptionPattern: pattern.descriptionPattern,
              averageAmount: avgAmount,
              typicalDayOfMonth: typicalDay,
              category: pattern.category,
              subcategory: pattern.subcategory,
              type: pattern.type,
              occurrenceCount: matching.length,
            ),
          );
        }
      }
    }

    // 2. Auto-detect fixed-amount recurring (not already covered by known patterns)
    final autoDetected = _autoDetectRecurring(history, results);
    results.addAll(autoDetected);

    return results;
  }

  /// Auto-detect recurring transactions with consistent amounts
  List<RecurringStatus> _autoDetectRecurring(
    List<Transaction> history,
    List<RecurringStatus> alreadyKnown,
  ) {
    final results = <RecurringStatus>[];

    // Group by normalized description
    final groups = <String, List<Transaction>>{};
    for (final t in history) {
      final key = _normalizeDescription(t.description);
      groups.putIfAbsent(key, () => []).add(t);
    }

    for (final entry in groups.entries) {
      final transactions = entry.value;

      // Need at least minOccurrencesForRecurring occurrences to be reliable
      if (transactions.length < minOccurrencesForRecurring) continue;

      // Skip if already covered by known patterns
      if (_isAlreadyCovered(transactions.first.description, alreadyKnown)) {
        continue;
      }

      // Check if amounts are similar (within 10%)
      if (!_hasSimilarAmounts(transactions)) continue;

      // Check if dates fall on similar day of month
      if (!_hasSimilarDays(transactions)) continue;

      // Require transactions to span at least 2 distinct months
      if (!_spansMultipleMonths(transactions)) continue;

      final avgAmount =
          transactions.map((t) => t.amount.abs()).reduce((a, b) => a + b) /
          transactions.length;
      final typicalDay = _calculateTypicalDay(transactions);
      final first = transactions.first;

      results.add(
        RecurringStatus(
          descriptionPattern: entry.key,
          averageAmount: avgAmount,
          typicalDayOfMonth: typicalDay,
          category: first.category,
          subcategory: first.subcategory,
          type: first.type,
          occurrenceCount: transactions.length,
        ),
      );
    }

    return results;
  }

  /// Normalize description for grouping (lowercase, remove numbers and special chars)
  String _normalizeDescription(String desc) {
    return desc
        .toUpperCase()
        .replaceAll(RegExp(r'[0-9]+'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Check if transactions have similar amounts (within maxAmountVarianceRatio)
  bool _hasSimilarAmounts(List<Transaction> transactions) {
    if (transactions.isEmpty) return false;
    final amounts = transactions.map((t) => t.amount.abs()).toList();
    final avg = amounts.reduce((a, b) => a + b) / amounts.length;
    return amounts.every(
      (a) => (a - avg).abs() / avg <= maxAmountVarianceRatio,
    );
  }

  /// Check if transactions fall on similar days of month (within ±maxDayVariance days)
  bool _hasSimilarDays(List<Transaction> transactions) {
    if (transactions.isEmpty) return false;
    final days = transactions.map((t) => t.date.day).toList();
    final avgDay = days.reduce((a, b) => a + b) / days.length;
    return days.every((d) => (d - avgDay).abs() <= maxDayVariance);
  }

  /// Check if transactions span at least 2 distinct months
  bool _spansMultipleMonths(List<Transaction> transactions) {
    if (transactions.isEmpty) return false;
    final months = transactions
        .map((t) => '${t.date.year}-${t.date.month}')
        .toSet();
    return months.length >= 2;
  }

  /// Calculate typical day of month from transactions
  int _calculateTypicalDay(List<Transaction> transactions) {
    if (transactions.isEmpty) return 1;
    final days = transactions.map((t) => t.date.day).toList();
    return (days.reduce((a, b) => a + b) / days.length).round();
  }

  /// Calculate typical number of transactions per month (returns the mode)
  int _calculateMonthlyFrequencyMode(List<Transaction> transactions) {
    if (transactions.isEmpty) return 1;

    // Group counts by month
    final monthlyCounts = <String, int>{};
    for (final t in transactions) {
      final key = '${t.date.year}-${t.date.month}';
      monthlyCounts.update(key, (v) => v + 1, ifAbsent: () => 1);
    }

    // Prepare frequency histogram (count -> how many months had this count)
    final frequencies = <int, int>{};
    for (final count in monthlyCounts.values) {
      frequencies.update(count, (v) => v + 1, ifAbsent: () => 1);
    }

    // Find mode (the count that appears in most months)
    var mode = 1;
    var maxOccurrences = 0;

    for (final entry in frequencies.entries) {
      // Prefer higher frequency if tied (e.g. if 50% months have 1, 50% have 2, assume 2 is the target)
      if (entry.value > maxOccurrences ||
          (entry.value == maxOccurrences && entry.key > mode)) {
        maxOccurrences = entry.value;
        mode = entry.key;
      }
    }

    return mode;
  }

  /// Check if a description is already covered by known patterns
  bool _isAlreadyCovered(String description, List<RecurringStatus> known) {
    final normalized = _normalizeDescription(description);
    return known.any(
      (k) => normalized.contains(k.descriptionPattern.toUpperCase()),
    );
  }
}
