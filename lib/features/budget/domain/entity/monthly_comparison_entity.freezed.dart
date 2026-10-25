// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_comparison_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ComparisonFigures {
  Money get totalIncome => throw _privateConstructorUsedError;
  Money get totalExpenses => throw _privateConstructorUsedError;
  Money get cashFlow => throw _privateConstructorUsedError;
  double? get cashFlowPercentage => throw _privateConstructorUsedError;

  /// Create a copy of ComparisonFigures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComparisonFiguresCopyWith<ComparisonFigures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonFiguresCopyWith<$Res> {
  factory $ComparisonFiguresCopyWith(
          ComparisonFigures value, $Res Function(ComparisonFigures) then) =
      _$ComparisonFiguresCopyWithImpl<$Res, ComparisonFigures>;
  @useResult
  $Res call(
      {Money totalIncome,
      Money totalExpenses,
      Money cashFlow,
      double? cashFlowPercentage});
}

/// @nodoc
class _$ComparisonFiguresCopyWithImpl<$Res, $Val extends ComparisonFigures>
    implements $ComparisonFiguresCopyWith<$Res> {
  _$ComparisonFiguresCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComparisonFigures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? cashFlow = null,
    Object? cashFlowPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as Money,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as Money,
      cashFlow: null == cashFlow
          ? _value.cashFlow
          : cashFlow // ignore: cast_nullable_to_non_nullable
              as Money,
      cashFlowPercentage: freezed == cashFlowPercentage
          ? _value.cashFlowPercentage
          : cashFlowPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComparisonFiguresImplCopyWith<$Res>
    implements $ComparisonFiguresCopyWith<$Res> {
  factory _$$ComparisonFiguresImplCopyWith(_$ComparisonFiguresImpl value,
          $Res Function(_$ComparisonFiguresImpl) then) =
      __$$ComparisonFiguresImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Money totalIncome,
      Money totalExpenses,
      Money cashFlow,
      double? cashFlowPercentage});
}

/// @nodoc
class __$$ComparisonFiguresImplCopyWithImpl<$Res>
    extends _$ComparisonFiguresCopyWithImpl<$Res, _$ComparisonFiguresImpl>
    implements _$$ComparisonFiguresImplCopyWith<$Res> {
  __$$ComparisonFiguresImplCopyWithImpl(_$ComparisonFiguresImpl _value,
      $Res Function(_$ComparisonFiguresImpl) _then)
      : super(_value, _then);

  /// Create a copy of ComparisonFigures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? cashFlow = null,
    Object? cashFlowPercentage = freezed,
  }) {
    return _then(_$ComparisonFiguresImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as Money,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as Money,
      cashFlow: null == cashFlow
          ? _value.cashFlow
          : cashFlow // ignore: cast_nullable_to_non_nullable
              as Money,
      cashFlowPercentage: freezed == cashFlowPercentage
          ? _value.cashFlowPercentage
          : cashFlowPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$ComparisonFiguresImpl implements _ComparisonFigures {
  const _$ComparisonFiguresImpl(
      {required this.totalIncome,
      required this.totalExpenses,
      required this.cashFlow,
      this.cashFlowPercentage});

  @override
  final Money totalIncome;
  @override
  final Money totalExpenses;
  @override
  final Money cashFlow;
  @override
  final double? cashFlowPercentage;

  @override
  String toString() {
    return 'ComparisonFigures(totalIncome: $totalIncome, totalExpenses: $totalExpenses, cashFlow: $cashFlow, cashFlowPercentage: $cashFlowPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonFiguresImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.cashFlow, cashFlow) ||
                other.cashFlow == cashFlow) &&
            (identical(other.cashFlowPercentage, cashFlowPercentage) ||
                other.cashFlowPercentage == cashFlowPercentage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, totalIncome, totalExpenses, cashFlow, cashFlowPercentage);

  /// Create a copy of ComparisonFigures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonFiguresImplCopyWith<_$ComparisonFiguresImpl> get copyWith =>
      __$$ComparisonFiguresImplCopyWithImpl<_$ComparisonFiguresImpl>(
          this, _$identity);
}

abstract class _ComparisonFigures implements ComparisonFigures {
  const factory _ComparisonFigures(
      {required final Money totalIncome,
      required final Money totalExpenses,
      required final Money cashFlow,
      final double? cashFlowPercentage}) = _$ComparisonFiguresImpl;

  @override
  Money get totalIncome;
  @override
  Money get totalExpenses;
  @override
  Money get cashFlow;
  @override
  double? get cashFlowPercentage;

  /// Create a copy of ComparisonFigures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComparisonFiguresImplCopyWith<_$ComparisonFiguresImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthComparison {
  DateTime get month => throw _privateConstructorUsedError;
  ComparisonFigures? get figures => throw _privateConstructorUsedError;

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthComparisonCopyWith<MonthComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthComparisonCopyWith<$Res> {
  factory $MonthComparisonCopyWith(
          MonthComparison value, $Res Function(MonthComparison) then) =
      _$MonthComparisonCopyWithImpl<$Res, MonthComparison>;
  @useResult
  $Res call({DateTime month, ComparisonFigures? figures});

  $ComparisonFiguresCopyWith<$Res>? get figures;
}

/// @nodoc
class _$MonthComparisonCopyWithImpl<$Res, $Val extends MonthComparison>
    implements $MonthComparisonCopyWith<$Res> {
  _$MonthComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? figures = freezed,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      figures: freezed == figures
          ? _value.figures
          : figures // ignore: cast_nullable_to_non_nullable
              as ComparisonFigures?,
    ) as $Val);
  }

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ComparisonFiguresCopyWith<$Res>? get figures {
    if (_value.figures == null) {
      return null;
    }

    return $ComparisonFiguresCopyWith<$Res>(_value.figures!, (value) {
      return _then(_value.copyWith(figures: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthComparisonImplCopyWith<$Res>
    implements $MonthComparisonCopyWith<$Res> {
  factory _$$MonthComparisonImplCopyWith(_$MonthComparisonImpl value,
          $Res Function(_$MonthComparisonImpl) then) =
      __$$MonthComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime month, ComparisonFigures? figures});

  @override
  $ComparisonFiguresCopyWith<$Res>? get figures;
}

/// @nodoc
class __$$MonthComparisonImplCopyWithImpl<$Res>
    extends _$MonthComparisonCopyWithImpl<$Res, _$MonthComparisonImpl>
    implements _$$MonthComparisonImplCopyWith<$Res> {
  __$$MonthComparisonImplCopyWithImpl(
      _$MonthComparisonImpl _value, $Res Function(_$MonthComparisonImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? figures = freezed,
  }) {
    return _then(_$MonthComparisonImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      figures: freezed == figures
          ? _value.figures
          : figures // ignore: cast_nullable_to_non_nullable
              as ComparisonFigures?,
    ));
  }
}

/// @nodoc

class _$MonthComparisonImpl extends _MonthComparison {
  const _$MonthComparisonImpl({required this.month, this.figures}) : super._();

  @override
  final DateTime month;
  @override
  final ComparisonFigures? figures;

  @override
  String toString() {
    return 'MonthComparison(month: $month, figures: $figures)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthComparisonImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.figures, figures) || other.figures == figures));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, figures);

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthComparisonImplCopyWith<_$MonthComparisonImpl> get copyWith =>
      __$$MonthComparisonImplCopyWithImpl<_$MonthComparisonImpl>(
          this, _$identity);
}

abstract class _MonthComparison extends MonthComparison {
  const factory _MonthComparison(
      {required final DateTime month,
      final ComparisonFigures? figures}) = _$MonthComparisonImpl;
  const _MonthComparison._() : super._();

  @override
  DateTime get month;
  @override
  ComparisonFigures? get figures;

  /// Create a copy of MonthComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthComparisonImplCopyWith<_$MonthComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
