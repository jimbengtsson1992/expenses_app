# Development Guide

## Getting Started

### Prerequisites
- Flutter SDK (compatible with Dart SDK ^3.9.2)
- IDE: Android Studio or VS Code with Flutter extensions
- iOS development: Xcode (for iOS builds)
- Android development: Android Studio

### Initial Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run code generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Development Workflow

### Making Changes to Data Models

When modifying Freezed models or Riverpod providers:

1. Make your changes to the source `.dart` file
2. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. For continuous generation during development:
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

### Adding New CSV Import Sources

To add support for a new bank or credit card:

1. **Add CSV files** to `assets/data/` directory
2. **Update detection logic** in `ExpensesRepository.getExpenses()`:
   ```dart
   if (filename.contains('YOUR_BANK_IDENTIFIER')) {
     allExpenses.addAll(_parseYourBankCsv(content, filename));
   }
   ```
3. **Create parser method**:
   ```dart
   List<Expense> _parseYourBankCsv(String content, String filename) {
     // Implement parsing logic
   }
   ```
4. **Consider**:
   - CSV delimiter (comma, semicolon, tab)
   - Decimal separator (period vs comma)
   - Date format
   - Amount sign convention
   - Which transactions to filter

### Adding New Expense Categories

1. **Update the Category enum** in `lib/src/features/expenses/domain/category.dart`:
   ```dart
   enum Category {
     // Existing categories...
     newCategory('Display Name', 0xFFCOLOR, '🎯'),
   }
   ```

2. **Update categorization logic** in `CategorizationService`:
   - Add keyword patterns for auto-categorization
   - Update categorization rules

3. **Run code generation** (if needed for serialization)

### Testing CSV Parsing

When debugging CSV import issues:

1. **Check the raw CSV file**:
   - Line endings (Unix vs Windows)
   - Actual delimiter used
   - Header row format
   - Data row format
   - Special characters or encoding

2. **Add debug logging** in parser methods:
   ```dart
   print('Row $i: ${row.map((e) => e.toString()).join(" | ")}');
   ```

3. **Test with sample data**:
   - Create unit tests with sample CSV strings
   - Verify edge cases (empty fields, special characters)

4. **Validation checks**:
   - Ensure date regex matches actual format
   - Verify section detection works for all rows
   - Check amount parsing handles all formats

## Common Tasks

### Adding New Accounts to Transfer Filter

Update `_myAccounts` in `ExpensesRepository`:

```dart
static const _myAccounts = [
  '1127 25 18949',
  '3016 28 91261',
  // Add new account number
  'YOUR_ACCOUNT_NUMBER',
];
```

### Changing Date Filter

Modify `_startParams` in `ExpensesRepository`:

```dart
static final _startParams = DateTime(2025, 1, 1); // Change date here
```

### Updating Source Account Names

Update the account name mapping in `_parseNordeaCsv`:

```dart
String sourceName = 'Nordea';
if (filename.contains('ACCOUNT_ID')) {
  sourceName = 'Your Account Name';
}
```

## UI Development

### Screen Structure

Typical screen hierarchy:
```
Screen Widget (Stateless/Stateful)
  ├── Scaffold
  │   ├── AppBar
  │   └── Body
  │       └── Consumer/ConsumerWidget (for Riverpod state)
  │           └── UI Components
```

### Using Riverpod in Widgets

**Consumer Widget Pattern**:
```dart
class ExpensesListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    
    return expensesAsync.when(
      data: (expenses) => ListView(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

### Adding Charts

The app uses `fl_chart` for visualization. Example patterns should be in the dashboard screen.

## Localization

- Primary language: **Swedish (sv)**
- Date formatting initialized in `main.dart`
- Use Swedish for all user-facing strings
- Category names are in Swedish

## Build Variants

### Debug Build
```bash
flutter run
```

### Release Build (Android)
```bash
flutter build apk --release
```

### Release Build (iOS)
```bash
flutter build ios --release
```

## Troubleshooting

### Code Generation Issues

**Problem**: Generated files out of sync
**Solution**: Delete generated files and rebuild
```bash
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
flutter pub run build_runner build --delete-conflicting-outputs
```

### CSV Import Not Working

**Problem**: Transactions not appearing
**Checklist**:
1. Is the CSV file in `assets/data/`?
2. Is the file listed in `pubspec.yaml` assets?
3. Does the filename match detection logic?
4. Are dates after `_startParams`?
5. Are transactions being filtered as transfers?
6. Is the CSV format as expected?

### Hot Reload Limitations

Changes requiring full restart:
- Asset file additions (new CSVs)
- `pubspec.yaml` modifications
- Code generation changes
- Native code changes

## Performance Considerations

- CSV parsing is synchronous but uses `async` for asset loading
- All transactions loaded into memory (fine for personal use)
- Consider pagination if transaction count grows significantly
- Charts may need optimization for thousands of data points

## Security Notes

- No sensitive data should be committed to git
- CSV files in `assets/data/` may contain personal financial data
- Consider adding `assets/data/*.csv` to `.gitignore` if sharing code
- No authentication/encryption implemented (local app only)

## Future Enhancement Ideas

1. **Database Integration**: Use SQLite for persistent storage
2. **Export Functionality**: Export filtered/categorized data
3. **Budget Tracking**: Set and monitor category budgets
4. **Recurring Expense Detection**: Identify subscription patterns
5. **Multi-Currency Support**: Handle foreign transactions
6. **Cloud Sync**: Backup data to cloud storage
7. **Receipt Scanning**: OCR for receipt capture
8. **Split Transactions**: Support shared expenses
