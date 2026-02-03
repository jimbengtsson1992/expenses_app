import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction_type.dart';

/// Known recurring transaction patterns.
/// Agent-maintained - see .agent/recurring_rules.md for documentation.
class KnownRecurringPattern {
  final String descriptionPattern;
  final Category category;
  final Subcategory subcategory;
  final TransactionType type;
  final int? typicalDayOfMonth;
  final DateTime? endDate;

  const KnownRecurringPattern({
    required this.descriptionPattern,
    required this.category,
    required this.subcategory,
    required this.type,
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
  // Housing
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro Verisure',
    category: Category.housing,
    subcategory: Subcategory.security,
    type: TransactionType.expense,
    typicalDayOfMonth: 30,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro GBG ENERGI',
    category: Category.housing,
    subcategory: Subcategory.electricity,
    type: TransactionType.expense,
    typicalDayOfMonth: 30,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro DINEL',
    category: Category.housing,
    subcategory: Subcategory.electricity,
    type: TransactionType.expense,
    typicalDayOfMonth: 30,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro TELE2',
    category: Category.housing,
    subcategory: Subcategory.broadband,
    type: TransactionType.expense,
    typicalDayOfMonth: 28,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Omsättning lån',
    category: Category.housing,
    subcategory: Subcategory.mortgage,
    type: TransactionType.expense,
    typicalDayOfMonth: 27,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Betalning BG 5164-5877 HÖJDENA BRF',
    category: Category.housing,
    subcategory: Subcategory.brfFee,
    type: TransactionType.expense,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro IF SKADEFÖRS',
    category: Category.housing,
    subcategory: Subcategory.homeInsurance,
    type: TransactionType.expense,
    typicalDayOfMonth: 1,
  ),

  // Health
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro FYSIKEN',
    category: Category.health,
    subcategory: Subcategory.gym,
    type: TransactionType.expense,
    typicalDayOfMonth: 28,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'SATS KOMPASSEN',
    category: Category.health,
    subcategory: Subcategory.gym,
    type: TransactionType.expense,
  ),

  // Fees
  KnownRecurringPattern(
    descriptionPattern: 'Autogiro CSN',
    category: Category.fees,
    subcategory: Subcategory.csn,
    type: TransactionType.expense,
    typicalDayOfMonth: 30,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Nordea Vardagspaket',
    category: Category.fees,
    subcategory: Subcategory.bankFees,
    type: TransactionType.expense,
    typicalDayOfMonth: 1,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'Avgift extra kort',
    category: Category.fees,
    subcategory: Subcategory.bankFees,
    type: TransactionType.expense,
    typicalDayOfMonth: 1,
  ),

  // Other
  KnownRecurringPattern(
    descriptionPattern: 'hallon',
    category: Category.other,
    subcategory: Subcategory.mobileSubscription,
    type: TransactionType.expense,
    typicalDayOfMonth: 2,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'jim fadder',
    category: Category.other,
    subcategory: Subcategory.godfather,
    type: TransactionType.expense,
    typicalDayOfMonth: 26,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'gudmor lollo',
    category: Category.other,
    subcategory: Subcategory.godfather,
    type: TransactionType.expense,
    typicalDayOfMonth: 24,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'apple.com/bill',
    category: Category.other,
    subcategory: Subcategory.mobileSubscription,
    type: TransactionType.expense,
  ),
  KnownRecurringPattern(
    descriptionPattern: 'nordea liv',
    category: Category.other,
    subcategory: Subcategory.personalInsurance,
    type: TransactionType.expense,
    typicalDayOfMonth: 1,
  ),

  // Income
  KnownRecurringPattern(
    descriptionPattern: 'lön',
    category: Category.income,
    subcategory: Subcategory.salary,
    type: TransactionType.income,
    typicalDayOfMonth: 24,
  ),
];
