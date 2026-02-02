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

    final specificOverride = _checkSpecificOverrides(description, amount, date);
    if (specificOverride != null) return specificOverride;

    final keywordRule = _checkKeywordRules(
      description,
      amount,
      date,
      lowerDesc,
    );
    if (keywordRule != null) return keywordRule;

    return (Category.other, Subcategory.unknown);
  }

  (Category, Subcategory)? _checkSpecificOverrides(
    String description,
    double amount,
    DateTime date,
  ) {
    // Specific Overrides
    if (_matches(description, ['NEWPORT']) &&
        (amount == -1032.5 || amount == 1032.5) &&
        date.year == 2026 &&
        date.month == 1 &&
        (date.day == 17 || date.day == 19)) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['NK KOK & DESIGN GBG']) &&
        (amount == -598.0 || amount == 598.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        (date.day == 17 || date.day == 19)) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['ARKET SE0702']) &&
        (amount == -149.0 || amount == 149.0)) {
       if (date.year == 2026 && date.month == 1 && (date.day == 16 || date.day == 19)) {
         return (Category.food, Subcategory.lunch);
       }
       if (date.year == 2026 && date.month == 1 && (date.day == 14 || date.day == 15)) {
         return (Category.food, Subcategory.lunch);
       }
    }

    if (_matches(description, ['Kortköp 250213 SP BLOMRUM']) &&
        (amount == -650.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 14) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['Kortköp 250213 KUNGS GOTTER']) &&
        (amount == -31.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 14) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning IDA BRUSBÄCK']) &&
        (amount == -145.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 11) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['POLISEN 1400 GO']) &&
        (amount == -500.00 || amount == 500.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        (date.day == 10 || date.day == 11)) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning ANDERS GUSTAFSSON']) &&
        (amount == -85.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 4) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Swish betalning VIKTORIA THOLANDER']) &&
        (amount == -90.00) &&
        date.year == 2025 &&
        date.month == 2 &&
        date.day == 3) {
      return (Category.food, Subcategory.restaurant);
    }

    if (_matches(description, ['GREEN EGG SP. Z O.O.']) &&
        (amount == -178.95) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 30) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Swish betalning Markus Bengtsson']) &&
        (amount == -1180.00) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 27) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['PARKERING GÖTEB']) &&
        (amount == -518.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 25) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['PARKERING GÖTEB']) &&
        (amount == -414.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 24) {
      return (Category.shopping, Subcategory.furniture);
    }
    if (_matches(description, ['BONNIER NEWS']) &&
        (amount == -9.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 24) {
      return (Category.entertainment, Subcategory.streaming);
    }
    if (_matches(description, ['LAGARDERE DUTY FREE G']) &&
        (amount == -26.71) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 30) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['MUZEUM BISTRO']) &&
        (amount == -17.36) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 30) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['APTEKA AKSAMITNA']) &&
        (amount == -101.2) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 29) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['SEXY SMASH']) &&
        (amount == -251.06) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 29) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['Swish betalning S R Larsson Charkut']) &&
        (amount == -89.00) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 28) {
      return (Category.food, Subcategory.groceries);
    }
    if (_matches(description, ['PRIME GRILL GOETEBORG']) &&
        (amount == -62.0) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 27) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Swish betalning GABRIELLA FOSSUM']) &&
        (amount == -100.00) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 27) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['WBDSPORTS']) &&
        (amount == -260.0) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 22) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['BODEGA PARTY']) &&
        (amount == -517.0) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 21) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['BODEGA PARTY']) &&
        (amount == -326.0) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 17) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['PINCHOS HEDEN']) &&
        (amount == -75.0) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 14) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(description, ['HEMMAKVÄLL HALM']) &&
        (amount == -23.9) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 8) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning Jonna Karlstedt']) &&
        (amount == -150.00) &&
        date.year == 2025 &&
        date.month == 3 &&
        date.day == 5) {
      return (Category.food, Subcategory.lunch);
    }

    if (_matches(description, ['Swish betalning LUNDBERG, CHARLOTTA']) &&
        amount == -155.00 &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 3) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(description, ['Open Banking BG 5734-9797 Patientfa']) &&
        amount == -100.00 &&
        date.year == 2025 &&
        date.month == 12 &&
        date.day == 22) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(description, ['SE0234;GOETEBORG']) &&
        amount == 552.98 &&
        date.year == 2025 &&
        date.month == 11 &&
        date.day == 15) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['STUDIO;GOTEBORG']) &&
        amount == 521.4 &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 11) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['LOOMISP*STAURANG VASTE;GOTEBORG']) &&
        // The request says 178, but typically these are matched by fuzzy description if needed
        // but here description is precise.
        amount == 178.0 &&
        date.year == 2025 &&
        date.month == 9 &&
        date.day == 6) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning FORTNOX FINANS AB']) &&
        amount == -1605.00 &&
        date.year == 2025 &&
        date.month == 8 &&
        date.day == 15) {
      return (Category.housing, Subcategory.cleaning);
    }
    if (_matches(description, ['Swish betalning BÄCK, NATALIE']) &&
        amount == -140.00 &&
        date.year == 2025 &&
        date.month == 8 &&
        date.day == 19) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Swish betalning DANIEL LENNARTSSON']) &&
        amount == -400.00 &&
        date.year == 2025 &&
        date.month == 8 &&
        date.day == 23) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Swish betalning LINDSTRÖM,VENDELA']) &&
        amount == -689.50 &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 31) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['GOTO HUB AB;HELSINGBORG']) &&
        amount == 1170.0 &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 17) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['Swish betalning GÖRAN BENGTSSON']) &&
        amount == -85.00 &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 13) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['ZETTLE_*TVELINGEN AB;GOTEBORG']) &&
        amount == 165.0 &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 12) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['2352 5694 01 75741']) &&
        amount == -3100.00 &&
        date.year == 2025 &&
        date.month == 10 &&
        date.day == 21) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(description, ['2326 5694 01 75741']) &&
        amount == -3500.00 &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 8) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(description, ['STORSTUGAN;FJARAS']) &&
        amount == 430.0 &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 1) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Swish betalning DUMAN MELIS']) &&
        amount == -1170.00 &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 29) {
      return (Category.health, Subcategory.beauty);
    }
    if (_matches(description, ['1år - Lollo 95576770341']) &&
        amount == -300.00 &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 7) {
      return (Category.other, Subcategory.godfather);
    }
    if (_matches(description, ['2303 5694 01 75741']) &&
        amount == -5344.00 &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 1) {
      return (Category.health, Subcategory.doctor);
    }

    if (_matches(description, ['Swish betalning Viktor Melin']) &&
        (amount == -60.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 29) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning JOAKIM SUNDLING']) &&
        (amount == -1060.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 29) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['OCHE GOETEBORG AB']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 29) {
      return (Category.food, Subcategory.restaurant);
    }
    // Use strict date/amount for overrides to be safe
    if (_matches(description, ['Swish betalning ANDERSSON,JOHANNA']) &&
        (amount == -220.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 26) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning LUKAS FOUGHMAN']) &&
        (amount == -170.50) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 26) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning RAGNAR, MIRANDA']) &&
        (amount == -500.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 26) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Bankomat kl 09.48 250622']) &&
        (amount == -500.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 23) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['VALLGATAN 12 FA']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 19) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['Swish betalning LEJON,MIKAEL']) &&
        date.year == 2025 &&
        date.month == 6) {
      if (date.day == 16 && amount == -230.00) {
        return (Category.other, Subcategory.other);
      }
      if (date.day == 13 && amount == -585.00) {
        return (Category.other, Subcategory.other);
      }
    }
    if (_matches(description, ['ULLEVI KONFEREN']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 13) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning JOHAN ROOS']) &&
        (amount == -1200.00) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 13) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['KITCHENS.SE']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 10) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['SYSTRAR OVAS AB']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 8) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['HASSELBACKEN']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 4) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['ZETTLE_*VILLA ODINSLUN']) &&
        date.year == 2025 &&
        date.month == 6 &&
        date.day == 1) {
      return (Category.other, Subcategory.other);
    }

    if (_matches(description, ['Swish betalning STRANDVERKET I MARS']) &&
        (amount == -20.00) &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 12) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning GABRIELLA FOSSUM']) &&
        (amount == -525.00) &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 3) {
      return (Category.other, Subcategory.other);
    }

    if (_matches(description, ['ROGER NILSSON STAVERSH']) &&
        (amount == 120.0 || amount == -120.0) &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 18) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['W*ROYALDESIGN.SE']) &&
        (amount == 4668.0 || amount == -4668.0) &&
        date.year == 2025 &&
        date.month == 7 &&
        date.day == 5) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['Kortköp 250625 SVEA BANK AB'])) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }

    if (_matches(description, ['Kortköp 250425 4051 WHS LS GOT']) &&
        (amount == -45.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 28) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Q*HTTPS://WWW.DAMMS']) &&
        // No amount check in request, but date check is good practice
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 27) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Swish betalning KARTAL,MIA']) &&
        (amount == -180.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 21) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning RAGNAR, MIRANDA']) &&
        (amount == -300.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 19) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['BJELIN SWEDEN AB']) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 18) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['Swish betalning NATALIE THORSSON RO']) &&
        (amount == -150.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 8) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Autogiro K*partykunge']) &&
        (amount == -368.70) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 8) {
      return (Category.shopping, Subcategory.other);
    }
    if (_matches(description, ['ZETTLE_*BLIGHTY FOOD C']) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 5) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['UNHCR']) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 5) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['ELGIGANTEN.SE']) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 5) {
      // Logic for this specific date ONLY, otherwise Elgiganten is usually Shopping/Electronics
      return (Category.entertainment, Subcategory.videoGames);
    }
    if (_matches(description, ['Swish betalning RICKARD LINDBLAD VO']) &&
        (amount == -3750.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 3) {
      return (Category.entertainment, Subcategory.travel);
    }
    if (_matches(description, ['Swish betalning Cecilia Kihlén']) &&
        (amount == -3390.00) &&
        date.year == 2025 &&
        date.month == 4 &&
        date.day == 3) {
      return (Category.entertainment, Subcategory.other);
    }

    if (_matches(description, ['VALLGATAN 12 FA']) &&
        (amount == -5499) &&
        date.year == 2025 && // 2025-05-30
        date.month == 5 &&
        date.day == 30) {
      return (Category.shopping, Subcategory.gifts);
    }
    if (_matches(description, ['KARMA']) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 29) {
      if (amount == -255.0) return (Category.food, Subcategory.restaurant);
      if (amount == -189.0) return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Open Banking BG 133-3087 Allgas CMS']) &&
        (amount == -2665.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 28) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['UNLMTED W/DR JOE DISPE']) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 25) {
      // Amount differs in request description vs logic sometimes, but description is unique enough here with date
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(description, ['KARAOKE-VERSION']) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 24) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['STATION LINNE 1']) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 21) {
      if (amount == -105.0) return (Category.food, Subcategory.restaurant);
      if (amount == -295.0) return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Swish betalning RAGNAR, MIRANDA']) &&
        (amount == -200.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 20) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning Lukas Gustavsson']) &&
        (amount == -100.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 19) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['TIPTAPP.CO* TIPTAPP.CO']) &&
        (amount == -789.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 18) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    // VALLGATAN 12 FA override #2
    if (_matches(description, ['VALLGATAN 12 FA']) &&
        (amount == -750.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 17) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(description, ['Swish betalning Thomas Boussard']) &&
        (amount == -145.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 14) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Autogiro K*flottegulv']) &&
        (amount == -145.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 13) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['EDO SUSHI I GOTEBORG A']) &&
        (amount == -99.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 12) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['Swish betalning GABRIELLA FOSSUM']) &&
        (amount == -40.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 8) {
      return (Category.other, Subcategory.other);
    }
    if (_matches(description, ['Swish betalning LINDSTRÖM,VENDELA']) &&
        (amount == -145.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 7) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['BSH HOME APPLIANCES AB']) &&
        (amount == -3807.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 7) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['BAMBA']) &&
        (amount == -330.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 7) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['O/O BAR']) &&
        (amount == -95.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 7) {
      return (Category.food, Subcategory.restaurant);
    }
    if (_matches(description, ['Swish betalning EMMA NIRVIN']) &&
        (amount == -130.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 5) {
      return (Category.food, Subcategory.lunch);
    }
    if (_matches(description, ['KLARNA*BESLAGONLINE.']) &&
        (amount == -7164.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 1) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['KLARNA*VITVARUEXPERT'])) {
      return (Category.housing, Subcategory.kitchenRenovation);
    }
    if (_matches(description, ['MATSAL STORGATA']) &&
        (amount == -480.0) &&
        date.year == 2025 &&
        date.month == 5 &&
        date.day == 1) {
      return (Category.food, Subcategory.restaurant);
    }

    if (_matches(description, ['Kortköp 250726 LEXINGTON HOME GOT']) &&
        (amount == -498.00)) {
      if (date.year == 2025 && date.month == 7 && date.day == 28) {
        return (Category.shopping, Subcategory.decor);
      }
    }
    if (_matches(description, ['LEKIA KUNGSGATAN']) && (amount == -304.0)) {
      if (date.year == 2025 && date.month == 7 && date.day == 27) {
        return (Category.shopping, Subcategory.gifts);
      }
    }
    if (_matches(description, ['Swish inbetalning JOAKIM MALMQVIST']) &&
        (amount == 2000.00)) {
      if (date.year == 2025 && date.month == 7 && date.day == 26) {
        return (Category.income, Subcategory.kitchenRenovation);
      }
    }
    if (_matches(description, ['Swish betalning LUCAS MALINA']) &&
        (amount == -200.00)) {
      if (date.year == 2025 && date.month == 7 && date.day == 23) {
        return (Category.other, Subcategory.other);
      }
    }
    if (_matches(description, ['Insättning']) && (amount == 400000.00)) {
      if (date.year == 2025 && date.month == 2 && date.day == 3) {
        return (Category.income, Subcategory.loan);
      }
    }

    if (_matches(description, ['Swish inbetalning SADIQ MAMAND']) &&
        (amount == 2600.00 || amount == -2600.00)) {
      // Allowing both for safety, but request was positive 2600,00
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
    if (_matches(description, ['SVEA*ALSENS.COM']) && (amount == -116.0)) {
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

    if (_matches(description, ['Swish betalning LUCAS MALINA']) &&
        (amount == -500.0) &&
        date.year == 2026 &&
        date.month == 1 &&
        date.day == 6) {
      return (Category.other, Subcategory.other);
    }

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
    if (_matches(description, ['GOTEBORGSVARVET'])) {
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
      return (Category.food, Subcategory.restaurant);
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

    return null;
  }

  (Category, Subcategory)? _checkKeywordRules(
    String description,
    double amount,
    DateTime date,
    String lowerDesc,
  ) {
    // --- Income (> 0) ---
    if (amount > 0) {
      if (_matches(lowerDesc, ['lön', 'salary'])) {
        return (Category.income, Subcategory.salary);
      }
      if (_matches(description, ['Swish inbetalning LINN RHEGALLÈ'])) {
        return (Category.income, Subcategory.kitchenRenovation);
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

    if (_matches(lowerDesc, ['pottan - götebo'])) {
      return (Category.other, Subcategory.other);
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
      'sj.se',
      'fc helsing@r',
      'aurora',
      'stromma sweden',
      'torpa',
      'klub parlament xi',
      'sj app',
      'vr snabbtåg sverige',
    ])) {
      return (Category.entertainment, Subcategory.travel);
    }

    if (_matches(lowerDesc, [
      'hobby',
      'panduro',
      'happy golfer',
      'k*ratsit.se',
      'ratsit.se',
      'norrviken',
      'paintballfabriken',
    ])) {
      return (Category.entertainment, Subcategory.hobby);
    }
    if (_matches(lowerDesc, [
      'akademibokhande',
      'bokus.com',
    ])) {
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
      'help.max.com',
    ])) {
      return (Category.entertainment, Subcategory.streaming);
    }
    if (_matches(description, ['SWAY'])) {
      return (Category.food, Subcategory.restaurant);
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
      'loomisp*laterian goteb',
      'los churros wafels',
      'bar centro',
      'loomisp*cafe kvarnpire',
    ])) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(lowerDesc, [
      'dubbel dubbel surbrunn',
      'restoria ab - dinner',
    ])) {
      return (Category.food, Subcategory.restaurant);
    }

    if (_matches(lowerDesc, [
      'interflora aktiebol',
      'marica roos',
      'avilena',
      'newport',
      'tz-shop',
      'euroflorist',
      'lekia',
      'betalning bg 5597-7003 sportdansklu',
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
      'krabbesk{rs fisk',
      'swish betalning willy:s ab',
      'netto',
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
      'jos halsocafe ab',
      'poke corner',
      'pho kim',
      'sunset falafel',
      'deli och coffee',
      'hasselbacken',
      'mu thai street food',
      'swish betalning karlsson andersson',
    ])) {
      return (Category.food, Subcategory.lunch);
    }

    if (_matches(lowerDesc, [
      'kitchen',
      'restaurant',
      'restaurang',
      //      'mat', // Moved to strict match
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
      'nonna',
      'benne pasta',
      'bastad hamnrestauran',
      'topeja bjäre ab',
      'v[rftets madmar',
      'nordsjallands v',
      'axelhus bodega',
      'familjen pax',
      'familjen orrmyr',
      'chicca belloni',
      'collage',
      'mugwort s bbq shack',
      'al banco pasta',
      'gumman elvira',
      'kajutan saluhallen',
      'blighty food connectio',
      'zettle_*villa odinslun',
      'brasserie isabelle',
      'barabicu',
      'storköket i göt',
      'olivia goteborg',
      'mcd landvetter',
      'puta madre/basque',
      'fiskekrogen',
      'moonglow',
      'jeppes familjekrog ab',
      'swish betalning happy order ab',
      'the hills stock',
      'ma cuisine',
      'caspeco',
      'made in china',
    ])) {
      return (Category.food, Subcategory.restaurant);
    }

    // Strict match for 'mat' to avoid matching 'Bankomat'
    // Strict match for 'mat' to avoid matching 'Bankomat'
    if (RegExp(r'\bmat\b', caseSensitive: false).hasMatch(description)) {
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
      'zamenhof',
      'clarion hotel post',
      'feskekoerkan', // Can be market hall but user requested bar
      'station linne 1', // From Override
      'o/o bar', // From Override
      'evion hotell &', // From Override
      'kopps',
    ])) {
      return (Category.food, Subcategory.restaurant);
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
      'da matteo - magasinsga',
      'gelato',
    ])) {
      return (Category.food, Subcategory.coffee);
    }
    if (_matches(lowerDesc, ['mmsports', 'mm sports ab'])) {
      return (Category.health, Subcategory.supplements);
    }

    // Shopping
    if (_matches(lowerDesc, [
      'nk beauty',
      'vacker nk',
      'kicks',
      'belle celine ab',
      'kicks',
      'belle celine ab',
    ])) {
      return (Category.shopping, Subcategory.beauty);
    }
    if (_matches(lowerDesc, [
      'remanns hogtidsklade',
      'twilfit ab',
      'sneaky steve',
    ])) {
      return (Category.shopping, Subcategory.clothes);
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
      'althallensfargtapetera',
      'bga.se',
      'jotex sweden ab',
    ])) {
      return (Category.shopping, Subcategory.decor);
    }
    if (_matches(lowerDesc, ['vasque kemtvatt'])) {
      return (Category.shopping, Subcategory.other);
    }

    // Strict match for NK to avoid matching "BANK"
    if (RegExp(r'\bnk\b', caseSensitive: false).hasMatch(description)) {
      return (Category.shopping, Subcategory.clothes);
    }

    if (_matches(lowerDesc, [
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
      'ginatricot',
      'bymalina',
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
      'hornbach',
      'flugger ab',
    ])) {
      return (Category.shopping, Subcategory.tools);
    }

    if (_matches(lowerDesc, ['majblommans riksför'])) {
      return (Category.shopping, Subcategory.other);
    }

    if (_matches(lowerDesc, ['adoore', 'uniqlo gothenburg'])) {
      return (Category.shopping, Subcategory.clothes);
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
      'nextbikese',
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
      'naturalcycles',
    ])) {
      return (Category.health, Subcategory.doctor);
    }
    if (_matches(lowerDesc, [
      'sanna andrén',
      'style barbershop',
      'beauty style va',
    ])) {
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
      'betalning bg 5835-1552 göteborg ene',
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
    if (_matches(lowerDesc, [
      'factoringgrup',
      'betalning bg 5212-1548 platsbyggda',
      'betalning bg 5368-4833 a & o marmor',
      'swish betalning daniel esmati',
    ])) {
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
    if (_matches(lowerDesc, ['csn', 'betalning bg 5591-9021 centrala stu'])) {
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
    if (_matches(lowerDesc, [
      'telenor',
      'telia',
      'tre ',
      'hallon',
      'vimla',
      'google one',
    ])) {
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

    if (_matches(lowerDesc, [
      'avanza',
      'lysa',
      'spar',
      'isk',
      'lastpass.com',
    ])) {
      return (Category.other, Subcategory.other);
    }

    return null;
  }

  bool _matches(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
