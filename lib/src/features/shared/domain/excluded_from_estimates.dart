import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';

/// Category/Subcategory combinations that should be excluded from
/// estimates and optionally from dashboard totals.
/// These are one-time or unusual expenses that skew averages.
const excludedFromEstimates = [
  (category: Category.housing, subcategory: Subcategory.kitchenRenovation),
  (category: Category.income, subcategory: Subcategory.loan),
  (category: Category.income, subcategory: Subcategory.kitchenRenovation),
];

/// Check if a category/subcategory combination should be excluded from estimates
bool isExcludedFromEstimates(Category category, Subcategory subcategory) {
  return excludedFromEstimates.any(
    (e) => e.category == category && e.subcategory == subcategory,
  );
}

/// Category/Subcategory combinations that should be excluded from
/// variable forecast (historical average projection) but NOT from
/// actuals or recurring items.
const excludedFromVariableForecast = [
  (category: Category.income, subcategory: Subcategory.other),
];

/// Check if excluded from variable forecast
bool isExcludedFromVariableForecast(Category category, Subcategory subcategory) {
  return excludedFromVariableForecast.any(
    (e) => e.category == category && e.subcategory == subcategory,
  );
}
