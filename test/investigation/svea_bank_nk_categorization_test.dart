import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SVEA BANK AB should NOT be categorized as Shopping/Clothes', () {
    final service = CategorizationService();
    const description = '3016 05 24377;;;Kortköp 250625 SVEA BANK AB';
    const amount = -1940.00;
    final date = DateTime(2025, 06, 26);

    final (category, subcategory) = service.categorize(
      description,
      amount,
      date,
    );

    expect(category, Category.housing);
    expect(subcategory, Subcategory.kitchenRenovation);
  });

  test('NK STOCKHOLM should BE categorized as Shopping/Clothes', () {
    final service = CategorizationService();
    // legitimate transaction
    const description = 'Kortköp 251221 NK STOCKHOLM';
    const amount = -500.00;
    final date = DateTime(2025, 12, 22);

    final (category, subcategory) = service.categorize(
      description,
      amount,
      date,
    );

    expect(category, Category.shopping);
    expect(subcategory, Subcategory.clothes);
  });
}
