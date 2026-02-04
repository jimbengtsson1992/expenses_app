import 'package:freezed_annotation/freezed_annotation.dart';
import 'category.dart';
import 'subcategory.dart';
import 'transaction_type.dart';
import 'account.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const Transaction._(); // Required for custom getters

  const factory Transaction({
    required String id,
    required DateTime date,
    required double amount,
    required String description,
    required Category category,
    required Account sourceAccount,
    required String sourceFilename,
    @Default(Subcategory.unknown) Subcategory subcategory,
    @Default(false) bool excludeFromOverview,
    String? rawCsvData,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Derived from amount: positive = income, negative = expense
  TransactionType get type =>
      amount >= 0 ? TransactionType.income : TransactionType.expense;
}
