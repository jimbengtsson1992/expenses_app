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
  Category.housing: 'housing',
  Category.food: 'food',
  Category.shopping: 'shopping',
  Category.entertainment: 'entertainment',
  Category.health: 'health',
  Category.fees: 'fees',
  Category.transport: 'transport',
  Category.income: 'income',
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
  Subcategory.brfFee: 'brfFee',
  Subcategory.mortgage: 'mortgage',
  Subcategory.electricity: 'electricity',
  Subcategory.homeInsurance: 'homeInsurance',
  Subcategory.broadband: 'broadband',
  Subcategory.groceries: 'groceries',
  Subcategory.restaurant: 'restaurant',
  Subcategory.bar: 'bar',
  Subcategory.lunch: 'lunch',
  Subcategory.takeaway: 'takeaway',
  Subcategory.coffee: 'coffee',
  Subcategory.alcohol: 'alcohol',
  Subcategory.supplements: 'supplements',
  Subcategory.personalInsurance: 'personalInsurance',
  Subcategory.mobileSubscription: 'mobileSubscription',
  Subcategory.newspapers: 'newspapers',
  Subcategory.streaming: 'streaming',
  Subcategory.clothes: 'clothes',
  Subcategory.electronics: 'electronics',
  Subcategory.furniture: 'furniture',
  Subcategory.gifts: 'gifts',
  Subcategory.decor: 'decor',
  Subcategory.beauty: 'beauty',
  Subcategory.travel: 'travel',
  Subcategory.hobby: 'hobby',
  Subcategory.boardGamesBooksAndToys: 'boardGamesBooksAndToys',
  Subcategory.snuff: 'snuff',
  Subcategory.gym: 'gym',
  Subcategory.pharmacy: 'pharmacy',
  Subcategory.doctor: 'doctor',
  Subcategory.bankFees: 'bankFees',
  Subcategory.tax: 'tax',
  Subcategory.taxi: 'taxi',
  Subcategory.publicTransport: 'publicTransport',
  Subcategory.car: 'car',
  Subcategory.fuel: 'fuel',
  Subcategory.parking: 'parking',
  Subcategory.salary: 'salary',
  Subcategory.interest: 'interest',
  Subcategory.unknown: 'unknown',
  Subcategory.other: 'other',
};
