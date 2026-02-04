import 'package:freezed_annotation/freezed_annotation.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction_type.dart';

part 'monthly_estimate.freezed.dart';

@freezed
abstract class MonthlyEstimate with _$MonthlyEstimate {
  const factory MonthlyEstimate({
    required double actualIncome,
    required double actualExpenses,
    required double estimatedIncome,
    required double estimatedExpenses,
    required Map<Category, CategoryEstimate> categoryEstimates,
    required List<RecurringStatus> pendingRecurring,
    required List<RecurringStatus> completedRecurring,
  }) = _MonthlyEstimate;
}

@freezed
abstract class CategoryEstimate with _$CategoryEstimate {
  const factory CategoryEstimate({
    required Category category,
    required double actual,
    required double estimated,
    required double historicalAverage,
    @Default({}) Map<Subcategory, SubcategoryEstimate> subcategoryEstimates,
  }) = _CategoryEstimate;
}

@freezed
abstract class SubcategoryEstimate with _$SubcategoryEstimate {
  const factory SubcategoryEstimate({
    required Subcategory subcategory,
    required double actual,
    required double estimated,
    required double historicalAverage,
  }) = _SubcategoryEstimate;
}

@freezed
abstract class RecurringStatus with _$RecurringStatus {
  const factory RecurringStatus({
    required String descriptionPattern,
    required double averageAmount,
    required int? typicalDayOfMonth,
    required Category category,
    required Subcategory subcategory,
    required TransactionType type,
    required int occurrenceCount,
  }) = _RecurringStatus;
}
