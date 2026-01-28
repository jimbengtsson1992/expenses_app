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
}
