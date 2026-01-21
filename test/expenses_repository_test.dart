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
          expect(
            repository.isInternalTransfer(
              'Transfer to ${account.accountNumber}',
            ),
            true,
            reason: 'Failed for ${account.name}',
          );
          expect(
            repository.isInternalTransfer(
              'Transfer to ${account.accountNumber!.replaceAll(' ', '')}',
            ),
            true,
            reason: 'Failed for ${account.name} (no spaces)',
          );
        }
      }
    });

    test('isInternalTransfer returns false for regular transactions', () {
      expect(repository.isInternalTransfer('ICA Maxi'), false);
      expect(repository.isInternalTransfer('Netflix'), false);
      expect(
        repository.isInternalTransfer('Lön'),
        false,
      ); // Salary is not a transfer in this context (unless from own account?)
    });

    test(
      'shouldExcludeFromOverview correctly identifies specific exclusions',
      () {
        // Jollyroom 1889 logic
        expect(
          repository.shouldExcludeFromOverview(
            'Swish återbetalning Jollyroom AB',
            1889.00,
            DateTime(2025, 1, 1),
          ),
          true,
        );
        expect(
          repository.shouldExcludeFromOverview(
            'Swish betalning Jollyroom AB',
            -1889.00,
            DateTime(2025, 1, 1),
          ),
          true,
        );

        // Louise Avanza exclusion
        expect(
          repository.shouldExcludeFromOverview(
            '95561384521 louise avanza',
            -100.00,
            DateTime(2025, 1, 1),
          ),
          true,
        );
        expect(
          repository.shouldExcludeFromOverview(
            'Payment to 95561384521 Louise Avanza',
            -500.00,
            DateTime(2025, 1, 1),
          ),
          true,
        );

        // Strict number check
        expect(
          repository.shouldExcludeFromOverview(
            '95561384521',
            -200.0,
            DateTime(2025, 1, 1),
          ),
          true,
        );

        // Jollyroom other amount should not be excluded
        expect(
          repository.shouldExcludeFromOverview(
            'Swish betalning Jollyroom AB',
            -500.00,
            DateTime(2025, 1, 1),
          ),
          false,
        );

        // Internal transfer should also be excluded
        expect(
          repository.shouldExcludeFromOverview(
            'Överföring till XXX',
            -1000.0,
            DateTime(2025, 1, 1),
          ),
          true,
        );

        // Regular transaction should not be excluded
        expect(
          repository.shouldExcludeFromOverview(
            'ICA Maxi',
            -500.0,
            DateTime(2025, 1, 1),
          ),
          false,
        );

        // New Exclusion 1: Nordea Swish
        expect(
          repository.shouldExcludeFromOverview(
            'Swish inbetalning ANDERSSON,ERIK',
            1485.00,
            DateTime(2025, 11, 12),
          ),
          true,
        );
        // Wrong date
        expect(
          repository.shouldExcludeFromOverview(
            'Swish inbetalning ANDERSSON,ERIK',
            1485.00,
            DateTime(2025, 11, 13),
          ),
          false,
        );

        // New Exclusion 2: Amex Jinx Dynasty
        expect(
          repository.shouldExcludeFromOverview(
            'JINX DYNASTY',
            -1485.00,
            DateTime(2025, 11, 12),
          ),
          true,
        );

        // New Exclusion 3: Aktiekapital
        expect(
          repository.shouldExcludeFromOverview(
            'Aktiekapital 1110 31 04004',
            -25000.00,
            DateTime(2025, 11, 16),
          ),
          true,
        );
      },
    );
  });
}
