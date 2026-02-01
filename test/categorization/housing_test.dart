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

  group('CategorizationService - Housing', () {
    test('Mortgage', () {
      expectCategory(service, 'Nordea Lån', -2000, dummyDate, Category.housing, Subcategory.mortgage);
    });

    test('Broadband', () {
      expectCategory(service, 'Tele2', -299, dummyDate, Category.housing, Subcategory.broadband);
    });

    test('Home Insurance', () {
      expectCategory(service, 'Autogiro If Skadeförs', -350, dummyDate, Category.housing, Subcategory.homeInsurance);
    });

    test('Security', () {
      expectCategory(service, 'Verisure', -499, dummyDate, Category.housing, Subcategory.security);
    });

    test('Cleaning', () {
      expectCategory(service, 'Renahus', -2500, dummyDate, Category.housing, Subcategory.cleaning);
      
      // Specific Overrides
      expectCategory(service, 'Swish betalning FORTNOX FINANS AB', -1605.00, DateTime(2025, 8, 15), Category.housing, Subcategory.cleaning);
    });

    test('Electricity', () {
      expectCategory(service, 'Göteborg Energi', -600, dummyDate, Category.housing, Subcategory.electricity);
      // New Rules 2026-02-01
      expectCategory(service, 'Betalning BG 5835-1552 GÖTEBORG ENE', -100, dummyDate, Category.housing, Subcategory.electricity);
    });

    test('BRF Fee', () {
      expectCategory(service, 'HSB', -4500, dummyDate, Category.housing, Subcategory.brfFee);
    });

    test('Kitchen Renovation', () {
      expectCategory(service, 'Factoringgrup', -5000, dummyDate, Category.housing, Subcategory.kitchenRenovation);
      
      // Explicitly check that it is part of the enum
      expect(Category.housing.subcategories, contains(Subcategory.kitchenRenovation));

      // New Rules 2026-01-28
      expectCategory(service, 'KLARNA*VITVARUEXPERT', -2000, dummyDate, Category.housing, Subcategory.kitchenRenovation);

      // Specific Overrides
      expectCategory(service, 'Kortköp 250625 SVEA BANK AB', -1000, dummyDate, Category.housing, Subcategory.kitchenRenovation);
      expectCategory(service, 'BJELIN SWEDEN AB', -15124.1, DateTime(2025, 4, 18), Category.housing, Subcategory.kitchenRenovation);

      // Investigation Test Case (SVEA BANK AB)
      expectCategory(service, '3016 05 24377;;;Kortköp 250625 SVEA BANK AB', -1940.00, DateTime(2025, 06, 26), Category.housing, Subcategory.kitchenRenovation);
    });
  });
}
