import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CategorizationService service;

  setUp(() {
    service = CategorizationService();
  });

  group('CategorizationService', () {
    test('categorizes Food accurately', () {
      expect(service.categorize('ICA Maxi', -100), (Category.food, Subcategory.groceries));
      expect(service.categorize('Willys', -200), (Category.food, Subcategory.groceries));
      expect(service.categorize('Restaurang Pizzeria', -150), (Category.food, Subcategory.restaurant));
    });

    test('categorizes Shopping accurately', () {
      expect(service.categorize('NK Göteborg', -500), (Category.shopping, Subcategory.clothes));
      expect(service.categorize('H&M', -300), (Category.shopping, Subcategory.clothes));
      expect(service.categorize('Elgiganten', -1000), (Category.shopping, Subcategory.electronics));
    });

    test('categorizes Transport accurately', () {
      expect(service.categorize('Västtrafik', -35), (Category.transport, Subcategory.publicTransport));
      expect(service.categorize('Uber Trip', -120), (Category.transport, Subcategory.taxi));
      expect(service.categorize('Circle K', -600), (Category.transport, Subcategory.fuel));
    });

    test('categorizes income transactions correctly', () {
      // Salary check
      expect(service.categorize('Lön Jim', 40000), (Category.income, Subcategory.salary));
      expect(service.categorize('Salary Jan', 35000), (Category.income, Subcategory.salary));

      // Other Income check
      expect(service.categorize('Swish Insättning', 500), (Category.income, Subcategory.otherIncome));
      expect(service.categorize('Återbetalning', 1200), (Category.income, Subcategory.otherIncome));
    });

    test('categorizes Bills correctly', () {
      // Logic for bills might differ, check service:
      // Nordea Lån -> unknown? checking service..
      // 'nordea' -> Category.bills, Subcategory.unknown
      expect(service.categorize('Nordea Lån', -2000), (Category.bills, Subcategory.unknown));
      expect(service.categorize('CSN', -1400), (Category.bills, Subcategory.unknown));
      expect(service.categorize('Netflix', -129), (Category.bills, Subcategory.streaming)); 
    });

    test('fallback to Other', () {
      expect(service.categorize('Unknown Blob', -50), (Category.other, Subcategory.unknown));
    });
  });
}
