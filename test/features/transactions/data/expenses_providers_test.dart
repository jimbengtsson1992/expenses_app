import 'package:expenses/src/features/transactions/data/expenses_providers.dart';
import 'package:expenses/src/features/transactions/data/expenses_repository.dart';
import 'package:expenses/src/features/transactions/domain/transaction.dart';
import 'package:expenses/src/features/transactions/domain/transaction_type.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
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

void main() {
  test('expensesListProvider filters transactions before 2024-12-01', () async {
    final tOld = Transaction(
        id: '1', 
        date: DateTime(2024, 11, 30), // Should exclude
        amount: 100, 
        description: 'Old', 
        category: Category.shopping, 
        sourceAccount: Account.sasAmex, 
        sourceFilename: 'file', 
        type: TransactionType.expense,
        subcategory: Subcategory.unknown,
    );
    final tNew = Transaction(
        id: '2', 
        date: DateTime(2024, 12, 1), // Should include
        amount: 100, 
        description: 'New', 
        category: Category.shopping, 
        sourceAccount: Account.sasAmex, 
        sourceFilename: 'file', 
        type: TransactionType.expense,
        subcategory: Subcategory.unknown,
    );
    final tFuture = Transaction(
        id: '3', 
        date: DateTime(2025, 1, 1), // Should include
        amount: 100, 
        description: 'Future', 
        category: Category.shopping, 
        sourceAccount: Account.sasAmex, 
        sourceFilename: 'file', 
        type: TransactionType.expense,
        subcategory: Subcategory.unknown,
    );

    final mockRepo = FakeExpensesRepository([tOld, tNew, tFuture]);

    final container = ProviderContainer(
      overrides: [
        expensesRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    final expenses = await container.read(expensesListProvider.future);

    expect(expenses.length, 2);
    expect(expenses.any((e) => e.id == '1'), isFalse);
    expect(expenses.any((e) => e.id == '2'), isTrue);
    expect(expenses.any((e) => e.id == '3'), isTrue);
  });
}
