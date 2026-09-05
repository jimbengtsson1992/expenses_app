import 'subcategory.dart';

enum Category {
  housing('Boende', 0xFF795548, '🏠', [
    Subcategory.brfFee,
    Subcategory.mortgage,
    Subcategory.electricity,
    Subcategory.homeInsurance,
    Subcategory.security,
    Subcategory.broadband,
    Subcategory.cleaning,
    Subcategory.kitchenRenovation,
    Subcategory.renovation,
    Subcategory.other,
  ]),

  food('Mat & Dryck', 0xFF4CAF50, '🍔', [
    Subcategory.groceries,
    Subcategory.restaurant,
    Subcategory.lunch,
    Subcategory.takeaway,
    Subcategory.alcohol,
    Subcategory.coffee,
    Subcategory.other,
  ]),

  shopping('Shopping', 0xFFE91E63, '🛍️', [
    Subcategory.clothes,
    Subcategory.electronics,
    Subcategory.furniture,
    Subcategory.gifts,
    Subcategory.decor,
    Subcategory.beauty,
    Subcategory.tools,
    Subcategory.baby,
    Subcategory.other,
  ]),

  entertainment('Nöje & Fritid', 0xFF9C27B0, '🎉', [
    Subcategory.travel,
    Subcategory.hobby,
    Subcategory.boardGamesBooksAndToys,
    Subcategory.newspapers,
    Subcategory.streamingAndPrenumerations,
    Subcategory.videoGames,
    Subcategory.other,
  ]),

  health('Hälsa', 0xFF2196F3, '💪', [
    Subcategory.gym,
    Subcategory.pharmacy,
    Subcategory.doctor,
    Subcategory.beauty,
    Subcategory.supplements,
    Subcategory.other,
  ]),

  fees('Avgifter', 0xFFF44336, '💳', [
    Subcategory.bankFees,
    Subcategory.tax,
    Subcategory.csn,
    Subcategory.jimHolding,
    Subcategory.other,
  ]),

  transport('Transport', 0xFFFF9800, '🚌', [
    Subcategory.taxi,
    Subcategory.publicTransport,
    Subcategory.car,
    Subcategory.fuel,
    Subcategory.parking,
    Subcategory.congestionTax,
    Subcategory.other,
  ]),

  income('Inkomst', 0xFF009688, '💰', [
    Subcategory.salary,
    Subcategory.interest,
    Subcategory.loan,
    Subcategory.childBenefit,
    Subcategory.parentalBenefit,
    Subcategory.tax,
    Subcategory.kitchenRenovation,
    Subcategory.other,
  ]),

  other('Övrigt', 0xFF9E9E9E, '🧹', [
    Subcategory.personalInsurance,
    Subcategory.godfather,
    Subcategory.mobileSubscription,
    Subcategory.unknown,
    Subcategory.other,
  ]);

  const Category(
    this.displayName,
    this.colorValue,
    this.emoji,
    this.subcategories,
  );
  final String displayName;
  final int colorValue;
  final String emoji;
  final List<Subcategory> subcategories;
}
