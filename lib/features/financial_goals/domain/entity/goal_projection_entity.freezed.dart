// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_projection_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoalProjection {
  String get goalId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  GoalLevel get level => throw _privateConstructorUsedError;
  Money get targetAmount => throw _privateConstructorUsedError;
  Money get currentNetWorth => throw _privateConstructorUsedError;
  Money get progressAmount => throw _privateConstructorUsedError;

  /// From 0 to 100, with two decimals.
  double get progressPercentage => throw _privateConstructorUsedError;
  Money get remainingAmount => throw _privateConstructorUsedError;
  Money get monthlyInvestment => throw _privateConstructorUsedError;
  double get expectedAnnualReturn => throw _privateConstructorUsedError;
  bool get reachable => throw _privateConstructorUsedError;
  List<ProjectionPoint> get dataPoints => throw _privateConstructorUsedError;
  int? get targetYears => throw _privateConstructorUsedError;

  /// Null when the target is not reachable within the projected horizon.
  int? get projectedMonthsToGoal => throw _privateConstructorUsedError;
  double? get projectedYearsToGoal => throw _privateConstructorUsedError;

  /// First day of the month the target is reached.
  DateTime? get projectedAchievementDate => throw _privateConstructorUsedError;

  /// Create a copy of GoalProjection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalProjectionCopyWith<GoalProjection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalProjectionCopyWith<$Res> {
  factory $GoalProjectionCopyWith(
          GoalProjection value, $Res Function(GoalProjection) then) =
      _$GoalProjectionCopyWithImpl<$Res, GoalProjection>;
  @useResult
  $Res call(
      {String goalId,
      String name,
      GoalLevel level,
      Money targetAmount,
      Money currentNetWorth,
      Money progressAmount,
      double progressPercentage,
      Money remainingAmount,
      Money monthlyInvestment,
      double expectedAnnualReturn,
      bool reachable,
      List<ProjectionPoint> dataPoints,
      int? targetYears,
      int? projectedMonthsToGoal,
      double? projectedYearsToGoal,
      DateTime? projectedAchievementDate});
}

/// @nodoc
class _$GoalProjectionCopyWithImpl<$Res, $Val extends GoalProjection>
    implements $GoalProjectionCopyWith<$Res> {
  _$GoalProjectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalProjection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalId = null,
    Object? name = null,
    Object? level = null,
    Object? targetAmount = null,
    Object? currentNetWorth = null,
    Object? progressAmount = null,
    Object? progressPercentage = null,
    Object? remainingAmount = null,
    Object? monthlyInvestment = null,
    Object? expectedAnnualReturn = null,
    Object? reachable = null,
    Object? dataPoints = null,
    Object? targetYears = freezed,
    Object? projectedMonthsToGoal = freezed,
    Object? projectedYearsToGoal = freezed,
    Object? projectedAchievementDate = freezed,
  }) {
    return _then(_value.copyWith(
      goalId: null == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as GoalLevel,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      currentNetWorth: null == currentNetWorth
          ? _value.currentNetWorth
          : currentNetWorth // ignore: cast_nullable_to_non_nullable
              as Money,
      progressAmount: null == progressAmount
          ? _value.progressAmount
          : progressAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyInvestment: null == monthlyInvestment
          ? _value.monthlyInvestment
          : monthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money,
      expectedAnnualReturn: null == expectedAnnualReturn
          ? _value.expectedAnnualReturn
          : expectedAnnualReturn // ignore: cast_nullable_to_non_nullable
              as double,
      reachable: null == reachable
          ? _value.reachable
          : reachable // ignore: cast_nullable_to_non_nullable
              as bool,
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<ProjectionPoint>,
      targetYears: freezed == targetYears
          ? _value.targetYears
          : targetYears // ignore: cast_nullable_to_non_nullable
              as int?,
      projectedMonthsToGoal: freezed == projectedMonthsToGoal
          ? _value.projectedMonthsToGoal
          : projectedMonthsToGoal // ignore: cast_nullable_to_non_nullable
              as int?,
      projectedYearsToGoal: freezed == projectedYearsToGoal
          ? _value.projectedYearsToGoal
          : projectedYearsToGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      projectedAchievementDate: freezed == projectedAchievementDate
          ? _value.projectedAchievementDate
          : projectedAchievementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalProjectionImplCopyWith<$Res>
    implements $GoalProjectionCopyWith<$Res> {
  factory _$$GoalProjectionImplCopyWith(_$GoalProjectionImpl value,
          $Res Function(_$GoalProjectionImpl) then) =
      __$$GoalProjectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String goalId,
      String name,
      GoalLevel level,
      Money targetAmount,
      Money currentNetWorth,
      Money progressAmount,
      double progressPercentage,
      Money remainingAmount,
      Money monthlyInvestment,
      double expectedAnnualReturn,
      bool reachable,
      List<ProjectionPoint> dataPoints,
      int? targetYears,
      int? projectedMonthsToGoal,
      double? projectedYearsToGoal,
      DateTime? projectedAchievementDate});
}

/// @nodoc
class __$$GoalProjectionImplCopyWithImpl<$Res>
    extends _$GoalProjectionCopyWithImpl<$Res, _$GoalProjectionImpl>
    implements _$$GoalProjectionImplCopyWith<$Res> {
  __$$GoalProjectionImplCopyWithImpl(
      _$GoalProjectionImpl _value, $Res Function(_$GoalProjectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalProjection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalId = null,
    Object? name = null,
    Object? level = null,
    Object? targetAmount = null,
    Object? currentNetWorth = null,
    Object? progressAmount = null,
    Object? progressPercentage = null,
    Object? remainingAmount = null,
    Object? monthlyInvestment = null,
    Object? expectedAnnualReturn = null,
    Object? reachable = null,
    Object? dataPoints = null,
    Object? targetYears = freezed,
    Object? projectedMonthsToGoal = freezed,
    Object? projectedYearsToGoal = freezed,
    Object? projectedAchievementDate = freezed,
  }) {
    return _then(_$GoalProjectionImpl(
      goalId: null == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as GoalLevel,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      currentNetWorth: null == currentNetWorth
          ? _value.currentNetWorth
          : currentNetWorth // ignore: cast_nullable_to_non_nullable
              as Money,
      progressAmount: null == progressAmount
          ? _value.progressAmount
          : progressAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyInvestment: null == monthlyInvestment
          ? _value.monthlyInvestment
          : monthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money,
      expectedAnnualReturn: null == expectedAnnualReturn
          ? _value.expectedAnnualReturn
          : expectedAnnualReturn // ignore: cast_nullable_to_non_nullable
              as double,
      reachable: null == reachable
          ? _value.reachable
          : reachable // ignore: cast_nullable_to_non_nullable
              as bool,
      dataPoints: null == dataPoints
          ? _value._dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<ProjectionPoint>,
      targetYears: freezed == targetYears
          ? _value.targetYears
          : targetYears // ignore: cast_nullable_to_non_nullable
              as int?,
      projectedMonthsToGoal: freezed == projectedMonthsToGoal
          ? _value.projectedMonthsToGoal
          : projectedMonthsToGoal // ignore: cast_nullable_to_non_nullable
              as int?,
      projectedYearsToGoal: freezed == projectedYearsToGoal
          ? _value.projectedYearsToGoal
          : projectedYearsToGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      projectedAchievementDate: freezed == projectedAchievementDate
          ? _value.projectedAchievementDate
          : projectedAchievementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$GoalProjectionImpl extends _GoalProjection {
  const _$GoalProjectionImpl(
      {required this.goalId,
      required this.name,
      required this.level,
      required this.targetAmount,
      required this.currentNetWorth,
      required this.progressAmount,
      required this.progressPercentage,
      required this.remainingAmount,
      required this.monthlyInvestment,
      required this.expectedAnnualReturn,
      required this.reachable,
      required final List<ProjectionPoint> dataPoints,
      this.targetYears,
      this.projectedMonthsToGoal,
      this.projectedYearsToGoal,
      this.projectedAchievementDate})
      : _dataPoints = dataPoints,
        super._();

  @override
  final String goalId;
  @override
  final String name;
  @override
  final GoalLevel level;
  @override
  final Money targetAmount;
  @override
  final Money currentNetWorth;
  @override
  final Money progressAmount;

  /// From 0 to 100, with two decimals.
  @override
  final double progressPercentage;
  @override
  final Money remainingAmount;
  @override
  final Money monthlyInvestment;
  @override
  final double expectedAnnualReturn;
  @override
  final bool reachable;
  final List<ProjectionPoint> _dataPoints;
  @override
  List<ProjectionPoint> get dataPoints {
    if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataPoints);
  }

  @override
  final int? targetYears;

  /// Null when the target is not reachable within the projected horizon.
  @override
  final int? projectedMonthsToGoal;
  @override
  final double? projectedYearsToGoal;

  /// First day of the month the target is reached.
  @override
  final DateTime? projectedAchievementDate;

  @override
  String toString() {
    return 'GoalProjection(goalId: $goalId, name: $name, level: $level, targetAmount: $targetAmount, currentNetWorth: $currentNetWorth, progressAmount: $progressAmount, progressPercentage: $progressPercentage, remainingAmount: $remainingAmount, monthlyInvestment: $monthlyInvestment, expectedAnnualReturn: $expectedAnnualReturn, reachable: $reachable, dataPoints: $dataPoints, targetYears: $targetYears, projectedMonthsToGoal: $projectedMonthsToGoal, projectedYearsToGoal: $projectedYearsToGoal, projectedAchievementDate: $projectedAchievementDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalProjectionImpl &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentNetWorth, currentNetWorth) ||
                other.currentNetWorth == currentNetWorth) &&
            (identical(other.progressAmount, progressAmount) ||
                other.progressAmount == progressAmount) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.monthlyInvestment, monthlyInvestment) ||
                other.monthlyInvestment == monthlyInvestment) &&
            (identical(other.expectedAnnualReturn, expectedAnnualReturn) ||
                other.expectedAnnualReturn == expectedAnnualReturn) &&
            (identical(other.reachable, reachable) ||
                other.reachable == reachable) &&
            const DeepCollectionEquality()
                .equals(other._dataPoints, _dataPoints) &&
            (identical(other.targetYears, targetYears) ||
                other.targetYears == targetYears) &&
            (identical(other.projectedMonthsToGoal, projectedMonthsToGoal) ||
                other.projectedMonthsToGoal == projectedMonthsToGoal) &&
            (identical(other.projectedYearsToGoal, projectedYearsToGoal) ||
                other.projectedYearsToGoal == projectedYearsToGoal) &&
            (identical(
                    other.projectedAchievementDate, projectedAchievementDate) ||
                other.projectedAchievementDate == projectedAchievementDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      goalId,
      name,
      level,
      targetAmount,
      currentNetWorth,
      progressAmount,
      progressPercentage,
      remainingAmount,
      monthlyInvestment,
      expectedAnnualReturn,
      reachable,
      const DeepCollectionEquality().hash(_dataPoints),
      targetYears,
      projectedMonthsToGoal,
      projectedYearsToGoal,
      projectedAchievementDate);

  /// Create a copy of GoalProjection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalProjectionImplCopyWith<_$GoalProjectionImpl> get copyWith =>
      __$$GoalProjectionImplCopyWithImpl<_$GoalProjectionImpl>(
          this, _$identity);
}

abstract class _GoalProjection extends GoalProjection {
  const factory _GoalProjection(
      {required final String goalId,
      required final String name,
      required final GoalLevel level,
      required final Money targetAmount,
      required final Money currentNetWorth,
      required final Money progressAmount,
      required final double progressPercentage,
      required final Money remainingAmount,
      required final Money monthlyInvestment,
      required final double expectedAnnualReturn,
      required final bool reachable,
      required final List<ProjectionPoint> dataPoints,
      final int? targetYears,
      final int? projectedMonthsToGoal,
      final double? projectedYearsToGoal,
      final DateTime? projectedAchievementDate}) = _$GoalProjectionImpl;
  const _GoalProjection._() : super._();

  @override
  String get goalId;
  @override
  String get name;
  @override
  GoalLevel get level;
  @override
  Money get targetAmount;
  @override
  Money get currentNetWorth;
  @override
  Money get progressAmount;

  /// From 0 to 100, with two decimals.
  @override
  double get progressPercentage;
  @override
  Money get remainingAmount;
  @override
  Money get monthlyInvestment;
  @override
  double get expectedAnnualReturn;
  @override
  bool get reachable;
  @override
  List<ProjectionPoint> get dataPoints;
  @override
  int? get targetYears;

  /// Null when the target is not reachable within the projected horizon.
  @override
  int? get projectedMonthsToGoal;
  @override
  double? get projectedYearsToGoal;

  /// First day of the month the target is reached.
  @override
  DateTime? get projectedAchievementDate;

  /// Create a copy of GoalProjection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalProjectionImplCopyWith<_$GoalProjectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProjectionPoint {
  int get month => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  Money get projectedValue => throw _privateConstructorUsedError;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectionPointCopyWith<ProjectionPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectionPointCopyWith<$Res> {
  factory $ProjectionPointCopyWith(
          ProjectionPoint value, $Res Function(ProjectionPoint) then) =
      _$ProjectionPointCopyWithImpl<$Res, ProjectionPoint>;
  @useResult
  $Res call({int month, DateTime date, Money projectedValue});
}

/// @nodoc
class _$ProjectionPointCopyWithImpl<$Res, $Val extends ProjectionPoint>
    implements $ProjectionPointCopyWith<$Res> {
  _$ProjectionPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? date = null,
    Object? projectedValue = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      projectedValue: null == projectedValue
          ? _value.projectedValue
          : projectedValue // ignore: cast_nullable_to_non_nullable
              as Money,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectionPointImplCopyWith<$Res>
    implements $ProjectionPointCopyWith<$Res> {
  factory _$$ProjectionPointImplCopyWith(_$ProjectionPointImpl value,
          $Res Function(_$ProjectionPointImpl) then) =
      __$$ProjectionPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int month, DateTime date, Money projectedValue});
}

/// @nodoc
class __$$ProjectionPointImplCopyWithImpl<$Res>
    extends _$ProjectionPointCopyWithImpl<$Res, _$ProjectionPointImpl>
    implements _$$ProjectionPointImplCopyWith<$Res> {
  __$$ProjectionPointImplCopyWithImpl(
      _$ProjectionPointImpl _value, $Res Function(_$ProjectionPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? date = null,
    Object? projectedValue = null,
  }) {
    return _then(_$ProjectionPointImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      projectedValue: null == projectedValue
          ? _value.projectedValue
          : projectedValue // ignore: cast_nullable_to_non_nullable
              as Money,
    ));
  }
}

/// @nodoc

class _$ProjectionPointImpl implements _ProjectionPoint {
  const _$ProjectionPointImpl(
      {required this.month, required this.date, required this.projectedValue});

  @override
  final int month;
  @override
  final DateTime date;
  @override
  final Money projectedValue;

  @override
  String toString() {
    return 'ProjectionPoint(month: $month, date: $date, projectedValue: $projectedValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectionPointImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.projectedValue, projectedValue) ||
                other.projectedValue == projectedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, date, projectedValue);

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectionPointImplCopyWith<_$ProjectionPointImpl> get copyWith =>
      __$$ProjectionPointImplCopyWithImpl<_$ProjectionPointImpl>(
          this, _$identity);
}

abstract class _ProjectionPoint implements ProjectionPoint {
  const factory _ProjectionPoint(
      {required final int month,
      required final DateTime date,
      required final Money projectedValue}) = _$ProjectionPointImpl;

  @override
  int get month;
  @override
  DateTime get date;
  @override
  Money get projectedValue;

  /// Create a copy of ProjectionPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectionPointImplCopyWith<_$ProjectionPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
