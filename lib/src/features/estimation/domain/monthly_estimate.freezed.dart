// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_estimate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyEstimate {

 double get actualIncome; double get actualExpenses; double get estimatedIncome; double get estimatedExpenses; Map<Category, CategoryEstimate> get categoryEstimates; List<RecurringStatus> get pendingRecurring; List<RecurringStatus> get completedRecurring;
/// Create a copy of MonthlyEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyEstimateCopyWith<MonthlyEstimate> get copyWith => _$MonthlyEstimateCopyWithImpl<MonthlyEstimate>(this as MonthlyEstimate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyEstimate&&(identical(other.actualIncome, actualIncome) || other.actualIncome == actualIncome)&&(identical(other.actualExpenses, actualExpenses) || other.actualExpenses == actualExpenses)&&(identical(other.estimatedIncome, estimatedIncome) || other.estimatedIncome == estimatedIncome)&&(identical(other.estimatedExpenses, estimatedExpenses) || other.estimatedExpenses == estimatedExpenses)&&const DeepCollectionEquality().equals(other.categoryEstimates, categoryEstimates)&&const DeepCollectionEquality().equals(other.pendingRecurring, pendingRecurring)&&const DeepCollectionEquality().equals(other.completedRecurring, completedRecurring));
}


@override
int get hashCode => Object.hash(runtimeType,actualIncome,actualExpenses,estimatedIncome,estimatedExpenses,const DeepCollectionEquality().hash(categoryEstimates),const DeepCollectionEquality().hash(pendingRecurring),const DeepCollectionEquality().hash(completedRecurring));

@override
String toString() {
  return 'MonthlyEstimate(actualIncome: $actualIncome, actualExpenses: $actualExpenses, estimatedIncome: $estimatedIncome, estimatedExpenses: $estimatedExpenses, categoryEstimates: $categoryEstimates, pendingRecurring: $pendingRecurring, completedRecurring: $completedRecurring)';
}


}

/// @nodoc
abstract mixin class $MonthlyEstimateCopyWith<$Res>  {
  factory $MonthlyEstimateCopyWith(MonthlyEstimate value, $Res Function(MonthlyEstimate) _then) = _$MonthlyEstimateCopyWithImpl;
@useResult
$Res call({
 double actualIncome, double actualExpenses, double estimatedIncome, double estimatedExpenses, Map<Category, CategoryEstimate> categoryEstimates, List<RecurringStatus> pendingRecurring, List<RecurringStatus> completedRecurring
});




}
/// @nodoc
class _$MonthlyEstimateCopyWithImpl<$Res>
    implements $MonthlyEstimateCopyWith<$Res> {
  _$MonthlyEstimateCopyWithImpl(this._self, this._then);

  final MonthlyEstimate _self;
  final $Res Function(MonthlyEstimate) _then;

/// Create a copy of MonthlyEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actualIncome = null,Object? actualExpenses = null,Object? estimatedIncome = null,Object? estimatedExpenses = null,Object? categoryEstimates = null,Object? pendingRecurring = null,Object? completedRecurring = null,}) {
  return _then(_self.copyWith(
actualIncome: null == actualIncome ? _self.actualIncome : actualIncome // ignore: cast_nullable_to_non_nullable
as double,actualExpenses: null == actualExpenses ? _self.actualExpenses : actualExpenses // ignore: cast_nullable_to_non_nullable
as double,estimatedIncome: null == estimatedIncome ? _self.estimatedIncome : estimatedIncome // ignore: cast_nullable_to_non_nullable
as double,estimatedExpenses: null == estimatedExpenses ? _self.estimatedExpenses : estimatedExpenses // ignore: cast_nullable_to_non_nullable
as double,categoryEstimates: null == categoryEstimates ? _self.categoryEstimates : categoryEstimates // ignore: cast_nullable_to_non_nullable
as Map<Category, CategoryEstimate>,pendingRecurring: null == pendingRecurring ? _self.pendingRecurring : pendingRecurring // ignore: cast_nullable_to_non_nullable
as List<RecurringStatus>,completedRecurring: null == completedRecurring ? _self.completedRecurring : completedRecurring // ignore: cast_nullable_to_non_nullable
as List<RecurringStatus>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyEstimate].
extension MonthlyEstimatePatterns on MonthlyEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyEstimate value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double actualIncome,  double actualExpenses,  double estimatedIncome,  double estimatedExpenses,  Map<Category, CategoryEstimate> categoryEstimates,  List<RecurringStatus> pendingRecurring,  List<RecurringStatus> completedRecurring)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyEstimate() when $default != null:
return $default(_that.actualIncome,_that.actualExpenses,_that.estimatedIncome,_that.estimatedExpenses,_that.categoryEstimates,_that.pendingRecurring,_that.completedRecurring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double actualIncome,  double actualExpenses,  double estimatedIncome,  double estimatedExpenses,  Map<Category, CategoryEstimate> categoryEstimates,  List<RecurringStatus> pendingRecurring,  List<RecurringStatus> completedRecurring)  $default,) {final _that = this;
switch (_that) {
case _MonthlyEstimate():
return $default(_that.actualIncome,_that.actualExpenses,_that.estimatedIncome,_that.estimatedExpenses,_that.categoryEstimates,_that.pendingRecurring,_that.completedRecurring);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double actualIncome,  double actualExpenses,  double estimatedIncome,  double estimatedExpenses,  Map<Category, CategoryEstimate> categoryEstimates,  List<RecurringStatus> pendingRecurring,  List<RecurringStatus> completedRecurring)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyEstimate() when $default != null:
return $default(_that.actualIncome,_that.actualExpenses,_that.estimatedIncome,_that.estimatedExpenses,_that.categoryEstimates,_that.pendingRecurring,_that.completedRecurring);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyEstimate implements MonthlyEstimate {
  const _MonthlyEstimate({required this.actualIncome, required this.actualExpenses, required this.estimatedIncome, required this.estimatedExpenses, required final  Map<Category, CategoryEstimate> categoryEstimates, required final  List<RecurringStatus> pendingRecurring, required final  List<RecurringStatus> completedRecurring}): _categoryEstimates = categoryEstimates,_pendingRecurring = pendingRecurring,_completedRecurring = completedRecurring;
  

@override final  double actualIncome;
@override final  double actualExpenses;
@override final  double estimatedIncome;
@override final  double estimatedExpenses;
 final  Map<Category, CategoryEstimate> _categoryEstimates;
@override Map<Category, CategoryEstimate> get categoryEstimates {
  if (_categoryEstimates is EqualUnmodifiableMapView) return _categoryEstimates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryEstimates);
}

 final  List<RecurringStatus> _pendingRecurring;
@override List<RecurringStatus> get pendingRecurring {
  if (_pendingRecurring is EqualUnmodifiableListView) return _pendingRecurring;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingRecurring);
}

 final  List<RecurringStatus> _completedRecurring;
@override List<RecurringStatus> get completedRecurring {
  if (_completedRecurring is EqualUnmodifiableListView) return _completedRecurring;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedRecurring);
}


/// Create a copy of MonthlyEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyEstimateCopyWith<_MonthlyEstimate> get copyWith => __$MonthlyEstimateCopyWithImpl<_MonthlyEstimate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyEstimate&&(identical(other.actualIncome, actualIncome) || other.actualIncome == actualIncome)&&(identical(other.actualExpenses, actualExpenses) || other.actualExpenses == actualExpenses)&&(identical(other.estimatedIncome, estimatedIncome) || other.estimatedIncome == estimatedIncome)&&(identical(other.estimatedExpenses, estimatedExpenses) || other.estimatedExpenses == estimatedExpenses)&&const DeepCollectionEquality().equals(other._categoryEstimates, _categoryEstimates)&&const DeepCollectionEquality().equals(other._pendingRecurring, _pendingRecurring)&&const DeepCollectionEquality().equals(other._completedRecurring, _completedRecurring));
}


@override
int get hashCode => Object.hash(runtimeType,actualIncome,actualExpenses,estimatedIncome,estimatedExpenses,const DeepCollectionEquality().hash(_categoryEstimates),const DeepCollectionEquality().hash(_pendingRecurring),const DeepCollectionEquality().hash(_completedRecurring));

@override
String toString() {
  return 'MonthlyEstimate(actualIncome: $actualIncome, actualExpenses: $actualExpenses, estimatedIncome: $estimatedIncome, estimatedExpenses: $estimatedExpenses, categoryEstimates: $categoryEstimates, pendingRecurring: $pendingRecurring, completedRecurring: $completedRecurring)';
}


}

/// @nodoc
abstract mixin class _$MonthlyEstimateCopyWith<$Res> implements $MonthlyEstimateCopyWith<$Res> {
  factory _$MonthlyEstimateCopyWith(_MonthlyEstimate value, $Res Function(_MonthlyEstimate) _then) = __$MonthlyEstimateCopyWithImpl;
@override @useResult
$Res call({
 double actualIncome, double actualExpenses, double estimatedIncome, double estimatedExpenses, Map<Category, CategoryEstimate> categoryEstimates, List<RecurringStatus> pendingRecurring, List<RecurringStatus> completedRecurring
});




}
/// @nodoc
class __$MonthlyEstimateCopyWithImpl<$Res>
    implements _$MonthlyEstimateCopyWith<$Res> {
  __$MonthlyEstimateCopyWithImpl(this._self, this._then);

  final _MonthlyEstimate _self;
  final $Res Function(_MonthlyEstimate) _then;

/// Create a copy of MonthlyEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actualIncome = null,Object? actualExpenses = null,Object? estimatedIncome = null,Object? estimatedExpenses = null,Object? categoryEstimates = null,Object? pendingRecurring = null,Object? completedRecurring = null,}) {
  return _then(_MonthlyEstimate(
actualIncome: null == actualIncome ? _self.actualIncome : actualIncome // ignore: cast_nullable_to_non_nullable
as double,actualExpenses: null == actualExpenses ? _self.actualExpenses : actualExpenses // ignore: cast_nullable_to_non_nullable
as double,estimatedIncome: null == estimatedIncome ? _self.estimatedIncome : estimatedIncome // ignore: cast_nullable_to_non_nullable
as double,estimatedExpenses: null == estimatedExpenses ? _self.estimatedExpenses : estimatedExpenses // ignore: cast_nullable_to_non_nullable
as double,categoryEstimates: null == categoryEstimates ? _self._categoryEstimates : categoryEstimates // ignore: cast_nullable_to_non_nullable
as Map<Category, CategoryEstimate>,pendingRecurring: null == pendingRecurring ? _self._pendingRecurring : pendingRecurring // ignore: cast_nullable_to_non_nullable
as List<RecurringStatus>,completedRecurring: null == completedRecurring ? _self._completedRecurring : completedRecurring // ignore: cast_nullable_to_non_nullable
as List<RecurringStatus>,
  ));
}


}

/// @nodoc
mixin _$CategoryEstimate {

 Category get category; double get actual; double get estimated; double get historicalAverage; Map<Subcategory, SubcategoryEstimate> get subcategoryEstimates;
/// Create a copy of CategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryEstimateCopyWith<CategoryEstimate> get copyWith => _$CategoryEstimateCopyWithImpl<CategoryEstimate>(this as CategoryEstimate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryEstimate&&(identical(other.category, category) || other.category == category)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.estimated, estimated) || other.estimated == estimated)&&(identical(other.historicalAverage, historicalAverage) || other.historicalAverage == historicalAverage)&&const DeepCollectionEquality().equals(other.subcategoryEstimates, subcategoryEstimates));
}


@override
int get hashCode => Object.hash(runtimeType,category,actual,estimated,historicalAverage,const DeepCollectionEquality().hash(subcategoryEstimates));

@override
String toString() {
  return 'CategoryEstimate(category: $category, actual: $actual, estimated: $estimated, historicalAverage: $historicalAverage, subcategoryEstimates: $subcategoryEstimates)';
}


}

/// @nodoc
abstract mixin class $CategoryEstimateCopyWith<$Res>  {
  factory $CategoryEstimateCopyWith(CategoryEstimate value, $Res Function(CategoryEstimate) _then) = _$CategoryEstimateCopyWithImpl;
@useResult
$Res call({
 Category category, double actual, double estimated, double historicalAverage, Map<Subcategory, SubcategoryEstimate> subcategoryEstimates
});




}
/// @nodoc
class _$CategoryEstimateCopyWithImpl<$Res>
    implements $CategoryEstimateCopyWith<$Res> {
  _$CategoryEstimateCopyWithImpl(this._self, this._then);

  final CategoryEstimate _self;
  final $Res Function(CategoryEstimate) _then;

/// Create a copy of CategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? actual = null,Object? estimated = null,Object? historicalAverage = null,Object? subcategoryEstimates = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as double,historicalAverage: null == historicalAverage ? _self.historicalAverage : historicalAverage // ignore: cast_nullable_to_non_nullable
as double,subcategoryEstimates: null == subcategoryEstimates ? _self.subcategoryEstimates : subcategoryEstimates // ignore: cast_nullable_to_non_nullable
as Map<Subcategory, SubcategoryEstimate>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryEstimate].
extension CategoryEstimatePatterns on CategoryEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryEstimate value)  $default,){
final _that = this;
switch (_that) {
case _CategoryEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Category category,  double actual,  double estimated,  double historicalAverage,  Map<Subcategory, SubcategoryEstimate> subcategoryEstimates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryEstimate() when $default != null:
return $default(_that.category,_that.actual,_that.estimated,_that.historicalAverage,_that.subcategoryEstimates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Category category,  double actual,  double estimated,  double historicalAverage,  Map<Subcategory, SubcategoryEstimate> subcategoryEstimates)  $default,) {final _that = this;
switch (_that) {
case _CategoryEstimate():
return $default(_that.category,_that.actual,_that.estimated,_that.historicalAverage,_that.subcategoryEstimates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Category category,  double actual,  double estimated,  double historicalAverage,  Map<Subcategory, SubcategoryEstimate> subcategoryEstimates)?  $default,) {final _that = this;
switch (_that) {
case _CategoryEstimate() when $default != null:
return $default(_that.category,_that.actual,_that.estimated,_that.historicalAverage,_that.subcategoryEstimates);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryEstimate implements CategoryEstimate {
  const _CategoryEstimate({required this.category, required this.actual, required this.estimated, required this.historicalAverage, final  Map<Subcategory, SubcategoryEstimate> subcategoryEstimates = const {}}): _subcategoryEstimates = subcategoryEstimates;
  

@override final  Category category;
@override final  double actual;
@override final  double estimated;
@override final  double historicalAverage;
 final  Map<Subcategory, SubcategoryEstimate> _subcategoryEstimates;
@override@JsonKey() Map<Subcategory, SubcategoryEstimate> get subcategoryEstimates {
  if (_subcategoryEstimates is EqualUnmodifiableMapView) return _subcategoryEstimates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_subcategoryEstimates);
}


/// Create a copy of CategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryEstimateCopyWith<_CategoryEstimate> get copyWith => __$CategoryEstimateCopyWithImpl<_CategoryEstimate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryEstimate&&(identical(other.category, category) || other.category == category)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.estimated, estimated) || other.estimated == estimated)&&(identical(other.historicalAverage, historicalAverage) || other.historicalAverage == historicalAverage)&&const DeepCollectionEquality().equals(other._subcategoryEstimates, _subcategoryEstimates));
}


@override
int get hashCode => Object.hash(runtimeType,category,actual,estimated,historicalAverage,const DeepCollectionEquality().hash(_subcategoryEstimates));

@override
String toString() {
  return 'CategoryEstimate(category: $category, actual: $actual, estimated: $estimated, historicalAverage: $historicalAverage, subcategoryEstimates: $subcategoryEstimates)';
}


}

/// @nodoc
abstract mixin class _$CategoryEstimateCopyWith<$Res> implements $CategoryEstimateCopyWith<$Res> {
  factory _$CategoryEstimateCopyWith(_CategoryEstimate value, $Res Function(_CategoryEstimate) _then) = __$CategoryEstimateCopyWithImpl;
@override @useResult
$Res call({
 Category category, double actual, double estimated, double historicalAverage, Map<Subcategory, SubcategoryEstimate> subcategoryEstimates
});




}
/// @nodoc
class __$CategoryEstimateCopyWithImpl<$Res>
    implements _$CategoryEstimateCopyWith<$Res> {
  __$CategoryEstimateCopyWithImpl(this._self, this._then);

  final _CategoryEstimate _self;
  final $Res Function(_CategoryEstimate) _then;

/// Create a copy of CategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? actual = null,Object? estimated = null,Object? historicalAverage = null,Object? subcategoryEstimates = null,}) {
  return _then(_CategoryEstimate(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as double,historicalAverage: null == historicalAverage ? _self.historicalAverage : historicalAverage // ignore: cast_nullable_to_non_nullable
as double,subcategoryEstimates: null == subcategoryEstimates ? _self._subcategoryEstimates : subcategoryEstimates // ignore: cast_nullable_to_non_nullable
as Map<Subcategory, SubcategoryEstimate>,
  ));
}


}

/// @nodoc
mixin _$SubcategoryEstimate {

 Subcategory get subcategory; double get actual; double get estimated; double get historicalAverage;
/// Create a copy of SubcategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubcategoryEstimateCopyWith<SubcategoryEstimate> get copyWith => _$SubcategoryEstimateCopyWithImpl<SubcategoryEstimate>(this as SubcategoryEstimate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubcategoryEstimate&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.estimated, estimated) || other.estimated == estimated)&&(identical(other.historicalAverage, historicalAverage) || other.historicalAverage == historicalAverage));
}


@override
int get hashCode => Object.hash(runtimeType,subcategory,actual,estimated,historicalAverage);

@override
String toString() {
  return 'SubcategoryEstimate(subcategory: $subcategory, actual: $actual, estimated: $estimated, historicalAverage: $historicalAverage)';
}


}

/// @nodoc
abstract mixin class $SubcategoryEstimateCopyWith<$Res>  {
  factory $SubcategoryEstimateCopyWith(SubcategoryEstimate value, $Res Function(SubcategoryEstimate) _then) = _$SubcategoryEstimateCopyWithImpl;
@useResult
$Res call({
 Subcategory subcategory, double actual, double estimated, double historicalAverage
});




}
/// @nodoc
class _$SubcategoryEstimateCopyWithImpl<$Res>
    implements $SubcategoryEstimateCopyWith<$Res> {
  _$SubcategoryEstimateCopyWithImpl(this._self, this._then);

  final SubcategoryEstimate _self;
  final $Res Function(SubcategoryEstimate) _then;

/// Create a copy of SubcategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subcategory = null,Object? actual = null,Object? estimated = null,Object? historicalAverage = null,}) {
  return _then(_self.copyWith(
subcategory: null == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as double,historicalAverage: null == historicalAverage ? _self.historicalAverage : historicalAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SubcategoryEstimate].
extension SubcategoryEstimatePatterns on SubcategoryEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubcategoryEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubcategoryEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubcategoryEstimate value)  $default,){
final _that = this;
switch (_that) {
case _SubcategoryEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubcategoryEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _SubcategoryEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Subcategory subcategory,  double actual,  double estimated,  double historicalAverage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubcategoryEstimate() when $default != null:
return $default(_that.subcategory,_that.actual,_that.estimated,_that.historicalAverage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Subcategory subcategory,  double actual,  double estimated,  double historicalAverage)  $default,) {final _that = this;
switch (_that) {
case _SubcategoryEstimate():
return $default(_that.subcategory,_that.actual,_that.estimated,_that.historicalAverage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Subcategory subcategory,  double actual,  double estimated,  double historicalAverage)?  $default,) {final _that = this;
switch (_that) {
case _SubcategoryEstimate() when $default != null:
return $default(_that.subcategory,_that.actual,_that.estimated,_that.historicalAverage);case _:
  return null;

}
}

}

/// @nodoc


class _SubcategoryEstimate implements SubcategoryEstimate {
  const _SubcategoryEstimate({required this.subcategory, required this.actual, required this.estimated, required this.historicalAverage});
  

@override final  Subcategory subcategory;
@override final  double actual;
@override final  double estimated;
@override final  double historicalAverage;

/// Create a copy of SubcategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubcategoryEstimateCopyWith<_SubcategoryEstimate> get copyWith => __$SubcategoryEstimateCopyWithImpl<_SubcategoryEstimate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubcategoryEstimate&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.actual, actual) || other.actual == actual)&&(identical(other.estimated, estimated) || other.estimated == estimated)&&(identical(other.historicalAverage, historicalAverage) || other.historicalAverage == historicalAverage));
}


@override
int get hashCode => Object.hash(runtimeType,subcategory,actual,estimated,historicalAverage);

@override
String toString() {
  return 'SubcategoryEstimate(subcategory: $subcategory, actual: $actual, estimated: $estimated, historicalAverage: $historicalAverage)';
}


}

/// @nodoc
abstract mixin class _$SubcategoryEstimateCopyWith<$Res> implements $SubcategoryEstimateCopyWith<$Res> {
  factory _$SubcategoryEstimateCopyWith(_SubcategoryEstimate value, $Res Function(_SubcategoryEstimate) _then) = __$SubcategoryEstimateCopyWithImpl;
@override @useResult
$Res call({
 Subcategory subcategory, double actual, double estimated, double historicalAverage
});




}
/// @nodoc
class __$SubcategoryEstimateCopyWithImpl<$Res>
    implements _$SubcategoryEstimateCopyWith<$Res> {
  __$SubcategoryEstimateCopyWithImpl(this._self, this._then);

  final _SubcategoryEstimate _self;
  final $Res Function(_SubcategoryEstimate) _then;

/// Create a copy of SubcategoryEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subcategory = null,Object? actual = null,Object? estimated = null,Object? historicalAverage = null,}) {
  return _then(_SubcategoryEstimate(
subcategory: null == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory,actual: null == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as double,historicalAverage: null == historicalAverage ? _self.historicalAverage : historicalAverage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$RecurringStatus {

 String get descriptionPattern; double get averageAmount; int? get typicalDayOfMonth; Category get category; Subcategory? get subcategory; TransactionType get type; int get occurrenceCount;
/// Create a copy of RecurringStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringStatusCopyWith<RecurringStatus> get copyWith => _$RecurringStatusCopyWithImpl<RecurringStatus>(this as RecurringStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringStatus&&(identical(other.descriptionPattern, descriptionPattern) || other.descriptionPattern == descriptionPattern)&&(identical(other.averageAmount, averageAmount) || other.averageAmount == averageAmount)&&(identical(other.typicalDayOfMonth, typicalDayOfMonth) || other.typicalDayOfMonth == typicalDayOfMonth)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount));
}


@override
int get hashCode => Object.hash(runtimeType,descriptionPattern,averageAmount,typicalDayOfMonth,category,subcategory,type,occurrenceCount);

@override
String toString() {
  return 'RecurringStatus(descriptionPattern: $descriptionPattern, averageAmount: $averageAmount, typicalDayOfMonth: $typicalDayOfMonth, category: $category, subcategory: $subcategory, type: $type, occurrenceCount: $occurrenceCount)';
}


}

/// @nodoc
abstract mixin class $RecurringStatusCopyWith<$Res>  {
  factory $RecurringStatusCopyWith(RecurringStatus value, $Res Function(RecurringStatus) _then) = _$RecurringStatusCopyWithImpl;
@useResult
$Res call({
 String descriptionPattern, double averageAmount, int? typicalDayOfMonth, Category category, Subcategory? subcategory, TransactionType type, int occurrenceCount
});




}
/// @nodoc
class _$RecurringStatusCopyWithImpl<$Res>
    implements $RecurringStatusCopyWith<$Res> {
  _$RecurringStatusCopyWithImpl(this._self, this._then);

  final RecurringStatus _self;
  final $Res Function(RecurringStatus) _then;

/// Create a copy of RecurringStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? descriptionPattern = null,Object? averageAmount = null,Object? typicalDayOfMonth = freezed,Object? category = null,Object? subcategory = freezed,Object? type = null,Object? occurrenceCount = null,}) {
  return _then(_self.copyWith(
descriptionPattern: null == descriptionPattern ? _self.descriptionPattern : descriptionPattern // ignore: cast_nullable_to_non_nullable
as String,averageAmount: null == averageAmount ? _self.averageAmount : averageAmount // ignore: cast_nullable_to_non_nullable
as double,typicalDayOfMonth: freezed == typicalDayOfMonth ? _self.typicalDayOfMonth : typicalDayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringStatus].
extension RecurringStatusPatterns on RecurringStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringStatus value)  $default,){
final _that = this;
switch (_that) {
case _RecurringStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringStatus value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String descriptionPattern,  double averageAmount,  int? typicalDayOfMonth,  Category category,  Subcategory? subcategory,  TransactionType type,  int occurrenceCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringStatus() when $default != null:
return $default(_that.descriptionPattern,_that.averageAmount,_that.typicalDayOfMonth,_that.category,_that.subcategory,_that.type,_that.occurrenceCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String descriptionPattern,  double averageAmount,  int? typicalDayOfMonth,  Category category,  Subcategory? subcategory,  TransactionType type,  int occurrenceCount)  $default,) {final _that = this;
switch (_that) {
case _RecurringStatus():
return $default(_that.descriptionPattern,_that.averageAmount,_that.typicalDayOfMonth,_that.category,_that.subcategory,_that.type,_that.occurrenceCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String descriptionPattern,  double averageAmount,  int? typicalDayOfMonth,  Category category,  Subcategory? subcategory,  TransactionType type,  int occurrenceCount)?  $default,) {final _that = this;
switch (_that) {
case _RecurringStatus() when $default != null:
return $default(_that.descriptionPattern,_that.averageAmount,_that.typicalDayOfMonth,_that.category,_that.subcategory,_that.type,_that.occurrenceCount);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringStatus implements RecurringStatus {
  const _RecurringStatus({required this.descriptionPattern, required this.averageAmount, required this.typicalDayOfMonth, required this.category, required this.subcategory, required this.type, required this.occurrenceCount});
  

@override final  String descriptionPattern;
@override final  double averageAmount;
@override final  int? typicalDayOfMonth;
@override final  Category category;
@override final  Subcategory? subcategory;
@override final  TransactionType type;
@override final  int occurrenceCount;

/// Create a copy of RecurringStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringStatusCopyWith<_RecurringStatus> get copyWith => __$RecurringStatusCopyWithImpl<_RecurringStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringStatus&&(identical(other.descriptionPattern, descriptionPattern) || other.descriptionPattern == descriptionPattern)&&(identical(other.averageAmount, averageAmount) || other.averageAmount == averageAmount)&&(identical(other.typicalDayOfMonth, typicalDayOfMonth) || other.typicalDayOfMonth == typicalDayOfMonth)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.type, type) || other.type == type)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount));
}


@override
int get hashCode => Object.hash(runtimeType,descriptionPattern,averageAmount,typicalDayOfMonth,category,subcategory,type,occurrenceCount);

@override
String toString() {
  return 'RecurringStatus(descriptionPattern: $descriptionPattern, averageAmount: $averageAmount, typicalDayOfMonth: $typicalDayOfMonth, category: $category, subcategory: $subcategory, type: $type, occurrenceCount: $occurrenceCount)';
}


}

/// @nodoc
abstract mixin class _$RecurringStatusCopyWith<$Res> implements $RecurringStatusCopyWith<$Res> {
  factory _$RecurringStatusCopyWith(_RecurringStatus value, $Res Function(_RecurringStatus) _then) = __$RecurringStatusCopyWithImpl;
@override @useResult
$Res call({
 String descriptionPattern, double averageAmount, int? typicalDayOfMonth, Category category, Subcategory? subcategory, TransactionType type, int occurrenceCount
});




}
/// @nodoc
class __$RecurringStatusCopyWithImpl<$Res>
    implements _$RecurringStatusCopyWith<$Res> {
  __$RecurringStatusCopyWithImpl(this._self, this._then);

  final _RecurringStatus _self;
  final $Res Function(_RecurringStatus) _then;

/// Create a copy of RecurringStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? descriptionPattern = null,Object? averageAmount = null,Object? typicalDayOfMonth = freezed,Object? category = null,Object? subcategory = freezed,Object? type = null,Object? occurrenceCount = null,}) {
  return _then(_RecurringStatus(
descriptionPattern: null == descriptionPattern ? _self.descriptionPattern : descriptionPattern // ignore: cast_nullable_to_non_nullable
as String,averageAmount: null == averageAmount ? _self.averageAmount : averageAmount // ignore: cast_nullable_to_non_nullable
as double,typicalDayOfMonth: freezed == typicalDayOfMonth ? _self.typicalDayOfMonth : typicalDayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as Subcategory?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
