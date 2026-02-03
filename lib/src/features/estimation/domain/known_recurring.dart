import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction_type.dart';

/// Known recurring transaction patterns.
/// Agent-maintained - see .agent/recurring_rules.md for documentation.
class KnownRecurringPattern {
  final String descriptionPattern;
  final Category category;
  final Subcategory? subcategory;
  final TransactionType type;
  final int? typicalDayOfMonth;
  final DateTime? endDate;

  const KnownRecurringPattern({
    required this.descriptionPattern,
    required this.category,
    required this.type,
    this.subcategory,
    this.typicalDayOfMonth,
    this.endDate,
  });

  /// Check if pattern matches a transaction description
  bool matches(String description) {
    return description.toUpperCase().contains(descriptionPattern.toUpperCase());
  }

  /// Check if pattern is active for a given month
  bool isActiveForMonth(int year, int month) {
    if (endDate == null) return true;
    final monthEnd = DateTime(year, month + 1, 0);
    return monthEnd.isBefore(endDate!) || monthEnd.isAtSameMomentAs(endDate!);
  }
}

/// Known recurring patterns - add patterns here via AI agent prompts.
/// See .agent/recurring_rules.md for documentation.
const List<KnownRecurringPattern> knownRecurringPatterns = [
  // TODO: Add patterns via AI agent prompts
  // Example:
  // KnownRecurringPattern(
  //   descriptionPattern: 'HYRA',
  //   category: Category.housing,
  //   type: TransactionType.expense,
  //   typicalDayOfMonth: 1,
  // ),
];
