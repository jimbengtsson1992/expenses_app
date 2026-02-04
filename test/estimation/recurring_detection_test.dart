import 'package:flutter_test/flutter_test.dart';
import 'package:expenses/src/features/estimation/application/recurring_detection_service.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';

void main() {
  late RecurringDetectionService service;

  setUp(() {
    service = RecurringDetectionService();
  });

  Transaction createTestTransaction({
    required String description,
    required double amount,
    required DateTime date,
    Category category = Category.other,
    TransactionType type = TransactionType.expense,
  }) {
    return Transaction(
      id: 'test-${date.millisecondsSinceEpoch}',
      date: date,
      amount: amount,
      description: description,
      category: category,
      subcategory: Subcategory.unknown,
      sourceAccount: Account.jimPersonkonto,
      sourceFilename: 'test.csv',
      type: type,
    );
  }

  group('RecurringDetectionService', () {
    test('detects recurring transactions with consistent amounts', () {
      // Same description, same amount, similar day of month
      final history = [
        createTestTransaction(
          description: 'NETFLIX STREAMING',
          amount: -149.0,
          date: DateTime(2025, 1, 15),
        ),
        createTestTransaction(
          description: 'NETFLIX STREAMING',
          amount: -149.0,
          date: DateTime(2025, 2, 14),
        ),
        createTestTransaction(
          description: 'NETFLIX STREAMING',
          amount: -149.0,
          date: DateTime(2025, 3, 15),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns, isNotEmpty);
      expect(patterns.length, 1);
      expect(patterns.first.averageAmount, 149.0);
      expect(patterns.first.occurrenceCount, 3);
    });

    test('detects multiple occurrences per month based on frequency for known patterns', () {
      // 2 times per month, matching 'lön' pattern
      final history = [
        // Month 1
        createTestTransaction(
          description: 'LÖN UTBETALNING',
          amount: 25000.0,
          date: DateTime(2025, 1, 15),
          type: TransactionType.income,
        ),
        createTestTransaction(
          description: 'LÖN UTBETALNING',
          amount: 25000.0,
          date: DateTime(2025, 1, 25), // Second payment
          type: TransactionType.income,
        ),
        // Month 2
        createTestTransaction(
          description: 'LÖN UTBETALNING',
          amount: 25000.0,
          date: DateTime(2025, 2, 15),
          type: TransactionType.income,
        ),
        createTestTransaction(
          description: 'LÖN UTBETALNING',
          amount: 25000.0,
          date: DateTime(2025, 2, 25), // Second payment
          type: TransactionType.income,
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      // Should return 2 recurring statuses for lön
      final salaryPatterns = patterns.where((p) => p.descriptionPattern == 'lön').toList();
      
      expect(salaryPatterns.length, 2);
      expect(salaryPatterns[0].averageAmount, 25000.0);
      expect(salaryPatterns[1].averageAmount, 25000.0);
    });

    test('does not detect one-time transactions', () {
      final history = [
        createTestTransaction(
          description: 'IKEA PURCHASE',
          amount: -2500.0,
          date: DateTime(2025, 1, 10),
        ),
        createTestTransaction(
          description: 'COOP FORUM',
          amount: -350.0,
          date: DateTime(2025, 2, 5),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns, isEmpty);
    });

    test('does not detect transactions with amount variance > 10%', () {
      // Different amounts
      final history = [
        createTestTransaction(
          description: 'UTILITY BILL',
          amount: -100.0,
          date: DateTime(2025, 1, 1),
        ),
        createTestTransaction(
          description: 'UTILITY BILL',
          amount: -200.0, // 100% variance
          date: DateTime(2025, 2, 1),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns, isEmpty);
    });

    test('detects transactions with small amount variance (<= 10%)', () {
      // Slightly different amounts within 10%
      final history = [
        createTestTransaction(
          description: 'SPOTIFY AB',
          amount: -119.0,
          date: DateTime(2025, 1, 15),
        ),
        createTestTransaction(
          description: 'SPOTIFY AB',
          amount: -119.0,
          date: DateTime(2025, 2, 15),
        ),
        createTestTransaction(
          description: 'SPOTIFY AB',
          amount: -129.0, // ~8% variance from first
          date: DateTime(2025, 3, 15),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      // May or may not detect depending on average - let's check actual behavior
      // Average is (119+119+129)/3 = 122.33
      // Variance from average: 119 is ~3%, 129 is ~5%
      expect(patterns.length, 1);
    });

    test('calculates typical day of month', () {
      final history = [
        createTestTransaction(
          description: 'RENT PAYMENT',
          amount: -15000.0,
          date: DateTime(2025, 1, 1),
        ),
        createTestTransaction(
          description: 'RENT PAYMENT',
          amount: -15000.0,
          date: DateTime(2025, 2, 1),
        ),
        createTestTransaction(
          description: 'RENT PAYMENT',
          amount: -15000.0,
          date: DateTime(2025, 3, 1),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns.length, 1);
      expect(patterns.first.typicalDayOfMonth, 1);
    });

    test('does not detect transactions on the same day as recurring', () {
      // Two transactions on the exact same day (the actual bug case)
      final history = [
        createTestTransaction(
          description: 'COFFEE SHOP',
          amount: -35.0,
          date: DateTime(2025, 4, 15),
        ),
        createTestTransaction(
          description: 'COFFEE SHOP',
          amount: -37.0,
          date: DateTime(2025, 4, 15),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns, isEmpty); // Should NOT be detected as recurring
    });

    test('does not detect transactions only in a single month as recurring', () {
      // Multiple transactions in the same month on different days
      final history = [
        createTestTransaction(
          description: 'COFFEE SHOP',
          amount: -35.0,
          date: DateTime(2025, 4, 1),
        ),
        createTestTransaction(
          description: 'COFFEE SHOP',
          amount: -36.0,
          date: DateTime(2025, 4, 15),
        ),
        createTestTransaction(
          description: 'COFFEE SHOP',
          amount: -37.0,
          date: DateTime(2025, 4, 28),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      expect(patterns, isEmpty); // Should NOT be detected as recurring
    });
  });
}
