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

  group('CategorizationService - Food', () {
    test('General Food/Groceries', () {
      expectCategory(
        service,
        'ICA Maxi',
        -100,
        dummyDate,
        Category.food,
        Subcategory.groceries,
      );
      expectCategory(
        service,
        'Willys',
        -200,
        dummyDate,
        Category.food,
        Subcategory.groceries,
      );
      expectCategory(
        service,
        'Capris',
        -100,
        dummyDate,
        Category.food,
        Subcategory.groceries,
      );
      expectCategory(
        service,
        'NETTO',
        -100,
        dummyDate,
        Category.food,
        Subcategory.groceries,
      );

      // Specific Overrides for Groceries
      expectCategory(
        service,
        'Swish betalning S R Larsson Charkut',
        -89.00,
        DateTime(2025, 3, 28),
        Category.food,
        Subcategory.groceries,
      );
    });

    test('Coffee', () {
      expectCategory(
        service,
        'Espresso House',
        -89,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'Steinbrenner & Nyberg',
        -150,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'BROGYLLEN',
        -89,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );

      // New Rules 2026-01-28
      expectCategory(
        service,
        'LOOMISP*LATERIAN GOTEB',
        -50,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'LOS CHURROS WAFELS',
        -50,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'BAR CENTRO',
        -50,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'LOOMISP*CAFE KVARNPIRE',
        -50,
        dummyDate,
        Category.food,
        Subcategory.coffee,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'PINCHOS HEDEN',
        -75.0,
        DateTime(2025, 3, 14),
        Category.food,
        Subcategory.coffee,
      );

      // Specific Overrides for Coffee
      expectCategory(
        service,
        'Swish betalning LUNDBERG, CHARLOTTA',
        -155.00,
        DateTime(2026, 1, 3),
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'ZETTLE_*VR SNABBTAG SV',
        -50.0,
        DateTime(2025, 10, 3),
        Category.food,
        Subcategory.coffee,
      );
      expectCategory(
        service,
        'ZETTLE_*VR SNABBTAG SV',
        50.0,
        DateTime(2025, 10, 3),
        Category.food,
        Subcategory.coffee,
      );
    });

    test('Lunch', () {
      expectCategory(
        service,
        'JoeAndTheJuice',
        -85,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'MASAKI HALSOSUSHI AB',
        -150,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'VELIC,AJLA',
        -100,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'DELI AND COFFEE',
        -85,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Swish inbetalning SEHLIN,MARIANNE',
        -120,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'GOTEBORG CITY MAT &',
        -130.0,
        DateTime(2025, 11, 15),
        Category.food,
        Subcategory.lunch,
      );

      // New Rules 2026-01-20
      expectCategory(
        service,
        'Köp SALUHALLEN WRAPSODY',
        -115,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'MR SHOU',
        -145,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'BUN GBG',
        -130,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'JINX DYNASTY',
        -100,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'HASSELSSONS MACKLUCKA',
        -100,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'HASSELBACKEN',
        -100,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'PASTOR - STORA SALUHAL',
        -125,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );

      // New Rules 2026-02-02
      expectCategory(
        service,
        'MU THAI STREET FOOD',
        -125,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );

      // Specific Overrides for Lunch
      expectCategory(
        service,
        'Swish betalning BÄCK, NATALIE',
        -140.00,
        DateTime(2025, 8, 19),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Q*HTTPS://WWW.DAMMS',
        -148.0,
        DateTime(2025, 4, 27),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Swish betalning NATALIE THORSSON RO',
        -150.00,
        DateTime(2025, 4, 8),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'ZETTLE_*BLIGHTY FOOD C',
        -124.0,
        DateTime(2025, 4, 5),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'GREEN EGG SP. Z O.O.',
        -178.95,
        DateTime(2025, 3, 30),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'PRIME GRILL GOETEBORG',
        -62.0,
        DateTime(2025, 3, 27),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Swish betalning GABRIELLA FOSSUM',
        -100.00,
        DateTime(2025, 3, 27),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Swish betalning Jonna Karlstedt',
        -150.00,
        DateTime(2025, 3, 5),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'Swish betalning IDA BRUSBÄCK',
        -145.00,
        DateTime(2025, 2, 11),
        Category.food,
        Subcategory.lunch,
      );
    });

    test('Restaurant', () {
      expectCategory(
        service,
        'Restaurant',
        -500,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // New Rules 2026-02-02
      expectCategory(
        service,
        'MOONGLOW',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'JEPPES FAMILJEKROG AB',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning HAPPY ORDER AB',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'THE HILLS STOCK',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'MA CUISINE',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'CASPECO',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'MADE IN CHINA',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'FISKEKROGEN',
        -1500,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // Swish Overrides
      expectCategory(
        service,
        'Swish betalning PETTER NILSSON',
        -885.72,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning PETTER NILSSON',
        885.72,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning PETTER NILSSON',
        -2550.00,
        DateTime(2025, 11, 22),
        Category.food,
        Subcategory.restaurant,
      );

      // Other Overrides
      expectCategory(
        service,
        'Swish betalning LUCAS MALINA',
        -2716.00,
        DateTime(2025, 11, 30),
        Category.food,
        Subcategory.restaurant,
      );

      // Keywords
      expectCategory(
        service,
        'MCDVARBERGNORD',
        -150,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // New Rules 2026-01-28
      expectCategory(
        service,
        'DUBBEL DUBBEL SURBRUNN',
        -300,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'RESTORIA AB - DINNER',
        -400,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'OLIVIA GOTEBORG',
        -100,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'MCD LANDVETTER',
        -100,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'PUTA MADRE/BASQUE',
        -100,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // Specific Overrides for Restaurant
      expectCategory(
        service,
        'Swish betalning DANIEL LENNARTSSON',
        -400.00,
        DateTime(2025, 8, 23),
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning LINDSTRÖM,VENDELA',
        -689.50,
        DateTime(2025, 7, 31),
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'STORSTUGAN;FJARAS',
        430.0,
        DateTime(2025, 5, 1),
        Category.food,
        Subcategory.restaurant,
      );
    });

    test('Takeaway', () {
      expectCategory(
        service,
        'FOODORA AB',
        -592,
        dummyDate,
        Category.food,
        Subcategory.takeaway,
      );
      expectCategory(
        service,
        'FOODORA AB',
        -100,
        dummyDate,
        Category.food,
        Subcategory.takeaway,
      );
      expectCategory(
        service,
        'THAICORNERILINDOMEAB',
        -615,
        dummyDate,
        Category.food,
        Subcategory.takeaway,
      );
      expectCategory(
        service,
        'THAICORNERILINDOMEAB',
        615,
        dummyDate,
        Category.food,
        Subcategory.takeaway,
      );
      expectCategory(
        service,
        'SULTAN DONER',
        -280.0,
        DateTime(2025, 11, 16),
        Category.food,
        Subcategory.takeaway,
      );
    });

    test('Bar & Club', () {
      expectCategory(
        service,
        'THE MELODY CLUB',
        -200,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'PARK LANE RESTA',
        -200,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // Specific Overrides for Bar
      expectCategory(
        service,
        'EVION HOTELL &',
        -96.0,
        DateTime(2025, 11, 15),
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'EVION HOTELL &',
        -42.0,
        DateTime(2025, 11, 15),
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'SWAY',
        -150,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );

      // New Rules 2026-02-02
      expectCategory(
        service,
        'KOPPS',
        -150,
        dummyDate,
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning ANDERS GUSTAFSSON',
        -85.00,
        DateTime(2025, 2, 4),
        Category.food,
        Subcategory.restaurant,
      );
      expectCategory(
        service,
        'Swish betalning VIKTORIA THOLANDER',
        -90.00,
        DateTime(2025, 2, 3),
        Category.food,
        Subcategory.restaurant,
      );
    });
    test('New Rules 2026-02-02 (Request)', () {
      expectCategory(
        service,
        'Swish betalning KARLSSON ANDERSSON',
        -100,
        dummyDate,
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'ARKET SE0702',
        -149.0, // Check negative
        DateTime(2026, 1, 16),
        Category.food,
        Subcategory.lunch,
      );
      expectCategory(
        service,
        'ARKET SE0702',
        -149.0,
        DateTime(2026, 1, 14),
        Category.food,
        Subcategory.lunch,
      );
    });
  });
}
