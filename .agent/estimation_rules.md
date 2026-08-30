# Estimation System

## 🚨 MANDATES
1. **New recurring patterns** → Add to `lib/src/features/estimation/domain/known_recurring.dart`
2. **One-time/unusual expenses** → Add to `excludedFromEstimates` in `lib/src/features/shared/domain/excluded_from_estimates.dart`
3. **Test changes** → Run tests in `test/features/estimation/`

## 📊 How Estimation Works
`EstimationService` calculates monthly estimates for incomplete months:
1. **Actuals**: Already-occurred transactions this month
2. **Known Recurring**: From `knownRecurringPatterns` (not yet occurred this month)
3. **Auto-detected Recurring**: Patterns found in history (requires 3+ occurrences spanning multiple months)
4. **Variable Forecast**: Historical averages for remaining categories (excludes internal transfers)

## 🔒 Exclusions

### `excludedFromEstimates` - Fully excluded
Skip from ALL estimate calculations (unusual one-time items):
```dart
const excludedFromEstimates = [
  (category: Category.housing, subcategory: Subcategory.kitchenRenovation),
  (category: Category.income, subcategory: Subcategory.loan),
];
```

### Trip-tagged transactions - Per-transaction excluded
`EstimationService` skips any transaction with `tripId != null` (actuals + category/subcategory averages). Trips are one-off bursts; excluding per-transaction keeps normal `(entertainment, travel)` spending in forecasts. **Never** add `(entertainment, travel)` to `excludedFromEstimates` for a trip — it would erase all regular travel from estimates.

## 🔄 Recurring Detection Thresholds
- **Min occurrences**: 3 (prevents false positives from 2 similar transactions)
- **Must span**: Multiple months (same month doesn't count as recurring)
- **Excludes**: Internal transfers between own accounts

## 🐛 Debug Tools
- `test/features/estimation/debug_all_estimates.dart` - Full estimate breakdown
- `test/features/estimation/debug_report.txt` - Generated report output
