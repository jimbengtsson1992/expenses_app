import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

import '../categorization_helpers.dart';

void main() {
  final dummyDate = DateTime(2025, 1, 1);
  late CategorizationService service;

  setUp(() {
    service = CategorizationService();
  });

  group('CategorizationService - Other', () {
    test('Mobile Subscription', () {
      expectCategory(
        service,
        'Telenor',
        -399,
        dummyDate,
        Category.other,
        Subcategory.mobileSubscription,
      );
      expectCategory(
        service,
        'APPLE.COM/BILL',
        -129,
        dummyDate,
        Category.other,
        Subcategory.mobileSubscription,
      );
    });

    test('Godfather', () {
      expectCategory(
        service,
        'Fadder',
        -200,
        dummyDate,
        Category.other,
        Subcategory.godfather,
      );
      expectCategory(
        service,
        'Överföring Gudmor Lollo',
        -200,
        dummyDate,
        Category.other,
        Subcategory.godfather,
      );

      // Specific Overrides for Godfather
      expectCategory(
        service,
        '1år - Lollo 95576770341',
        -300.00,
        DateTime(2025, 4, 7),
        Category.other,
        Subcategory.godfather,
      );
    });

    test('Personal Insurance', () {
      expectCategory(
        service,
        'Trygg-Hansa',
        -500,
        dummyDate,
        Category.other,
        Subcategory.personalInsurance,
      );
    });

    test('Unknown', () {
      expectCategory(
        service,
        'Unknown Blob',
        -50,
        dummyDate,
        Category.other,
        Subcategory.unknown,
      );
    });

    test('Other (General)', () {
      expectCategory(
        service,
        'Avanza',
        -5000,
        dummyDate,
        Category.other,
        Subcategory.other,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'LASTPASS.COM',
        -100,
        dummyDate,
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'WBDSPORTS',
        -260.0,
        DateTime(2025, 3, 22),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'HEMMAKVÄLL HALM',
        -23.9,
        DateTime(2025, 3, 8),
        Category.other,
        Subcategory.other,
      );

      // Specific Overrides for Other
      expectCategory(
        service,
        'Swish betalning LUNDBERG, CHARLOTTA',
        -155.00,
        dummyDate,
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'JINX DYNASTY',
        -1485,
        DateTime(2025, 11, 12),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning gdb i centrum ab',
        -174.00,
        DateTime(2025, 11, 7),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning LUCAS MALINA',
        -280.0,
        DateTime(2025, 11, 1),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning LUCAS MALINA',
        -500.0,
        DateTime(2026, 1, 6),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'SE0234;GOETEBORG',
        552.98,
        DateTime(2025, 11, 15),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'STUDIO;GOTEBORG',
        521.4,
        DateTime(2025, 9, 11),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'LOOMISP*STAURANG VASTE;GOTEBORG',
        178.0,
        DateTime(2025, 9, 6),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning GÖRAN BENGTSSON',
        -85.00,
        DateTime(2025, 7, 13),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Kortköp 250425 4051 WHS LS GOT',
        -45.00,
        DateTime(2025, 4, 28),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning KARTAL,MIA',
        -180.00,
        DateTime(2025, 4, 21),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'Swish betalning RAGNAR, MIRANDA',
        -300.00,
        DateTime(2025, 4, 19),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'UNHCR',
        -10.0,
        DateTime(2025, 4, 5),
        Category.other,
        Subcategory.other,
      );
      expectCategory(
        service,
        'APTEKA AKSAMITNA',
        -101.2,
        DateTime(2025, 3, 29),
        Category.other,
        Subcategory.other,
      );
    });
  });
}
