// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {

 String get id; DateTime get date; double get amount; String get description; Category get category; Account get sourceAccount; String get sourceFilename; TransactionType get type; Subcategory get subcategory; bool get excludeFromOverview; String? get rawCsvData;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.sourceAccount, sourceAccount) || other.sourceAccount == sourceAccount)&&(identical(other.sourceFilename, sourceFilename) || other.sourceFilename == sourceFilename)&&(identical(other.type, type) || other.type == type)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.excludeFromOverview, excludeFromOverview) || other.excludeFromOverview == excludeFromOverview)&&(identical(other.rawCsvData, rawCsvData) || other.rawCsvData == rawCsvData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,amount,description,category,sourceAccount,sourceFilename,type,subcategory,excludeFromOverview,rawCsvData);

@override
String toString() {
  return 'Transaction(id: $id, date: $date, amount: $amount, description: $description, category: $category, sourceAccount: $sourceAccount, sourceFilename: $sourceFilename, type: $type, subcategory: $subcategory, excludeFromOverview: $excludeFromOverview, rawCsvData: $rawCsvData)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, double amount, String description, Category category, Account sourceAccount, String sourceFilename, TransactionType type, Subcategory subcategory, bool excludeFromOverview, String? rawCsvData
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? amount = null,Object? description = null,Object? category = null,Object? sourceAccount = null,Object? sourceFilename = null,Object? type = null,Object? subcategory = null,Object? excludeFromOverview = null,Object? rawCsvData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,sourceAccount: null == sourceAccount ? _self.sourceAccount : sourceAccount // ignore: cast_nullable_to_non_nullable
as Account,sourceFilename: null == sourceFilename ? _self.sourceFilename : sourceFilename // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,subcategory: null == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory,excludeFromOverview: null == excludeFromOverview ? _self.excludeFromOverview : excludeFromOverview // ignore: cast_nullable_to_non_nullable
as bool,rawCsvData: freezed == rawCsvData ? _self.rawCsvData : rawCsvData // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  double amount,  String description,  Category category,  Account sourceAccount,  String sourceFilename,  TransactionType type,  Subcategory subcategory,  bool excludeFromOverview,  String? rawCsvData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.date,_that.amount,_that.description,_that.category,_that.sourceAccount,_that.sourceFilename,_that.type,_that.subcategory,_that.excludeFromOverview,_that.rawCsvData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  double amount,  String description,  Category category,  Account sourceAccount,  String sourceFilename,  TransactionType type,  Subcategory subcategory,  bool excludeFromOverview,  String? rawCsvData)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.date,_that.amount,_that.description,_that.category,_that.sourceAccount,_that.sourceFilename,_that.type,_that.subcategory,_that.excludeFromOverview,_that.rawCsvData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  double amount,  String description,  Category category,  Account sourceAccount,  String sourceFilename,  TransactionType type,  Subcategory subcategory,  bool excludeFromOverview,  String? rawCsvData)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.date,_that.amount,_that.description,_that.category,_that.sourceAccount,_that.sourceFilename,_that.type,_that.subcategory,_that.excludeFromOverview,_that.rawCsvData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transaction implements Transaction {
  const _Transaction({required this.id, required this.date, required this.amount, required this.description, required this.category, required this.sourceAccount, required this.sourceFilename, required this.type, this.subcategory = Subcategory.unknown, this.excludeFromOverview = false, this.rawCsvData});
  factory _Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

@override final  String id;
@override final  DateTime date;
@override final  double amount;
@override final  String description;
@override final  Category category;
@override final  Account sourceAccount;
@override final  String sourceFilename;
@override final  TransactionType type;
@override@JsonKey() final  Subcategory subcategory;
@override@JsonKey() final  bool excludeFromOverview;
@override final  String? rawCsvData;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.sourceAccount, sourceAccount) || other.sourceAccount == sourceAccount)&&(identical(other.sourceFilename, sourceFilename) || other.sourceFilename == sourceFilename)&&(identical(other.type, type) || other.type == type)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.excludeFromOverview, excludeFromOverview) || other.excludeFromOverview == excludeFromOverview)&&(identical(other.rawCsvData, rawCsvData) || other.rawCsvData == rawCsvData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,amount,description,category,sourceAccount,sourceFilename,type,subcategory,excludeFromOverview,rawCsvData);

@override
String toString() {
  return 'Transaction(id: $id, date: $date, amount: $amount, description: $description, category: $category, sourceAccount: $sourceAccount, sourceFilename: $sourceFilename, type: $type, subcategory: $subcategory, excludeFromOverview: $excludeFromOverview, rawCsvData: $rawCsvData)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, double amount, String description, Category category, Account sourceAccount, String sourceFilename, TransactionType type, Subcategory subcategory, bool excludeFromOverview, String? rawCsvData
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? amount = null,Object? description = null,Object? category = null,Object? sourceAccount = null,Object? sourceFilename = null,Object? type = null,Object? subcategory = null,Object? excludeFromOverview = null,Object? rawCsvData = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,sourceAccount: null == sourceAccount ? _self.sourceAccount : sourceAccount // ignore: cast_nullable_to_non_nullable
as Account,sourceFilename: null == sourceFilename ? _self.sourceFilename : sourceFilename // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,subcategory: null == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory,excludeFromOverview: null == excludeFromOverview ? _self.excludeFromOverview : excludeFromOverview // ignore: cast_nullable_to_non_nullable
as bool,rawCsvData: freezed == rawCsvData ? _self.rawCsvData : rawCsvData // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
