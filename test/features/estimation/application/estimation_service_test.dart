
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
    required String description,
  }) {
    return Transaction(
      id: 'id_${date.toIso8601String()}',
      date: date,
      amount: amount,
      description: description,
      category: category,
      subcategory: subcategory,
      sourceAccount: Account.gemensamt,
      sourceFilename: 'test.csv',
      type: amount < 0 ? TransactionType.expense : TransactionType.income, 
    );
  }

  test('Category estimate should equal sum of subcategory estimates when mixed recurring/variable exists', () {
    // Setup:
    // Category: Food
    // Subcat A (Groceries): Recurring (Future)
    // Subcat B (Restaurants): Variable (Historical)

    final now = DateTime(2025, 2, 15); // Halfway through the month
    const period = DatePeriod.month(2025, 2);

    // History: 
    // - 1000 SEK Restaurants (Variable) per month for previous months
    // - 0 SEK Groceries (Assuming new recurring pattern or just no history for simplicity)
    final history = [
      createTransaction(date: DateTime(2025, 1, 15), amount: -1000, category: Category.food, subcategory: Subcategory.restaurant, description: 'Tasty Burger'),
    ];

    // Current Month Transactions: Empty for now (so we rely purely on estimates)
    final currentMonthTrans = <Transaction>[];
    
    final allTransactions = [...history, ...currentMonthTrans];

    // Recurring Setup:
    // Defined a recurring pattern for Groceries
    const recurringPattern = RecurringStatus(
      descriptionPattern: 'Coop',
      averageAmount: 500,
      typicalDayOfMonth: 20,
      category: Category.food,
      subcategory: Subcategory.groceries,
      type: TransactionType.expense,
      occurrenceCount: 5,
    );

    when(mockRecurringService.detectRecurringPatterns(any, forYear: 2025, forMonth: 2))
        .thenReturn([recurringPattern]);

    // Execute
    final result = service.calculateEstimate(period, allTransactions, now);

    expect(result, isNotNull);
    
    final foodEstimate = result!.categoryEstimates[Category.food];
    expect(foodEstimate, isNotNull);

    // Analyze Subcategory Estimates
    // 1. Groceries: Should be 500 (Recurring)
    final groceriesEst = foodEstimate!.subcategoryEstimates[Subcategory.groceries];
    expect(groceriesEst?.estimated, 500, reason: 'Groceries should be 500 (Recurring) but was ${groceriesEst?.estimated}');

    // 2. Restaurants: Should be ~500 (Variable: 1000 avg * 0.5 remaining) (approximate depending on days calculation)
    // Feb 2025 has 28 days.
    // currentDay = 15. Remaining = 28-15 = 13. Ratio = 13/28 = 0.464...
    // Expected = 1000 * (13/28) = 464.28...
    final restaurantsEst = foodEstimate.subcategoryEstimates[Subcategory.restaurant];
    expect(restaurantsEst, isNotNull);
    const expectedRestVar = 1000.0 * (13/28);
    expect(restaurantsEst!.estimated, closeTo(expectedRestVar, 0.1), reason: 'Restaurants should be variable estimate');

    // Analyze Category Estimate
    // Should be Sum(Groceries + Restaurants) = 500 + 464.28 = 964.28
    // CURRENT BUG: It will likely be 500 only, because "Food" has a recurring pattern, so variable portion is ignored.
    const expectedTotal = 500 + expectedRestVar;
    
    expect(foodEstimate.estimated, closeTo(expectedTotal, 0.1), 
      reason: 'Category Estimate (${foodEstimate.estimated}) should equal sum of subcategories ($expectedTotal)');
  });
}
