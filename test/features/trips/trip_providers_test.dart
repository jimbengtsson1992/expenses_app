import 'package:expenses/src/features/transactions/data/expenses_repository.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/trips/application/trip_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeExpensesRepository implements ExpensesRepository {
  final List<Transaction> _transactions;
  FakeExpensesRepository(this._transactions);

  @override
  Future<List<Transaction>> getExpenses() async {
    return _transactions;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Transaction createTransaction({
  required String id,
  required DateTime date,
  String? tripId,
}) {
  return Transaction(
    id: id,
    date: date,
    amount: -100,
    description: 'Test transaction',
    category: Category.entertainment,
    subcategory: Subcategory.travel,
    sourceAccount: Account.sasMastercard,
    sourceFilename: 'test.csv',
    tripId: tripId,
  );
}

void main() {
  group('groupByTrip', () {
    test('groups by tripId, drops untagged, preserves order', () {
      final transactions = [
        createTransaction(id: '1', date: DateTime(2026, 9, 5), tripId: 'a'),
        createTransaction(id: '2', date: DateTime(2026, 9, 4)),
        createTransaction(id: '3', date: DateTime(2026, 9, 3), tripId: 'b'),
        createTransaction(id: '4', date: DateTime(2026, 6, 1), tripId: 'a'),
      ];

      final groups = groupByTrip(transactions);

      expect(groups.keys, {'a', 'b'});
      expect(groups['a']!.map((t) => t.id), ['1', '4']);
      expect(groups['b']!.map((t) => t.id), ['3']);
    });

    test('returns empty map when nothing is tagged', () {
      final groups = groupByTrip([
        createTransaction(id: '1', date: DateTime(2026, 9, 5)),
      ]);

      expect(groups, isEmpty);
    });

    test('period-filtered input yields only that period (dashboard case)', () {
      final all = [
        createTransaction(
          id: 'june',
          date: DateTime(2026, 6, 10),
          tripId: 'florence-2026',
        ),
        createTransaction(
          id: 'sept',
          date: DateTime(2026, 9, 5),
          tripId: 'florence-2026',
        ),
      ];
      final september = all.where((t) => t.date.month == 9);
      final july = all.where((t) => t.date.month == 7);

      expect(groupByTrip(september)['florence-2026']!.map((t) => t.id), [
        'sept',
      ]);
      expect(groupByTrip(july), isEmpty);
    });
  });

  test(
    'tripTransactionsProvider returns tagged transactions across months',
    () async {
      final transactions = [
        createTransaction(
          id: '1',
          date: DateTime(2026, 6, 10),
          tripId: 'florence-2026', // Advance booking, earlier month
        ),
        createTransaction(
          id: '2',
          date: DateTime(2026, 9, 5),
          tripId: 'florence-2026', // During trip
        ),
        createTransaction(
          id: '3',
          date: DateTime(2026, 9, 6),
          tripId: 'other-trip', // Different trip
        ),
        createTransaction(
          id: '4',
          date: DateTime(2026, 9, 7), // Untagged
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          expensesRepositoryProvider.overrideWithValue(
            FakeExpensesRepository(transactions),
          ),
        ],
      );

      final result = await container.read(
        tripTransactionsProvider('florence-2026').future,
      );

      expect(result.map((t) => t.id).toSet(), {'1', '2'});
    },
  );

  test(
    'tripTransactionsProvider returns empty list when nothing is tagged',
    () async {
      final container = ProviderContainer(
        overrides: [
          expensesRepositoryProvider.overrideWithValue(
            FakeExpensesRepository([
              createTransaction(id: '1', date: DateTime(2026, 9, 5)),
            ]),
          ),
        ],
      );

      final result = await container.read(
        tripTransactionsProvider('florence-2026').future,
      );

      expect(result, isEmpty);
    },
  );
}
