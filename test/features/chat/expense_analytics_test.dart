import 'package:expenses/src/features/chat/domain/expense_analytics.dart';
import 'package:expenses/src/features/chat/application/expense_analytics_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseAnalytics Domain', () {
    test('toMarkdownPrompt includes subcategories and transaction CSV', () {
      const analytics = ExpenseAnalytics(
        monthSummaries: [
          MonthSummary(
            year: 2024,
            month: 1,
            income: 25000,
            expenses: 1000,
            categoryBreakdown: {Category.food: 500, Category.transport: 500},
            subcategoryBreakdown: {
              Subcategory.coffee: 500,
              Subcategory.taxi: 500,
            },
          ),
        ],
        categoryTotals: {},
        totalIncome: 25000,
        totalExpenses: 1000,
        compactTransactions: [
          '2024-01-15;500;Mat & Dryck;Kaffe & Fika;Espresso House',
          '2024-01-16;500;Transport;Taxi & Voi;Uber',
        ],
      );

      final prompt = analytics.toMarkdownPrompt();

      // Verify Subcategories (indented with *)
      expect(prompt, contains('* Kaffe & Fika: 500 kr'));
      expect(prompt, contains('* Taxi & Voi: 500 kr'));

      // Verify CSV Header
      expect(
        prompt,
        contains('Datum;Belopp;Kategori;Underkategori;Beskrivning'),
      );

      // Verify CSV Content
      expect(
        prompt,
        contains('2024-01-15;500;Mat & Dryck;Kaffe & Fika;Espresso House'),
      );
      expect(prompt, contains('2024-01-16;500;Transport;Taxi & Voi;Uber'));
    });
  });

  group('ExpenseAnalyticsService', () {
    test('analyze() populates subcategories and compactTransactions', () {
      final service = ExpenseAnalyticsService();
      final transactions = [
        Transaction(
          id: '1',
          date: DateTime(2024, 1, 15),
          amount: -500,
          description: 'Espresso House',
          category: Category.food,
          subcategory: Subcategory.coffee,
          sourceAccount: Account.gemensamt,
          sourceFilename: 'file',
        ),
        Transaction(
          id: '2',
          date: DateTime(2024, 1, 16),
          amount: -500,
          description: 'Uber',
          category: Category.transport,
          subcategory: Subcategory.taxi,
          sourceAccount: Account.gemensamt,
          sourceFilename: 'file',
        ),
      ];

      final analytics = service.analyze(transactions);

      // Verify Subcategory Breakdown in Month Summary
      expect(analytics.monthSummaries, isNotEmpty);
      final summary = analytics.monthSummaries.first;
      expect(summary.subcategoryBreakdown[Subcategory.coffee], 500);
      expect(summary.subcategoryBreakdown[Subcategory.taxi], 500);

      // Verify Compact Transactions
      expect(analytics.compactTransactions.length, 2);
      // Format: YYYY-MM-DD;Amount;Category;Subcategory;Description
      // Note: Amount is absolute value or signed?
      // In service: amount = t.amount.round().
      // Since amount is -500, round() is -500.
      expect(
        analytics.compactTransactions[0],
        '2024-1-15;-500;Mat & Dryck;Kaffe & Fika;Espresso House',
      );
      expect(
        analytics.compactTransactions[1],
        '2024-1-16;-500;Transport;Taxi & Voi;Uber',
      );
    });
  });
}
