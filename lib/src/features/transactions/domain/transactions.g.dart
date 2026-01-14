// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

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
  subcategory:
      $enumDecodeNullable(_$SubcategoryEnumMap, json['subcategory']) ??
      Subcategory.unknown,
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
      'subcategory': _$SubcategoryEnumMap[instance.subcategory]!,
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

const _$SubcategoryEnumMap = {
  Subcategory.taxi: 'taxi',
  Subcategory.publicTransport: 'publicTransport',
  Subcategory.car: 'car',
  Subcategory.fuel: 'fuel',
  Subcategory.parking: 'parking',
  Subcategory.groceries: 'groceries',
  Subcategory.restaurant: 'restaurant',
  Subcategory.clothes: 'clothes',
  Subcategory.electronics: 'electronics',
  Subcategory.home: 'home',
  Subcategory.gym: 'gym',
  Subcategory.pharmacy: 'pharmacy',
  Subcategory.doctor: 'doctor',
  Subcategory.streaming: 'streaming',
  Subcategory.electricity: 'electricity',
  Subcategory.internet: 'internet',
  Subcategory.phone: 'phone',
  Subcategory.insurance: 'insurance',
  Subcategory.salary: 'salary',
  Subcategory.otherIncome: 'otherIncome',
  Subcategory.unknown: 'unknown',
};
