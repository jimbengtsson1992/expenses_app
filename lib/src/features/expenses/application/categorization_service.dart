import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/category.dart';

part 'categorization_service.g.dart';

@riverpod
CategorizationService categorizationService(Ref ref) {
  return CategorizationService();
}

class CategorizationService {
  Category categorize(String description, double amount) {
    final lowerDesc = description.toLowerCase();

    // Income overrides
    if (lowerDesc.contains('lön') && !lowerDesc.contains('överföring')) return Category.income;
    if (lowerDesc.contains('insättning')) return Category.income;
    if (amount > 0 && !lowerDesc.contains('överföring') && !lowerDesc.contains('betalning')) {
       // Positive amount usually means income or refund. 
       // If it's a refund, it might be better to keep original category? 
       // For now, let's treat large positive as income?
       // The user said "Income from input files".
       // Let's stick to "Lön" and "Insättning" for explicit income, 
       // and maybe 'return' items are just negative expenses (positive value).
       // Actually, in the app, Expense amount is usually positive in UI, but logic-wise:
       // If I spend 100, amount is -100.
       // Only specifically 'Lön' is Real Income.
    }

    // Food & Drink
    if (_matches(lowerDesc, ['ica', 'willys', 'coop', 'hemköp', 'lidl', 'systembolaget', 'kitchen', 'restaurant', 'mat', 'pizza', 'burger', 'espresso', 'starbucks', 'foodora', 'uber eats'])) {
      return Category.food;
    }

    // Shopping
    if (_matches(lowerDesc, ['nk ', 'mq ', 'åhlens', 'hestra', 'blomrum', 'hm ', 'zara', 'shopping', 'kläder', 'skor', 'ikea', 'bauhaus', 'jula', 'clas ohlson', 'elgiganten', 'inet', 'webhallen', 'amazon'])) {
      return Category.shopping;
    }

    // Transport
    if (_matches(lowerDesc, ['västtrafik', 'uber', 'bolt', 'parkering', 'bensin', 'macken', 'circle k', 'st1', 'sj ', 'vy '])) {
      return Category.transport;
    }

    // Health
    if (_matches(lowerDesc, ['fysiken', 'sats', 'nordic wellness', 'apotek', 'vård', 'tandläkare', 'karolinska', 'sjukvård', 'doctor'])) {
      return Category.health;
    }

    // Bills
    if (_matches(lowerDesc, ['nordea', 'csn', 'bolagsverket', 'skatt', 'försäkring', 'trygg-hansa', 'if ', 'folksam', 'tele2', 'telenor', 'telia', 'tre ', 'netflix', 'spotify', 'hbo', 'viaplay', 'tv4', 'disney'])) {
      return Category.bills;
    }

    // Savings
    if (_matches(lowerDesc, ['avanza', 'lysa', 'spar', 'isk'])) {
      return Category.savings;
    }

    return Category.other;
  }

  bool _matches(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
