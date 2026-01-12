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
  sourceAccount: $enumDecode(_$AccountEnumMap, json['sourceAccount']),
  sourceFilename: json['sourceFilename'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  excludeFromOverview: json['excludeFromOverview'] as bool? ?? false,
  rawCsvData: json['rawCsvData'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'description': instance.description,
      'category': _$CategoryEnumMap[instance.category]!,
      'sourceAccount': _$AccountEnumMap[instance.sourceAccount]!,
      'sourceFilename': instance.sourceFilename,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'excludeFromOverview': instance.excludeFromOverview,
      'rawCsvData': instance.rawCsvData,
    };

const _$CategoryEnumMap = {
  Category.food: 'food',
  Category.shopping: 'shopping',
  Category.transport: 'transport',
  Category.health: 'health',
  Category.bills: 'bills',
  Category.savings: 'savings',
  Category.income: 'income',
  Category.salary: 'salary',
  Category.loansAndBrf: 'loansAndBrf',
  Category.other: 'other',
};

const _$AccountEnumMap = {
  Account.jimPersonkonto: 'jimPersonkonto',
  Account.jimSparkonto: 'jimSparkonto',
  Account.gemensamt: 'gemensamt',
  Account.gemensamtSpar: 'gemensamtSpar',
  Account.sasAmex: 'sasAmex',
  Account.unknown: 'unknown',
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
