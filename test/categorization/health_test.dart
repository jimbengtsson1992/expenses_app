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
      expectCategory(service, 'Sanna andrén', -500, dummyDate, Category.health, Subcategory.beauty);
      expectCategory(service, 'STYLE BARBERSHOP', -450, dummyDate, Category.health, Subcategory.beauty);
      
      // Specific Overrides for Beauty
      expectCategory(service, 'Swish betalning DUMAN MELIS', -1170.00, DateTime(2025, 5, 29), Category.health, Subcategory.beauty);
    });

    test('Gym', () {
      expectCategory(service, 'SATS', -450, dummyDate, Category.health, Subcategory.gym);
    });

    test('Pharmacy', () {
      expectCategory(service, 'Apoteket AB', -120, dummyDate, Category.health, Subcategory.pharmacy);
    });

    test('Doctor', () {
      expectCategory(service, 'Vårdcentralen', -200, dummyDate, Category.health, Subcategory.doctor);
      expectCategory(service, 'IDROTTSREHAB', -200, dummyDate, Category.health, Subcategory.doctor);
      expectCategory(service, 'BABYSCREEN GBG', -1200, dummyDate, Category.health, Subcategory.doctor);

      // Specific Overrides for Doctor
      expectCategory(service, 'Open Banking BG 5734-9797 Patientfa', -100.00, DateTime(2025, 12, 22), Category.health, Subcategory.doctor);
      expectCategory(service, '2352 5694 01 75741', -3100.00, DateTime(2025, 10, 21), Category.health, Subcategory.doctor);
      expectCategory(service, '2326 5694 01 75741', -3500.00, DateTime(2025, 7, 8), Category.health, Subcategory.doctor);
      expectCategory(service, '2303 5694 01 75741', -5344.00, DateTime(2025, 4, 1), Category.health, Subcategory.doctor);
    });

    test('Supplements', () {
      expectCategory(service, 'MMSports', -500, dummyDate, Category.health, Subcategory.supplements);
    });
  });
}
