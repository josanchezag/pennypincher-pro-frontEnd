// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_goal_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialGoal {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  GoalLevel get level => throw _privateConstructorUsedError;
  String get levelDescription => throw _privateConstructorUsedError;
  Money get targetAmount => throw _privateConstructorUsedError;
  Money get monthlyInvestment => throw _privateConstructorUsedError;

  /// Fraction of one, such as `0.11` for 11 % a year.
  double get expectedAnnualReturn => throw _privateConstructorUsedError;

  /// Years the user wants to reach it in, when set. Always set in the
  /// income modes.
  int? get targetYears => throw _privateConstructorUsedError;

  /// Where the desired income comes from; [GoalIncomeMode.manual] for a
  /// backend that does not send it yet.
  GoalIncomeMode get incomeMode => throw _privateConstructorUsedError;

  /// Times the current income the goal aims to earn; only in
  /// [GoalIncomeMode.currentIncome].
  double? get incomeFactor => throw _privateConstructorUsedError;

  /// Current monthly income the backend read; null in
  /// [GoalIncomeMode.manual].
  Money? get monthlyIncomeBasis => throw _privateConstructorUsedError;

  /// Monthly income the target pays at the reference return; null in
  /// [GoalIncomeMode.manual].
  Money? get desiredMonthlyIncome => throw _privateConstructorUsedError;

  /// Monthly investment that reaches the target in [targetYears]; null
  /// for a manual goal without target years.
  Money? get requiredMonthlyInvestment => throw _privateConstructorUsedError;

  /// What the target yields at 10 % effective annual, as the backend
  /// computed it.
  ReferenceReturn? get referenceReturn => throw _privateConstructorUsedError;

  /// Progress and projection against the current net worth; null until
  /// it is loaded.
  GoalProjection? get projection => throw _privateConstructorUsedError;

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialGoalCopyWith<FinancialGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialGoalCopyWith<$Res> {
  factory $FinancialGoalCopyWith(
          FinancialGoal value, $Res Function(FinancialGoal) then) =
      _$FinancialGoalCopyWithImpl<$Res, FinancialGoal>;
  @useResult
  $Res call(
      {String id,
      String name,
      GoalLevel level,
      String levelDescription,
      Money targetAmount,
      Money monthlyInvestment,
      double expectedAnnualReturn,
      int? targetYears,
      GoalIncomeMode incomeMode,
      double? incomeFactor,
      Money? monthlyIncomeBasis,
      Money? desiredMonthlyIncome,
      Money? requiredMonthlyInvestment,
      ReferenceReturn? referenceReturn,
      GoalProjection? projection});

  $GoalProjectionCopyWith<$Res>? get projection;
}

/// @nodoc
class _$FinancialGoalCopyWithImpl<$Res, $Val extends FinancialGoal>
    implements $FinancialGoalCopyWith<$Res> {
  _$FinancialGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? levelDescription = null,
    Object? targetAmount = null,
    Object? monthlyInvestment = null,
    Object? expectedAnnualReturn = null,
    Object? targetYears = freezed,
    Object? incomeMode = null,
    Object? incomeFactor = freezed,
    Object? monthlyIncomeBasis = freezed,
    Object? desiredMonthlyIncome = freezed,
    Object? requiredMonthlyInvestment = freezed,
    Object? referenceReturn = freezed,
    Object? projection = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as GoalLevel,
      levelDescription: null == levelDescription
          ? _value.levelDescription
          : levelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyInvestment: null == monthlyInvestment
          ? _value.monthlyInvestment
          : monthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money,
      expectedAnnualReturn: null == expectedAnnualReturn
          ? _value.expectedAnnualReturn
          : expectedAnnualReturn // ignore: cast_nullable_to_non_nullable
              as double,
      targetYears: freezed == targetYears
          ? _value.targetYears
          : targetYears // ignore: cast_nullable_to_non_nullable
              as int?,
      incomeMode: null == incomeMode
          ? _value.incomeMode
          : incomeMode // ignore: cast_nullable_to_non_nullable
              as GoalIncomeMode,
      incomeFactor: freezed == incomeFactor
          ? _value.incomeFactor
          : incomeFactor // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyIncomeBasis: freezed == monthlyIncomeBasis
          ? _value.monthlyIncomeBasis
          : monthlyIncomeBasis // ignore: cast_nullable_to_non_nullable
              as Money?,
      desiredMonthlyIncome: freezed == desiredMonthlyIncome
          ? _value.desiredMonthlyIncome
          : desiredMonthlyIncome // ignore: cast_nullable_to_non_nullable
              as Money?,
      requiredMonthlyInvestment: freezed == requiredMonthlyInvestment
          ? _value.requiredMonthlyInvestment
          : requiredMonthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money?,
      referenceReturn: freezed == referenceReturn
          ? _value.referenceReturn
          : referenceReturn // ignore: cast_nullable_to_non_nullable
              as ReferenceReturn?,
      projection: freezed == projection
          ? _value.projection
          : projection // ignore: cast_nullable_to_non_nullable
              as GoalProjection?,
    ) as $Val);
  }

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GoalProjectionCopyWith<$Res>? get projection {
    if (_value.projection == null) {
      return null;
    }

    return $GoalProjectionCopyWith<$Res>(_value.projection!, (value) {
      return _then(_value.copyWith(projection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialGoalImplCopyWith<$Res>
    implements $FinancialGoalCopyWith<$Res> {
  factory _$$FinancialGoalImplCopyWith(
          _$FinancialGoalImpl value, $Res Function(_$FinancialGoalImpl) then) =
      __$$FinancialGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      GoalLevel level,
      String levelDescription,
      Money targetAmount,
      Money monthlyInvestment,
      double expectedAnnualReturn,
      int? targetYears,
      GoalIncomeMode incomeMode,
      double? incomeFactor,
      Money? monthlyIncomeBasis,
      Money? desiredMonthlyIncome,
      Money? requiredMonthlyInvestment,
      ReferenceReturn? referenceReturn,
      GoalProjection? projection});

  @override
  $GoalProjectionCopyWith<$Res>? get projection;
}

/// @nodoc
class __$$FinancialGoalImplCopyWithImpl<$Res>
    extends _$FinancialGoalCopyWithImpl<$Res, _$FinancialGoalImpl>
    implements _$$FinancialGoalImplCopyWith<$Res> {
  __$$FinancialGoalImplCopyWithImpl(
      _$FinancialGoalImpl _value, $Res Function(_$FinancialGoalImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? levelDescription = null,
    Object? targetAmount = null,
    Object? monthlyInvestment = null,
    Object? expectedAnnualReturn = null,
    Object? targetYears = freezed,
    Object? incomeMode = null,
    Object? incomeFactor = freezed,
    Object? monthlyIncomeBasis = freezed,
    Object? desiredMonthlyIncome = freezed,
    Object? requiredMonthlyInvestment = freezed,
    Object? referenceReturn = freezed,
    Object? projection = freezed,
  }) {
    return _then(_$FinancialGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as GoalLevel,
      levelDescription: null == levelDescription
          ? _value.levelDescription
          : levelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyInvestment: null == monthlyInvestment
          ? _value.monthlyInvestment
          : monthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money,
      expectedAnnualReturn: null == expectedAnnualReturn
          ? _value.expectedAnnualReturn
          : expectedAnnualReturn // ignore: cast_nullable_to_non_nullable
              as double,
      targetYears: freezed == targetYears
          ? _value.targetYears
          : targetYears // ignore: cast_nullable_to_non_nullable
              as int?,
      incomeMode: null == incomeMode
          ? _value.incomeMode
          : incomeMode // ignore: cast_nullable_to_non_nullable
              as GoalIncomeMode,
      incomeFactor: freezed == incomeFactor
          ? _value.incomeFactor
          : incomeFactor // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyIncomeBasis: freezed == monthlyIncomeBasis
          ? _value.monthlyIncomeBasis
          : monthlyIncomeBasis // ignore: cast_nullable_to_non_nullable
              as Money?,
      desiredMonthlyIncome: freezed == desiredMonthlyIncome
          ? _value.desiredMonthlyIncome
          : desiredMonthlyIncome // ignore: cast_nullable_to_non_nullable
              as Money?,
      requiredMonthlyInvestment: freezed == requiredMonthlyInvestment
          ? _value.requiredMonthlyInvestment
          : requiredMonthlyInvestment // ignore: cast_nullable_to_non_nullable
              as Money?,
      referenceReturn: freezed == referenceReturn
          ? _value.referenceReturn
          : referenceReturn // ignore: cast_nullable_to_non_nullable
              as ReferenceReturn?,
      projection: freezed == projection
          ? _value.projection
          : projection // ignore: cast_nullable_to_non_nullable
              as GoalProjection?,
    ));
  }
}

/// @nodoc

class _$FinancialGoalImpl extends _FinancialGoal {
  const _$FinancialGoalImpl(
      {required this.id,
      required this.name,
      required this.level,
      required this.levelDescription,
      required this.targetAmount,
      required this.monthlyInvestment,
      required this.expectedAnnualReturn,
      this.targetYears,
      this.incomeMode = GoalIncomeMode.manual,
      this.incomeFactor,
      this.monthlyIncomeBasis,
      this.desiredMonthlyIncome,
      this.requiredMonthlyInvestment,
      this.referenceReturn,
      this.projection})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final GoalLevel level;
  @override
  final String levelDescription;
  @override
  final Money targetAmount;
  @override
  final Money monthlyInvestment;

  /// Fraction of one, such as `0.11` for 11 % a year.
  @override
  final double expectedAnnualReturn;

  /// Years the user wants to reach it in, when set. Always set in the
  /// income modes.
  @override
  final int? targetYears;

  /// Where the desired income comes from; [GoalIncomeMode.manual] for a
  /// backend that does not send it yet.
  @override
  @JsonKey()
  final GoalIncomeMode incomeMode;

  /// Times the current income the goal aims to earn; only in
  /// [GoalIncomeMode.currentIncome].
  @override
  final double? incomeFactor;

  /// Current monthly income the backend read; null in
  /// [GoalIncomeMode.manual].
  @override
  final Money? monthlyIncomeBasis;

  /// Monthly income the target pays at the reference return; null in
  /// [GoalIncomeMode.manual].
  @override
  final Money? desiredMonthlyIncome;

  /// Monthly investment that reaches the target in [targetYears]; null
  /// for a manual goal without target years.
  @override
  final Money? requiredMonthlyInvestment;

  /// What the target yields at 10 % effective annual, as the backend
  /// computed it.
  @override
  final ReferenceReturn? referenceReturn;

  /// Progress and projection against the current net worth; null until
  /// it is loaded.
  @override
  final GoalProjection? projection;

  @override
  String toString() {
    return 'FinancialGoal(id: $id, name: $name, level: $level, levelDescription: $levelDescription, targetAmount: $targetAmount, monthlyInvestment: $monthlyInvestment, expectedAnnualReturn: $expectedAnnualReturn, targetYears: $targetYears, incomeMode: $incomeMode, incomeFactor: $incomeFactor, monthlyIncomeBasis: $monthlyIncomeBasis, desiredMonthlyIncome: $desiredMonthlyIncome, requiredMonthlyInvestment: $requiredMonthlyInvestment, referenceReturn: $referenceReturn, projection: $projection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.levelDescription, levelDescription) ||
                other.levelDescription == levelDescription) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.monthlyInvestment, monthlyInvestment) ||
                other.monthlyInvestment == monthlyInvestment) &&
            (identical(other.expectedAnnualReturn, expectedAnnualReturn) ||
                other.expectedAnnualReturn == expectedAnnualReturn) &&
            (identical(other.targetYears, targetYears) ||
                other.targetYears == targetYears) &&
            (identical(other.incomeMode, incomeMode) ||
                other.incomeMode == incomeMode) &&
            (identical(other.incomeFactor, incomeFactor) ||
                other.incomeFactor == incomeFactor) &&
            (identical(other.monthlyIncomeBasis, monthlyIncomeBasis) ||
                other.monthlyIncomeBasis == monthlyIncomeBasis) &&
            (identical(other.desiredMonthlyIncome, desiredMonthlyIncome) ||
                other.desiredMonthlyIncome == desiredMonthlyIncome) &&
            (identical(other.requiredMonthlyInvestment,
                    requiredMonthlyInvestment) ||
                other.requiredMonthlyInvestment == requiredMonthlyInvestment) &&
            (identical(other.referenceReturn, referenceReturn) ||
                other.referenceReturn == referenceReturn) &&
            (identical(other.projection, projection) ||
                other.projection == projection));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      level,
      levelDescription,
      targetAmount,
      monthlyInvestment,
      expectedAnnualReturn,
      targetYears,
      incomeMode,
      incomeFactor,
      monthlyIncomeBasis,
      desiredMonthlyIncome,
      requiredMonthlyInvestment,
      referenceReturn,
      projection);

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialGoalImplCopyWith<_$FinancialGoalImpl> get copyWith =>
      __$$FinancialGoalImplCopyWithImpl<_$FinancialGoalImpl>(this, _$identity);
}

abstract class _FinancialGoal extends FinancialGoal {
  const factory _FinancialGoal(
      {required final String id,
      required final String name,
      required final GoalLevel level,
      required final String levelDescription,
      required final Money targetAmount,
      required final Money monthlyInvestment,
      required final double expectedAnnualReturn,
      final int? targetYears,
      final GoalIncomeMode incomeMode,
      final double? incomeFactor,
      final Money? monthlyIncomeBasis,
      final Money? desiredMonthlyIncome,
      final Money? requiredMonthlyInvestment,
      final ReferenceReturn? referenceReturn,
      final GoalProjection? projection}) = _$FinancialGoalImpl;
  const _FinancialGoal._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  GoalLevel get level;
  @override
  String get levelDescription;
  @override
  Money get targetAmount;
  @override
  Money get monthlyInvestment;

  /// Fraction of one, such as `0.11` for 11 % a year.
  @override
  double get expectedAnnualReturn;

  /// Years the user wants to reach it in, when set. Always set in the
  /// income modes.
  @override
  int? get targetYears;

  /// Where the desired income comes from; [GoalIncomeMode.manual] for a
  /// backend that does not send it yet.
  @override
  GoalIncomeMode get incomeMode;

  /// Times the current income the goal aims to earn; only in
  /// [GoalIncomeMode.currentIncome].
  @override
  double? get incomeFactor;

  /// Current monthly income the backend read; null in
  /// [GoalIncomeMode.manual].
  @override
  Money? get monthlyIncomeBasis;

  /// Monthly income the target pays at the reference return; null in
  /// [GoalIncomeMode.manual].
  @override
  Money? get desiredMonthlyIncome;

  /// Monthly investment that reaches the target in [targetYears]; null
  /// for a manual goal without target years.
  @override
  Money? get requiredMonthlyInvestment;

  /// What the target yields at 10 % effective annual, as the backend
  /// computed it.
  @override
  ReferenceReturn? get referenceReturn;

  /// Progress and projection against the current net worth; null until
  /// it is loaded.
  @override
  GoalProjection? get projection;

  /// Create a copy of FinancialGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialGoalImplCopyWith<_$FinancialGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
