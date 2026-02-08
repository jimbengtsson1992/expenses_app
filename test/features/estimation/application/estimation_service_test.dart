import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:expenses/src/features/estimation/application/estimation_service.dart';
import 'package:expenses/src/features/estimation/application/recurring_detection_service.dart';
import 'package:expenses/src/features/estimation/domain/monthly_estimate.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';
import 'package:expenses/src/features/dashboard/domain/date_period.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';

@GenerateNiceMocks([MockSpec<RecurringDetectionService>()])
import 'estimation_service_test.mocks.dart';

void main() {
  late EstimationService service;
  late MockRecurringDetectionService mockRecurringService;

  setUp(() {
    mockRecurringService = MockRecurringDetectionService();
    service = EstimationService(mockRecurringService);
  });

  Transaction createTransaction({
    required DateTime date,
    required double amount,
    required Category category,
    required Subcategory subcategory,
    String description = 'Test transaction',
    bool excludeFromOverview = false,
  }) {
    return Transaction(
      id: 'id_${date.toIso8601String()}_$amount',
      date: date,
      amount: amount,
      description: description,
      category: category,
      subcategory: subcategory,
      sourceAccount: Account.gemensamt,
      sourceFilename: 'test.csv',
      excludeFromOverview: excludeFromOverview,
    );
  }

  group('calculateEstimate - Entry Point', () {
    test('returns null for DatePeriod.year', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      const period = DatePeriod.year(2025);
      final now = DateTime(2025, 6, 15);

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNull);
    });

    test('returns null for completed past month', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      const period = DatePeriod.month(2025, 1); // January 2025
      final now = DateTime(2025, 3, 15); // March 2025

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNull);
    });

    test('returns MonthlyEstimate for current month', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      const period = DatePeriod.month(2025, 3);
      final now = DateTime(2025, 3, 15);

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNotNull);
    });

    test('returns MonthlyEstimate for future month', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      const period = DatePeriod.month(2025, 6); // June 2025
      final now = DateTime(2025, 3, 15); // March 2025

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNotNull);
    });
  });

  group('Actuals Calculation', () {
    test('correctly sums income and expense transactions', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 15);
      const period = DatePeriod.month(2025, 2);

      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 5),
          amount: 5000,
          category: Category.income,
          subcategory: Subcategory.salary,
        ),
        createTransaction(
          date: DateTime(2025, 2, 10),
          amount: -200,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
        createTransaction(
          date: DateTime(2025, 2, 12),
          amount: -100,
          category: Category.food,
          subcategory: Subcategory.restaurant,
        ),
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);
      expect(result!.actualIncome, 5000);
      expect(result.actualExpenses, 300);
    });

    test('excludes transactions with excludeFromOverview = true', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 15);
      const period = DatePeriod.month(2025, 2);

      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 5),
          amount: 5000,
          category: Category.income,
          subcategory: Subcategory.salary,
        ),
        createTransaction(
          date: DateTime(2025, 2, 10),
          amount: -200,
          category: Category.food,
          subcategory: Subcategory.groceries,
          excludeFromOverview: true,
        ), // Excluded
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);
      expect(result!.actualIncome, 5000);
      expect(result.actualExpenses, 0); // The 200 expense is excluded
    });

    test(
      'excludes isExcludedFromEstimates categories (housing/kitchenRenovation)',
      () {
        when(
          mockRecurringService.detectRecurringPatterns(
            any,
            forYear: anyNamed('forYear'),
            forMonth: anyNamed('forMonth'),
          ),
        ).thenReturn([]);

        final now = DateTime(2025, 2, 15);
        const period = DatePeriod.month(2025, 2);

        final transactions = [
          createTransaction(
            date: DateTime(2025, 2, 5),
            amount: -50000,
            category: Category.housing,
            subcategory: Subcategory.kitchenRenovation,
          ), // Excluded
          createTransaction(
            date: DateTime(2025, 2, 10),
            amount: -200,
            category: Category.food,
            subcategory: Subcategory.groceries,
          ),
        ];

        final result = service.calculateEstimate(period, transactions, now);

        expect(result, isNotNull);
        expect(result!.actualExpenses, 200); // Only groceries counted
      },
    );

    test('populates categoryActuals correctly', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 15);
      const period = DatePeriod.month(2025, 2);

      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 5),
          amount: -200,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
        createTransaction(
          date: DateTime(2025, 2, 10),
          amount: -100,
          category: Category.food,
          subcategory: Subcategory.restaurant,
        ),
        createTransaction(
          date: DateTime(2025, 2, 12),
          amount: -50,
          category: Category.transport,
          subcategory: Subcategory.publicTransport,
        ),
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);
      expect(result!.categoryEstimates[Category.food]?.actual, 300);
      expect(result.categoryEstimates[Category.transport]?.actual, 50);
    });
  });

  group('Recurring Transaction Handling', () {
    test('classifies recurring as completed when description matches', () {
      const recurringPattern = RecurringStatus(
        descriptionPattern: 'Netflix',
        averageAmount: 179,
        typicalDayOfMonth: 15,
        category: Category.entertainment,
        subcategory: Subcategory.streaming,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([recurringPattern]);

      final now = DateTime(2025, 2, 20);
      const period = DatePeriod.month(2025, 2);

      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 15),
          amount: -179,
          category: Category.entertainment,
          subcategory: Subcategory.streaming,
          description: 'Netflix Premium',
        ),
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);
      expect(result!.completedRecurring.length, 1);
      expect(result.pendingRecurring.length, 0);
    });

    test('classifies recurring as pending when no match found', () {
      const recurringPattern = RecurringStatus(
        descriptionPattern: 'Netflix',
        averageAmount: 179,
        typicalDayOfMonth: 25,
        category: Category.entertainment,
        subcategory: Subcategory.streaming,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([recurringPattern]);

      final now = DateTime(2025, 2, 10);
      const period = DatePeriod.month(2025, 2);

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNotNull);
      expect(result!.completedRecurring.length, 0);
      expect(result.pendingRecurring.length, 1);
    });

    test('adds pending recurring amounts to estimated totals', () {
      const incomeRecurring = RecurringStatus(
        descriptionPattern: 'Salary',
        averageAmount: 50000,
        typicalDayOfMonth: 25,
        category: Category.income,
        subcategory: Subcategory.salary,
        type: TransactionType.income,
        occurrenceCount: 12,
      );

      const expenseRecurring = RecurringStatus(
        descriptionPattern: 'Rent',
        averageAmount: 15000,
        typicalDayOfMonth: 1,
        category: Category.housing,
        subcategory: Subcategory.brfFee,
        type: TransactionType.expense,
        occurrenceCount: 12,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([incomeRecurring, expenseRecurring]);

      final now = DateTime(2025, 2, 1);
      const period = DatePeriod.month(2025, 2);

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNotNull);
      expect(result!.estimatedIncome, greaterThanOrEqualTo(50000));
      expect(result.estimatedExpenses, greaterThanOrEqualTo(15000));
    });

    test('transaction pool matching consumes one transaction per pattern', () {
      // Two patterns with same description
      const pattern1 = RecurringStatus(
        descriptionPattern: 'Coop',
        averageAmount: 500,
        typicalDayOfMonth: 10,
        category: Category.food,
        subcategory: Subcategory.groceries,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );
      const pattern2 = RecurringStatus(
        descriptionPattern: 'Coop',
        averageAmount: 500,
        typicalDayOfMonth: 20,
        category: Category.food,
        subcategory: Subcategory.groceries,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([pattern1, pattern2]);

      final now = DateTime(2025, 2, 25);
      const period = DatePeriod.month(2025, 2);

      // Only one Coop transaction in current month
      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 12),
          amount: -500,
          category: Category.food,
          subcategory: Subcategory.groceries,
          description: 'Coop Stora',
        ),
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);
      expect(result!.completedRecurring.length, 1);
      expect(result.pendingRecurring.length, 1);
    });
  });

  group('Variable Spending Pro-rating', () {
    test('calculates correct remainingRatio for mid-month', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      // Feb 2025 has 28 days, day 14 = halfway
      final now = DateTime(2025, 2, 14);
      const period = DatePeriod.month(2025, 2);

      // History: 1000 SEK/month food
      final history = [
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -1000,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // Expected: (28-14)/28 * 1000 = 500
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.estimated, closeTo(500, 1));
    });

    test('skips pro-rating for categories with known recurring patterns', () {
      const recurringPattern = RecurringStatus(
        descriptionPattern: 'Netflix',
        averageAmount: 179,
        typicalDayOfMonth: 15,
        category: Category.entertainment,
        subcategory: Subcategory.streaming,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([recurringPattern]);

      final now = DateTime(2025, 2, 1);
      const period = DatePeriod.month(2025, 2);

      // History with entertainment spending
      final history = [
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -179,
          category: Category.entertainment,
          subcategory: Subcategory.streaming,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // Should only have the pending recurring (179), not pro-rated variable
      final entertainmentEstimate =
          result!.categoryEstimates[Category.entertainment];
      expect(entertainmentEstimate, isNotNull);
      expect(entertainmentEstimate!.estimated, 179);
    });
  });

  group('Historical Average Calculation', () {
    test('returns correct averages across multiple months', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 3, 15);
      const period = DatePeriod.month(2025, 3);

      // History: 2 months of transactions
      final history = [
        // January: 1000 food
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -1000,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
        // February: 2000 food
        createTransaction(
          date: DateTime(2025, 2, 15),
          amount: -2000,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // Average = (1000+2000)/2 = 1500
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.historicalAverage, 1500);
    });

    test('excludes excludeFromOverview transactions from history', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 3, 15);
      const period = DatePeriod.month(2025, 3);

      final history = [
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -1000,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
        createTransaction(
          date: DateTime(2025, 2, 15),
          amount: -5000,
          category: Category.food,
          subcategory: Subcategory.groceries,
          excludeFromOverview: true,
        ), // Excluded
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // Only the 1000 should count (1 month)
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.historicalAverage, 1000);
    });
  });

  group('Subcategory Estimates', () {
    test('calculates correct subcategory estimates', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 14);
      const period = DatePeriod.month(2025, 2);

      // History with multiple subcategories
      final history = [
        createTransaction(
          date: DateTime(2025, 1, 10),
          amount: -600,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
        createTransaction(
          date: DateTime(2025, 1, 20),
          amount: -400,
          category: Category.food,
          subcategory: Subcategory.restaurant,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);

      final groceriesEst =
          foodEstimate!.subcategoryEstimates[Subcategory.groceries];
      final restaurantEst =
          foodEstimate.subcategoryEstimates[Subcategory.restaurant];

      expect(groceriesEst, isNotNull);
      expect(restaurantEst, isNotNull);

      // 14/28 = 0.5 remaining ratio
      // Groceries: 600 * 0.5 = 300
      // Restaurant: 400 * 0.5 = 200
      expect(groceriesEst!.estimated, closeTo(300, 1));
      expect(restaurantEst!.estimated, closeTo(200, 1));
    });
  });

  group('Edge Cases', () {
    test('handles empty transaction history', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 15);
      const period = DatePeriod.month(2025, 2);

      final result = service.calculateEstimate(period, [], now);

      expect(result, isNotNull);
      expect(result!.actualIncome, 0);
      expect(result.actualExpenses, 0);
      expect(result.estimatedIncome, 0);
      expect(result.estimatedExpenses, 0);
    });

    test('handles first day of month correctly', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 1);
      const period = DatePeriod.month(2025, 2);

      // History from previous month
      final history = [
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -1000,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // remainingRatio = (28-1)/28 = 0.964...
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.estimated, closeTo(1000 * (27 / 28), 1));
    });

    test('handles last day of month correctly', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 2, 28);
      const period = DatePeriod.month(2025, 2);

      // Some actuals in current month
      final transactions = [
        createTransaction(
          date: DateTime(2025, 2, 15),
          amount: -500,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
      ];

      final result = service.calculateEstimate(period, transactions, now);

      expect(result, isNotNull);

      // remainingRatio = (28-28)/28 = 0
      // Only actuals should be in estimate
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.actual, 500);
      expect(foodEstimate.estimated, 500); // No pro-rated addition
    });

    test('handles 31-day month correctly', () {
      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: anyNamed('forYear'),
          forMonth: anyNamed('forMonth'),
        ),
      ).thenReturn([]);

      final now = DateTime(2025, 1, 16); // Mid-January (31 days)
      const period = DatePeriod.month(2025, 1);

      // History from December
      final history = [
        createTransaction(
          date: DateTime(2024, 12, 15),
          amount: -3100,
          category: Category.food,
          subcategory: Subcategory.groceries,
        ),
      ];

      final result = service.calculateEstimate(period, history, now);

      expect(result, isNotNull);

      // remainingRatio = (31-16)/31 = 15/31
      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);
      expect(foodEstimate!.estimated, closeTo(3100 * (15 / 31), 1));
    });
  });

  // Existing test - kept for backward compatibility
  test(
    'Category estimate should equal sum of subcategory estimates when mixed recurring/variable exists',
    () {
      final now = DateTime(2025, 2, 15);
      const period = DatePeriod.month(2025, 2);

      final history = [
        createTransaction(
          date: DateTime(2025, 1, 15),
          amount: -1000,
          category: Category.food,
          subcategory: Subcategory.restaurant,
          description: 'Tasty Burger',
        ),
      ];

      final currentMonthTrans = <Transaction>[];
      final allTransactions = [...history, ...currentMonthTrans];

      const recurringPattern = RecurringStatus(
        descriptionPattern: 'Coop',
        averageAmount: 500,
        typicalDayOfMonth: 20,
        category: Category.food,
        subcategory: Subcategory.groceries,
        type: TransactionType.expense,
        occurrenceCount: 5,
      );

      when(
        mockRecurringService.detectRecurringPatterns(
          any,
          forYear: 2025,
          forMonth: 2,
        ),
      ).thenReturn([recurringPattern]);

      final result = service.calculateEstimate(period, allTransactions, now);

      expect(result, isNotNull);

      final foodEstimate = result!.categoryEstimates[Category.food];
      expect(foodEstimate, isNotNull);

      final groceriesEst =
          foodEstimate!.subcategoryEstimates[Subcategory.groceries];
      expect(
        groceriesEst?.estimated,
        500,
        reason:
            'Groceries should be 500 (Recurring) but was ${groceriesEst?.estimated}',
      );

      final restaurantsEst =
          foodEstimate.subcategoryEstimates[Subcategory.restaurant];
      expect(restaurantsEst, isNotNull);
      const expectedRestVar = 1000.0 * (13 / 28);
      expect(
        restaurantsEst!.estimated,
        closeTo(expectedRestVar, 0.1),
        reason: 'Restaurants should be variable estimate',
      );

      const expectedTotal = 500 + expectedRestVar;
      expect(
        foodEstimate.estimated,
        closeTo(expectedTotal, 0.1),
        reason:
            'Category Estimate (${foodEstimate.estimated}) should equal sum of subcategories ($expectedTotal)',
      );
    },
  );
}
