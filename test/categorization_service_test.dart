import 'package:expenses/src/features/expenses/application/categorization_service.dart';
import 'package:expenses/src/features/expenses/domain/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CategorizationService service;

  setUp(() {
    service = CategorizationService();
  });

  group('CategorizationService', () {
    test('categorizes Food accurately', () {
      expect(service.categorize('ICA Maxi', -100), Category.food);
      expect(service.categorize('Willys', -200), Category.food);
      expect(service.categorize('Restaurang Pizzeria', -150), Category.food);
    });

    test('categorizes Shopping accurately', () {
      expect(service.categorize('NK Göteborg', -500), Category.shopping);
      expect(service.categorize('H&M', -300), Category.shopping);
      expect(service.categorize('Elgiganten', -1000), Category.shopping);
    });

    test('categorizes Transport accurately', () {
      expect(service.categorize('Västtrafik', -35), Category.transport);
      expect(service.categorize('Uber Trip', -120), Category.transport);
      expect(service.categorize('Circle K', -600), Category.transport);
    });

    test('categorizes income transactions as other by default', () {
      // Income detection is now handled by TransactionType, not Category
      expect(service.categorize('Lön Jim', 40000), Category.other);
      expect(service.categorize('Swish Insättning', 500), Category.other);
    });

    test('categorizes Bills correctly', () {
      expect(service.categorize('Nordea Lån', -2000), Category.bills);
      expect(service.categorize('CSN', -1400), Category.bills);
      expect(service.categorize('Netflix', -129), Category.bills); // Added netflix to bills list in service
    });

    test('fallback to Other', () {
      expect(service.categorize('Unknown Blob', -50), Category.other);
    });
  });
}
