import 'package:expenses/src/features/transactions/application/categorization_service.dart';
import 'package:expenses/src/features/transactions/domain/category.dart';
import 'package:expenses/src/features/transactions/domain/subcategory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dummyDate = DateTime(2025, 1, 1);
  late CategorizationService service;

  setUp(() {
    service = CategorizationService();
  });

  group('CategorizationService', () {
    test('categorizes Food accurately', () {
      expect(service.categorize('ICA Maxi', -100, dummyDate), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('Willys', -200, dummyDate), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('Restaurang Pizzeria', -150, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('Espresso House', -89, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('Capris', -100, dummyDate), (
        Category.food,
        Subcategory.groceries,
      ));
      expect(service.categorize('MMSports', -500, dummyDate), (
        Category.food,
        Subcategory.supplements,
      ));
      expect(service.categorize('JoeAndTheJuice', -85, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
    });

    test('categorizes Shopping accurately', () {
      expect(service.categorize('NK Göteborg', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('H&M', -300, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('Boss GBG', -1300, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('Elgiganten', -1000, dummyDate), (
        Category.shopping,
        Subcategory.electronics,
      ));
      expect(service.categorize('NK BEAUTY', -350, dummyDate), (
        Category.shopping,
        Subcategory.beauty,
      ));
      expect(service.categorize('Vacker NK', -300, dummyDate), (
        Category.shopping,
        Subcategory.beauty,
      ));
      expect(service.categorize('Arket', -450, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
    });

    test('categorizes Transport accurately', () {
      expect(service.categorize('Västtrafik', -35, dummyDate), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      expect(service.categorize('Vasttrafik', -35, dummyDate), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      expect(service.categorize('Uber Trip', -120, dummyDate), (
        Category.transport,
        Subcategory.taxi,
      ));
      expect(service.categorize('Circle K', -600, dummyDate), (
        Category.transport,
        Subcategory.fuel,
      ));
    });

    test('categorizes income transactions correctly', () {
      // Salary check
      expect(service.categorize('Lön Jim', 40000, dummyDate), (
        Category.income,
        Subcategory.salary,
      ));
      expect(service.categorize('Salary Jan', 35000, dummyDate), (
        Category.income,
        Subcategory.salary,
      ));

      // Other Income check
      expect(service.categorize('Swish Insättning', 500, dummyDate), (
        Category.income,
        Subcategory.other,
      ));
      expect(service.categorize('Återbetalning', 1200, dummyDate), (
        Category.income,
        Subcategory.other,
      ));
    });

    test('categorizes Bills/Housing/Subscriptions correctly', () {
      // Nordea Lån -> Housing/Mortgage
      expect(service.categorize('Nordea Lån', -2000, dummyDate), (
        Category.housing,
        Subcategory.mortgage,
      ));

      // CSN -> Fees/CSN
      expect(service.categorize('CSN', -1400, dummyDate), (
        Category.fees,
        Subcategory.csn,
      ));

      // Netflix -> Entertainment/Streaming
      expect(service.categorize('Netflix', -129, dummyDate), (
        Category.entertainment,
        Subcategory.streaming,
      ));
      expect(service.categorize('Amazon Prime', -59, dummyDate), (
        Category.entertainment,
        Subcategory.streaming,
      ));

      // Tele2 -> Housing/Broadband (Logic changed to favor broadband for generic 'Tele2')
      expect(service.categorize('Tele2', -299, dummyDate), (
        Category.housing,
        Subcategory.broadband,
      ));

      // Trygg-Hansa -> Other/PersonalInsurance
      expect(service.categorize('Trygg-Hansa', -500, dummyDate), (
        Category.other,
        Subcategory.personalInsurance,
      ));

      // DN -> Entertainment/Newspapers
      expect(service.categorize('DN Prenumeration', -100, dummyDate), (
        Category.entertainment,
        Subcategory.newspapers,
      ));
    });

    test('fallback to Other', () {
      expect(service.categorize('Unknown Blob', -50, dummyDate), (
        Category.other,
        Subcategory.unknown,
      ));
    });
    test('categorizes Entertainment correctly', () {
      expect(service.categorize('Snusbolaget', -500, dummyDate), (
        Category.entertainment,
        Subcategory.snuff,
      ));
      expect(service.categorize('Nintendo eShop', -500, dummyDate), (
        Category.entertainment,
        Subcategory.videoGames,
      ));
    });

    test('categorizes Food accurately', () {
      // ... existing tests
      expect(service.categorize('Steinbrenner & Nyberg', -150, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('THE MELODY CLUB', -200, dummyDate), (
        Category.food,
        Subcategory.bar,
      ));
      // Regression test for Foodora
      expect(service.categorize('FOODORA AB', -592, dummyDate), (
        Category.food,
        Subcategory.takeaway,
      ));

      // New rule for Masaki
      expect(service.categorize('MASAKI HALSOSUSHI AB', -150, dummyDate), (
        Category.food,
        Subcategory.takeaway,
      ));

      // Regression test for HBOMAX (containing 'max ')
      expect(service.categorize('HBOMAX HELP.HBOMAX.COM', -74.5, dummyDate), (
        Category.entertainment,
        Subcategory.streaming,
      ));

      // Regression test for Bolagsverket
      expect(service.categorize('Kortköp 251117 BOLAGSVERKET', -3435.72, dummyDate), (
        Category.fees,
        Subcategory.other,
      ));
    });

    test('Specific Overrides', () {
      expect(service.categorize('ZETTLE_*SAD RETAIL GRO', -950, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('NK KOK & DESIGN GBG', -2090, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KIDS & TEENS GBG', -239, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KIDS & TEENS GBG', -70, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Kortköp 251218 NK KOK & DESIGN GBG', -1299, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('KLARNA SMALANDSGRAN', -1315, dummyDate), (
        Category.shopping,
        Subcategory.other,
      ));
      expect(service.categorize('ELLOS AB', -3148.1, dummyDate), (
        Category.shopping,
        Subcategory.furniture,
      ));
      expect(service.categorize('NORDISKA GALLERIET GOT', 400, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('NORDISKA GALLERIET GOT', -400, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('THAICORNERILINDOMEAB', -615, dummyDate), (
        Category.food,
        Subcategory.takeaway,
      ));
      expect(service.categorize('THAICORNERILINDOMEAB', 615, dummyDate), (
        Category.food,
        Subcategory.takeaway,
      ));
      expect(service.categorize('Swish betalning PETTER NILSSON', -885.72, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('Swish betalning PETTER NILSSON', 885.72, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
    });

    test('categorizes Health accurately', () {
      expect(service.categorize('Sanna andrén', -500, dummyDate), (
        Category.health,
        Subcategory.beauty,
      ));
      expect(service.categorize('SATS', -450, dummyDate), (
        Category.health,
        Subcategory.gym,
      ));
      expect(service.categorize('Apoteket AB', -120, dummyDate), (
        Category.health,
        Subcategory.pharmacy,
      ));
      expect(service.categorize('Vårdcentralen', -200, dummyDate), (
        Category.health,
        Subcategory.doctor,
      ));
    });

    test('categorizes Housing accurately', () {
      expect(service.categorize('Autogiro If Skadeförs', -350, dummyDate), (
        Category.housing,
        Subcategory.homeInsurance,
      ));
      expect(service.categorize('Verisure', -499, dummyDate), (
        Category.housing,
        Subcategory.security,
      ));
      expect(service.categorize('Renahus', -2500, dummyDate), (
        Category.housing,
        Subcategory.cleaning,
      ));
      expect(service.categorize('Göteborg Energi', -600, dummyDate), (
        Category.housing,
        Subcategory.electricity,
      ));
      expect(service.categorize('HSB', -4500, dummyDate), (
        Category.housing,
        Subcategory.brfFee,
      ));
    });

    test('categorizes Fees accurately', () {
      expect(service.categorize('Nordea Vardagspaket', -20, dummyDate), (
        Category.fees,
        Subcategory.bankFees,
      ));
      expect(service.categorize('Skatteverket', -10000, dummyDate), (
        Category.fees,
        Subcategory.tax,
      ));
    });

    test('categorizes Other/Admin accurately', () {
      expect(service.categorize('Telenor', -399, dummyDate), (
        Category.other,
        Subcategory.mobileSubscription,
      ));
      expect(service.categorize('Fadder', -200, dummyDate), (
        Category.other,
        Subcategory.godfather,
      ));
      expect(service.categorize('Avanza', -5000, dummyDate), (
        Category.other,
        Subcategory.other,
      ));
    });

    test('categorizes Entertainment extended', () {
      expect(service.categorize('SF Bio', -250, dummyDate), (
        Category.entertainment,
        Subcategory.other,
      ));
      expect(service.categorize('SJ Resor', -400, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('Panduro', -150, dummyDate), (
        Category.entertainment,
        Subcategory.hobby,
      ));
      expect(service.categorize('APPLE.COM/BILL', -129, dummyDate), (
        Category.other,
        Subcategory.mobileSubscription,
      ));
      expect(service.categorize('Akademibokhandeln', -199, dummyDate), (
        Category.entertainment,
        Subcategory.boardGamesBooksAndToys,
      ));
    });

    test('categorizes Shopping extended', () {
      expect(service.categorize('NK KOK & DESIGN', -500, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('Clas Ohlson', -129, dummyDate), (
        Category.shopping,
        Subcategory.tools,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-17)', () {
      // General Logic
      expect(service.categorize('Köp INTERFLORA AKTIEBOL', -350, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));
      expect(service.categorize('Betalning K*ratsit.se', -59, dummyDate), (
        Category.entertainment,
        Subcategory.hobby,
      ));

      // Specific Exceptions
      expect(service.categorize('Swish betalning LUNDBERG, CHARLOTTA', -155.00, dummyDate), (
        Category.other,
        Subcategory.other,
      ));
      expect(service.categorize('HESTRA GOTHENBURG', -1400, DateTime(2026, 1, 3)), (
        Category.shopping,
        Subcategory.gifts,
      ));
      // Fallback test
      expect(service.categorize('HESTRA GOTHENBURG', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-18)', () {
      // Keyword: Gudmor Lollo
      expect(service.categorize('Överföring Gudmor Lollo', -200, dummyDate), (
        Category.other,
        Subcategory.godfather,
      ));

      // Specific Override: NK MAN GBG
      expect(service.categorize('Kortköp 251221 NK MAN GBG', -2299.00, DateTime(2025, 12, 22)), (
        Category.shopping,
        Subcategory.gifts,
      ));

      // Specific Override: Patientfa
      expect(service.categorize('Open Banking BG 5734-9797 Patientfa', -100.00, DateTime(2025, 12, 22)), (
        Category.other,
        Subcategory.other,
      ));

      // Specific Override: JOHN HENRIC NK GBG
      expect(service.categorize('JOHN HENRIC NK GBG', -1999.00, DateTime(2025, 12, 22)), (
        Category.shopping,
        Subcategory.gifts,
      ));

      // Specific Override: CAPRIS
      expect(service.categorize('CAPRIS', -650.00, DateTime(2025, 12, 30)), (
        Category.shopping,
        Subcategory.gifts,
      ));

      // General Logic: PASTOR - STORA SALUHAL
      expect(service.categorize('PASTOR - STORA SALUHAL', -125, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));

      // Fallback check (wrong date/amount)
      expect(service.categorize('Kortköp 251221 NK MAN GBG', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
    });
  });
}
