# Recurring Transaction Rules

## 🚨 MANDATE
**EVERY** new recurring pattern MUST be added to `lib/src/features/estimation/domain/known_recurring.dart`.

## 📝 Pattern Format

```dart
KnownRecurringPattern(
  descriptionPattern: 'PATTERN',     // Required: matches if description contains this
  category: Category.housing,        // Required
  subcategory: Subcategory.rent,     // Required
  type: TransactionType.expense,     // Required: expense or income
  typicalDayOfMonth: 1,              // Optional: expected day (1-31)
  endDate: DateTime(2025, 6, 30),    // Optional: for cancelled/ended recurring
),
```

## ✅ Examples

### Permanent Recurring
```dart
// Rent - always on 1st
KnownRecurringPattern(
  descriptionPattern: 'HYRA',
  category: Category.housing,
  subcategory: Subcategory.rent,
  type: TransactionType.expense,
  typicalDayOfMonth: 1,
),

// Salary - around 25th
KnownRecurringPattern(
  descriptionPattern: 'LÖN',
  category: Category.income,
  subcategory: Subcategory.salary,
  type: TransactionType.income,
  typicalDayOfMonth: 25,
),
```

### Time-Limited Recurring
```dart
// Gym cancelled after June 2025
KnownRecurringPattern(
  descriptionPattern: 'OLD GYM',
  category: Category.health,
  subcategory: Subcategory.gym,
  type: TransactionType.expense,
  endDate: DateTime(2025, 6, 30),
),
```

## 🔍 Common Description Patterns
- Housing: `HYRA`, `BOSTADSRÄTT`
- Fees: `VATTENFALL`, `TELIA`, `FÖRSÄKRING`
- Income: `LÖN`, `SALARY`
- Health: `SATS`, `GYM`
