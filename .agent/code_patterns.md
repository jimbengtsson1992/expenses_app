# Code Patterns & Conventions

## State Management with Riverpod

### Provider Pattern
```dart
@riverpod
ExpensesRepository expensesRepository(Ref ref) {
  return ExpensesRepository(ref.read(categorizationServiceProvider));
}
```

- Use `@riverpod` annotation for code generation
- Providers are defined as top-level functions
- Dependencies injected via `ref.read()` or `ref.watch()`

## Data Models with Freezed

### Immutable Model Pattern
```dart
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required DateTime date,
    required double amount,
    required String description,
    required Category category,
    required String sourceAccount,
    required String sourceFilename,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}
```

- All domain models use Freezed for immutability
- Include `fromJson` for potential serialization
- Use `required` for all fields (no nullable types unless necessary)
- Part files: `.freezed.dart` and `.g.dart`

## Enums with Associated Values

```dart
enum Category {
  food('Mat & Dryck', 0xFF4CAF50, '🍔'),
  shopping('Shopping', 0xFFE91E63, '🛍️');

  const Category(this.displayName, this.colorValue, this.emoji);
  final String displayName;
  final int colorValue;
  final String emoji;
}
```

- Use enhanced enums for domain enumerations
- Include display properties (name, color, icon)
- Swedish language for user-facing strings

## CSV Parsing Pattern

### Data Source Detection
```dart
if (filename.toUpperCase().contains('PERSONKONTO') || 
    filename.toUpperCase().contains('SPARKONTO')) {
  allExpenses.addAll(_parseNordeaCsv(content, filename));
} else {
  allExpenses.addAll(_parseSasAmexCsv(content, filename));
}
```

### Section-Based Parsing (SAS Amex)
```dart
bool isInTransactionSection = false;

for (var i = 0; i < rows.length; i++) {
  final row = rows[i];
  
  // Detect section start
  if (firstCol == 'Datum' && row.length > 6 && row[2].toString() == 'Specifikation') {
    isInTransactionSection = true;
    continue;
  }
  
  // Detect section end
  if (isInTransactionSection) {
     if (firstCol.isEmpty && row.length > 2 && row[2].toString().startsWith('Summa')) {
       isInTransactionSection = false;
       break;
     }
     // Process row...
  }
}
```

### Data Validation
```dart
// Date validation using regex
if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(firstCol)) continue;

// Date filtering
if (date.isBefore(_startParams)) continue;

// Business rule filtering
if (_isInternalTransfer(description)) continue;
```

## Date Handling

### Localization
```dart
// In main.dart
await initializeDateFormatting('sv', null);
```

### Parsing Different Formats
```dart
// Nordea format: 2025/12/30
final date = DateFormat('yyyy/MM/dd').parse(dateStr);

// SAS Amex format: 2026-01-08
final date = DateFormat('yyyy-MM-dd').parse(dateStr);
```

## Amount Handling

### Nordea (Comma Decimal)
```dart
final amount = double.tryParse(amountStr.replaceAll(',', '.')) ?? 0;
```

### SAS Amex (Period Decimal + Inversion)
```dart
double amount = 0;
if (row[6] is num) {
  amount = (row[6] as num).toDouble();
} else {
  amount = double.tryParse(amountStr.replaceAll(',', '')) ?? 0;
}

// Invert: expense shows as positive in file, store as negative
amount = -amount;
```

## Filtering Patterns

### String Matching for Transfers
```dart
bool _isInternalTransfer(String description) {
  if (!description.toLowerCase().contains('överföring') && 
      !description.toLowerCase().contains('lån')) return false;
  
  for (final acc in _myAccounts) {
     if (description.contains(acc)) return true;
     // Flexible matching without spaces
     if (description.replaceAll(' ', '').contains(acc.replaceAll(' ', ''))) return true;
  }
  return false;
}
```

### Duplicate Payment Filtering
```dart
// In Nordea parser - filter SAS payments
if (description.contains('Betalning BG 595-4300 SAS EUROBONUS')) continue;

// In SAS parser - filter bill payments
if (description.contains('BETALT BG DATUM')) continue;
```

## Routing with GoRouter

Structure suggests type-safe routing with go_router_builder:
- `routes.dart` defines route definitions
- Code generation creates type-safe navigation
- Bottom navigation bar scaffold for main app sections

## Asset Management

### Loading CSV Files
```dart
final manifestContent = await rootBundle.loadString('AssetManifest.json');
final Map<String, dynamic> manifestMap = json.decode(manifestContent);
final filePaths = manifestMap.keys
    .where((String key) => key.startsWith('assets/data/') && 
           (key.endsWith('.csv') || key.endsWith('.CSV')))
    .toList();

for (final path in filePaths) {
  final content = await rootBundle.loadString(path);
  // Process...
}
```

## Error Handling Philosophy

- Use null-safe parsing: `double.tryParse(...) ?? 0`
- Skip invalid rows: `if (row.length < 6) continue;`
- Defensive checks before accessing array indices
- Type checking for CSV parsed values (may be num or string)

## Testing Approach

- Unit tests for services (e.g., `categorization_service_test.dart`)
- Test categorization logic in isolation
- Consider adding CSV parser tests for edge cases
