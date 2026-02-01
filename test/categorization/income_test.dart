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

  group('CategorizationService - Income', () {
    test('Salary', () {
      expectCategory(service, 'Lön Jim', 40000, dummyDate, Category.income, Subcategory.salary);
      expectCategory(service, 'Salary Jan', 35000, dummyDate, Category.income, Subcategory.salary);
    });

    test('Loan', () {
      // New Rules 2026-01-20
      expectCategory(service, 'Insättning', 400000.00, DateTime(2025, 2, 3), Category.income, Subcategory.loan);
    });

    test('Kitchen Renovation (Income)', () {
      // New Rules 2026-01-28
      expectCategory(service, 'Swish inbetalning LINN RHEGALLÈ', 1000, dummyDate, Category.income, Subcategory.kitchenRenovation);
    });

    test('Other (Income)', () {
      expectCategory(service, 'Swish Insättning', 500, dummyDate, Category.income, Subcategory.other);
      expectCategory(service, 'Återbetalning', 1200, dummyDate, Category.income, Subcategory.other);
    });
  });
}
