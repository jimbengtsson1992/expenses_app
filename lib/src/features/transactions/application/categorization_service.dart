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
      'tågsemester',
    ])) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(lowerDesc, ['hobby', 'panduro', 'happy golfer', 'k*ratsit.se', 'ratsit.se'])) {
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
    if (_matches(lowerDesc, ['interflora aktiebol', 'marica roos', 'avilena', 'newport', 'tz-shop'])) {
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
    ])) {
      return (Category.food, Subcategory.groceries);
    }
    if (_matches(lowerDesc, ['systembolaget'])) {
      return (Category.food, Subcategory.alcohol);
    }
    if (_matches(lowerDesc, [
      'foodora ab',
      'pastor - stora saluhal',
      'masaki halsosushi ab',
    ])) {
      return (Category.food, Subcategory.takeaway);
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
    ])) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(lowerDesc, ['pub', 'bar ', 'öl', 'vin', 'the melody club'])) {
      return (Category.food, Subcategory.bar);
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
    ])) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(lowerDesc, ['mmsports', 'mm sports ab'])) {
      return (Category.food, Subcategory.supplements);
    }

    // Shopping
    if (_matches(lowerDesc, ['nk beauty', 'vacker nk', 'kicks'])) {
      return (Category.shopping, Subcategory.beauty);
    }
    if (_matches(lowerDesc, ['nk kok & design'])) {
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
      'bauhaus',
      'jula',
      'biltema',
      'byggmax',
      'golvvarmeb',
    ])) {
      return (Category.shopping, Subcategory.tools);
    }

    if (_matches(lowerDesc, ['ikea', 'mio', 'rusta', 'plantagen'])) {
      return (Category.shopping, Subcategory.furniture); // Approximation
    }

    // Transport
    if (_matches(lowerDesc, ['uber', 'bolt', 'taxi'])) {
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
    ])) {
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
    ])) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(lowerDesc, ['sanna andrén'])) {
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
      'nordea vardagspaket',
    ])) {
      return (Category.fees, Subcategory.bankFees);
    }
    if (_matches(lowerDesc, ['boplats göteborg sw', 'bolagsverket'])) {
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
    if (_matches(lowerDesc, ['avanza', 'lysa', 'spar', 'isk'])) {
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
