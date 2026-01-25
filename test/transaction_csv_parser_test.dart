
import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/data/transaction_csv_parser.dart';
import 'package:expenses/src/features/transactions/data/user_rules_repository.dart';
import 'package:expenses/src/features/transactions/domain/account.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CategorizationService>(),
  MockSpec<UserRulesRepository>(),
])
import 'transaction_csv_parser_test.mocks.dart';

void main() {
  late TransactionCsvParser parser;
  late MockCategorizationService mockCategorizationService;
  late MockUserRulesRepository mockUserRulesRepository;

  setUp(() {
    mockCategorizationService = MockCategorizationService();
    mockUserRulesRepository = MockUserRulesRepository();
    parser = TransactionCsvParser(
      mockCategorizationService,
      mockUserRulesRepository,
    );

    // Default mock behavior for categorization
    when(
      mockCategorizationService.categorize(any, any, any),
    ).thenReturn((Category.other, Subcategory.unknown));
  });

  group('TransactionCsvParser Tests', () {
    test('isInternalTransfer identifies transfers correctly', () {
      expect(parser.isInternalTransfer('Överföring till XXX'), true);
      expect(parser.isInternalTransfer('Överföring från XXX'), true);
      expect(parser.isInternalTransfer('Lån återbetalning'), true);
      expect(parser.isInternalTransfer('Omsättning lån'), false);
      expect(parser.isInternalTransfer('Autogiro AVANZA BANK'), true);
    });

    test('isInternalTransfer identifies internal account numbers', () {
      for (final account in Account.values) {
        if (account.accountNumber != null) {
          expect(
            parser.isInternalTransfer('Transfer to ${account.accountNumber}'),
            true,
            reason: 'Failed for ${account.name}',
          );
          expect(
            parser.isInternalTransfer(
              'Transfer to ${account.accountNumber!.replaceAll(' ', '')}',
            ),
            true,
            reason: 'Failed for ${account.name} (no spaces)',
          );
        }
      }
    });

    test('shouldExcludeFromOverview correctly identifies exclusions', () {
      expect(
        parser.shouldExcludeFromOverview(
          'Swish återbetalning Jollyroom AB',
          1889.00,
          DateTime(2025, 1, 1),
        ),
        true,
      );
      expect(
        parser.shouldExcludeFromOverview(
          'Random Transaction',
          -500.0,
          DateTime(2025, 1, 1),
        ),
        false,
      );
    });

    test('shouldExcludeFromOverview excludes Swish between Jim and Louise', () {
      final date = DateTime(2025, 1, 1);
      final excludedDescriptions = [
        'Swish inbetalning RAGNAR,LOUISE',
        'Swish inbetalning RAGNAR, LOUISE',
        'Swish inbetalning Bengtsson,Jim',
        'Swish inbetalning Bengtsson, Jim',
        'Swish inbetalning ragnar,louise', // lowercase check
        'SWISH INBETALNING BENGTSSON,JIM', // uppercase check
      ];

      for (final desc in excludedDescriptions) {
        expect(
          parser.shouldExcludeFromOverview(desc, 100, date),
          true,
          reason: 'Failed to exclude: $desc',
        );
      }

      final includedDescriptions = [
        'Swish inbetalning ANDERSSON,ERIK', // Only specific date/amount excluded in other rule
        'Swish inbetalning Another,Person',
      ];

      for (final desc in includedDescriptions) {
        // ANDERSSON,ERIK has a specific rule for date/amount, so we use a generic amount/date here to ensure it's NOT excluded by the new logic
        expect(
          parser.shouldExcludeFromOverview(desc, 500, date),
          false,
          reason: 'Incorrectly excluded: $desc',
        );
      }
    });

    test('parseSasAmexCsv parses transactions and supports multiple sections', () {
      const csvContent = '''
Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp
2025-07-30;2025-07-31;Some Purchase;;SEK;0;100
;;Summa utgifter/debiteringar;;;;100

Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp
2025-07-31;2025-08-06;ÅRSAVGIFT;;SEK;0;2335
2025-07-31;2025-08-06;EXTRAKORTSAVGIFT;;SEK;0;295
;;Summa avgifter;;;;2630
''';

      final idRegistry = <String, int>{};
      final transactions = parser.parseSasAmexCsv(
        csvContent,
        'test.csv',
        idRegistry,
      );

      // We expect 3 transactions: Purchase, Fee 1, Fee 2.
      // If the parser stops at "Summa utgifter", we get 1.
      expect(transactions.length, 3,
          reason:
              'Should parse all sections including fees. Found ${transactions.length}');

      final fee1 = transactions.firstWhere((t) => t.description == 'ÅRSAVGIFT');
      expect(fee1.amount, -2335.0); // Converted to negative

      final fee2 = transactions.firstWhere(
        (t) => t.description == 'EXTRAKORTSAVGIFT',
      );
      expect(fee2.amount, -295.0);
    });
  });
}
