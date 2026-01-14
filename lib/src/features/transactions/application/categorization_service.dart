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
      return (Category.income, Subcategory.other); // Defaults to "Övrigt"
    }

    // --- Expenses (<= 0) ---
    
    // Food & Drink
    if (_matches(lowerDesc, ['ica', 'willys', 'coop', 'hemköp', 'lidl'])) {
      return (Category.food, Subcategory.groceries);
    }
    if (_matches(lowerDesc, ['systembolaget', 'kitchen', 'restaurant', 'restaurang', 'mat', 'pizza', 'burger', 'espresso', 'starbucks', 'foodora', 'uber eats'])) {
      return (Category.food, Subcategory.restaurant);
    }

    // Shopping
    if (_matches(lowerDesc, ['nk ', 'mq ', 'åhlens', 'hestra', 'blomrum', 'hm ', 'h&m', 'zara', 'shopping', 'kläder', 'skor'])) {
      return (Category.shopping, Subcategory.clothes);
    }
    if (_matches(lowerDesc, ['elgiganten', 'inet', 'webhallen', 'amazon', 'apple'])) {
      return (Category.shopping, Subcategory.electronics);
    }
    if (_matches(lowerDesc, ['ikea', 'bauhaus', 'jula', 'clas ohlson'])) {
      return (Category.shopping, Subcategory.home);
    }

    // Transport
    if (_matches(lowerDesc, ['uber', 'bolt', 'taxi'])) {
      return (Category.transport, Subcategory.taxi);
    }
    if (_matches(lowerDesc, ['västtrafik', 'sj ', 'vy ', 'skånetrafiken', 'sl '])) {
      return (Category.transport, Subcategory.publicTransport);
    }
    if (_matches(lowerDesc, ['bensin', 'macken', 'circle k', 'st1', 'preem', 'okq8'])) {
      return (Category.transport, Subcategory.fuel);
    }
    if (_matches(lowerDesc, ['parkering', 'easypark', 'aimo'])) {
      return (Category.transport, Subcategory.parking);
    }

    // Health
    if (_matches(lowerDesc, ['fysiken', 'sats', 'nordic wellness', 'fitness', 'gym'])) {
      return (Category.health, Subcategory.gym);
    }
    if (_matches(lowerDesc, ['apotek'])) {
      return (Category.health, Subcategory.pharmacy);
    }
    if (_matches(lowerDesc, ['vård', 'tandläkare', 'karolinska', 'sjukvård', 'doctor'])) {
      return (Category.health, Subcategory.doctor);
    }

    // Loans & BRF
    if (_matches(lowerDesc, ['omsättning lån', 'höjdena brf', 'bolån', 'brf avgift', 'bostadsrätt', 'amortering'])) {
      return (Category.loansAndBrf, Subcategory.unknown);
    }

    // Bills
    if (_matches(lowerDesc, ['netflix', 'spotify', 'hbo', 'viaplay', 'tv4', 'disney', 'youtube'])) {
      return (Category.bills, Subcategory.streaming);
    }
    if (_matches(lowerDesc, ['tele2', 'telenor', 'telia', 'tre ', 'hallon'])) {
      return (Category.bills, Subcategory.phone);
    }
    if (_matches(lowerDesc, ['trygg-hansa', 'if ', 'folksam', 'länsförsäkringar'])) {
      return (Category.bills, Subcategory.insurance);
    }
    if (_matches(lowerDesc, ['göteborg energi', 'ellevio', 'vattenfall'])) {
      return (Category.bills, Subcategory.electricity);
    }
    if (_matches(lowerDesc, ['bahnhof', 'comhem'])) {
      return (Category.bills, Subcategory.internet);
    }
    if (_matches(lowerDesc, ['nordea', 'csn', 'bolagsverket', 'skatt'])) {
      return (Category.bills, Subcategory.unknown);
    }

    // Savings
    if (_matches(lowerDesc, ['avanza', 'lysa', 'spar', 'isk'])) {
      return (Category.savings, Subcategory.unknown);
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
