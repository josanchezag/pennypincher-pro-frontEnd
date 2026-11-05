// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ant_expense_report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AntCategoryShare {
  AntExpenseCategory get category => throw _privateConstructorUsedError;
  Money get total => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Create a copy of AntCategoryShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntCategoryShareCopyWith<AntCategoryShare> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntCategoryShareCopyWith<$Res> {
  factory $AntCategoryShareCopyWith(
          AntCategoryShare value, $Res Function(AntCategoryShare) then) =
      _$AntCategoryShareCopyWithImpl<$Res, AntCategoryShare>;
  @useResult
  $Res call(
      {AntExpenseCategory category, Money total, int count, double percentage});
}

/// @nodoc
class _$AntCategoryShareCopyWithImpl<$Res, $Val extends AntCategoryShare>
    implements $AntCategoryShareCopyWith<$Res> {
  _$AntCategoryShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntCategoryShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntCategoryShareImplCopyWith<$Res>
    implements $AntCategoryShareCopyWith<$Res> {
  factory _$$AntCategoryShareImplCopyWith(_$AntCategoryShareImpl value,
          $Res Function(_$AntCategoryShareImpl) then) =
      __$$AntCategoryShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AntExpenseCategory category, Money total, int count, double percentage});
}

/// @nodoc
class __$$AntCategoryShareImplCopyWithImpl<$Res>
    extends _$AntCategoryShareCopyWithImpl<$Res, _$AntCategoryShareImpl>
    implements _$$AntCategoryShareImplCopyWith<$Res> {
  __$$AntCategoryShareImplCopyWithImpl(_$AntCategoryShareImpl _value,
      $Res Function(_$AntCategoryShareImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntCategoryShare
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(_$AntCategoryShareImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$AntCategoryShareImpl implements _AntCategoryShare {
  const _$AntCategoryShareImpl(
      {required this.category,
      required this.total,
      required this.count,
      required this.percentage});

  @override
  final AntExpenseCategory category;
  @override
  final Money total;
  @override
  final int count;
  @override
  final double percentage;

  @override
  String toString() {
    return 'AntCategoryShare(category: $category, total: $total, count: $count, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntCategoryShareImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, category, total, count, percentage);

  /// Create a copy of AntCategoryShare
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntCategoryShareImplCopyWith<_$AntCategoryShareImpl> get copyWith =>
      __$$AntCategoryShareImplCopyWithImpl<_$AntCategoryShareImpl>(
          this, _$identity);
}

abstract class _AntCategoryShare implements AntCategoryShare {
  const factory _AntCategoryShare(
      {required final AntExpenseCategory category,
      required final Money total,
      required final int count,
      required final double percentage}) = _$AntCategoryShareImpl;

  @override
  AntExpenseCategory get category;
  @override
  Money get total;
  @override
  int get count;
  @override
  double get percentage;

  /// Create a copy of AntCategoryShare
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntCategoryShareImplCopyWith<_$AntCategoryShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AntLastCut {
  String get budgetId => throw _privateConstructorUsedError;

  /// First day of the month of the budget.
  DateTime get month => throw _privateConstructorUsedError;
  DateTime get cutAt => throw _privateConstructorUsedError;

  /// Create a copy of AntLastCut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntLastCutCopyWith<AntLastCut> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntLastCutCopyWith<$Res> {
  factory $AntLastCutCopyWith(
          AntLastCut value, $Res Function(AntLastCut) then) =
      _$AntLastCutCopyWithImpl<$Res, AntLastCut>;
  @useResult
  $Res call({String budgetId, DateTime month, DateTime cutAt});
}

/// @nodoc
class _$AntLastCutCopyWithImpl<$Res, $Val extends AntLastCut>
    implements $AntLastCutCopyWith<$Res> {
  _$AntLastCutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntLastCut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? month = null,
    Object? cutAt = null,
  }) {
    return _then(_value.copyWith(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cutAt: null == cutAt
          ? _value.cutAt
          : cutAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntLastCutImplCopyWith<$Res>
    implements $AntLastCutCopyWith<$Res> {
  factory _$$AntLastCutImplCopyWith(
          _$AntLastCutImpl value, $Res Function(_$AntLastCutImpl) then) =
      __$$AntLastCutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String budgetId, DateTime month, DateTime cutAt});
}

/// @nodoc
class __$$AntLastCutImplCopyWithImpl<$Res>
    extends _$AntLastCutCopyWithImpl<$Res, _$AntLastCutImpl>
    implements _$$AntLastCutImplCopyWith<$Res> {
  __$$AntLastCutImplCopyWithImpl(
      _$AntLastCutImpl _value, $Res Function(_$AntLastCutImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntLastCut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? month = null,
    Object? cutAt = null,
  }) {
    return _then(_$AntLastCutImpl(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cutAt: null == cutAt
          ? _value.cutAt
          : cutAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$AntLastCutImpl implements _AntLastCut {
  const _$AntLastCutImpl(
      {required this.budgetId, required this.month, required this.cutAt});

  @override
  final String budgetId;

  /// First day of the month of the budget.
  @override
  final DateTime month;
  @override
  final DateTime cutAt;

  @override
  String toString() {
    return 'AntLastCut(budgetId: $budgetId, month: $month, cutAt: $cutAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntLastCutImpl &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.cutAt, cutAt) || other.cutAt == cutAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, budgetId, month, cutAt);

  /// Create a copy of AntLastCut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntLastCutImplCopyWith<_$AntLastCutImpl> get copyWith =>
      __$$AntLastCutImplCopyWithImpl<_$AntLastCutImpl>(this, _$identity);
}

abstract class _AntLastCut implements AntLastCut {
  const factory _AntLastCut(
      {required final String budgetId,
      required final DateTime month,
      required final DateTime cutAt}) = _$AntLastCutImpl;

  @override
  String get budgetId;

  /// First day of the month of the budget.
  @override
  DateTime get month;
  @override
  DateTime get cutAt;

  /// Create a copy of AntLastCut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntLastCutImplCopyWith<_$AntLastCutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AntLimitUsage {
  Money get monthlyLimit => throw _privateConstructorUsedError;
  double get usedPercentage => throw _privateConstructorUsedError;
  Money get remaining => throw _privateConstructorUsedError;

  /// Create a copy of AntLimitUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntLimitUsageCopyWith<AntLimitUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntLimitUsageCopyWith<$Res> {
  factory $AntLimitUsageCopyWith(
          AntLimitUsage value, $Res Function(AntLimitUsage) then) =
      _$AntLimitUsageCopyWithImpl<$Res, AntLimitUsage>;
  @useResult
  $Res call({Money monthlyLimit, double usedPercentage, Money remaining});
}

/// @nodoc
class _$AntLimitUsageCopyWithImpl<$Res, $Val extends AntLimitUsage>
    implements $AntLimitUsageCopyWith<$Res> {
  _$AntLimitUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntLimitUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlyLimit = null,
    Object? usedPercentage = null,
    Object? remaining = null,
  }) {
    return _then(_value.copyWith(
      monthlyLimit: null == monthlyLimit
          ? _value.monthlyLimit
          : monthlyLimit // ignore: cast_nullable_to_non_nullable
              as Money,
      usedPercentage: null == usedPercentage
          ? _value.usedPercentage
          : usedPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as Money,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntLimitUsageImplCopyWith<$Res>
    implements $AntLimitUsageCopyWith<$Res> {
  factory _$$AntLimitUsageImplCopyWith(
          _$AntLimitUsageImpl value, $Res Function(_$AntLimitUsageImpl) then) =
      __$$AntLimitUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Money monthlyLimit, double usedPercentage, Money remaining});
}

/// @nodoc
class __$$AntLimitUsageImplCopyWithImpl<$Res>
    extends _$AntLimitUsageCopyWithImpl<$Res, _$AntLimitUsageImpl>
    implements _$$AntLimitUsageImplCopyWith<$Res> {
  __$$AntLimitUsageImplCopyWithImpl(
      _$AntLimitUsageImpl _value, $Res Function(_$AntLimitUsageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntLimitUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlyLimit = null,
    Object? usedPercentage = null,
    Object? remaining = null,
  }) {
    return _then(_$AntLimitUsageImpl(
      monthlyLimit: null == monthlyLimit
          ? _value.monthlyLimit
          : monthlyLimit // ignore: cast_nullable_to_non_nullable
              as Money,
      usedPercentage: null == usedPercentage
          ? _value.usedPercentage
          : usedPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as Money,
    ));
  }
}

/// @nodoc

class _$AntLimitUsageImpl extends _AntLimitUsage {
  const _$AntLimitUsageImpl(
      {required this.monthlyLimit,
      required this.usedPercentage,
      required this.remaining})
      : super._();

  @override
  final Money monthlyLimit;
  @override
  final double usedPercentage;
  @override
  final Money remaining;

  @override
  String toString() {
    return 'AntLimitUsage(monthlyLimit: $monthlyLimit, usedPercentage: $usedPercentage, remaining: $remaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntLimitUsageImpl &&
            (identical(other.monthlyLimit, monthlyLimit) ||
                other.monthlyLimit == monthlyLimit) &&
            (identical(other.usedPercentage, usedPercentage) ||
                other.usedPercentage == usedPercentage) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, monthlyLimit, usedPercentage, remaining);

  /// Create a copy of AntLimitUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntLimitUsageImplCopyWith<_$AntLimitUsageImpl> get copyWith =>
      __$$AntLimitUsageImplCopyWithImpl<_$AntLimitUsageImpl>(this, _$identity);
}

abstract class _AntLimitUsage extends AntLimitUsage {
  const factory _AntLimitUsage(
      {required final Money monthlyLimit,
      required final double usedPercentage,
      required final Money remaining}) = _$AntLimitUsageImpl;
  const _AntLimitUsage._() : super._();

  @override
  Money get monthlyLimit;
  @override
  double get usedPercentage;
  @override
  Money get remaining;

  /// Create a copy of AntLimitUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntLimitUsageImplCopyWith<_$AntLimitUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AntSummary {
  Money get total => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Days from [periodStart] to today, both included; 0 without a start.
  int get days => throw _privateConstructorUsedError;
  Money get dailyAverage => throw _privateConstructorUsedError;

  /// Only the categories with expenses, in the order of
  /// [AntExpenseCategory.values].
  List<AntCategoryShare> get byCategory => throw _privateConstructorUsedError;
  DateTime? get periodStart => throw _privateConstructorUsedError;
  AntExpenseCategory? get topCategory => throw _privateConstructorUsedError;
  AntLastCut? get lastCut => throw _privateConstructorUsedError;
  int? get daysSinceLastCut => throw _privateConstructorUsedError;
  AntLimitUsage? get limit => throw _privateConstructorUsedError;

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntSummaryCopyWith<AntSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntSummaryCopyWith<$Res> {
  factory $AntSummaryCopyWith(
          AntSummary value, $Res Function(AntSummary) then) =
      _$AntSummaryCopyWithImpl<$Res, AntSummary>;
  @useResult
  $Res call(
      {Money total,
      int count,
      int days,
      Money dailyAverage,
      List<AntCategoryShare> byCategory,
      DateTime? periodStart,
      AntExpenseCategory? topCategory,
      AntLastCut? lastCut,
      int? daysSinceLastCut,
      AntLimitUsage? limit});

  $AntLastCutCopyWith<$Res>? get lastCut;
  $AntLimitUsageCopyWith<$Res>? get limit;
}

/// @nodoc
class _$AntSummaryCopyWithImpl<$Res, $Val extends AntSummary>
    implements $AntSummaryCopyWith<$Res> {
  _$AntSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? count = null,
    Object? days = null,
    Object? dailyAverage = null,
    Object? byCategory = null,
    Object? periodStart = freezed,
    Object? topCategory = freezed,
    Object? lastCut = freezed,
    Object? daysSinceLastCut = freezed,
    Object? limit = freezed,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      dailyAverage: null == dailyAverage
          ? _value.dailyAverage
          : dailyAverage // ignore: cast_nullable_to_non_nullable
              as Money,
      byCategory: null == byCategory
          ? _value.byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as List<AntCategoryShare>,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      topCategory: freezed == topCategory
          ? _value.topCategory
          : topCategory // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory?,
      lastCut: freezed == lastCut
          ? _value.lastCut
          : lastCut // ignore: cast_nullable_to_non_nullable
              as AntLastCut?,
      daysSinceLastCut: freezed == daysSinceLastCut
          ? _value.daysSinceLastCut
          : daysSinceLastCut // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as AntLimitUsage?,
    ) as $Val);
  }

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AntLastCutCopyWith<$Res>? get lastCut {
    if (_value.lastCut == null) {
      return null;
    }

    return $AntLastCutCopyWith<$Res>(_value.lastCut!, (value) {
      return _then(_value.copyWith(lastCut: value) as $Val);
    });
  }

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AntLimitUsageCopyWith<$Res>? get limit {
    if (_value.limit == null) {
      return null;
    }

    return $AntLimitUsageCopyWith<$Res>(_value.limit!, (value) {
      return _then(_value.copyWith(limit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AntSummaryImplCopyWith<$Res>
    implements $AntSummaryCopyWith<$Res> {
  factory _$$AntSummaryImplCopyWith(
          _$AntSummaryImpl value, $Res Function(_$AntSummaryImpl) then) =
      __$$AntSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Money total,
      int count,
      int days,
      Money dailyAverage,
      List<AntCategoryShare> byCategory,
      DateTime? periodStart,
      AntExpenseCategory? topCategory,
      AntLastCut? lastCut,
      int? daysSinceLastCut,
      AntLimitUsage? limit});

  @override
  $AntLastCutCopyWith<$Res>? get lastCut;
  @override
  $AntLimitUsageCopyWith<$Res>? get limit;
}

/// @nodoc
class __$$AntSummaryImplCopyWithImpl<$Res>
    extends _$AntSummaryCopyWithImpl<$Res, _$AntSummaryImpl>
    implements _$$AntSummaryImplCopyWith<$Res> {
  __$$AntSummaryImplCopyWithImpl(
      _$AntSummaryImpl _value, $Res Function(_$AntSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? count = null,
    Object? days = null,
    Object? dailyAverage = null,
    Object? byCategory = null,
    Object? periodStart = freezed,
    Object? topCategory = freezed,
    Object? lastCut = freezed,
    Object? daysSinceLastCut = freezed,
    Object? limit = freezed,
  }) {
    return _then(_$AntSummaryImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as int,
      dailyAverage: null == dailyAverage
          ? _value.dailyAverage
          : dailyAverage // ignore: cast_nullable_to_non_nullable
              as Money,
      byCategory: null == byCategory
          ? _value._byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as List<AntCategoryShare>,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      topCategory: freezed == topCategory
          ? _value.topCategory
          : topCategory // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory?,
      lastCut: freezed == lastCut
          ? _value.lastCut
          : lastCut // ignore: cast_nullable_to_non_nullable
              as AntLastCut?,
      daysSinceLastCut: freezed == daysSinceLastCut
          ? _value.daysSinceLastCut
          : daysSinceLastCut // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as AntLimitUsage?,
    ));
  }
}

/// @nodoc

class _$AntSummaryImpl implements _AntSummary {
  const _$AntSummaryImpl(
      {required this.total,
      required this.count,
      required this.days,
      required this.dailyAverage,
      required final List<AntCategoryShare> byCategory,
      this.periodStart,
      this.topCategory,
      this.lastCut,
      this.daysSinceLastCut,
      this.limit})
      : _byCategory = byCategory;

  @override
  final Money total;
  @override
  final int count;

  /// Days from [periodStart] to today, both included; 0 without a start.
  @override
  final int days;
  @override
  final Money dailyAverage;

  /// Only the categories with expenses, in the order of
  /// [AntExpenseCategory.values].
  final List<AntCategoryShare> _byCategory;

  /// Only the categories with expenses, in the order of
  /// [AntExpenseCategory.values].
  @override
  List<AntCategoryShare> get byCategory {
    if (_byCategory is EqualUnmodifiableListView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byCategory);
  }

  @override
  final DateTime? periodStart;
  @override
  final AntExpenseCategory? topCategory;
  @override
  final AntLastCut? lastCut;
  @override
  final int? daysSinceLastCut;
  @override
  final AntLimitUsage? limit;

  @override
  String toString() {
    return 'AntSummary(total: $total, count: $count, days: $days, dailyAverage: $dailyAverage, byCategory: $byCategory, periodStart: $periodStart, topCategory: $topCategory, lastCut: $lastCut, daysSinceLastCut: $daysSinceLastCut, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntSummaryImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.days, days) || other.days == days) &&
            (identical(other.dailyAverage, dailyAverage) ||
                other.dailyAverage == dailyAverage) &&
            const DeepCollectionEquality()
                .equals(other._byCategory, _byCategory) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.topCategory, topCategory) ||
                other.topCategory == topCategory) &&
            (identical(other.lastCut, lastCut) || other.lastCut == lastCut) &&
            (identical(other.daysSinceLastCut, daysSinceLastCut) ||
                other.daysSinceLastCut == daysSinceLastCut) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      count,
      days,
      dailyAverage,
      const DeepCollectionEquality().hash(_byCategory),
      periodStart,
      topCategory,
      lastCut,
      daysSinceLastCut,
      limit);

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntSummaryImplCopyWith<_$AntSummaryImpl> get copyWith =>
      __$$AntSummaryImplCopyWithImpl<_$AntSummaryImpl>(this, _$identity);
}

abstract class _AntSummary implements AntSummary {
  const factory _AntSummary(
      {required final Money total,
      required final int count,
      required final int days,
      required final Money dailyAverage,
      required final List<AntCategoryShare> byCategory,
      final DateTime? periodStart,
      final AntExpenseCategory? topCategory,
      final AntLastCut? lastCut,
      final int? daysSinceLastCut,
      final AntLimitUsage? limit}) = _$AntSummaryImpl;

  @override
  Money get total;
  @override
  int get count;

  /// Days from [periodStart] to today, both included; 0 without a start.
  @override
  int get days;
  @override
  Money get dailyAverage;

  /// Only the categories with expenses, in the order of
  /// [AntExpenseCategory.values].
  @override
  List<AntCategoryShare> get byCategory;
  @override
  DateTime? get periodStart;
  @override
  AntExpenseCategory? get topCategory;
  @override
  AntLastCut? get lastCut;
  @override
  int? get daysSinceLastCut;
  @override
  AntLimitUsage? get limit;

  /// Create a copy of AntSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntSummaryImplCopyWith<_$AntSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AntCut {
  String get budgetId => throw _privateConstructorUsedError;

  /// First day of the month of the budget.
  DateTime get month => throw _privateConstructorUsedError;
  DateTime get cutAt => throw _privateConstructorUsedError;

  /// Oldest and newest purchase among the expenses of the cut.
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  Money get total => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<AntCategoryShare> get byCategory => throw _privateConstructorUsedError;
  AntExpenseCategory? get topCategory => throw _privateConstructorUsedError;

  /// Create a copy of AntCut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntCutCopyWith<AntCut> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntCutCopyWith<$Res> {
  factory $AntCutCopyWith(AntCut value, $Res Function(AntCut) then) =
      _$AntCutCopyWithImpl<$Res, AntCut>;
  @useResult
  $Res call(
      {String budgetId,
      DateTime month,
      DateTime cutAt,
      DateTime periodStart,
      DateTime periodEnd,
      Money total,
      int count,
      List<AntCategoryShare> byCategory,
      AntExpenseCategory? topCategory});
}

/// @nodoc
class _$AntCutCopyWithImpl<$Res, $Val extends AntCut>
    implements $AntCutCopyWith<$Res> {
  _$AntCutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntCut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? month = null,
    Object? cutAt = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? total = null,
    Object? count = null,
    Object? byCategory = null,
    Object? topCategory = freezed,
  }) {
    return _then(_value.copyWith(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cutAt: null == cutAt
          ? _value.cutAt
          : cutAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      byCategory: null == byCategory
          ? _value.byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as List<AntCategoryShare>,
      topCategory: freezed == topCategory
          ? _value.topCategory
          : topCategory // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntCutImplCopyWith<$Res> implements $AntCutCopyWith<$Res> {
  factory _$$AntCutImplCopyWith(
          _$AntCutImpl value, $Res Function(_$AntCutImpl) then) =
      __$$AntCutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String budgetId,
      DateTime month,
      DateTime cutAt,
      DateTime periodStart,
      DateTime periodEnd,
      Money total,
      int count,
      List<AntCategoryShare> byCategory,
      AntExpenseCategory? topCategory});
}

/// @nodoc
class __$$AntCutImplCopyWithImpl<$Res>
    extends _$AntCutCopyWithImpl<$Res, _$AntCutImpl>
    implements _$$AntCutImplCopyWith<$Res> {
  __$$AntCutImplCopyWithImpl(
      _$AntCutImpl _value, $Res Function(_$AntCutImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntCut
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetId = null,
    Object? month = null,
    Object? cutAt = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? total = null,
    Object? count = null,
    Object? byCategory = null,
    Object? topCategory = freezed,
  }) {
    return _then(_$AntCutImpl(
      budgetId: null == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cutAt: null == cutAt
          ? _value.cutAt
          : cutAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodStart: null == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodEnd: null == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      byCategory: null == byCategory
          ? _value._byCategory
          : byCategory // ignore: cast_nullable_to_non_nullable
              as List<AntCategoryShare>,
      topCategory: freezed == topCategory
          ? _value.topCategory
          : topCategory // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory?,
    ));
  }
}

/// @nodoc

class _$AntCutImpl implements _AntCut {
  const _$AntCutImpl(
      {required this.budgetId,
      required this.month,
      required this.cutAt,
      required this.periodStart,
      required this.periodEnd,
      required this.total,
      required this.count,
      required final List<AntCategoryShare> byCategory,
      this.topCategory})
      : _byCategory = byCategory;

  @override
  final String budgetId;

  /// First day of the month of the budget.
  @override
  final DateTime month;
  @override
  final DateTime cutAt;

  /// Oldest and newest purchase among the expenses of the cut.
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  @override
  final Money total;
  @override
  final int count;
  final List<AntCategoryShare> _byCategory;
  @override
  List<AntCategoryShare> get byCategory {
    if (_byCategory is EqualUnmodifiableListView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byCategory);
  }

  @override
  final AntExpenseCategory? topCategory;

  @override
  String toString() {
    return 'AntCut(budgetId: $budgetId, month: $month, cutAt: $cutAt, periodStart: $periodStart, periodEnd: $periodEnd, total: $total, count: $count, byCategory: $byCategory, topCategory: $topCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntCutImpl &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.cutAt, cutAt) || other.cutAt == cutAt) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality()
                .equals(other._byCategory, _byCategory) &&
            (identical(other.topCategory, topCategory) ||
                other.topCategory == topCategory));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      budgetId,
      month,
      cutAt,
      periodStart,
      periodEnd,
      total,
      count,
      const DeepCollectionEquality().hash(_byCategory),
      topCategory);

  /// Create a copy of AntCut
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntCutImplCopyWith<_$AntCutImpl> get copyWith =>
      __$$AntCutImplCopyWithImpl<_$AntCutImpl>(this, _$identity);
}

abstract class _AntCut implements AntCut {
  const factory _AntCut(
      {required final String budgetId,
      required final DateTime month,
      required final DateTime cutAt,
      required final DateTime periodStart,
      required final DateTime periodEnd,
      required final Money total,
      required final int count,
      required final List<AntCategoryShare> byCategory,
      final AntExpenseCategory? topCategory}) = _$AntCutImpl;

  @override
  String get budgetId;

  /// First day of the month of the budget.
  @override
  DateTime get month;
  @override
  DateTime get cutAt;

  /// Oldest and newest purchase among the expenses of the cut.
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  Money get total;
  @override
  int get count;
  @override
  List<AntCategoryShare> get byCategory;
  @override
  AntExpenseCategory? get topCategory;

  /// Create a copy of AntCut
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntCutImplCopyWith<_$AntCutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AntTrendMonth {
  /// First day of the month.
  DateTime get month => throw _privateConstructorUsedError;
  Money get total => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Create a copy of AntTrendMonth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntTrendMonthCopyWith<AntTrendMonth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntTrendMonthCopyWith<$Res> {
  factory $AntTrendMonthCopyWith(
          AntTrendMonth value, $Res Function(AntTrendMonth) then) =
      _$AntTrendMonthCopyWithImpl<$Res, AntTrendMonth>;
  @useResult
  $Res call({DateTime month, Money total, int count});
}

/// @nodoc
class _$AntTrendMonthCopyWithImpl<$Res, $Val extends AntTrendMonth>
    implements $AntTrendMonthCopyWith<$Res> {
  _$AntTrendMonthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntTrendMonth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntTrendMonthImplCopyWith<$Res>
    implements $AntTrendMonthCopyWith<$Res> {
  factory _$$AntTrendMonthImplCopyWith(
          _$AntTrendMonthImpl value, $Res Function(_$AntTrendMonthImpl) then) =
      __$$AntTrendMonthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime month, Money total, int count});
}

/// @nodoc
class __$$AntTrendMonthImplCopyWithImpl<$Res>
    extends _$AntTrendMonthCopyWithImpl<$Res, _$AntTrendMonthImpl>
    implements _$$AntTrendMonthImplCopyWith<$Res> {
  __$$AntTrendMonthImplCopyWithImpl(
      _$AntTrendMonthImpl _value, $Res Function(_$AntTrendMonthImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntTrendMonth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(_$AntTrendMonthImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AntTrendMonthImpl implements _AntTrendMonth {
  const _$AntTrendMonthImpl(
      {required this.month, required this.total, required this.count});

  /// First day of the month.
  @override
  final DateTime month;
  @override
  final Money total;
  @override
  final int count;

  @override
  String toString() {
    return 'AntTrendMonth(month: $month, total: $total, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntTrendMonthImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, total, count);

  /// Create a copy of AntTrendMonth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntTrendMonthImplCopyWith<_$AntTrendMonthImpl> get copyWith =>
      __$$AntTrendMonthImplCopyWithImpl<_$AntTrendMonthImpl>(this, _$identity);
}

abstract class _AntTrendMonth implements AntTrendMonth {
  const factory _AntTrendMonth(
      {required final DateTime month,
      required final Money total,
      required final int count}) = _$AntTrendMonthImpl;

  /// First day of the month.
  @override
  DateTime get month;
  @override
  Money get total;
  @override
  int get count;

  /// Create a copy of AntTrendMonth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntTrendMonthImplCopyWith<_$AntTrendMonthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
