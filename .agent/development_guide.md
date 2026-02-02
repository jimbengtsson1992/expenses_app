# Development Guide

## 🚀 Setup
```bash
fvm flutter pub get
fvm dart pub run build_runner build --delete-conflicting-outputs
fvm flutter run
```

## 🛠 Common Tasks

### Add New Bank (CSV)
1. Add CSV to `assets/data/`.
2. Add detection logic in `ExpensesRepository.getExpenses()`.
3. Create parser: `List<Expense> _parseNewBank(String content)`.
   - **Check**: Delimiters, Date format, Amount format.
   - **Filter**: Internal transfers.

### Add Category
1. Add enum case to `Category` in `category.dart`.
   - `newCat('Display', 0xFF..., 'emoji')`.
2. Update `CategorizationService` & `test/`. See `.agent/categorization_rules.md`.

### UI Dev
- **Files**: `lib/src/features/.../presentation/`.
- **State**: Use `ConsumerWidget` / `ref.watch(provider)`.
- **Charts**: Use `fl_chart`.

## 🐞 Troubleshooting
- **Missing Transactions**: Check date filter (> 2024-12-01). Check `_isInternalTransfer`.
- **Gen Error**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`.
