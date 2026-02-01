import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dummyDate = DateTime(2025, 1, 1);
  late CategorizationService service;

  setUp(() {
    service = CategorizationService();
  });

  group('CategorizationService - New Rules 2026-02-01', () {
    test('Keyword Rules', () {
      expect(service.categorize('OLIVIA GOTEBORG', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('HASSELBACKEN', -100, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(service.categorize('TORPA', -100, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
    });

    test('Specific Overrides', () {
      // 1. Food / Coffee: Swish betalning LUNDBERG, CHARLOTTA
      expect(
        service.categorize(
          'Swish betalning LUNDBERG, CHARLOTTA',
          -155.00,
          DateTime(2026, 1, 3),
        ),
        (Category.food, Subcategory.coffee),
      );

      // 2. Health / Doctor: Open Banking BG 5734-9797 Patientfa
      expect(
        service.categorize(
          'Open Banking BG 5734-9797 Patientfa',
          -100.00,
          DateTime(2025, 12, 22),
        ),
        (Category.health, Subcategory.doctor),
      );

      // 3. Other / Other: SE0234;GOETEBORG
      expect(
        service.categorize(
          'SE0234;GOETEBORG',
          552.98,
          DateTime(2025, 11, 15),
        ),
        (Category.other, Subcategory.other),
      );

      // 4. Other / Other: STUDIO;GOTEBORG
      expect(
        service.categorize(
          'STUDIO;GOTEBORG',
          521.4,
          DateTime(2025, 9, 11),
        ),
        (Category.other, Subcategory.other),
      );

      // 5. Other / Other: LOOMISP*STAURANG VASTE;GOTEBORG
      expect(
        service.categorize(
          'LOOMISP*STAURANG VASTE;GOTEBORG',
          178.0,
          DateTime(2025, 9, 6),
        ),
        (Category.other, Subcategory.other),
      );

      // 6. Housing / Cleaning: Swish betalning FORTNOX FINANS AB
      expect(
        service.categorize(
          'Swish betalning FORTNOX FINANS AB',
          -1605.00,
          DateTime(2025, 8, 15),
        ),
        (Category.housing, Subcategory.cleaning),
      );

      // 7. Food / Lunch: Swish betalning BÄCK, NATALIE
      expect(
        service.categorize(
          'Swish betalning BÄCK, NATALIE',
          -140.00,
          DateTime(2025, 8, 19),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 8. Food / Restaurant: Swish betalning DANIEL LENNARTSSON
      expect(
        service.categorize(
          'Swish betalning DANIEL LENNARTSSON',
          -400.00,
          DateTime(2025, 8, 23),
        ),
        (Category.food, Subcategory.restaurant),
      );

      // 9. Food / Restaurant: Swish betalning LINDSTRÖM,VENDELA
      expect(
        service.categorize(
          'Swish betalning LINDSTRÖM,VENDELA',
          -689.50,
          DateTime(2025, 7, 31),
        ),
        (Category.food, Subcategory.restaurant),
      );

      // 10. Entertainment / Travel: GOTO HUB AB;HELSINGBORG
      expect(
        service.categorize(
          'GOTO HUB AB;HELSINGBORG',
          1170.0,
          DateTime(2025, 7, 17),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 11. Other / Other: Swish betalning GÖRAN BENGTSSON
      expect(
        service.categorize(
          'Swish betalning GÖRAN BENGTSSON',
          -85.00,
          DateTime(2025, 7, 13),
        ),
        (Category.other, Subcategory.other),
      );

      // 12. Entertainment / Travel: ZETTLE_*TVELINGEN AB;GOTEBORG
      expect(
        service.categorize(
          'ZETTLE_*TVELINGEN AB;GOTEBORG',
          165.0,
          DateTime(2025, 7, 12),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 13. Health / Doctor: 2352 5694 01 75741 (Oct 21)
      expect(
        service.categorize(
          '2352 5694 01 75741',
          -3100.00,
          DateTime(2025, 10, 21),
        ),
        (Category.health, Subcategory.doctor),
      );

      // 14. Health / Doctor: 2326 5694 01 75741 (July 8)
      expect(
        service.categorize(
          '2326 5694 01 75741',
          -3500.00,
          DateTime(2025, 7, 8),
        ),
        (Category.health, Subcategory.doctor),
      );

      // 15. Food / Restaurant: STORSTUGAN;FJARAS
      expect(
        service.categorize(
          'STORSTUGAN;FJARAS',
          430.0,
          DateTime(2025, 5, 1),
        ),
        (Category.food, Subcategory.restaurant),
      );

      // 16. Health / Beauty: Swish betalning DUMAN MELIS
      expect(
        service.categorize(
          'Swish betalning DUMAN MELIS',
          -1170.00,
          DateTime(2025, 5, 29),
        ),
        (Category.health, Subcategory.beauty),
      );

      // 17. Other / Godfather: 1år - Lollo 95576770341
      expect(
        service.categorize(
          '1år - Lollo 95576770341',
          -300.00,
          DateTime(2025, 4, 7),
        ),
        (Category.other, Subcategory.godfather),
      );

      // 18. Health / Doctor: 2303 5694 01 75741
      expect(
        service.categorize(
          '2303 5694 01 75741',
          -5344.00,
          DateTime(2025, 4, 1),
        ),
        (Category.health, Subcategory.doctor),
      );
    });
  });

  group('CategorizationService - New Rules 2026-01-28', () {
    test('Keyword Rules', () {
      // Food / Coffee
      expect(service.categorize('LOOMISP*LATERIAN GOTEB', -50, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('LOS CHURROS WAFELS', -50, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('BAR CENTRO', -50, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('LOOMISP*CAFE KVARNPIRE', -50, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // Shopping / Other
      expect(service.categorize('MAJBLOMMANS RIKSFÖR', -100, dummyDate), (
        Category.shopping,
        Subcategory.other,
      ));

      // Food / Restaurant
      expect(service.categorize('DUBBEL DUBBEL SURBRUNN', -300, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('RESTORIA AB - DINNER', -400, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // Income / KitchenRenovation
      expect(
        service.categorize(
          'Swish inbetalning LINN RHEGALLÈ',
          1000,
          dummyDate,
        ),
        (Category.income, Subcategory.kitchenRenovation),
      );

      // Shopping / Clothes
      expect(service.categorize('ADOORE', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('UNIQLO GOTHENBURG', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // Housing / KitchenRenovation
      expect(service.categorize('KLARNA*VITVARUEXPERT', -2000, dummyDate), (
        Category.housing,
        Subcategory.kitchenRenovation,
      ));
    });

    test('Specific Overrides', () {
      // 1. Other / Other: Kortköp 250425 4051 WHS LS GOT
      expect(
        service.categorize(
          'Kortköp 250425 4051 WHS LS GOT',
          -45.00,
          DateTime(2025, 4, 28),
        ),
        (Category.other, Subcategory.other),
      );

      // 2. Food / Lunch: Q*HTTPS://WWW.DAMMS
      expect(
        service.categorize(
          'Q*HTTPS://WWW.DAMMS',
          -148.0, // Amount not strictly checked but usually negative for expenses
          DateTime(2025, 4, 27),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 3. Other / Other: Swish betalning KARTAL,MIA
      expect(
        service.categorize(
          'Swish betalning KARTAL,MIA',
          -180.00,
          DateTime(2025, 4, 21),
        ),
        (Category.other, Subcategory.other),
      );

      // 4. Other / Other: Swish betalning RAGNAR, MIRANDA
      expect(
        service.categorize(
          'Swish betalning RAGNAR, MIRANDA',
          -300.00,
          DateTime(2025, 4, 19),
        ),
        (Category.other, Subcategory.other),
      );

      // 5. Housing / KitchenRenovation: BJELIN SWEDEN AB
      // Amount not strictly checked in logic
      expect(
        service.categorize(
          'BJELIN SWEDEN AB',
          -15124.1,
          DateTime(2025, 4, 18),
        ),
        (Category.housing, Subcategory.kitchenRenovation),
      );

      // 6. Food / Lunch: Swish betalning NATALIE THORSSON RO
      expect(
        service.categorize(
          'Swish betalning NATALIE THORSSON RO',
          -150.00,
          DateTime(2025, 4, 8),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 7. Shopping / Other: Autogiro K*partykunge
      expect(
        service.categorize(
          'Autogiro K*partykunge',
          -368.70,
          DateTime(2025, 4, 8),
        ),
        (Category.shopping, Subcategory.other),
      );

      // 8. Food / Lunch: ZETTLE_*BLIGHTY FOOD C
      expect(
        service.categorize(
          'ZETTLE_*BLIGHTY FOOD C',
          -124.0,
          DateTime(2025, 4, 5),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 9. Other / Other: UNHCR
      expect(service.categorize('UNHCR', -10.0, DateTime(2025, 4, 5)), (
        Category.other,
        Subcategory.other,
      ));

      // 10. Entertainment / VideoGames: ELGIGANTEN.SE
      expect(service.categorize('ELGIGANTEN.SE', -7490.0, DateTime(2025, 4, 5)), (
        Category.entertainment,
        Subcategory.videoGames,
      ));

      // 11. Entertainment / Travel: Swish betalning RICKARD LINDBLAD VO
      expect(
        service.categorize(
          'Swish betalning RICKARD LINDBLAD VO',
          -3750.00,
          DateTime(2025, 4, 3),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 12. Entertainment / Other: Swish betalning Cecilia Kihlén
      expect(
        service.categorize(
          'Swish betalning Cecilia Kihlén',
          -3390.00,
          DateTime(2025, 4, 3),
        ),
        (Category.entertainment, Subcategory.other),
      );
    });
  });

  group('CategorizationService - New Rules 2026-02-01', () {
    test('Keyword Rules', () {
      // Entertainment / Travel
      expect(service.categorize('KLUB PARLAMENT XI', -100, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('SJ APP', -100, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('VR SNABBTÅG SVERIGE', -100, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));

      // Food / Groceries
      expect(service.categorize('NETTO', -100, dummyDate), (
        Category.food,
        Subcategory.groceries,
      ));

      // Food / Takeaway
      expect(service.categorize('FOODORA AB', -100, dummyDate), (
        Category.food,
        Subcategory.takeaway,
      ));

      // Food / Restaurant
      expect(service.categorize('MCD LANDVETTER', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('PUTA MADRE/BASQUE', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // Fees / CSN
      expect(
          service.categorize(
              'Betalning BG 5591-9021 Centrala Stu', -100, dummyDate),
          (
            Category.fees,
            Subcategory.csn,
          ));

      // Housing / Electricity
      expect(
          service.categorize(
              'Betalning BG 5835-1552 GÖTEBORG ENE', -100, dummyDate),
          (
            Category.housing,
            Subcategory.electricity,
          ));

      // Other / Other
      expect(service.categorize('LASTPASS.COM', -100, dummyDate), (
        Category.other,
        Subcategory.other,
      ));
    });

    test('Specific Overrides 2026-02-01', () {
      // 1. Food / Lunch: GREEN EGG SP. Z O.O.
      expect(
        service.categorize(
          'GREEN EGG SP. Z O.O.',
          -178.95,
          DateTime(2025, 3, 30),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 2. Entertainment / Travel: LAGARDERE DUTY FREE G
      expect(
        service.categorize(
          'LAGARDERE DUTY FREE G',
          -26.71,
          DateTime(2025, 3, 30),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 3. Entertainment / Travel: MUZEUM BISTRO
      expect(
        service.categorize(
          'MUZEUM BISTRO',
          -17.36,
          DateTime(2025, 3, 30),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 4. Other / Other: APTEKA AKSAMITNA
      expect(
        service.categorize(
          'APTEKA AKSAMITNA',
          -101.2,
          DateTime(2025, 3, 29),
        ),
        (Category.other, Subcategory.other),
      );

      // 5. Entertainment / Travel: SEXY SMASH
      expect(
        service.categorize(
          'SEXY SMASH',
          -251.06,
          DateTime(2025, 3, 29),
        ),
        (Category.entertainment, Subcategory.travel),
      );

      // 6. Food / Groceries: Swish betalning S R Larsson Charkut
      expect(
        service.categorize(
          'Swish betalning S R Larsson Charkut',
          -89.00,
          DateTime(2025, 3, 28),
        ),
        (Category.food, Subcategory.groceries),
      );

      // 7. Food / Lunch: PRIME GRILL GOETEBORG
      expect(
        service.categorize(
          'PRIME GRILL GOETEBORG',
          -62.0,
          DateTime(2025, 3, 27),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 8. Food / Lunch: Swish betalning GABRIELLA FOSSUM
      expect(
        service.categorize(
          'Swish betalning GABRIELLA FOSSUM',
          -100.00,
          DateTime(2025, 3, 27),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 9. Other / Other: WBDSPORTS
      expect(
        service.categorize(
          'WBDSPORTS',
          -260.0,
          DateTime(2025, 3, 22),
        ),
        (Category.other, Subcategory.other),
      );

      // 10. Shopping / Gifts: BODEGA PARTY (1)
      expect(
        service.categorize(
          'BODEGA PARTY',
          -517.0,
          DateTime(2025, 3, 21),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // 11. Shopping / Gifts: BODEGA PARTY (2)
      expect(
        service.categorize(
          'BODEGA PARTY',
          -326.0,
          DateTime(2025, 3, 17),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // 12. Food / Coffee: PINCHOS HEDEN
      expect(
        service.categorize(
          'PINCHOS HEDEN',
          -75.0,
          DateTime(2025, 3, 14),
        ),
        (Category.food, Subcategory.coffee),
      );

      // 13. Other / Other: HEMMAKVÄLL HALM
      expect(
        service.categorize(
          'HEMMAKVÄLL HALM',
          -23.9,
          DateTime(2025, 3, 8),
        ),
        (Category.other, Subcategory.other),
      );

      // 14. Food / Lunch: Swish betalning Jonna Karlstedt
      expect(
        service.categorize(
          'Swish betalning Jonna Karlstedt',
          -150.00,
          DateTime(2025, 3, 5),
        ),
        (Category.food, Subcategory.lunch),
      );
    });
  });
}
