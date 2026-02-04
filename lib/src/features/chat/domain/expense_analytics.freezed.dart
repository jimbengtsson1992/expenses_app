// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthSummary {

 int get year; int get month; double get income; double get expenses; Map<Category, double> get categoryBreakdown;
/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthSummaryCopyWith<MonthSummary> get copyWith => _$MonthSummaryCopyWithImpl<MonthSummary>(this as MonthSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthSummary&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,income,expenses,const DeepCollectionEquality().hash(categoryBreakdown));

@override
String toString() {
  return 'MonthSummary(year: $year, month: $month, income: $income, expenses: $expenses, categoryBreakdown: $categoryBreakdown)';
}


}

/// @nodoc
abstract mixin class $MonthSummaryCopyWith<$Res>  {
  factory $MonthSummaryCopyWith(MonthSummary value, $Res Function(MonthSummary) _then) = _$MonthSummaryCopyWithImpl;
@useResult
$Res call({
 int year, int month, double income, double expenses, Map<Category, double> categoryBreakdown
});




}
/// @nodoc
class _$MonthSummaryCopyWithImpl<$Res>
    implements $MonthSummaryCopyWith<$Res> {
  _$MonthSummaryCopyWithImpl(this._self, this._then);

  final MonthSummary _self;
  final $Res Function(MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? income = null,Object? expenses = null,Object? categoryBreakdown = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as Map<Category, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthSummary].
extension MonthSummaryPatterns on MonthSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthSummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double income,  double expenses,  Map<Category, double> categoryBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.year,_that.month,_that.income,_that.expenses,_that.categoryBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double income,  double expenses,  Map<Category, double> categoryBreakdown)  $default,) {final _that = this;
switch (_that) {
case _MonthSummary():
return $default(_that.year,_that.month,_that.income,_that.expenses,_that.categoryBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double income,  double expenses,  Map<Category, double> categoryBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _MonthSummary() when $default != null:
return $default(_that.year,_that.month,_that.income,_that.expenses,_that.categoryBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _MonthSummary implements MonthSummary {
  const _MonthSummary({required this.year, required this.month, required this.income, required this.expenses, required final  Map<Category, double> categoryBreakdown}): _categoryBreakdown = categoryBreakdown;
  

@override final  int year;
@override final  int month;
@override final  double income;
@override final  double expenses;
 final  Map<Category, double> _categoryBreakdown;
@override Map<Category, double> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableMapView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryBreakdown);
}


/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthSummaryCopyWith<_MonthSummary> get copyWith => __$MonthSummaryCopyWithImpl<_MonthSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthSummary&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,year,month,income,expenses,const DeepCollectionEquality().hash(_categoryBreakdown));

@override
String toString() {
  return 'MonthSummary(year: $year, month: $month, income: $income, expenses: $expenses, categoryBreakdown: $categoryBreakdown)';
}


}

/// @nodoc
abstract mixin class _$MonthSummaryCopyWith<$Res> implements $MonthSummaryCopyWith<$Res> {
  factory _$MonthSummaryCopyWith(_MonthSummary value, $Res Function(_MonthSummary) _then) = __$MonthSummaryCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double income, double expenses, Map<Category, double> categoryBreakdown
});




}
/// @nodoc
class __$MonthSummaryCopyWithImpl<$Res>
    implements _$MonthSummaryCopyWith<$Res> {
  __$MonthSummaryCopyWithImpl(this._self, this._then);

  final _MonthSummary _self;
  final $Res Function(_MonthSummary) _then;

/// Create a copy of MonthSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? income = null,Object? expenses = null,Object? categoryBreakdown = null,}) {
  return _then(_MonthSummary(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as Map<Category, double>,
  ));
}


}

/// @nodoc
mixin _$ExpenseAnalytics {

 List<MonthSummary> get monthSummaries; Map<Category, double> get categoryTotals; double get totalIncome; double get totalExpenses;
/// Create a copy of ExpenseAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseAnalyticsCopyWith<ExpenseAnalytics> get copyWith => _$ExpenseAnalyticsCopyWithImpl<ExpenseAnalytics>(this as ExpenseAnalytics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseAnalytics&&const DeepCollectionEquality().equals(other.monthSummaries, monthSummaries)&&const DeepCollectionEquality().equals(other.categoryTotals, categoryTotals)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(monthSummaries),const DeepCollectionEquality().hash(categoryTotals),totalIncome,totalExpenses);

@override
String toString() {
  return 'ExpenseAnalytics(monthSummaries: $monthSummaries, categoryTotals: $categoryTotals, totalIncome: $totalIncome, totalExpenses: $totalExpenses)';
}


}

/// @nodoc
abstract mixin class $ExpenseAnalyticsCopyWith<$Res>  {
  factory $ExpenseAnalyticsCopyWith(ExpenseAnalytics value, $Res Function(ExpenseAnalytics) _then) = _$ExpenseAnalyticsCopyWithImpl;
@useResult
$Res call({
 List<MonthSummary> monthSummaries, Map<Category, double> categoryTotals, double totalIncome, double totalExpenses
});




}
/// @nodoc
class _$ExpenseAnalyticsCopyWithImpl<$Res>
    implements $ExpenseAnalyticsCopyWith<$Res> {
  _$ExpenseAnalyticsCopyWithImpl(this._self, this._then);

  final ExpenseAnalytics _self;
  final $Res Function(ExpenseAnalytics) _then;

/// Create a copy of ExpenseAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthSummaries = null,Object? categoryTotals = null,Object? totalIncome = null,Object? totalExpenses = null,}) {
  return _then(_self.copyWith(
monthSummaries: null == monthSummaries ? _self.monthSummaries : monthSummaries // ignore: cast_nullable_to_non_nullable
as List<MonthSummary>,categoryTotals: null == categoryTotals ? _self.categoryTotals : categoryTotals // ignore: cast_nullable_to_non_nullable
as Map<Category, double>,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseAnalytics].
extension ExpenseAnalyticsPatterns on ExpenseAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MonthSummary> monthSummaries,  Map<Category, double> categoryTotals,  double totalIncome,  double totalExpenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseAnalytics() when $default != null:
return $default(_that.monthSummaries,_that.categoryTotals,_that.totalIncome,_that.totalExpenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MonthSummary> monthSummaries,  Map<Category, double> categoryTotals,  double totalIncome,  double totalExpenses)  $default,) {final _that = this;
switch (_that) {
case _ExpenseAnalytics():
return $default(_that.monthSummaries,_that.categoryTotals,_that.totalIncome,_that.totalExpenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MonthSummary> monthSummaries,  Map<Category, double> categoryTotals,  double totalIncome,  double totalExpenses)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseAnalytics() when $default != null:
return $default(_that.monthSummaries,_that.categoryTotals,_that.totalIncome,_that.totalExpenses);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseAnalytics extends ExpenseAnalytics {
  const _ExpenseAnalytics({required final  List<MonthSummary> monthSummaries, required final  Map<Category, double> categoryTotals, required this.totalIncome, required this.totalExpenses}): _monthSummaries = monthSummaries,_categoryTotals = categoryTotals,super._();
  

 final  List<MonthSummary> _monthSummaries;
@override List<MonthSummary> get monthSummaries {
  if (_monthSummaries is EqualUnmodifiableListView) return _monthSummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthSummaries);
}

 final  Map<Category, double> _categoryTotals;
@override Map<Category, double> get categoryTotals {
  if (_categoryTotals is EqualUnmodifiableMapView) return _categoryTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryTotals);
}

@override final  double totalIncome;
@override final  double totalExpenses;

/// Create a copy of ExpenseAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseAnalyticsCopyWith<_ExpenseAnalytics> get copyWith => __$ExpenseAnalyticsCopyWithImpl<_ExpenseAnalytics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseAnalytics&&const DeepCollectionEquality().equals(other._monthSummaries, _monthSummaries)&&const DeepCollectionEquality().equals(other._categoryTotals, _categoryTotals)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_monthSummaries),const DeepCollectionEquality().hash(_categoryTotals),totalIncome,totalExpenses);

@override
String toString() {
  return 'ExpenseAnalytics(monthSummaries: $monthSummaries, categoryTotals: $categoryTotals, totalIncome: $totalIncome, totalExpenses: $totalExpenses)';
}


}

/// @nodoc
abstract mixin class _$ExpenseAnalyticsCopyWith<$Res> implements $ExpenseAnalyticsCopyWith<$Res> {
  factory _$ExpenseAnalyticsCopyWith(_ExpenseAnalytics value, $Res Function(_ExpenseAnalytics) _then) = __$ExpenseAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 List<MonthSummary> monthSummaries, Map<Category, double> categoryTotals, double totalIncome, double totalExpenses
});




}
/// @nodoc
class __$ExpenseAnalyticsCopyWithImpl<$Res>
    implements _$ExpenseAnalyticsCopyWith<$Res> {
  __$ExpenseAnalyticsCopyWithImpl(this._self, this._then);

  final _ExpenseAnalytics _self;
  final $Res Function(_ExpenseAnalytics) _then;

/// Create a copy of ExpenseAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthSummaries = null,Object? categoryTotals = null,Object? totalIncome = null,Object? totalExpenses = null,}) {
  return _then(_ExpenseAnalytics(
monthSummaries: null == monthSummaries ? _self._monthSummaries : monthSummaries // ignore: cast_nullable_to_non_nullable
as List<MonthSummary>,categoryTotals: null == categoryTotals ? _self._categoryTotals : categoryTotals // ignore: cast_nullable_to_non_nullable
as Map<Category, double>,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
