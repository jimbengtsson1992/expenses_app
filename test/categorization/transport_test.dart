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
  });
}
