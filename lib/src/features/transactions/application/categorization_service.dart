import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';

part 'categorization_service.g.dart';

@riverpod
CategorizationService categorizationService(Ref ref) {
  return CategorizationService();
}

class CategorizationService {
  (Category, Subcategory) categorize(String description, double amount) {
    final lowerDesc = description.toLowerCase();

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
    
    // Food & Drink
    if (_matches(lowerDesc, ['ica', 'willys', 'coop', 'hemköp', 'lidl', 'mathem', 'city gross', 'capris'])) {
      return (Category.food, Subcategory.groceries);
    }
    if (_matches(lowerDesc, ['systembolaget'])) {
      return (Category.food, Subcategory.alcohol);
    }
    if (_matches(lowerDesc, ['kitchen', 'restaurant', 'restaurang', 'mat', 'pizza', 'burger', 'espresso', 'starbucks', 'foodora', 'uber eats', 'max ', 'mcdonalds'])) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(lowerDesc, ['pub', 'bar ', 'öl', 'vin'])) {
      return (Category.food, Subcategory.bar);
    }
    if (_matches(lowerDesc, ['7-eleven'])) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(lowerDesc, ['mmsports'])) {
      return (Category.food, Subcategory.supplements);
    }

    // Shopping
    if (_matches(lowerDesc, ['nk ', 'mq ', 'åhlens', 'hestra', 'blomrum', 'hm ', 'h&m', 'zara', 'shopping', 'kläder', 'skor', 'zalando', 'asos'])) {
      return (Category.shopping, Subcategory.clothes);
    }
    if (_matches(lowerDesc, ['elgiganten', 'inet', 'webhallen', 'amazon', 'apple', 'power', 'netonnet'])) {
      return (Category.shopping, Subcategory.electronics);
    }
    if (_matches(lowerDesc, ['ikea', 'bauhaus', 'jula', 'clas ohlson', 'mio', 'rusta', 'plantagen'])) {
      return (Category.shopping, Subcategory.furniture); // Approximation
    }

    // Transport
    if (_matches(lowerDesc, ['uber', 'bolt', 'taxi'])) {
      return (Category.transport, Subcategory.taxi);
    }
    if (_matches(lowerDesc, ['västtrafik', 'vasttrafik', 'sj ', 'vy ', 'skånetrafiken', 'sl ', 'arlanda express', 'flygbussarna'])) {
      return (Category.transport, Subcategory.publicTransport);
    }
    if (_matches(lowerDesc, ['bensin', 'macken', 'circle k', 'st1', 'preem', 'okq8', 'shell', 'ingo'])) {
      return (Category.transport, Subcategory.fuel);
    }
    if (_matches(lowerDesc, ['parkering', 'easypark', 'aimo', 'parkster'])) {
      return (Category.transport, Subcategory.parking);
    }

    // Health
    if (_matches(lowerDesc, ['fysiken', 'sats', 'nordic wellness', 'fitness', 'gym', 'friskis'])) {
      return (Category.health, Subcategory.gym);
    }
    if (_matches(lowerDesc, ['apotek', 'kronans', 'doz'])) {
      return (Category.health, Subcategory.pharmacy);
    }
    if (_matches(lowerDesc, ['vård', 'tandläkare', 'karolinska', 'sjukvård', 'doctor', '1177', 'capio'])) {
      return (Category.health, Subcategory.doctor);
    }

    // Housing (Boende)
    if (_matches(lowerDesc, ['höjdena brf', 'brf avgift', 'hsb'])) {
      return (Category.housing, Subcategory.brfFee);
    }
    if (_matches(lowerDesc, ['omsättning lån', 'bolån', 'bostadsrätt', 'amortering', 'sbab', 'nordea lån'])) {
      return (Category.housing, Subcategory.mortgage);
    }
    if (_matches(lowerDesc, ['göteborg energi', 'ellevio', 'vattenfall', 'eon', 'fortum'])) {
      return (Category.housing, Subcategory.electricity);
    }
    if (_matches(lowerDesc, ['bahnhof', 'comhem', 'tele2 bredband', 'telenor bredband'])) {
      return (Category.housing, Subcategory.broadband);
    }
    if (_matches(lowerDesc, ['hemförsäkring', 'hedvig'])) {
      return (Category.housing, Subcategory.homeInsurance);
    }


    // Fees (Avgifter)
    if (_matches(lowerDesc, ['bankavgift', 'prisplan', 'kortavgift', 'årsavgift'])) {
      return (Category.fees, Subcategory.bankFees);
    }
    
    // Other / Admin
    if (_matches(lowerDesc, ['skatt', 'skatteverket', 'restskatt'])) {
      return (Category.other, Subcategory.tax);
    }
    if (_matches(lowerDesc, ['tele2', 'telenor', 'telia', 'tre ', 'hallon', 'vimla'])) {
      return (Category.other, Subcategory.mobileSubscription);
    }
    if (_matches(lowerDesc, ['trygg-hansa', 'if ', 'folksam', 'länsförsäkringar', 'moderna', 'ica försäkring'])) {
      return (Category.other, Subcategory.personalInsurance);
    }

    // Entertainment (Nöje & fritid)
    if (_matches(lowerDesc, ['bio', 'sf bio', 'filmstaden', 'event', 'konsert', 'ticketmaster'])) {
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
     if (_matches(lowerDesc, ['resor', 'hotell', 'booking', 'airbnb', 'tågsemester'])) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(lowerDesc, ['hobby', 'panduro'])) {
      return (Category.entertainment, Subcategory.hobby);
    }
    if (_matches(lowerDesc, ['akademibokhande'])) {
      return (Category.entertainment, Subcategory.boardGamesBooksAndToys);
    }
    if (_matches(lowerDesc, ['snusbolaget'])) {
      return (Category.entertainment, Subcategory.snuff);
    }
    if (_matches(lowerDesc, ['netflix', 'spotify', 'hbo', 'viaplay', 'tv4', 'disney', 'youtube', 'apple music', 'storytel', 'audible'])) {
      return (Category.entertainment, Subcategory.streaming);
    }
    if (_matches(lowerDesc, ['dn ', 'gp ', 'svd', 'di '])) {
      return (Category.entertainment, Subcategory.newspapers);
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
