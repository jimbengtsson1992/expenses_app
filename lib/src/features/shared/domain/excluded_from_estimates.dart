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
