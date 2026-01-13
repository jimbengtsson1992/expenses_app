import 'subcategory.dart';

enum Category {
  food('Mat & Dryck', 0xFF4CAF50, '🍔', [
    Subcategory.groceries,
    Subcategory.restaurant,
    Subcategory.unknown,
  ]),
  shopping('Shopping', 0xFFE91E63, '🛍️', [
    Subcategory.clothes,
    Subcategory.electronics,
    Subcategory.home,
    Subcategory.unknown,
  ]),
  transport('Transport', 0xFFFF9800, '🚌', [
    Subcategory.taxi,
    Subcategory.publicTransport,
    Subcategory.car,
    Subcategory.fuel,
    Subcategory.parking,
    Subcategory.unknown,
  ]),
  health('Hälsa & Träning', 0xFF2196F3, '💪', [
    Subcategory.gym,
    Subcategory.pharmacy,
    Subcategory.doctor,
  ]),
  bills('Räkningar & Bank', 0xFF607D8B, '📄', [
    Subcategory.streaming,
    Subcategory.electricity,
    Subcategory.internet,
    Subcategory.phone,
    Subcategory.insurance,
    Subcategory.unknown,
  ]),
  savings('Sparande', 0xFF9C27B0, '💰', [Subcategory.unknown]),
  income('Inkomst', 0xFF009688, '💵', [
    Subcategory.salary,
    Subcategory.otherIncome,
    Subcategory.unknown,
  ]),
  loansAndBrf('Lån & BRF', 0xFF795548, '🏘️', [Subcategory.unknown]),
  other('Övrigt', 0xFF9E9E9E, '❓', [Subcategory.unknown]);

  const Category(this.displayName, this.colorValue, this.emoji, this.subcategories);
  final String displayName;
  final int colorValue;
  final String emoji;
  final List<Subcategory> subcategories;
}
