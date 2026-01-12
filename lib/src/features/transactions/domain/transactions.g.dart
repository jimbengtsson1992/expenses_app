// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  category: $enumDecode(_$CategoryEnumMap, json['category']),
  sourceAccount: json['sourceAccount'] as String,
  sourceFilename: json['sourceFilename'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'description': instance.description,
      'category': _$CategoryEnumMap[instance.category]!,
      'sourceAccount': instance.sourceAccount,
      'sourceFilename': instance.sourceFilename,
      'type': _$TransactionTypeEnumMap[instance.type]!,
    };

const _$CategoryEnumMap = {
  Category.food: 'food',
  Category.shopping: 'shopping',
  Category.transport: 'transport',
  Category.health: 'health',
  Category.bills: 'bills',
  Category.savings: 'savings',
  Category.income: 'income',
  Category.other: 'other',
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
