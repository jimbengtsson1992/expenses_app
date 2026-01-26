import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';

part 'categorization_service.g.dart';

@riverpod
CategorizationService categorizationService(Ref ref) {
  return CategorizationService();
}

class CategorizationService {
  (Category, Subcategory) categorize(
    String description,
    double amount,
    DateTime date,
  ) {
    final lowerDesc = description.toLowerCase();

    // Specific Overrides (User Requested) - Checked FIRST to allow positive amounts (refunds) or specific exceptions
    // --- New User Request 2026-01-26 ---
    // Housing / KitchenRenovation
    // --- New User Request 2026-01-26 ---
    if (_matches(description, ['Insättning']) &&
        (amount == 400000.00)) {
       if (date.year == 2025 && date.month == 2 && date.day == 3) {
          return (Category.income, Subcategory.loan);
       }
    }
    
    if (_matches(description, ['Swish inbetalning SADIQ MAMAND']) &&
        (amount == 2600.00 || amount == -2600.00)) { // Allowing both for safety, but request was positive 2600,00
         if (date.year == 2025 && date.month == 8 && date.day == 11) {
            return (Category.income, Subcategory.other);
         }
    }
    if (_matches(description, ['Swish inbetalning AZMIR ALIC']) &&
        (amount == 1000.00)) {
         if (date.year == 2025 && date.month == 8 && date.day == 11) {
            return (Category.income, Subcategory.kitchenRenovation);
         }
    }
    if (_matches(description, ['Swish inbetalning ANDERSSON,MIKAEL']) &&
        (amount == 1500.00)) {
         if (date.year == 2025 && date.month == 8 && date.day == 10) {
            return (Category.income, Subcategory.kitchenRenovation);
         }
    }
    // Other / Other
    if (_matches(description, ['Swish betalning PEHR ZETHELIUS']) &&
        (amount == -200.00)) {
         if (date.year == 2025 && date.month == 8 && date.day == 10) {
            return (Category.other, Subcategory.other);
         }
    }
     // Shopping / Decor
    if (_matches(description, ['SVEA*ALSENS.COM']) &&
        (amount == -116.0)) {
         if (date.year == 2025 && date.month == 8 && date.day == 8) {
            return (Category.shopping, Subcategory.decor);
         }
    }
     // Entertainment / Travel
    if (_matches(description, ['MS* GRANDHOTELFALKENB']) &&
        (amount == -2108.0)) {
         if (date.year == 2025 && date.month == 8 && date.day == 2) {
            return (Category.entertainment, Subcategory.travel);
         }
    }

    if (_matches(description, ['STUDIO']) &&
        (amount == 521.4) &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 11) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['LOOMISP*STAURANG VASTE']) &&
        (amount == 178.0) &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 6) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['HASSELBACKEN']) &&
        (amount == 162.41) &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 5) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning BYSTRÖM, MALOU']) &&
        (amount == -1000.0) &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 5) {
      return (Category.other, Subcategory.other);
    }

    // --- New User Request 2026-01-22 ---
    if (_matches(description, ['Swish betalning DANIEL LENNARTSSON']) &&
        (amount == -400.00)) {
      if (date.year == 2025 && date.month == 8 && date.day == 23) {
        return (Category.other, Subcategory.other);
      }
    }
    if (_matches(description, ['Swish betalning KUJTIM LENA']) &&
        (amount == -40.00)) {
      if (date.year == 2025 && date.month == 8 && date.day == 23) {
        return (Category.other, Subcategory.other);
      }
    }
    if (_matches(description, ['Swish betalning HAPPY ORDER AB']) &&
        (amount == -129.00)) {
      if (date.year == 2025 && date.month == 8 && date.day == 21) {
        return (Category.food, Subcategory.lunch);
      }
    }

    // --- New User Request 2026-01-25 ---
    if (_matches(description, ['Swish betalning LUCAS MALINA']) &&
        (amount == -500.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 6) {
      return (Category.other, Subcategory.other);
    }
    
    // --- New User Request 2026-01-25 ---
    if (_matches(description, ['MARBODAL']) &&
        (amount == -297.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 19) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['TM *TICKETMASTER']) &&
        (amount == -1770.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 11) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Swish betalning BYSTRÖM, ALEXANDER']) &&
        (amount == -1580.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 5) {
      return (Category.food, Subcategory.restaurant);
    }

    if (_matches(description, ['EVENT BOOKING (RACEID)'])) {
      return (Category.health, Subcategory.gym);
    }
    if (_matches(description, ['ZETTLE_*VR SNABBTAG SV']) &&
        (amount == -50.0 || amount == 50.0) &&
        date.year == 2025 &&
        date.month == 10 &&
        date.day == 3) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(description, ['OLIVIA GOTEBORG']) &&
        (amount == -359.0 || amount == 359.0) &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 26) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['2352 5694 01 75741']) &&
        amount == -3100.0 &&
        date.year == 2025 &&
        date.month == 10 &&
        date.day == 21) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning Aros Ballroom And L']) &&
        date.year == 2025 &&
        date.month == 10 &&
        date.day == 18) {
      if (amount == -60.0) return (Category.food, Subcategory.coffee);
      if (amount == -85.0 || amount == -150.0) {
        return (Category.food, Subcategory.lunch);
      }
    }
    if (date.year == 2025 && date.month == 10 && date.day == 4) {
      if (_matches(description, ['NYX*SANIBOXAB'])) {
        return (Category.other, Subcategory.other);
      }
      if (_matches(description, ['KMARKT TEATERN'])) {
        return (Category.other, Subcategory.other);
      }
    }

    if (_matches(description, ['NK KAFFE, TE & KONFEKT']) &&
        (amount == -109.0 || amount == 109.0) &&
        (date.year == 2025 && date.month == 10 && date.day == 31)) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Swish betalning PETTER NILSSON']) &&
        (amount == -2550.0 || amount == 2550.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 22) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Kortköp 251115 Hestra Gothenburg']) &&
        (amount == -1400.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 16) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['SULTAN DONER']) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 16) {
      return (Category.food, Subcategory.takeaway);
    }
    if (_matches(description, ['Aktiekapital 1110 31 04004']) &&
        (amount == -25000.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 16) {
      return (Category.fees, Subcategory.jimHolding);
    }

    if (_matches(description, ['EVION HOTELL &']) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 15) {
      return (Category.entertainment, Subcategory.bar);
    }
    if (_matches(description, ['GOTEBORG CITY MAT &']) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 15) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['JINX DYNASTY']) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 12) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning AB SVENSKA SPEL']) &&
        (amount == -250.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 9) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Swish betalning GÖRAN BENGTSSON']) &&
        (amount == -600.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 8) {
      return (Category.shopping, Subcategory.tools);
    }
    if (_matches(description, ['Kontantuttag 251107 BANKOMAT ALMEDA']) &&
        (amount == -1300.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 8) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['Swish betalning gdb i centrum ab']) &&
        (amount == -174.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 7) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['BILLDALS BLOMMOR']) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 1) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['Swish betalning LUCAS MALINA']) &&
        (amount == -280.0) &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 1) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning LUNDBERG, CHARLOTTA']) &&
        amount == -155.0) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['HESTRA GOTHENBURG']) &&
        (amount == -1400 || amount == 1400)) {
      // Logic for HESTRA GOTHENBURG: 2026-01-03 row -> Shopping/Gifts
      if (date.year == 2026 && date.month == 1 && date.day == 3) {
        return (Category.shopping, Subcategory.gifts);
      }
    }

    if (_matches(description, ['ZETTLE_*SAD RETAIL GRO']) && amount == -950) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['NK KOK & DESIGN GBG']) && amount == -2090) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Kortköp 251218 NK KIDS & TEENS GBG']) &&
        (amount == -239 || amount == -70)) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Kortköp 251218 NK KOK & DESIGN GBG']) &&
        amount == -1299) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['KLARNA SMALANDSGRAN']) && amount == -1315) {
      return (Category.shopping, Subcategory.other);
    }
    if (_matches(description, ['ELLOS AB']) && amount == -3148.1) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['NORDISKA GALLERIET GOT']) &&
        (amount == 400 || amount == -400)) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['THAICORNERILINDOMEAB']) &&
        (amount == -615 || amount == 615)) {
      return (Category.food, Subcategory.takeaway);
    }
    if (_matches(description, ['Kortköp 251221 NK MAN GBG']) &&
        amount == -2299.00 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 22) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Swish betalning PETTER NILSSON']) &&
        (amount == -885.72 || amount == 885.72)) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Open Banking BG 5734-9797 Patientfa']) &&
        amount == -100.0 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 22) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['JOHN HENRIC NK GBG']) &&
        amount == -1999.0 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 22) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['CAPRIS']) &&
        amount == -650.0 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 30) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['Swish betalning LUCAS MALINA']) &&
        amount == -2716.0 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 30) {
      return (Category.food, Subcategory.restaurant);
    }

    // --- Income (> 0) ---
    if (amount > 0) {
      if (_matches(lowerDesc, ['lön', 'salary'])) {
        return (Category.income, Subcategory.salary);
      }
      if (_matches(lowerDesc, ['ränta'])) {
        return (Category.income, Subcategory.interest);
      }
      return (Category.income, Subcategory.other);
    }

    // --- Expenses (<= 0) ---
    if (_matches(lowerDesc, ['apple.com/bill'])) {
      return (Category.other, Subcategory.mobileSubscription);
    }

    // Entertainment - MOVED UP TO PRIORITIZE STREAMING (e.g. HBOMAX vs MAX burger)
    if (_matches(lowerDesc, [
      'bio',
      'sf bio',
      'filmstaden',
      'event',
      'konsert',
      'ticketmaster',
    ])) {
      // Was cinema, now gone. Put in Other or keep looking?
      // User removed cinema. Maybe 'Other'?
      // Actually user wanted 'Bio / event' under Nöje & fritid in the list, but then said "Remove this" for Subcategory.cinema.
      // Wait, let's re-read the interaction.
      // User list: "Bio / event" under Nöje.
      // Comments: "Selection: >Subcategory.cinema, Comment: 'Remove this'".
      // So no 'cinema' subcategory.
      // I should categorize these as... 'Other' in Entertainment? Or just 'Category.entertainment, Subcategory.other/unknown'.
      // I will put them in Subcategory.other for now.
      return (Category.entertainment, Subcategory.other);
    }
    if (_matches(lowerDesc, [
      'resor',
      'hotell',
      'booking',
      'airbnb',
      'bnb',
      'tågsemester',
      'vr resa',
    ])) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(lowerDesc, [
      'hobby',
      'panduro',
      'happy golfer',
      'k*ratsit.se',
      'ratsit.se',
    ])) {
      return (Category.entertainment, Subcategory.hobby);
    }
    if (_matches(lowerDesc, ['akademibokhande'])) {
      return (Category.entertainment, Subcategory.boardGamesBooksAndToys);
    }
    if (_matches(lowerDesc, ['snusbolaget'])) {
      return (Category.entertainment, Subcategory.snuff);
    }
    if (_matches(lowerDesc, ['nintendo'])) {
      return (Category.entertainment, Subcategory.videoGames);
    }
    if (_matches(lowerDesc, [
      'netflix',
      'spotify',
      'hbo',
      'viaplay',
      'tv4',
      'disney',
      'youtube',
      'apple music',
      'storytel',
      'audible',
      'amazon prime',
      'hbomax',
    ])) {
      return (Category.entertainment, Subcategory.streaming);
    }
    if (_matches(lowerDesc, [
      'dn ',
      'gp ',
      'svd',
      'di ',
      'klarna bonnier-local',
      'aftonbladet.se',
    ])) {
      return (Category.entertainment, Subcategory.newspapers);
    }

    // Food & Drink
    if (_matches(lowerDesc, [
      'interflora aktiebol',
      'marica roos',
      'avilena',
      'newport',
      'tz-shop',
      'euroflorist',
    ])) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(lowerDesc, [
      'ica',
      'willys',
      'coop',
      'hemköp',
      'lidl',
      'mathem',
      'city gross',
      'capris',
      'feskekorka',
      'hemkop',
      'hugo ericson ost i sal',
    ])) {
      return (Category.food, Subcategory.groceries);
    }
    if (_matches(lowerDesc, ['systembolaget'])) {
      return (Category.food, Subcategory.alcohol);
    }
    if (_matches(lowerDesc, ['foodora ab', 'indiska hornet'])) {
      return (Category.food, Subcategory.takeaway);
    }
    if (_matches(lowerDesc, ['masaki halsosushi ab'])) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(lowerDesc, [
      'beets salads bar',
      'beets',
      'holy greens',
      'joeandthejuice',
      'joe  the juice',
      'aldardo',
      's o larsson',
      'banh mi shop',
      'harmoni dumplings',
      'pastor - stora saluhal',
      'velic,ajla',
      'deli and coffee',
      'swish inbetalning sehlin,marianne',
      'saluhallen wrapsody',
      'mr shou',
      'bun gbg',
      'jinx dynasty',
      'hasselssons macklucka',
      'swish betalning ellen abenius',
      'zettle_*cheap noodles',
      'vietnam market',
    ])) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(lowerDesc, [
      'kitchen',
      'restaurant',
      'restaurang',
      'mat',
      'pizza',
      'burger',
      'starbucks',
      'foodora',
      'uber eats',
      'max ',
      'mcdonalds',
      'mcdvarbergnord',
      'voyage gbg ab',
      'chopchop',
      'enoteca sassi',
      'zettle_*jimmy   joan s',
      'skanshof',
      'storkoket i got',
      'toso',
      'vita duvan',
      'elio',
      'loco',
      'villa belparc',

    ])) {
      return (Category.food, Subcategory.restaurant);
    }

    if (_matches(lowerDesc, [
      'pub',
      'bar ',
      'öl',
      'vin',
      'the melody club',
      'park lane resta',
      'on air game shows swed',
      'champagnebaren',

    ])) {
      return (Category.entertainment, Subcategory.bar);
    }

    if (_matches(lowerDesc, [
      '7-eleven',
      'espresso house',
      'steinbrenner',
      'pressbyran',
      'direkten ostra sjukh',
      'condeco',
      'agnas glogg',
      'pp trading varm chokla',
      'brogyllen',
      'espresso', // Matches 'espresso house' too? No, checks contains from list. 'espresso house' is already in list separately. 'espresso' will catch both. Should be fine.
      '5151 ritazza st',
      '5151 ritazza st',
      'tehuset',
      'kaffelabbet',
      'stenugnsbageriet heden',

    ])) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(lowerDesc, ['mmsports', 'mm sports ab'])) {
      return (Category.health, Subcategory.supplements);
    }

    // Shopping
    if (_matches(lowerDesc, ['nk beauty', 'vacker nk', 'kicks', 'belle celine ab'])) {
      return (Category.shopping, Subcategory.beauty);
    }
    if (_matches(lowerDesc, ['nk kok & design', 'artilleriet store'])) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(lowerDesc, [
      'arket',
      'lampgrossen',
      'nk inredning',
      'hemtex',
      'ahlens',
      'bagaren och koc',
      'elboden',
    ])) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(lowerDesc, ['vasque kemtvatt'])) {
      return (Category.shopping, Subcategory.dryCleaning);
    }
    if (_matches(lowerDesc, [
      'nk ',
      'mq ',
      'åhlens',
      'hestra',
      'blomrum',
      'hm ',
      'h&m',
      'zara',
      'shopping',
      'kläder',
      'skor',
      'zalando',
      'asos',
      'boss gbg',
      'twist & tango',
      'widing o stollman',
      'livly',
      'stadium',
      'newbody ab',
      'j. lindeberg nk',
      'j. lindeberg nk',
      'autogiro k*rohnisch.c',
      'weekday',
      'weekday',
      'dressmann',
      'filippa k',
    ])) {
      return (Category.shopping, Subcategory.clothes);
    }
    if (_matches(lowerDesc, [
      'elgiganten',
      'inet',
      'webhallen',
      'amazon',
      'apple',
      'power',
      'netonnet',
    ])) {
      return (Category.shopping, Subcategory.electronics);
    }

    if (_matches(lowerDesc, [
      'clas ohlson',
      'clasohlson.com/se',
      'bauhaus',
      'jula',
      'biltema',
      'byggmax',
      'golvvarmeb',
    ])) {
      return (Category.shopping, Subcategory.tools);
    }

    if (_matches(lowerDesc, [
      'ikea',
      'mio',
      'rusta',
      'plantagen',
      'nordiskagalleriet',
    ])) {
      return (Category.shopping, Subcategory.furniture); // Approximation
    }

    // Transport
    if (_matches(lowerDesc, ['uber', 'bolt', 'taxi', 'voi se'])) {
      return (Category.transport, Subcategory.taxi);
    }
    if (_matches(lowerDesc, [
      'västtrafik',
      'vasttrafik',
      'sj ',
      'vy ',
      'skånetrafiken',
      'sl ',
      'arlanda express',
      'flygbussarna',
      'hallandstrafike',
      'styr  staell',
    ])) {
      return (Category.transport, Subcategory.publicTransport);
    }
    // Strict match for SL
    if (RegExp(r'\bSL\b', caseSensitive: false).hasMatch(description)) {
      return (Category.transport, Subcategory.publicTransport);
    }
    if (_matches(lowerDesc, [
      'bensin',
      'macken',
      'circle k',
      'st1',
      'preem',
      'okq8',
      'shell',
      'ingo',
    ])) {
      return (Category.transport, Subcategory.fuel);
    }
    if (_matches(lowerDesc, ['parkering', 'easypark', 'aimo', 'parkster'])) {
      return (Category.transport, Subcategory.parking);
    }

    // Health
    if (_matches(lowerDesc, [
      'fysiken',
      'sats',
      'nordic wellness',
      'fitness',
      'gym',
      'friskis',
      'nordicwell',
      'event booking (raceid)',
    ])) {
      return (Category.health, Subcategory.gym);
    }
    if (_matches(lowerDesc, ['apotek', 'kronans', 'doz', 'apotea'])) {
      return (Category.health, Subcategory.pharmacy);
    }
    if (_matches(lowerDesc, [
      'vård',
      'tandläkare',
      'karolinska',
      'sjukvård',
      'doctor',
      '1177',
      'capio',
      'idrottsrehab',
      'babyscreen',
      'eliasson psyk',
    ])) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(lowerDesc, ['sanna andrén', 'style barbershop'])) {
      return (Category.health, Subcategory.beauty);
    }

    // Housing (Boende)
    if (_matches(lowerDesc, ['höjdena brf', 'brf avgift', 'hsb'])) {
      return (Category.housing, Subcategory.brfFee);
    }
    if (_matches(lowerDesc, [
      'omsättning lån',
      'bolån',
      'bostadsrätt',
      'amortering',
      'sbab',
      'nordea lån',
    ])) {
      return (Category.housing, Subcategory.mortgage);
    }
    if (_matches(lowerDesc, [
      'göteborg energi',
      'ellevio',
      'vattenfall',
      'eon',
      'fortum',
      'gbg energi',
      'dinel',
    ])) {
      return (Category.housing, Subcategory.electricity);
    }
    if (_matches(lowerDesc, [
      'bahnhof',
      'comhem',
      'tele2 bredband',
      'telenor bredband',
      'tele2',
    ])) {
      return (Category.housing, Subcategory.broadband);
    }
    if (_matches(lowerDesc, [
      'hemförsäkring',
      'hedvig',
      'autogiro if skadeförs',
    ])) {
      return (Category.housing, Subcategory.homeInsurance);
    }
    if (_matches(lowerDesc, ['verisure'])) {
      return (Category.housing, Subcategory.security);
    }
    if (_matches(lowerDesc, ['factoringgrup'])) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }

    if (_matches(lowerDesc, ['renahus'])) {
      return (Category.housing, Subcategory.cleaning);
    }

    // Fees (Avgifter)
    if (_matches(lowerDesc, [
      'bankavgift',
      'prisplan',
      'kortavgift',
      'årsavgift',
      'avgift extra kort',
      'extrakortsavgift',
      'nordea vardagspaket',
    ])) {
      return (Category.fees, Subcategory.bankFees);
    }
    if (_matches(lowerDesc, ['bolagsverket'])) {
      return (Category.fees, Subcategory.jimHolding);
    }
    if (_matches(lowerDesc, ['boplats göteborg sw'])) {
      return (Category.fees, Subcategory.other);
    }
    if (_matches(lowerDesc, ['csn'])) {
      return (Category.fees, Subcategory.csn);
    }

    // Other / Admin
    if (_matches(lowerDesc, [
      'skatt',
      'skatteverket',
      'restskatt',
      'preliminär skatt',
    ])) {
      return (Category.fees, Subcategory.tax);
    }
    if (_matches(lowerDesc, ['telenor', 'telia', 'tre ', 'hallon', 'vimla'])) {
      return (Category.other, Subcategory.mobileSubscription);
    }
    if (_matches(lowerDesc, [
      'trygg-hansa',
      'if ',
      'folksam',
      'länsförsäkringar',
      'moderna',
      'ica försäkring',
      'nordea liv',
    ])) {
      return (Category.other, Subcategory.personalInsurance);
    }
    if (_matches(lowerDesc, ['fadder', 'gudmor lollo'])) {
      return (Category.other, Subcategory.godfather);
    }

    // Savings (Removed category, moved to Other)
    if (_matches(lowerDesc, ['avanza', 'lysa', 'spar', 'isk', 'torpa'])) {
      return (Category.other, Subcategory.other);
    }

    return (Category.other, Subcategory.unknown);
  }

  bool _matches(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
