# Code Patterns

## State (Riverpod)
```dart
@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref.read(categorizationServiceProvider));
}
```

## Models (Freezed)
```dart
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required DateTime date,
    required double amount,
    // ...
  }) = _Expense;
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}
```

## Categorization Logic
Flow & Templates: `.agent/categorization_rules.md`.

## CSV Parsing
### Data Source Detection
```dart
if (filename.contains('PERSONKONTO')) parseNordea(content);
else if (filename.contains('SAS AMEX')) parseAmex(content);
```

### Amex Section Parsing
```dart
// "Köp/uttag" section only
if (col[2] == 'Specifikation') inSection = true;
if (col[2].startsWith('Summa')) inSection = false;
```

### Amount Handling
- **Nordea**: `double.parse(s.replaceAll(',', '.'))`
- **Amex**: Invert sign (Positive in CSV = Expense). `s.replaceAll(',', '')` (thousands sep is space/comma, decimal is point).

## Internal Transfers
Filter if desc matches `_myAccounts` list in `ExpensesRepository`.
```dart
bool _isInternalTransfer(String desc) {
   return _myAccounts.any((acc) => desc.contains(acc));
}
```

## Routing (GoRouter)
Type-safe routes via `go_router_builder`. `routes.dart`.
