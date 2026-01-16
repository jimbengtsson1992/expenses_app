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
      expect(service.categorize('ICA Maxi', -100), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('Willys', -200), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('Restaurang Pizzeria', -150), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('Espresso House', -89), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('Capris', -100), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('MMSports', -500), (
        Category.food,
        Subcategory.supplements,
      ));
      expect(service.categorize('JoeAndTheJuice', -85), (
        Category.food,
        Subcategory.lunch,
      ));
    });

    test('categorizes Shopping accurately', () {
      expect(service.categorize('NK Göteborg', -500), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('H&M', -300), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('Boss GBG', -1300), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('Elgiganten', -1000), (
        Category.shopping,
        Subcategory.electronics,
      ));
      expect(service.categorize('NK BEAUTY', -350), (
        Category.shopping,
        Subcategory.beauty,
      ));
      expect(service.categorize('Vacker NK', -300), (
        Category.shopping,
        Subcategory.beauty,
      ));
      expect(service.categorize('Arket', -450), (
        Category.shopping,
        Subcategory.decor,
      ));
    });

    test('categorizes Transport accurately', () {
      expect(service.categorize('Västtrafik', -35), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      expect(service.categorize('Vasttrafik', -35), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      expect(service.categorize('Uber Trip', -120), (
        Category.transport,
        Subcategory.taxi,
      ));
      expect(service.categorize('Circle K', -600), (
        Category.transport,
        Subcategory.fuel,
      ));
    });

    test('categorizes income transactions correctly', () {
      // Salary check
      expect(service.categorize('Lön Jim', 40000), (
        Category.income,
        Subcategory.salary,
      ));
      expect(service.categorize('Salary Jan', 35000), (
        Category.income,
        Subcategory.salary,
      ));

      // Other Income check
      expect(service.categorize('Swish Insättning', 500), (
        Category.income,
        Subcategory.other,
      ));
      expect(service.categorize('Återbetalning', 1200), (
        Category.income,
        Subcategory.other,
      ));
    });

    test('categorizes Bills/Housing/Subscriptions correctly', () {
      // Nordea Lån -> Housing/Mortgage
      expect(service.categorize('Nordea Lån', -2000), (
        Category.housing,
        Subcategory.mortgage,
      ));

      // CSN -> Fees/CSN
      expect(service.categorize('CSN', -1400), (
        Category.fees,
        Subcategory.csn,
      ));

      // Netflix -> Entertainment/Streaming
      expect(service.categorize('Netflix', -129), (
        Category.entertainment,
        Subcategory.streaming,
      ));
      expect(service.categorize('Amazon Prime', -59), (
        Category.entertainment,
        Subcategory.streaming,
      ));

      // Tele2 -> Housing/Broadband (Logic changed to favor broadband for generic 'Tele2')
      expect(service.categorize('Tele2', -299), (
        Category.housing,
        Subcategory.broadband,
      ));

      // Trygg-Hansa -> Other/PersonalInsurance
      expect(service.categorize('Trygg-Hansa', -500), (
        Category.other,
        Subcategory.personalInsurance,
      ));

      // DN -> Entertainment/Newspapers
      expect(service.categorize('DN Prenumeration', -100), (
        Category.entertainment,
        Subcategory.newspapers,
      ));
    });

    test('fallback to Other', () {
      expect(service.categorize('Unknown Blob', -50), (
        Category.other,
        Subcategory.unknown,
      ));
    });
    test('categorizes Entertainment correctly', () {
      expect(service.categorize('Snusbolaget', -500), (
        Category.entertainment,
        Subcategory.snuff,
      ));
      expect(service.categorize('Nintendo eShop', -500), (
        Category.entertainment,
        Subcategory.videoGames,
      ));
    });

    test('categorizes Food accurately', () {
      // ... existing tests
      expect(service.categorize('Steinbrenner & Nyberg', -150), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('THE MELODY CLUB', -200), (
        Category.food,
        Subcategory.bar,
      ));
      // Regression test for Foodora
      expect(service.categorize('FOODORA AB', -592), (
        Category.food,
        Subcategory.takeaway,
      ));

      // New rule for Masaki
      expect(service.categorize('MASAKI HALSOSUSHI AB', -150), (
        Category.food,
        Subcategory.takeaway,
      ));

      // Regression test for HBOMAX (containing 'max ')
      expect(service.categorize('HBOMAX HELP.HBOMAX.COM', -74.5), (
        Category.entertainment,
        Subcategory.streaming,
      ));

      // Regression test for Bolagsverket
      expect(service.categorize('Kortköp 251117 BOLAGSVERKET', -3435.72), (
        Category.fees,
        Subcategory.other,
      ));
    });

    test('Specific Overrides', () {
      expect(service.categorize('ZETTLE_*SAD RETAIL GRO', -950), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('NK KOK & DESIGN GBG', -2090), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KIDS & TEENS GBG', -239), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KIDS & TEENS GBG', -70), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KOK & DESIGN GBG', -1299), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('KLARNA SMALANDSGRAN', -1315), (
        Category.shopping,
        Subcategory.other,
      ));
      expect(service.categorize('ELLOS AB', -3148.1), (
        Category.shopping,
        Subcategory.furniture,
      ));
      expect(service.categorize('NORDISKA GALLERIET GOT', 400), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('NORDISKA GALLERIET GOT', -400), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('THAICORNERILINDOMEAB', -615), (
        Category.food,
        Subcategory.takeaway,
      ));
      expect(service.categorize('THAICORNERILINDOMEAB', 615), (
        Category.food,
        Subcategory.takeaway,
      ));
      expect(service.categorize('Swish betalning PETTER NILSSON', -885.72), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('Swish betalning PETTER NILSSON', 885.72), (
        Category.food,
        Subcategory.restaurant,
      ));
    });

    test('categorizes Health accurately', () {
      expect(service.categorize('Sanna andrén', -500), (
        Category.health,
        Subcategory.beauty,
      ));
      expect(service.categorize('SATS', -450), (
        Category.health,
        Subcategory.gym,
      ));
      expect(service.categorize('Apoteket AB', -120), (
        Category.health,
        Subcategory.pharmacy,
      ));
      expect(service.categorize('Vårdcentralen', -200), (
        Category.health,
        Subcategory.doctor,
      ));
    });

    test('categorizes Housing accurately', () {
      expect(service.categorize('Autogiro If Skadeförs', -350), (
        Category.housing,
        Subcategory.homeInsurance,
      ));
      expect(service.categorize('Verisure', -499), (
        Category.housing,
        Subcategory.security,
      ));
      expect(service.categorize('Renahus', -2500), (
        Category.housing,
        Subcategory.cleaning,
      ));
      expect(service.categorize('Göteborg Energi', -600), (
        Category.housing,
        Subcategory.electricity,
      ));
      expect(service.categorize('HSB', -4500), (
        Category.housing,
        Subcategory.brfFee,
      ));
    });

    test('categorizes Fees accurately', () {
      expect(service.categorize('Nordea Vardagspaket', -20), (
        Category.fees,
        Subcategory.bankFees,
      ));
      expect(service.categorize('Skatteverket', -10000), (
        Category.fees,
        Subcategory.tax,
      ));
    });

    test('categorizes Other/Admin accurately', () {
      expect(service.categorize('Telenor', -399), (
        Category.other,
        Subcategory.mobileSubscription,
      ));
      expect(service.categorize('Fadder', -200), (
        Category.other,
        Subcategory.godfather,
      ));
      expect(service.categorize('Avanza', -5000), (
        Category.other,
        Subcategory.other,
      ));
    });

    test('categorizes Entertainment extended', () {
      expect(service.categorize('SF Bio', -250), (
        Category.entertainment,
        Subcategory.other,
      ));
      expect(service.categorize('SJ Resor', -400), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('Panduro', -150), (
        Category.entertainment,
        Subcategory.hobby,
      ));
      expect(service.categorize('APPLE.COM/BILL', -129), (
        Category.other,
        Subcategory.mobileSubscription,
      ));
      expect(service.categorize('Akademibokhandeln', -199), (
        Category.entertainment,
        Subcategory.boardGamesBooksAndToys,
      ));
    });

    test('categorizes Shopping extended', () {
      expect(service.categorize('NK KOK & DESIGN', -500), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('Clas Ohlson', -129), (
        Category.shopping,
        Subcategory.tools,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-17)', () {
      // General Logic
      expect(service.categorize('Köp INTERFLORA AKTIEBOL', -350), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Betalning K*ratsit.se', -59), (
        Category.entertainment,
        Subcategory.hobby,
      ));

      // Specific Exceptions
      expect(service.categorize('Swish betalning LUNDBERG, CHARLOTTA', -155.00), (
        Category.other,
        Subcategory.other,
      ));
      expect(service.categorize('HESTRA GOTHENBURG', -1400), (
        Category.shopping,
        Subcategory.gifts,
      ));
      // Fallback test
      expect(service.categorize('HESTRA GOTHENBURG', -500), (
        Category.shopping,
        Subcategory.clothes,
      ));
    });
  });
}
