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
      expect(service.categorize('Espresso House', -89), (Category.food, Subcategory.coffee));
      expect(service.categorize('Capris', -100), (Category.food, Subcategory.groceries));
      expect(service.categorize('MMSports', -500), (Category.food, Subcategory.supplements));
      expect(service.categorize('JoeAndTheJuice', -85), (Category.food, Subcategory.lunch));
    });

    test('categorizes Shopping accurately', () {
      expect(service.categorize('NK Göteborg', -500), (Category.shopping, Subcategory.clothes));
      expect(service.categorize('H&M', -300), (Category.shopping, Subcategory.clothes));
      expect(service.categorize('Boss GBG', -1300), (Category.shopping, Subcategory.clothes));
      expect(service.categorize('Elgiganten', -1000), (Category.shopping, Subcategory.electronics));
      expect(service.categorize('NK BEAUTY', -350), (Category.shopping, Subcategory.beauty));
      expect(service.categorize('Vacker NK', -300), (Category.shopping, Subcategory.beauty));
      expect(service.categorize('Arket', -450), (Category.shopping, Subcategory.decor));
    });

    test('categorizes Transport accurately', () {
      expect(service.categorize('Västtrafik', -35), (Category.transport, Subcategory.publicTransport));
      expect(service.categorize('Vasttrafik', -35), (Category.transport, Subcategory.publicTransport));
      expect(service.categorize('Uber Trip', -120), (Category.transport, Subcategory.taxi));
      expect(service.categorize('Circle K', -600), (Category.transport, Subcategory.fuel));
    });

    test('categorizes income transactions correctly', () {
      // Salary check
      expect(service.categorize('Lön Jim', 40000), (Category.income, Subcategory.salary));
      expect(service.categorize('Salary Jan', 35000), (Category.income, Subcategory.salary));

      // Other Income check
      expect(service.categorize('Swish Insättning', 500), (Category.income, Subcategory.other));
      expect(service.categorize('Återbetalning', 1200), (Category.income, Subcategory.other));
    });

    test('categorizes Bills/Housing/Subscriptions correctly', () {
      // Nordea Lån -> Housing/Mortgage
      expect(service.categorize('Nordea Lån', -2000), (Category.housing, Subcategory.mortgage));
      
      
      // CSN -> Fees/CSN
      expect(service.categorize('CSN', -1400), (Category.fees, Subcategory.csn));
      
      // Netflix -> Entertainment/Streaming
      expect(service.categorize('Netflix', -129), (Category.entertainment, Subcategory.streaming)); 
      expect(service.categorize('Amazon Prime', -59), (Category.entertainment, Subcategory.streaming)); 
      
      // Tele2 -> Housing/Broadband (Logic changed to favor broadband for generic 'Tele2')
      expect(service.categorize('Tele2', -299), (Category.housing, Subcategory.broadband));

      // Trygg-Hansa -> Other/PersonalInsurance
      expect(service.categorize('Trygg-Hansa', -500), (Category.other, Subcategory.personalInsurance));

      // DN -> Entertainment/Newspapers
      expect(service.categorize('DN Prenumeration', -100), (Category.entertainment, Subcategory.newspapers));
    });

    test('fallback to Other', () {
      expect(service.categorize('Unknown Blob', -50), (Category.other, Subcategory.unknown));
    });
    test('categorizes Entertainment correctly', () {
      expect(service.categorize('Snusbolaget', -500), (Category.entertainment, Subcategory.snuff));
      expect(service.categorize('Nintendo eShop', -500), (Category.entertainment, Subcategory.videoGames));
    });


    test('categorizes Food accurately', () {
        // ... existing tests
        expect(service.categorize('Steinbrenner & Nyberg', -150), (Category.food, Subcategory.coffee));
        expect(service.categorize('THE MELODY CLUB', -200), (Category.food, Subcategory.bar));
        // Regression test for Foodora
        expect(service.categorize('FOODORA AB', -592), (Category.food, Subcategory.takeaway));

        // Regression test for HBOMAX (containing 'max ')
        expect(service.categorize('HBOMAX HELP.HBOMAX.COM', -74.5), (Category.entertainment, Subcategory.streaming)); 
    });

    test('Specific Overrides', () {
      expect(service.categorize('ELLOS AB', -3148.1), (Category.shopping, Subcategory.furniture));
    });
  });


}
