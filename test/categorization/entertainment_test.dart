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

  group('CategorizationService - Entertainment', () {
    test('Streaming', () {
      expectCategory(
        service,
        'Netflix',
        -129,
        dummyDate,
        Category.entertainment,
        Subcategory.streaming,
      );
      expectCategory(
        service,
        'Amazon Prime',
        -59,
        dummyDate,
        Category.entertainment,
        Subcategory.streaming,
      );
      expectCategory(
        service,
        'HBOMAX HELP.HBOMAX.COM',
        -74.5,
        dummyDate,
        Category.entertainment,
        Subcategory.streaming,
      );

      // Override 2026-01-26
      expectCategory(
        service,
        'BONNIER NEWS',
        -9.0,
        DateTime(2026, 1, 24),
        Category.entertainment,
        Subcategory.streaming,
      );
    });

    test('Newspapers', () {
      expectCategory(
        service,
        'DN Prenumeration',
        -100,
        dummyDate,
        Category.entertainment,
        Subcategory.newspapers,
      );
    });

    test('Snuff', () {
      expectCategory(
        service,
        'Snusbolaget',
        -500,
        dummyDate,
        Category.entertainment,
        Subcategory.snuff,
      );
    });

    test('Video Games', () {
      expectCategory(
        service,
        'Nintendo eShop',
        -500,
        dummyDate,
        Category.entertainment,
        Subcategory.videoGames,
      );
      expectCategory(
        service,
        'ELGIGANTEN.SE',
        -7490.0,
        DateTime(2025, 4, 5),
        Category.entertainment,
        Subcategory.videoGames,
      );
    });

    test('Bar', () {
      expectCategory(
        service,
        'THE MELODY CLUB',
        -200,
        dummyDate,
        Category.entertainment,
        Subcategory.bar,
      );
      expectCategory(
        service,
        'PARK LANE RESTA',
        -200,
        dummyDate,
        Category.entertainment,
        Subcategory.bar,
      );

      // Specific Overrides for Bar
      expectCategory(
        service,
        'EVION HOTELL &',
        -96.0,
        DateTime(2025, 11, 15),
        Category.entertainment,
        Subcategory.bar,
      );
      expectCategory(
        service,
        'EVION HOTELL &',
        -42.0,
        DateTime(2025, 11, 15),
        Category.entertainment,
        Subcategory.bar,
      );
      expectCategory(
        service,
        'SWAY',
        -150,
        dummyDate,
        Category.entertainment,
        Subcategory.bar,
      );
    });

    test('Travel', () {
      expectCategory(
        service,
        'SJ Resor',
        -400,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'TORPA',
        -100,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'KLUB PARLAMENT XI',
        -100,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'SJ APP',
        -100,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'VR SNABBTÅG SVERIGE',
        -100,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );

      // Specific Overrides for Travel
      expectCategory(
        service,
        'GOTO HUB AB;HELSINGBORG',
        1170.0,
        DateTime(2025, 7, 17),
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'ZETTLE_*TVELINGEN AB;GOTEBORG',
        165.0,
        DateTime(2025, 7, 12),
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'Swish betalning RICKARD LINDBLAD VO',
        -3750.00,
        DateTime(2025, 4, 3),
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'LAGARDERE DUTY FREE G',
        -26.71,
        DateTime(2025, 3, 30),
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'MUZEUM BISTRO',
        -17.36,
        DateTime(2025, 3, 30),
        Category.entertainment,
        Subcategory.travel,
      );
      expectCategory(
        service,
        'SEXY SMASH',
        -251.06,
        DateTime(2025, 3, 29),
        Category.entertainment,
        Subcategory.travel,
      );
    });

    test('Hobby', () {
      expectCategory(
        service,
        'Panduro',
        -150,
        dummyDate,
        Category.entertainment,
        Subcategory.hobby,
      );
      expectCategory(
        service,
        'Betalning K*ratsit.se',
        -59,
        dummyDate,
        Category.entertainment,
        Subcategory.hobby,
      );
    });

    test('Board Games, Books, and Toys', () {
      expectCategory(
        service,
        'Akademibokhandeln',
        -199,
        dummyDate,
        Category.entertainment,
        Subcategory.boardGamesBooksAndToys,
      );
    });

    test('Other (Entertainment)', () {
      expectCategory(
        service,
        'SF Bio',
        -250,
        dummyDate,
        Category.entertainment,
        Subcategory.other,
      );

      // Specific Overrides for Other
      expectCategory(
        service,
        'Swish betalning Cecilia Kihlén',
        -3390.00,
        DateTime(2025, 4, 3),
        Category.entertainment,
        Subcategory.other,
      );
    });
  });
}
