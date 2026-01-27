
import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SVEA BANK AB should NOT be categorized as Shopping/Clothes', () {
    final service = CategorizationService();
    final description = '3016 05 24377;;;Kortköp 250625 SVEA BANK AB';
    final amount = -1940.00;
    final date = DateTime(2025, 06, 26);

    final (category, subcategory) = service.categorize(description, amount, date);

    print('Category: $category, Subcategory: $subcategory');

    expect(category, Category.other);
    expect(subcategory, Subcategory.unknown);
  });

  test('NK STOCKHOLM should BE categorized as Shopping/Clothes', () {
    final service = CategorizationService();
    // legitimate transaction
    final description = 'Kortköp 251221 NK STOCKHOLM'; 
    final amount = -500.00;
    final date = DateTime(2025, 12, 22);

    final (category, subcategory) = service.categorize(description, amount, date);

    expect(category, Category.shopping);
    expect(subcategory, Subcategory.clothes);
  });
}
