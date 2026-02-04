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

    test('does not auto-detect recurring with only 2 occurrences', () {
      // Only 2 transactions across 2 months - should NOT be detected
      // This prevents weak patterns like "BANH MI SHOP" from being classified as recurring
      final history = [
        createTestTransaction(
          description: 'BANH MI SHOP',
          amount: -125.0,
          date: DateTime(2025, 1, 13),
        ),
        createTestTransaction(
          description: 'BANH MI SHOP',
          amount: -115.0,
          date: DateTime(2025, 12, 10),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      // Should NOT be detected as recurring (needs minimum 3 occurrences)
      final banhMiPatterns = patterns.where(
        (p) => p.descriptionPattern.toUpperCase().contains('BANH MI'),
      );
      expect(banhMiPatterns, isEmpty,
          reason: 'Transactions with only 2 occurrences should not be auto-detected as recurring');
    });

    test('auto-detects recurring with 3+ occurrences across multiple months', () {
      // 3 transactions across 3 months - should BE detected
      final history = [
        createTestTransaction(
          description: 'MONTHLY SUBSCRIPTION',
          amount: -99.0,
          date: DateTime(2025, 1, 15),
        ),
        createTestTransaction(
          description: 'MONTHLY SUBSCRIPTION',
          amount: -99.0,
          date: DateTime(2025, 2, 14),
        ),
        createTestTransaction(
          description: 'MONTHLY SUBSCRIPTION',
          amount: -99.0,
          date: DateTime(2025, 3, 15),
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      final subscriptionPatterns = patterns.where(
        (p) => p.descriptionPattern.toUpperCase().contains('SUBSCRIPTION'),
      );
      expect(subscriptionPatterns.length, 1,
          reason: 'Transactions with 3+ occurrences across multiple months should be detected as recurring');
      expect(subscriptionPatterns.first.occurrenceCount, 3);
      expect(subscriptionPatterns.first.averageAmount, 99.0);
    });

    test('handles both known recurring and auto-detected patterns in same category/subcategory', () {
      // Test that:
      // 1. Known recurring patterns (e.g., 'spotify') are detected via knownRecurringPatterns
      // 2. Auto-detected patterns (e.g., 'CUSTOM STREAMING SERVICE') are also detected
      // 3. Both coexist without duplication or interference

      final history = [
        // Known recurring: Spotify (matches 'spotify' pattern in knownRecurringPatterns)
        createTestTransaction(
          description: 'SPOTIFY P3E8032732',
          amount: -129.0,
          date: DateTime(2025, 1, 18),
          category: Category.entertainment,
        ),
        createTestTransaction(
          description: 'SPOTIFY P3D89E7989',
          amount: -129.0,
          date: DateTime(2025, 2, 18),
          category: Category.entertainment,
        ),
        createTestTransaction(
          description: 'SPOTIFY P3C8515FE4',
          amount: -129.0,
          date: DateTime(2025, 3, 18),
          category: Category.entertainment,
        ),

        // Auto-detected: A custom streaming service (not in knownRecurringPatterns)
        // Same description, consistent amounts, should be auto-detected
        createTestTransaction(
          description: 'CUSTOM STREAMING SVC',
          amount: -79.0,
          date: DateTime(2025, 1, 5),
          category: Category.entertainment,
        ),
        createTestTransaction(
          description: 'CUSTOM STREAMING SVC',
          amount: -79.0,
          date: DateTime(2025, 2, 5),
          category: Category.entertainment,
        ),
        createTestTransaction(
          description: 'CUSTOM STREAMING SVC',
          amount: -79.0,
          date: DateTime(2025, 3, 5),
          category: Category.entertainment,
        ),
      ];

      final patterns = service.detectRecurringPatterns(history);

      // Find Spotify pattern (known recurring)
      final spotifyPatterns = patterns.where(
        (p) => p.descriptionPattern.toLowerCase().contains('spotify'),
      ).toList();
      expect(spotifyPatterns.length, 1,
          reason: 'Spotify should be detected via known recurring patterns');
      expect(spotifyPatterns.first.averageAmount, 129.0);

      // Find custom streaming pattern (auto-detected)
      final customPatterns = patterns.where(
        (p) => p.descriptionPattern.toUpperCase().contains('CUSTOM STREAMING'),
      ).toList();
      expect(customPatterns.length, 1,
          reason: 'Custom streaming service should be auto-detected');
      expect(customPatterns.first.averageAmount, 79.0);

      // Both patterns should be present (total >= 2 for entertainment)
      final entertainmentPatterns = patterns.where(
        (p) => p.category == Category.entertainment,
      ).toList();
      expect(entertainmentPatterns.length, greaterThanOrEqualTo(2),
          reason: 'Both known and auto-detected patterns should coexist');
    });
  });
}
