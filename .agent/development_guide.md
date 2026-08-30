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

### Add Trip
1. Add one const entry to `allTrips` in `lib/src/features/trips/domain/trip.dart` (`Trip(id: 'x-2027', name: 'X', emoji: '🏝')`). No codegen.
2. Dashboard card + tagging UI pick it up automatically. User tags transactions via transaction detail screen ("Resa").
3. Tests: `test/features/trips/`, `test/features/transactions/data/user_rules_repository_test.dart`.

### Hardcode Trip Tags (from export prompt)
Add a `KnownTripTransaction(tripId:, descriptionContains:, amount:, year:, month:, day:)` to `knownTripTransactions` in `lib/src/features/trips/domain/trip.dart` for each `### Trip Assignments` line. Do NOT add a categorization override — the parser derives `(entertainment, travel)` from the trip. Test: `test/features/trips/known_trip_transactions_test.dart`.

### UI Dev
- **Files**: `lib/src/features/.../presentation/`.
- **State**: Use `ConsumerWidget` / `ref.watch(provider)`.
- **Charts**: Use `fl_chart`.

## 🐞 Troubleshooting
- **Missing Transactions**: Check date filter (> 2024-12-01). Check `_isInternalTransfer`.
- **Gen Error**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`.
