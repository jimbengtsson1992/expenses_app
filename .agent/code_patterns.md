# Code Patterns

## State (Riverpod)
**MUST** use `riverpod_generator` (`@riverpod`). No manual `Provider`/`StateNotifierProvider`.

```dart
@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref.read(categorizationServiceProvider));
}
```

## Models (Freezed)
```dart
@freezed
abstract class Transaction with _$Transaction {
  const Transaction._(); // Required for custom getters

  const factory Transaction({
    required String id,
    required DateTime date,
    required double amount,
    // ...
  }) = _Transaction;
  
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  // Computed getters (derive from stored fields)
  TransactionType get type => amount >= 0 ? TransactionType.income : TransactionType.expense;
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
