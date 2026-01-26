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
        Category.health,
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
        Category.entertainment,
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
        Subcategory.lunch,
      ));

      // Regression test for HBOMAX (containing 'max ')
      expect(service.categorize('HBOMAX HELP.HBOMAX.COM', -74.5, dummyDate), (
        Category.entertainment,
        Subcategory.streaming,
      ));

      // Regression test for Bolagsverket
      expect(
        service.categorize('Kortköp 251117 BOLAGSVERKET', -3435.72, dummyDate),
        (Category.fees, Subcategory.jimHolding),
      );
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
      expect(
        service.categorize(
          'Kortköp 251218 NK KIDS & TEENS GBG',
          -239,
          dummyDate,
        ),
        (Category.shopping, Subcategory.gifts),
      );
      expect(
        service.categorize(
          'Kortköp 251218 NK KIDS & TEENS GBG',
          -70,
          dummyDate,
        ),
        (Category.shopping, Subcategory.gifts),
      );
      expect(
        service.categorize(
          'Kortköp 251218 NK KOK & DESIGN GBG',
          -1299,
          dummyDate,
        ),
        (Category.shopping, Subcategory.gifts),
      );
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
      expect(
        service.categorize(
          'Swish betalning PETTER NILSSON',
          -885.72,
          dummyDate,
        ),
        (Category.food, Subcategory.restaurant),
      );
      expect(
        service.categorize('Swish betalning PETTER NILSSON', 885.72, dummyDate),
        (Category.food, Subcategory.restaurant),
      );
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

      // Verification for Kitchen Renovation (User Request 2026-01-26)
      expect(service.categorize('Factoringgrup', -5000, dummyDate), (
        Category.housing,
        Subcategory.kitchenRenovation,
      ));
      // Explicitly check that it is part of the enum (compile-time check essentially)
      expect(Category.housing.subcategories, contains(Subcategory.kitchenRenovation));
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
      expect(
        service.categorize(
          'Swish betalning LUNDBERG, CHARLOTTA',
          -155.00,
          dummyDate,
        ),
        (Category.other, Subcategory.other),
      );
      expect(
        service.categorize('HESTRA GOTHENBURG', -1400, DateTime(2026, 1, 3)),
        (Category.shopping, Subcategory.gifts),
      );
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
      expect(
        service.categorize(
          'Kortköp 251221 NK MAN GBG',
          -2299.00,
          DateTime(2025, 12, 22),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // Specific Override: Patientfa
      expect(
        service.categorize(
          'Open Banking BG 5734-9797 Patientfa',
          -100.00,
          DateTime(2025, 12, 22),
        ),
        (Category.other, Subcategory.other),
      );

      // Specific Override: JOHN HENRIC NK GBG
      expect(
        service.categorize(
          'JOHN HENRIC NK GBG',
          -1999.00,
          DateTime(2025, 12, 22),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // Specific Override: CAPRIS
      expect(service.categorize('CAPRIS', -650.00, DateTime(2025, 12, 30)), (
        Category.shopping,
        Subcategory.gifts,
      ));

      // Specific Override: LUCAS MALINA
      expect(
        service.categorize(
          'Swish betalning LUCAS MALINA',
          -2716.00,
          DateTime(2025, 11, 30),
        ),
        (Category.food, Subcategory.restaurant),
      );

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

    test('categorizes New Rules (User Request 2026-01-18 - Batch 2)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Lunch
      expect(service.categorize('VELIC,AJLA', -100, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(service.categorize('MASAKI HALSOSUSHI AB', -150, dummyDate), (
        Category.food,
        Subcategory.lunch,
      )); // Updated existing rule/test logic
      expect(service.categorize('DELI AND COFFEE', -85, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(
        service.categorize(
          'Swish inbetalning SEHLIN,MARIANNE',
          -120,
          dummyDate,
        ),
        (Category.food, Subcategory.lunch),
      );

      // Shopping / Decor
      expect(service.categorize('ARTILLERIET STORE', -500, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));

      // Food / Bar
      expect(service.categorize('PARK LANE RESTA', -200, dummyDate), (
        Category.entertainment,
        Subcategory.bar,
      ));

      // Health / Beauty
      expect(
        service.categorize('STYLE BARBERSHOP', -450, dummyDate),
        (Category.health, Subcategory.beauty),
      ); // Request said Health/Beauty but code puts it in Shopping/Beauty. Checking code... Yes, Shopping/Beauty. Wait, user request said "Category.health / Subcategory.beauty".

      // Shopping / Gifts
      expect(service.categorize('EUROFLORIST', -350, dummyDate), (
        Category.shopping,
        Subcategory.gifts,
      ));

      // Transport / PublicTransport
      expect(service.categorize('HALLANDSTRAFIKE', -35, dummyDate), (
        Category.transport,
        Subcategory.publicTransport,
      ));

      // Shopping / Clothes
      expect(service.categorize('LIVLY', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // Food / Coffee
      expect(service.categorize('BROGYLLEN', -89, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // Food / Restaurant
      expect(service.categorize('MCDVARBERGNORD', -150, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // Health / Doctor
      expect(service.categorize('IDROTTSREHAB', -200, dummyDate), (
        Category.health,
        Subcategory.doctor,
      ));

      // --- SPECIFIC OVERRIDES ---

      // Swish betalning PETTER NILSSON -> Food/Restaurant
      expect(
        service.categorize(
          'Swish betalning PETTER NILSSON',
          -2550.00,
          DateTime(2025, 11, 22),
        ),
        (Category.food, Subcategory.restaurant),
      );

      // Hestra Gothenburg -> Shopping/Gifts
      expect(
        service.categorize(
          'Kortköp 251115 Hestra Gothenburg',
          -1400.00,
          DateTime(2025, 11, 16),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // SULTAN DONER -> Food/Takeaway
      expect(
        service.categorize('SULTAN DONER', -280.0, DateTime(2025, 11, 16)),
        (Category.food, Subcategory.takeaway),
      );

      // JimHolding -> Fees/JimHolding
      expect(
        service.categorize(
          'Aktiekapital 1110 31 04004',
          -25000.00,
          DateTime(2025, 11, 16),
        ),
        (Category.fees, Subcategory.jimHolding),
      );

      // EVION HOTELL & -> Food/Bar
      expect(
        service.categorize('EVION HOTELL &', -96.0, DateTime(2025, 11, 15)),
        (Category.entertainment, Subcategory.bar),
      );
      expect(
        service.categorize('EVION HOTELL &', -42.0, DateTime(2025, 11, 15)),
        (Category.entertainment, Subcategory.bar),
      );

      // GOTEBORG CITY MAT & -> Food/Lunch
      expect(
        service.categorize(
          'GOTEBORG CITY MAT &',
          -130.0,
          DateTime(2025, 11, 15),
        ),
        (Category.food, Subcategory.lunch),
      );

      // JINX DYNASTY -> Other/Other
      expect(
        service.categorize('JINX DYNASTY', -1485, DateTime(2025, 11, 12)),
        (Category.other, Subcategory.other),
      );

      // SVENSKA SPEL -> Shopping/Gifts
      expect(
        service.categorize(
          'Swish betalning AB SVENSKA SPEL',
          -250.00,
          DateTime(2025, 11, 9),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // GÖRAN BENGTSSON -> Shopping/Tools
      expect(
        service.categorize(
          'Swish betalning GÖRAN BENGTSSON',
          -600.00,
          DateTime(2025, 11, 8),
        ),
        (Category.shopping, Subcategory.tools),
      );

      // BANKOMAT ALMEDA -> Shopping/Furniture
      expect(
        service.categorize(
          'Kontantuttag 251107 BANKOMAT ALMEDA',
          -1300.00,
          DateTime(2025, 11, 8),
        ),
        (Category.shopping, Subcategory.furniture),
      );

      // gdb i centrum ab -> Other/Other
      expect(
        service.categorize(
          'Swish betalning gdb i centrum ab',
          -174.00,
          DateTime(2025, 11, 7),
        ),
        (Category.other, Subcategory.other),
      );

      // BILLDALS BLOMMOR -> Shopping/Decor
      expect(
        service.categorize('BILLDALS BLOMMOR', -720.0, DateTime(2025, 11, 1)),
        (Category.shopping, Subcategory.decor),
      );

      // LUCAS MALINA -> Other/Other
      expect(
        service.categorize(
          'Swish betalning LUCAS MALINA',
          -280.0,
          DateTime(2025, 11, 1),
        ),
        (Category.other, Subcategory.other),
      );
    });

    test('categorizes New Rules (User Request 2026-01-20)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Lunch: 'SALUHALLEN WRAPSODY', 'MR SHOU', 'BUN GBG'
      expect(service.categorize('Köp SALUHALLEN WRAPSODY', -115, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(service.categorize('MR SHOU', -145, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(service.categorize('BUN GBG', -130, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));

      // Shopping / Clothes: 'STADIUM'
      expect(service.categorize('Köp STADIUM', -499, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // Health / Doctor: 'BABYSCREEN'
      expect(service.categorize('BABYSCREEN GBG', -1200, dummyDate), (
        Category.health,
        Subcategory.doctor,
      ));

      // --- SPECIFIC OVERRIDES ---

      // NK KAFFE, TE & KONFEKT -> Shopping/Gifts
      // Row: 2025-10-31;2025-11-03;NK KAFFE, TE & KONFEKT;GA.TEBORG;SEK;0;109
      expect(
        service.categorize(
          'NK KAFFE, TE & KONFEKT',
          -109.0,
          DateTime(2025, 10, 31),
        ),
        (Category.shopping, Subcategory.gifts),
      );
      expect(
        service.categorize(
          'NK KAFFE, TE & KONFEKT',
          109.0,
          DateTime(2025, 10, 31),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // Loan Deposit (User Request 2026-01-26)
      expect(
        service.categorize(
          'Insättning',
          400000.00,
          DateTime(2025, 2, 3),
        ),
        (Category.income, Subcategory.loan),
      );
    });
    test('categorizes New Rules (User Request 2026-01-20 - Zettle)', () {
      // ZETTLE_*VR SNABBTAG SV -> Food/Coffee
      // Row: 2025-10-03;2025-10-06;ZETTLE_*VR SNABBTAG SV;STOCKHOLM;SEK;0;50
      expect(
        service.categorize(
          'ZETTLE_*VR SNABBTAG SV',
          -50.0,
          DateTime(2025, 10, 3),
        ),
        (Category.food, Subcategory.coffee),
      );
      expect(
        service.categorize(
          'ZETTLE_*VR SNABBTAG SV',
          50.0,
          DateTime(2025, 10, 3),
        ),
        (Category.food, Subcategory.coffee),
      );
      
      // Swish betalning LUCAS MALINA -> Other/Other (2026-01-06)
      expect(
        service.categorize(
          'Swish betalning LUCAS MALINA',
          -500.0,
          DateTime(2026, 1, 6),
        ),
        (Category.other, Subcategory.other),
      );
    });
    test('categorizes New Rules (User Request 2026-01-20)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Lunch
      expect(service.categorize('JINX DYNASTY', -100, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(service.categorize('HASSELSSONS MACKLUCKA', -100, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));
      expect(
        service.categorize('Swish betalning Ellen Abenius', -100, dummyDate),
        (Category.food, Subcategory.lunch),
      );
      expect(service.categorize('ZETTLE_*CHEAP NOODLES', -100, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));

      // Shopping / Clothes
      expect(service.categorize('NEWBODY AB', -100, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
      expect(service.categorize('J. LINDEBERG NK', -100, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-20 - Part 2)', () {
      // Food / Restaurant
      expect(service.categorize('VOYAGE GBG AB', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('CHOPCHOP', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-25)', () {
      // General Keyword
      expect(service.categorize('Köp CLASOHLSON.COM/SE', -100, dummyDate), (
        Category.shopping,
        Subcategory.tools,
      ));

      // Specific Exceptions
      expect(
        service.categorize(
          'MARBODAL',
          -297.0,
          DateTime(2026, 1, 19),
        ),
        (Category.shopping, Subcategory.furniture),
      );

      expect(
        service.categorize(
          'TM *TICKETMASTER',
          -1770.0,
          DateTime(2026, 1, 11),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      expect(
        service.categorize(
          'Swish betalning BYSTRÖM, ALEXANDER',
          -1580.0,
          DateTime(2026, 1, 5),
        ),
        (Category.food, Subcategory.restaurant),
      );
    });


    test('categorizes New Rules (User Request 2026-01-22)', () {
      // --- GENERAL KEYWORDS ---

      // 'Filippa K' -> Shopping/Clothes
      expect(service.categorize('Köp Filippa K', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // 'ELIO', 'LOCO' -> Food/Restaurant
      expect(service.categorize('ELIO RESTAURANT', -200, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('LOCO BAR', -200, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // 'KAFFELABBET' -> Food/Coffee
      expect(service.categorize('KAFFELABBET GBG', -89, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // 'BELLE CELINE AB' -> Shopping/Beauty
      expect(service.categorize('BELLE CELINE AB', -350, dummyDate), (
        Category.shopping,
        Subcategory.beauty,
      ));

      // 'VIETNAM MARKET' -> Food/Lunch
      expect(service.categorize('VIETNAM MARKET', -120, dummyDate), (
        Category.food,
        Subcategory.lunch,
      ));

      // --- SPECIFIC OVERRIDES ---

      // Swish betalning DANIEL LENNARTSSON
      expect(
        service.categorize(
          'Swish betalning DANIEL LENNARTSSON',
          -400.00,
          DateTime(2025, 8, 23),
        ),
        (Category.other, Subcategory.other),
      );

      // Swish betalning KUJTIM LENA
      expect(
        service.categorize(
          'Swish betalning KUJTIM LENA',
          -40.00,
          DateTime(2025, 8, 23),
        ),
        (Category.other, Subcategory.other),
      );

      // Swish betalning HAPPY ORDER AB
      expect(
        service.categorize(
          'Swish betalning HAPPY ORDER AB',
          -129.00,
          DateTime(2025, 8, 21),
        ),
        (Category.food, Subcategory.lunch),
      );
    });

    test('categorizes New Rules (User Request 2026-01-21)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Groceries: 'HUGO ERICSON OST I SAL'
      expect(
        service.categorize('HUGO ERICSON OST I SAL', -100, dummyDate),
        (Category.food, Subcategory.groceries),
      );

      // Food / Restaurant: 'VITA DUVAN'
      expect(
        service.categorize('VITA DUVAN', -100, dummyDate),
        (Category.food, Subcategory.restaurant),
      );

      // Transport / PublicTransport: 'STYR  STAELL'
      expect(
        service.categorize('STYR  STAELL', -25, dummyDate),
        (Category.transport, Subcategory.publicTransport),
      );

      // --- SPECIFIC OVERRIDES ---

      // 2025-09-11;2025-09-12;STUDIO;GOTEBORG;SEK;0;521.4 -> Other/Other
      expect(
        service.categorize(
          'STUDIO',
          521.4,
          DateTime(2025, 9, 11),
        ), // Positive amount in CSV? User said "SEK;0;521.4" usually implies amount is 521.4, but overrides usually check negative for expenses or specific amount. The user request says "2025-09-11... 521.4". I will assume it's an expense recorded as positive in description or just match the number. Wait, in this codebase expenses are negative. But the user wrote "521.4". I should check if it's income or expense. Usually 'STUDIO' sounds like an expense. The user pasted a CSV row. "2025-09-11;...;521.4". It might be positive. If it's a refund or split. Or maybe the CSV format has positive for expenses?
        // Looking at previous tests: 'Kortköp... -1400'. 'Lön... 40000'. So expenses are negative.
        // The user provided row: "2025-09-11;...;521.4". If this is a copy paste from a CSV where expenses are positive (some banks do that), I need to be careful.
        // However, looking at the other rows: "2025/09/05;-1000,00...". That one has negative.
        // "2025-09-11... 521.4". This is positive.
        // "2025-09-06... 178". Positive.
        // "2025-09-05... 162.41". Positive.
        // I will match exact amount 521.4.
        (Category.other, Subcategory.other),
      );

      // 2025-09-06;...;LOOMISP*STAURANG VASTE;...;178 -> Food/Lunch
      expect(
        service.categorize(
          'LOOMISP*STAURANG VASTE',
          178.0,
          DateTime(2025, 9, 6),
        ),
        (Category.food, Subcategory.lunch),
      );

      // 2025-09-05;...;HASSELBACKEN;...;162.41 -> Other/Other
      expect(
        service.categorize(
          'HASSELBACKEN',
          162.41,
          DateTime(2025, 9, 5),
        ),
        (Category.other, Subcategory.other),
      );

      // 2025/09/05;-1000,00;...Swish betalning BYSTRÖM, MALOU... -> Other/Other
      // Note: User wrote "2025/09/05;-1000,00...". This is definitely negative.
      expect(
        service.categorize(
          'Swish betalning BYSTRÖM, MALOU',
          -1000.0,
          DateTime(2025, 9, 5),
        ),
        (Category.other, Subcategory.other),
      );
    });

    test('categorizes New Rules (User Request 2026-01-21)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Restaurant
      expect(service.categorize('ZETTLE_*JIMMY   JOAN S', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('SKANSHOF', -200, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('STORKOKET I GOT', -150, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('TOSO', -300, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // Entertainment / Travel
      expect(service.categorize('VR RESA', -400, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));

      // Entertainment / Bar
      expect(service.categorize('ON AIR GAME SHOWS SWED', -250, dummyDate), (
        Category.entertainment,
        Subcategory.bar,
      ));

      // Shopping / DryCleaning
      expect(service.categorize('VASQUE KEMTVATT', -150, dummyDate), (
        Category.shopping,
        Subcategory.dryCleaning,
      ));
    });

    test('Additional checks', () {
      expect(service.categorize('ENOTECA SASSI', -100, dummyDate), (
        Category.food,
        Subcategory.restaurant,
      ));

      // Health / Gym
      expect(service.categorize('EVENT BOOKING (RACEID)', -100, dummyDate), (
        Category.health,
        Subcategory.gym,
      ));

      // Food / Coffee
      expect(service.categorize('ESPRESSO', -100, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));
      expect(service.categorize('5151 RITAZZA ST', -100, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // Transport / PublicTransport: 'SL'
      // Strict match check
      expect(service.categorize('SL', -39, dummyDate), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      expect(service.categorize('Resa SL Stockholm', -39, dummyDate), (
        Category.transport,
        Subcategory.publicTransport,
      ));
      // Should NOT match 'Tesla', 'Island', 'Slow'
      expect(service.categorize('Tesla Supercharger', -100, dummyDate), (
        Category.other,
        Subcategory.unknown,
      )); // Correctly avoids SL match
      // Actually 'Tesla' might fall to unknown if no other rule matches. Let's precise:
      // 'Tesla' should not match 'SL' rule. If it returns Unknown, that's fine for this test context (assuming no other 'Tesla' rule exists).

      // --- SPECIFIC OVERRIDES ---

      // Row 1: 2025/10/21;-3100,00;...2352 5694 01 75741... -> Other/Other
      expect(
        service.categorize(
          '2352 5694 01 75741',
          -3100.0,
          DateTime(2025, 10, 21),
        ),
        (Category.other, Subcategory.other),
      );

      // Row 2: 2025/10/18;-60,00;...Swish betalning Aros Ballroom And L... -> Food/Coffee
      expect(
        service.categorize(
          'Swish betalning Aros Ballroom And L',
          -60.0,
          DateTime(2025, 10, 18),
        ),
        (Category.food, Subcategory.coffee),
      );

      // Row 3: 2025/10/18;-85,00;...Swish betalning Aros Ballroom And L... -> Food/Lunch
      expect(
        service.categorize(
          'Swish betalning Aros Ballroom And L',
          -85.0,
          DateTime(2025, 10, 18),
        ),
        (Category.food, Subcategory.lunch),
      );

      // Row 4: 2025/10/18;-150,00;...Swish betalning Aros Ballroom And L... -> Food/Lunch
      expect(
        service.categorize(
          'Swish betalning Aros Ballroom And L',
          -150.0,
          DateTime(2025, 10, 18),
        ),
        (Category.food, Subcategory.lunch),
      );

      // Row 5: 2025-10-04;...NYX*SANIBOXAB... -> Other/Other
      // Note: Amount 10 or -10? User request "SEK;0;10" often means 10.00 amount. Expenses are neg? Let's assume -10.0 for safety, or check both if ambiguous.
      // Given previous context, expenses are negative.
      expect(
        service.categorize('NYX*SANIBOXAB', -10.0, DateTime(2025, 10, 4)),
        (Category.other, Subcategory.other),
      );
      // Try positive too just in case
      expect(service.categorize('NYX*SANIBOXAB', 10.0, DateTime(2025, 10, 4)), (
        Category.other,
        Subcategory.other,
      ));

      // Row 6: 2025-10-04;...KMARKT TEATERN... -> Other/Other
      expect(
        service.categorize('KMARKT TEATERN', -57.0, DateTime(2025, 10, 4)),
        (Category.other, Subcategory.other),
      );
    });
  test('categorizes New Rules (User Request 2026-01-21)', () {
      // --- GENERAL KEYWORDS ---

      // Food / Groceries
      expect(service.categorize('Köp HEMKOP', -200, dummyDate), (
        Category.food,
        Subcategory.groceries,
      ));

      // Food / Coffee
      expect(service.categorize('TEHUSET', -89, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // Transport / Taxi
      expect(service.categorize('VOI SE', -45, dummyDate), (
        Category.transport,
        Subcategory.taxi,
      ));

      // Health / Doctor
      expect(service.categorize('Eliasson Psyk', -1200, dummyDate), (
        Category.health,
        Subcategory.doctor,
      ));

      // Shopping / Clothes
      expect(service.categorize('WEEKDAY', -500, dummyDate), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // --- SPECIFIC OVERRIDES ---

      // OLIVIA GOTEBORG -> Other/Other
      expect(
        service.categorize(
          'OLIVIA GOTEBORG',
          -359.0,
          DateTime(2025, 9, 26),
        ),
        (Category.other, Subcategory.other),
      );
      expect(
        service.categorize(
          'OLIVIA GOTEBORG',
          359.0,
          DateTime(2025, 9, 26),
        ),
        (Category.other, Subcategory.other),
      );
    });

    test('categorizes New Rules (User Request 2026-01-22)', () {
      // Shopping / Clothes: 'DRESSMANN'
      expect(
        service.categorize('Köp DRESSMANN', -500, dummyDate),
        (Category.shopping, Subcategory.clothes),
      );
    });
    test('categorizes New Rules (User Request 2026-01-25 - Missing SAS Fees)', () {
      expect(service.categorize('ÅRSAVGIFT', -2335, dummyDate), (
        Category.fees,
        Subcategory.bankFees,
      ));
      expect(service.categorize('EXTRAKORTSAVGIFT', -295, dummyDate), (
        Category.fees,
        Subcategory.bankFees,
      ));
    });

    test('categorizes New Rules (User Request 2026-01-26)', () {
      final d = dummyDate;

      // --- GENERAL KEYWORDS ---

      // 'NATURALCYCLES' -> Health / Doctor
      expect(service.categorize('NATURALCYCLES', -100, d), (
        Category.health,
        Subcategory.doctor,
      ));

      // 'HORNBACH' -> Shopping / Tools
      expect(service.categorize('Köp HORNBACH', -500, d), (
        Category.shopping,
        Subcategory.tools,
      ));

      // 'NONNA', 'BENNE PASTA' -> Food / Restaurant
      expect(service.categorize('NONNA', -200, d), (
        Category.food,
        Subcategory.restaurant,
      ));
      expect(service.categorize('BENNE PASTA', -150, d), (
        Category.food,
        Subcategory.restaurant,
      ));

      // 'LEKIA' -> Shopping / Gifts
      expect(service.categorize('LEKIA', -300, d), (
        Category.shopping,
        Subcategory.gifts,
      ));
      
      // 'Betalning BG 5597-7003 SPORTDANSKLU' -> Shopping / Gifts
      expect(
          service.categorize(
              'Betalning BG 5597-7003 SPORTDANSKLU', -300, d),
          (Category.shopping, Subcategory.gifts));

      // 'BEAUTY STYLE VA' -> Health / Beauty
      expect(service.categorize('BEAUTY STYLE VA', -400, d), (
        Category.health,
        Subcategory.beauty,
      ));

      // 'SJ.SE' -> Entertainment / Travel
      expect(service.categorize('SJ.SE', -500, d), (
        Category.entertainment,
        Subcategory.travel,
      ));

      // 'KRABBESK{RS FISK' -> Food / Groceries
      expect(service.categorize('KRABBESK{RS FISK', -200, d), (
        Category.food,
        Subcategory.groceries,
      ));

      // 'ginatricot' -> Shopping / Clothes
      expect(service.categorize('ginatricot', -400, d), (
        Category.shopping,
        Subcategory.clothes,
      ));

      // --- SPECIFIC EXCEPTIONS (OVERRIDES) ---

      // Row: 2025/07/28;-498,00;...;Kortköp 250726 LEXINGTON HOME GOT;...
      // -> Shopping / Decor
      expect(
        service.categorize(
          'Kortköp 250726 LEXINGTON HOME GOT',
          -498.00,
          DateTime(2025, 7, 28),
        ),
        (Category.shopping, Subcategory.decor),
      );

      // Row: 2025-07-27;...;LEKIA KUNGSGATAN;...;304
      // -> Shopping / Gifts
      expect(
        service.categorize(
          'LEKIA KUNGSGATAN',
          -304.0,
          DateTime(2025, 7, 27),
        ),
        (Category.shopping, Subcategory.gifts),
      );

      // Row: 2025/07/26;2000,00;...;Swish inbetalning JOAKIM MALMQVIST;...
      // -> Income / KitchenRenovation
      expect(
        service.categorize(
          'Swish inbetalning JOAKIM MALMQVIST',
          2000.00,
          DateTime(2025, 7, 26),
        ),
        (Category.income, Subcategory.kitchenRenovation),
      );

      // Row: 2025/07/23;-200,00;...;Swish betalning LUCAS MALINA;...
      // -> Other / Other
      expect(
        service.categorize(
          'Swish betalning LUCAS MALINA',
          -200.00,
          DateTime(2025, 7, 23),
        ),
        (Category.other, Subcategory.other),
      );
    });


    test('categorizes New Rules (User Request 2026-01-26 - Late)', () {
      // --- SPECIFIC OVERRIDES ---

      // ROGER NILSSON STAVERSH -> Other/Other
      expect(
        service.categorize(
          'ROGER NILSSON STAVERSH',
          -120.0,
          DateTime(2025, 7, 18),
        ),
        (Category.other, Subcategory.other),
      );
      // Check allowing positive amount just in case
      expect(
         service.categorize(
          'ROGER NILSSON STAVERSH',
          120.0,
          DateTime(2025, 7, 18),
        ),
        (Category.other, Subcategory.other),
      );

       // W*ROYALDESIGN.SE -> Shopping/Decor
      expect(
        service.categorize(
          'W*ROYALDESIGN.SE',
          -4668.0,
          DateTime(2025, 7, 5),
        ),
        (Category.shopping, Subcategory.decor),
      );

      // --- GENERAL KEYWORDS ---

      // Food / Coffee: 'GELATO'
      expect(service.categorize('GELATO', -50, dummyDate), (
        Category.food,
        Subcategory.coffee,
      ));

      // Food / Restaurant
      expect(service.categorize('BASTAD HAMNRESTAURAN', -200, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('TOPEJA BJÄRE AB', -300, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('V[RFTETS MADMAR', -250, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('NORDSJALLANDS V', -400, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('AXELHUS BODEGA', -150, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('FAMILJEN PAX', -600, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('FAMILJEN ORRMYR', -700, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('CHICCA BELLONI', -200, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));
      expect(service.categorize('COLLAGE', -150, dummyDate), (
         Category.food,
         Subcategory.restaurant,
      ));

      // Entertainment / Hobby: 'NORRVIKEN'
      expect(service.categorize('NORRVIKEN', -100, dummyDate), (
        Category.entertainment,
        Subcategory.hobby,
      ));

      // Entertainment / Travel
      expect(service.categorize('FC HELSING@R', -100, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('AURORA', -500, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));
      expect(service.categorize('STROMMA SWEDEN', -300, dummyDate), (
        Category.entertainment,
        Subcategory.travel,
      ));

      // Shopping / Decor
      expect(service.categorize('ALTHALLENSFARGTAPETERA', -1000, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
      expect(service.categorize('BGA.SE', -200, dummyDate), (
        Category.shopping,
        Subcategory.decor,
      ));
    });
  });
}
