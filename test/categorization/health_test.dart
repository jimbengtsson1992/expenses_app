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

  group('CategorizationService - Health', () {
    test('Beauty (Health)', () {
      expectCategory(
        service,
        'Sanna andrén',
        -500,
        dummyDate,
        Category.health,
        Subcategory.beauty,
      );
      expectCategory(
        service,
        'STYLE BARBERSHOP',
        -450,
        dummyDate,
        Category.health,
        Subcategory.beauty,
      );
      expectCategory(
        service,
        'Kortköp 230912 DOBRUK, EDYTA',
        -550,
        dummyDate,
        Category.health,
        Subcategory.beauty,
      );

      // Specific Overrides for Beauty
      expectCategory(
        service,
        'Swish betalning DUMAN MELIS',
        -1170.00,
        DateTime(2025, 5, 29),
        Category.health,
        Subcategory.beauty,
      );
    });

    test('Gym', () {
      expectCategory(
        service,
        'SATS',
        -450,
        dummyDate,
        Category.health,
        Subcategory.gym,
      );
    });

    test('Pharmacy', () {
      expectCategory(
        service,
        'Apoteket AB',
        -120,
        dummyDate,
        Category.health,
        Subcategory.pharmacy,
      );

      // Specific Overrides for Pharmacy
      expectCategory(
        service,
        'KLARNA AB',
        -359.0,
        DateTime(2026, 3, 22),
        Category.health,
        Subcategory.pharmacy,
      );
    });

    test('Doctor', () {
      expectCategory(
        service,
        'Vårdcentralen',
        -200,
        dummyDate,
        Category.health,
        Subcategory.doctor,
      );
      expectCategory(
        service,
        'IDROTTSREHAB',
        -200,
        dummyDate,
        Category.health,
        Subcategory.doctor,
      );
      expectCategory(
        service,
        'BABYSCREEN GBG',
        -1200,
        dummyDate,
        Category.health,
        Subcategory.doctor,
      );

      // Specific Overrides for Doctor
      expectCategory(
        service,
        'Open Banking BG 5734-9797 Patientfa',
        -100.00,
        DateTime(2025, 12, 22),
        Category.health,
        Subcategory.doctor,
      );
      expectCategory(
        service,
        '2352 5694 01 75741',
        -3100.00,
        DateTime(2025, 10, 21),
        Category.health,
        Subcategory.doctor,
      );
      expectCategory(
        service,
        '2326 5694 01 75741',
        -3500.00,
        DateTime(2025, 7, 8),
        Category.health,
        Subcategory.doctor,
      );
      expectCategory(
        service,
        '2303 5694 01 75741',
        -5344.00,
        DateTime(2025, 4, 1),
        Category.health,
        Subcategory.doctor,
      );
    });

    test('Supplements', () {
      expectCategory(
        service,
        'MMSports',
        -500,
        dummyDate,
        Category.health,
        Subcategory.supplements,
      );
    });

    test('New Rules 2026-05-10 (Request)', () {
      // Override: STADIUM FREDSGA (Mastercard 2026-04-24, 399.0 inverted) → gym
      expectCategory(
        service,
        'STADIUM FREDSGA',
        -399.0,
        DateTime(2026, 4, 24),
        Category.health,
        Subcategory.gym,
      );
    });

    test('New Rules 2026-07-03 (Request)', () {
      // Keyword: BOKADIREKT - BOKNING → beauty
      expectCategory(
        service,
        'BOKADIREKT - BOKNING',
        -350.0,
        dummyDate,
        Category.health,
        Subcategory.beauty,
      );
      // Override: Open Banking BG 5734-9797 Patientfa (Nordea 2026-06-25, -130) → doctor
      expectCategory(
        service,
        'Open Banking BG 5734-9797 Patientfa',
        -130.0,
        DateTime(2026, 6, 25),
        Category.health,
        Subcategory.doctor,
      );
    });

    test('New Rules 2026-07-19 (Request)', () {
      // Keyword: APOTEK HJARTAT ICA MAX → pharmacy (must not hit 'ica' groceries rule)
      expectCategory(
        service,
        'APOTEK HJARTAT ICA MAX',
        -215.0,
        dummyDate,
        Category.health,
        Subcategory.pharmacy,
      );
      // Override: LYA NAILS & SPA (Mastercard 2026-07-09, 450.0 inverted) → beauty
      expectCategory(
        service,
        'LYA NAILS & SPA',
        -450.0,
        DateTime(2026, 7, 9),
        Category.health,
        Subcategory.beauty,
      );
      // Keyword: ORVELIN E-HANDEL AB → supplements
      expectCategory(
        service,
        'ORVELIN E-HANDEL AB',
        -349.0,
        dummyDate,
        Category.health,
        Subcategory.supplements,
      );
    });
    test('New Rules 2026-09-05 (Request)', () {
      // Override: Betalning BG 127-7078 AQUA BARN AB (Nordea 2026-08-21, -2499) → gym
      expectCategory(
        service,
        'Betalning BG 127-7078 AQUA BARN AB',
        -2499.0,
        DateTime(2026, 8, 21),
        Category.health,
        Subcategory.gym,
      );
      // Override: APOHEM.SE (Mastercard 2026-08-21, 735 inverted) → pharmacy
      expectCategory(
        service,
        'APOHEM.SE',
        -735.0,
        DateTime(2026, 8, 21),
        Category.health,
        Subcategory.pharmacy,
      );
      // Override: Swish betalning FRÖLUNDA MASSAGE AN (Nordea 2026-08-30, -895) → doctor
      expectCategory(
        service,
        'Swish betalning FRÖLUNDA MASSAGE AN',
        -895.0,
        DateTime(2026, 8, 30),
        Category.health,
        Subcategory.doctor,
      );
      // Wrong amount must not match the override.
      expect(
        service.categorize(
          'Betalning BG 127-7078 AQUA BARN AB',
          -100.0,
          DateTime(2026, 8, 21),
        ),
        isNot((Category.health, Subcategory.gym)),
      );
    });
  });
}
