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

  group('CategorizationService - Transport', () {
    test('Car', () {
      expectCategory(
        service,
        'FORDONSSK',
        -500,
        dummyDate,
        Category.transport,
        Subcategory.car,
      );
      expectCategory(
        service,
        'BILIA',
        -500,
        dummyDate,
        Category.transport,
        Subcategory.car,
      );
    });

    test('Public Transport', () {
      expectCategory(
        service,
        'Västtrafik',
        -35,
        dummyDate,
        Category.transport,
        Subcategory.publicTransport,
      );
      expectCategory(
        service,
        'Vasttrafik',
        -35,
        dummyDate,
        Category.transport,
        Subcategory.publicTransport,
      );
      expectCategory(
        service,
        'HALLANDSTRAFIKE',
        -35,
        dummyDate,
        Category.entertainment,
        Subcategory.travel,
      );
    });

    test('Taxi', () {
      expectCategory(
        service,
        'Uber Trip',
        -120,
        dummyDate,
        Category.transport,
        Subcategory.taxi,
      );
    });

    test('Fuel', () {
      expectCategory(
        service,
        'Circle K',
        -600,
        dummyDate,
        Category.transport,
        Subcategory.fuel,
      );
    });

    test('Congestion Tax', () {
      expectCategory(
        service,
        'TRÄNGSELSKATT',
        -150,
        dummyDate,
        Category.transport,
        Subcategory.congestionTax,
      );
      expectCategory(
        service,
        'Open Banking BG 282-4647 TRÄNGSELSK',
        -41,
        dummyDate,
        Category.transport,
        Subcategory.congestionTax,
      );
      expectCategory(
        service,
        'EPASS24',
        -150,
        dummyDate,
        Category.transport,
        Subcategory.congestionTax,
      );
    });
    test('New Rules (March 2026)', () {
      // General
      expectCategory(
        service,
        'Betalning BG 5488-2303 Gbg Stad/Int',
        -50,
        dummyDate,
        Category.transport,
        Subcategory.parking,
      );
      expectCategory(
        service,
        'Betalning BG 317-2434 Ziklo Bank AB',
        -200,
        dummyDate,
        Category.transport,
        Subcategory.car,
      );
      
      // Overrides
      expectCategory(
        service,
        'PARKADEN',
        -20.0,
        DateTime(2026, 3, 8),
        Category.transport,
        Subcategory.parking,
      );
    });
    test('New Rules 2026-04-03 (Request)', () {
      expectCategory(
        service,
        'MJUK BILTVATT',
        -200.0,
        dummyDate,
        Category.transport,
        Subcategory.car,
      );
    });
    test('New Rules 2026-04-14 (Request)', () {
      expectCategory(
        service,
        '5488-2303 Gbg Stad',
        -50.0,
        dummyDate,
        Category.transport,
        Subcategory.parking,
      );
    });
  });
}
