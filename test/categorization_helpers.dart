import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void expectCategory(
  CategorizationService service,
  String description,
  double amount,
  DateTime date,
  Category expectedCategory,
  Subcategory expectedSubcategory,
) {
  expect(service.categorize(description, amount, date), (
    expectedCategory,
    expectedSubcategory,
  ), reason: 'Failed for: $description');
}
