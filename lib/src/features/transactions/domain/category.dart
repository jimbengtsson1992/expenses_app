import 'subcategory.dart';

enum Category {
  food('Mat & Dryck', 0xFF4CAF50, '🍔', [
    Subcategory.groceries,
    Subcategory.restaurant,
    Subcategory.unknown,
    Subcategory.other,
  ]),
  shopping('Shopping', 0xFFE91E63, '🛍️', [
    Subcategory.clothes,
    Subcategory.electronics,
    Subcategory.home,
    Subcategory.unknown,
    Subcategory.other,
  ]),
  transport('Transport', 0xFFFF9800, '🚌', [
    Subcategory.taxi,
    Subcategory.publicTransport,
    Subcategory.car,
    Subcategory.fuel,
    Subcategory.parking,
    Subcategory.unknown,
    Subcategory.other,
  ]),
  health('Hälsa & Träning', 0xFF2196F3, '💪', [
    Subcategory.gym,
    Subcategory.pharmacy,
    Subcategory.doctor,
    Subcategory.other,
  ]),
  bills('Räkningar & Bank', 0xFF607D8B, '📄', [
    Subcategory.streaming,
    Subcategory.electricity,
    Subcategory.internet,
    Subcategory.phone,
    Subcategory.insurance,
    Subcategory.unknown,
    Subcategory.other,
  ]),
  savings('Sparande', 0xFF9C27B0, '💰', [Subcategory.unknown, Subcategory.other]),
  income('Inkomst', 0xFF009688, '💵', [
    Subcategory.salary,
    Subcategory.unknown,
    Subcategory.other,
  ]),
  loansAndBrf('Lån & BRF', 0xFF795548, '🏘️', [Subcategory.unknown, Subcategory.other]),
  other('Övrigt', 0xFF9E9E9E, '❓', [Subcategory.unknown, Subcategory.other]);

  const Category(this.displayName, this.colorValue, this.emoji, this.subcategories);
  final String displayName;
  final int colorValue;
  final String emoji;
  final List<Subcategory> subcategories;
}
