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

  group('CategorizationService - Shopping', () {
    test('Clothes', () {
      expectCategory(
        service,
        'NK Göteborg',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'H&M',
        -300,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'Boss GBG',
        -1300,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'LIVLY',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );

      // New Rules 2026-01-20
      expectCategory(
        service,
        'Köp STADIUM',
        -499,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      // New Rules 2026-02-02
      expectCategory(
        service,
        'bymalina',
        -1500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );

      // New Rules 2026-01-28
      expectCategory(
        service,
        'ADOORE',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'UNIQLO GOTHENBURG',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );

      // Fallback checks
      expectCategory(
        service,
        'HESTRA GOTHENBURG',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      // Fallback check (wrong date/amount)
      expectCategory(
        service,
        'Kortköp 251221 NK MAN GBG',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );

      // Investigation Test Case (NK STOCKHOLM)
      expectCategory(
        service,
        'Kortköp 251221 NK STOCKHOLM',
        -500.00,
        DateTime(2025, 12, 22),
        Category.shopping,
        Subcategory.clothes,
      );
    });

    test('Electronics', () {
      expectCategory(
        service,
        'Elgiganten',
        -1000,
        dummyDate,
        Category.shopping,
        Subcategory.electronics,
      );
    });

    test('Beauty (Shopping)', () {
      expectCategory(
        service,
        'NK BEAUTY',
        -350,
        dummyDate,
        Category.shopping,
        Subcategory.beauty,
      );
      expectCategory(
        service,
        'Vacker NK',
        -300,
        dummyDate,
        Category.shopping,
        Subcategory.beauty,
      );
    });

    test('Decor', () {
      expectCategory(
        service,
        'Arket',
        -450,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'NK KOK & DESIGN',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'ARTILLERIET STORE',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      // New Rules 2026-02-02
      expectCategory(
        service,
        'JOTEX SWEDEN AB',
        -2000,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );

      // New Rules 2026-02-02
      expectCategory(
        service,
        'Kortköp 250213 SP BLOMRUM',
        -650.00,
        DateTime(2025, 2, 14),
        Category.shopping,
        Subcategory.decor,
      );

      // Specific Overrides for Decor
      expectCategory(
        service,
        'NORDISKA GALLERIET GOT',
        400,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'NORDISKA GALLERIET GOT',
        -400,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'BILLDALS BLOMMOR',
        -720.0,
        DateTime(2025, 11, 1),
        Category.shopping,
        Subcategory.decor,
      );
    });

    test('Gifts', () {
      // General Logic
      expectCategory(
        service,
        'Köp INTERFLORA AKTIEBOL',
        -350,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'EUROFLORIST',
        -350,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );

      // Specific Overrides for Gifts
      expectCategory(
        service,
        'ZETTLE_*SAD RETAIL GRO',
        -950,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'NK KOK & DESIGN GBG',
        -2090,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 251218 NK KIDS & TEENS GBG',
        -239,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 251218 NK KIDS & TEENS GBG',
        -70,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 251218 NK KOK & DESIGN GBG',
        -1299,
        dummyDate,
        Category.shopping,
        Subcategory.gifts,
      );

      expectCategory(
        service,
        'HESTRA GOTHENBURG',
        -1400,
        DateTime(2026, 1, 3),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 251221 NK MAN GBG',
        -2299.00,
        DateTime(2025, 12, 22),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'JOHN HENRIC NK GBG',
        -1999.00,
        DateTime(2025, 12, 22),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'CAPRIS',
        -650.00,
        DateTime(2025, 12, 30),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 251115 Hestra Gothenburg',
        -1400.00,
        DateTime(2025, 11, 16),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Swish betalning AB SVENSKA SPEL',
        -250.00,
        DateTime(2025, 11, 9),
        Category.shopping,
        Subcategory.gifts,
      );

      // NK KAFFE, TE & KONFEKT
      expectCategory(
        service,
        'NK KAFFE, TE & KONFEKT',
        -109.0,
        DateTime(2025, 10, 31),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'NK KAFFE, TE & KONFEKT',
        109.0,
        DateTime(2025, 10, 31),
        Category.shopping,
        Subcategory.gifts,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'BODEGA PARTY',
        -517.0,
        DateTime(2025, 3, 21),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'BODEGA PARTY',
        -326.0,
        DateTime(2025, 3, 17),
        Category.shopping,
        Subcategory.gifts,
      );
    });

    test('Furniture', () {
      expectCategory(
        service,
        'ELLOS AB',
        -3148.1,
        dummyDate,
        Category.shopping,
        Subcategory.furniture,
      );
      expectCategory(
        service,
        'Kontantuttag 251107 BANKOMAT ALMEDA',
        -1300.00,
        DateTime(2025, 11, 8),
        Category.shopping,
        Subcategory.furniture,
      );

      // New Overrides 2026-01-27
      expectCategory(
        service,
        'Swish betalning Markus Bengtsson',
        -1180.00,
        DateTime(2026, 1, 27),
        Category.shopping,
        Subcategory.furniture,
      );
      expectCategory(
        service,
        'PARKERING GÖTEB',
        -518.0,
        DateTime(2026, 1, 25),
        Category.shopping,
        Subcategory.furniture,
      );
      expectCategory(
        service,
        'PARKERING GÖTEB',
        -414.0,
        DateTime(2026, 1, 24),
        Category.shopping,
        Subcategory.furniture,
      );
    });

    test('Tools', () {
      expectCategory(
        service,
        'Clas Ohlson',
        -129,
        dummyDate,
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'Swish betalning GÖRAN BENGTSSON',
        -600.00,
        DateTime(2025, 11, 8),
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'FLUGGER AB',
        -500,
        dummyDate,
        Category.shopping,
        Subcategory.tools,
      );
    });

    test('Other (Shopping)', () {
      // New Rules 2026-01-28
      expectCategory(
        service,
        'MAJBLOMMANS RIKSFÖR',
        -100,
        dummyDate,
        Category.shopping,
        Subcategory.other,
      );

      // Specific Overrides for Other
      expectCategory(
        service,
        'Autogiro K*partykunge',
        -368.70,
        DateTime(2025, 4, 8),
        Category.shopping,
        Subcategory.other,
      );

      // Remapped Dry Cleaning
      expectCategory(
        service,
        'VASQUE KEMTVATT',
        -200,
        dummyDate,
        Category.shopping,
        Subcategory.other,
      );
    });
    test('New Rules 2026-02-02 (Request)', () {
      expectCategory(
        service,
        'NEWPORT',
        -1032.5,
        DateTime(2026, 1, 17),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'NK KOK & DESIGN GBG',
        -598.0,
        DateTime(2026, 1, 19),
        Category.shopping,
        Subcategory.gifts,
      );
    });
    test('New Rules 2026-02-03 (Request)', () {
      expectCategory(
        service,
        'KJELL & CO',
        -200,
        dummyDate,
        Category.shopping,
        Subcategory.electronics,
      );
      expectCategory(
        service,
        'RITUALS COSMETICS SWED',
        -300,
        dummyDate,
        Category.shopping,
        Subcategory.beauty,
      );
      expectCategory(
        service,
        'Smalandsgr',
        -150,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
    });
    test('New Rules 2026-02-08 (Request)', () {
      // General
      expectCategory(
        service,
        'SAMSOEE  SAMSOEE',
        -500.0,
        DateTime(2025, 1, 1),
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'J.LINDEBERG AB',
        -500.0,
        DateTime(2025, 1, 1),
        Category.shopping,
        Subcategory.clothes,
      );

      // Overrides
      expectCategory(
        service,
        'JYSK STENALYCKAN',
        -269.0,
        DateTime(2024, 12, 29),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'LAGERHAUS HALMSTAD HAL',
        -59.0,
        DateTime(2024, 12, 29),
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'LAGERHAUS HALMSTAD HAL',
        -867.0,
        DateTime(2024, 12, 29),
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'VALLGATAN 12 FA',
        -2800.0,
        DateTime(2024, 12, 26),
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'VALLGATAN 12 FA',
        -2200.0,
        DateTime(2024, 12, 22),
        Category.shopping,
        Subcategory.clothes,
      );
    });
  });
}
