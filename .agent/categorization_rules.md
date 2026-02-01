# Categorization Rules

## 🧠 Decision Logic
- **Specific Override**: Use when rule depends on **Date** AND **Amount**. (e.g., "Swish on 2025-03-30 for -100kr").
- **Keyword Rule**: Use when rule depends ONLY on **Description**. (e.g., "MCDONALDS always Food/Restaurant").

## 🚨 MANDATE
**EVERY** new rule MUST have a corresponding test case in `test/categorization/`.

## 📝 Implementation

### 1. Specific Override
`lib/.../categorization_service.dart` -> `_checkSpecificOverrides`
```dart
if (_matches(description, ['UNIQUE_DESC_SUBSTRING']) &&
    (amount == -123.00) &&
    date.year == 2025 &&
    date.month == 1 &&
    date.day == 1) {
  return (Category.food, Subcategory.groceries);
}
```

### 2. Keyword Rule
`lib/.../categorization_service.dart` -> `_checkKeywordRules`
```dart
if (_matches(description, ['KEYWORD_1', 'KEYWORD_2'])) {
  return (Category.shopping, Subcategory.clothing);
}
```

## ✅ Testing

### Test File
`test/categorization/{category}_test.dart`

```dart
test('My New Rule', () {
  // Specific Override (Date matches rule)
  expectCategory(service, 'Full Description', -123.0, DateTime(2025, 1, 1), Category.food, Subcategory.groceries);
  
  // OR Keyword Rule (Date matches dummyDate)
  expectCategory(service, 'Desc with KEYWORD_1', -500, dummyDate, Category.shopping, Subcategory.clothing);
});
```
