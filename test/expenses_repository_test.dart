import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/data/expenses_repository.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Since we are only testing isInternalTransfer which doesn't use refs/dependencies, we pass a dummy Ref.
class MockCategorizationService extends Mock implements CategorizationService {}

void main() {
  late ExpensesRepository repository;
  late MockCategorizationService mockCategorizationService;

  setUp(() {
    mockCategorizationService = MockCategorizationService();
    
    // Create a real Ref using ProviderContainer
    final container = ProviderContainer();
    final ref = container.read(Provider((ref) => ref));
    
    repository = ExpensesRepository(ref, mockCategorizationService);
    addTearDown(container.dispose);
  });

  group('ExpensesRepository', () {
    test('isInternalTransfer identifies transfers correctly', () {
      // General keywords
      expect(repository.isInternalTransfer('Överföring till XXX'), true);
      expect(repository.isInternalTransfer('Överföring från XXX'), true);
      expect(repository.isInternalTransfer('Lån återbetalning'), true);
      
      // Exclusion logic for "Omsättning lån"
      expect(repository.isInternalTransfer('Omsättning lån'), false);
      expect(repository.isInternalTransfer('Omsättning lån 123'), false);

      // Specific known transfers
      expect(repository.isInternalTransfer('Autogiro AVANZA BANK'), true);
    });

    test('isInternalTransfer identifies internal account numbers', () {
      // Loop through accounts and check if their numbers are flagged
      for (final account in Account.values) {
        if (account.accountNumber != null) {
          expect(repository.isInternalTransfer('Transfer to ${account.accountNumber}'), true, reason: 'Failed for ${account.name}');
          expect(repository.isInternalTransfer('Transfer to ${account.accountNumber!.replaceAll(' ', '')}'), true, reason: 'Failed for ${account.name} (no spaces)');
        }
      }
    });

    test('isInternalTransfer returns false for regular transactions', () {
      expect(repository.isInternalTransfer('ICA Maxi'), false);
      expect(repository.isInternalTransfer('Netflix'), false);
      expect(repository.isInternalTransfer('Lön'), false); // Salary is not a transfer in this context (unless from own account?)
    });
  });
}
