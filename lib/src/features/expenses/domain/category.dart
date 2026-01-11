
enum Category {
  food('Mat & Dryck', 0xFF4CAF50, '🍔'), // Green
  shopping('Shopping', 0xFFE91E63, '🛍️'), // Pink
  transport('Transport', 0xFFFF9800, '🚌'), // Orange
  health('Hälsa & Träning', 0xFF2196F3, '💪'), // Blue
  bills('Räkningar & Bank', 0xFF607D8B, '📄'), // BlueGrey
  savings('Sparande', 0xFF9C27B0, '💰'), // Purple
  income('Inkomst', 0xFF009688, '💵'), // Teal
  other('Övrigt', 0xFF9E9E9E, '❓'); // Grey

  const Category(this.displayName, this.colorValue, this.emoji);
  final String displayName;
  final int colorValue;
  final String emoji;
}
