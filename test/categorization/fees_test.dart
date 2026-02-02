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

  group('CategorizationService - Fees', () {
    test('Bank Fees', () {
      expectCategory(
        service,
        'Nordea Vardagspaket',
        -20,
        dummyDate,
        Category.fees,
        Subcategory.bankFees,
      );
    });

    test('Tax', () {
      expectCategory(
        service,
        'Skatteverket',
        -10000,
        dummyDate,
        Category.fees,
        Subcategory.tax,
      );
    });

    test('CSN', () {
      expectCategory(
        service,
        'CSN',
        -1400,
        dummyDate,
        Category.fees,
        Subcategory.csn,
      );

      // New Rules 2026-02-01
      expectCategory(
        service,
        'Betalning BG 5591-9021 Centrala Stu',
        -100,
        dummyDate,
        Category.fees,
        Subcategory.csn,
      );
    });

    test('Jim Holding', () {
      expectCategory(
        service,
        'Kortköp 251117 BOLAGSVERKET',
        -3435.72,
        dummyDate,
        Category.fees,
        Subcategory.jimHolding,
      );

      // Specific Overrides for Jim Holding
      expectCategory(
        service,
        'Aktiekapital 1110 31 04004',
        -25000.00,
        DateTime(2025, 11, 16),
        Category.fees,
        Subcategory.jimHolding,
      );
    });
  });
}
