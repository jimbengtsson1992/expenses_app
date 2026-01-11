import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

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
