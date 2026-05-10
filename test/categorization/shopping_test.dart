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

      // New Rules 2026-02-22
      expectCategory(
        service,
        'LEXINGTON HOME GOT',
        -758.0,
        DateTime(2026, 2, 13),
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
    test('New Rules 2026-02-15 (Request)', () {
      // Exceptions
      expectCategory(
        service,
        'Kortköp 260213 SP BLOMRUM',
        -650.00,
        DateTime(2026, 2, 14),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 260213 AHLENS Goeteborg Kun',
        -600.00,
        DateTime(2026, 2, 14),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 260213 NK INREDNING',
        -1298.00,
        DateTime(2026, 2, 14),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Kortköp 260213 GINA TRICOT',
        -468.95,
        DateTime(2026, 2, 14),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Swish betalning WALLEY',
        -2160.00,
        DateTime(2026, 2, 8),
        Category.shopping,
        Subcategory.decor,
      );
    });
    test('New Rules 2026-03-01 (Request)', () {
      expectCategory(
        service,
        'BUTIK NORRVIKEN',
        -838.0,
        DateTime(2026, 2, 21),
        Category.shopping,
        Subcategory.gifts,
      );
      expectCategory(
        service,
        'Swish betalning RAGNAR, CAMILLA',
        -668.0,
        DateTime(2026, 2, 27),
        Category.shopping,
        Subcategory.beauty,
      );
      expectCategory(
        service,
        'Autogiro K*babyland.s',
        -1183.0,
        DateTime(2026, 2, 25),
        Category.shopping,
        Subcategory.decor,
      );
    });
    test('New Rules 2026-03-04 (Request)', () {
      // Keyword
      expectCategory(
        service,
        'FLORAMORAOCHKRUKATOSAB',
        -100.0,
        DateTime(2026, 3, 1),
        Category.shopping,
        Subcategory.decor,
      );
      // Override
      expectCategory(
        service,
        'FLORAMORAOCHKRUKATOSAB',
        -269.0,
        DateTime(2026, 2, 28),
        Category.shopping,
        Subcategory.gifts,
      );
    });
    test('New Rules (March 2026 Update)', () {
      // General
      expectCategory(
        service,
        'SVENSKT TENN',
        -100,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'DESIGNTORGET OSTRA H',
        -100,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'BOUTIQUE TINNA',
        -100,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );

      // Overrides
      expectCategory(
        service,
        'NK KIDS & TEENS GBG',
        -129.0,
        DateTime(2026, 3, 1),
        Category.shopping,
        Subcategory.gifts,
      );
    });
    test('New Rules 2026-03-18 (Request)', () {
      expectCategory(
        service,
        'BABY WORLD BACKAPLAN',
        -1496.95,
        DateTime(2026, 3, 14),
        Category.shopping,
        Subcategory.baby,
      );
    });
    test('New Rules 2026-04-03 (Request)', () {
      expectCategory(
        service,
        'LE CREUSET FREE',
        -2844.4,
        DateTime(2026, 3, 21),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'BUNCHERY BY BLOMRUM',
        -199.0,
        DateTime(2026, 3, 20),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'SE0234',
        -229.0,
        DateTime(2026, 3, 19),
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'PROSHOP.SE',
        -1347.0,
        DateTime(2026, 3, 15),
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'SVEA BANK AB',
        -6694.0,
        DateTime(2026, 3, 11),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'SE0234',
        -929.0,
        DateTime(2026, 3, 19),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'LINDEX',
        -929.0,
        dummyDate,
        Category.shopping,
        Subcategory.clothes,
      );
      expectCategory(
        service,
        'BUNCHERY BY BLOMRUM',
        -550.0,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'Open banking 99602600817064',
        -18995.0,
        DateTime(2026, 3, 30),
        Category.shopping,
        Subcategory.baby,
      );
      expectCategory(
        service,
        'Swish betalning FIRMA JUAN FERNANDE',
        -500.0,
        DateTime(2026, 4, 1),
        Category.shopping,
        Subcategory.decor,
      );
    });

    test('Baby', () {
      expectCategory(
        service,
        'Autogiro K*babyland.s',
        -550.0,
        dummyDate,
        Category.shopping,
        Subcategory.baby,
      );
      expectCategory(
        service,
        'BABY WORLD',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.baby,
      );
      expectCategory(
        service,
        'BABYSAM',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.baby,
      );
    });
    test('New Rules 2026-05-05 (Request)', () {
      // Nordea: 2026/04/18;-200,00;...;Swish betalning GRÖNBERGS INTERIÖR;...
      expectCategory(
        service,
        'Swish betalning GRÖNBERGS INTERIÖR',
        -200.0,
        DateTime(2026, 4, 18),
        Category.shopping,
        Subcategory.decor,
      );
      // Mastercard: 2026-04-25;...;E-VILLE.COM;HELSINKI;SEK;0.0;578.0 (inverted to -578)
      expectCategory(
        service,
        'E-VILLE.COM',
        -578.0,
        DateTime(2026, 4, 25),
        Category.shopping,
        Subcategory.baby,
      );
    });
    test('New Rules 2026-04-14 (Request)', () {
      // Keywords
      expectCategory(
        service,
        'GRANIT 40412',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'STUCKATUR I SVE',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'BLOMRUM',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'JOLLYROOM',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.baby,
      );

      // Overrides
      expectCategory(
        service,
        'STENBOLAGET SVE',
        -784.26,
        DateTime(2026, 4, 11),
        Category.shopping,
        Subcategory.tools,
      );
      expectCategory(
        service,
        'SP RUBIO MONOCOAT',
        -150.3,
        DateTime(2026, 4, 11),
        Category.shopping,
        Subcategory.decor,
      );
      expectCategory(
        service,
        'KLARNA AB',
        -1990.0,
        DateTime(2026, 4, 11),
        Category.shopping,
        Subcategory.baby,
      );
    });
    test('New Rules 2026-05-10b (Request)', () {
      // Keyword: BLOMSTERLANDET → decor
      expectCategory(
        service,
        'BLOMSTERLANDET',
        -100.0,
        dummyDate,
        Category.shopping,
        Subcategory.decor,
      );
      // Override: LOOMISP*DAHLS BAGERI-4 (Mastercard 2026-05-01, 99.0 inverted) → coffee
      expectCategory(
        service,
        'LOOMISP*DAHLS BAGERI-4',
        -99.0,
        DateTime(2026, 5, 1),
        Category.food,
        Subcategory.coffee,
      );
      // Override: Swish betalning GÖRAN BENGTSSON (Nordea 2026-05-02) → tools
      expectCategory(
        service,
        'Swish betalning GÖRAN BENGTSSON',
        -200.0,
        DateTime(2026, 5, 2),
        Category.shopping,
        Subcategory.tools,
      );
    });
    test('New Rules 2026-05-10 (Request)', () {
      // Keyword: SP MOMKIND APS → baby
      expectCategory(
        service,
        'SP MOMKIND APS',
        -500.0,
        dummyDate,
        Category.shopping,
        Subcategory.baby,
      );
      // Override: CAMELLIA I GOTE (Mastercard 2026-04-18, 95.0 inverted) → decor
      expectCategory(
        service,
        'CAMELLIA I GOTE',
        -95.0,
        DateTime(2026, 4, 18),
        Category.shopping,
        Subcategory.decor,
      );
      // Override: Autogiro K*Boob/ImseV (Nordea 2026-04-27) → baby
      expectCategory(
        service,
        'Autogiro K*Boob/ImseV',
        -1497.0,
        DateTime(2026, 4, 27),
        Category.shopping,
        Subcategory.baby,
      );
      // Override: Autogiro K*kappahl.co (Nordea 2026-04-27) → baby
      expectCategory(
        service,
        'Autogiro K*kappahl.co',
        -2142.35,
        DateTime(2026, 4, 27),
        Category.shopping,
        Subcategory.baby,
      );
    });
  });
}
