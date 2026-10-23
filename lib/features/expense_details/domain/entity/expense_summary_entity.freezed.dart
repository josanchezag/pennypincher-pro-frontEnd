// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseSummary {
  Money get monthlyTotal => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  Money? get balanceTotal => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseSummaryCopyWith<ExpenseSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseSummaryCopyWith<$Res> {
  factory $ExpenseSummaryCopyWith(
          ExpenseSummary value, $Res Function(ExpenseSummary) then) =
      _$ExpenseSummaryCopyWithImpl<$Res, ExpenseSummary>;
  @useResult
  $Res call({Money monthlyTotal, int count, Money? balanceTotal});
}

/// @nodoc
class _$ExpenseSummaryCopyWithImpl<$Res, $Val extends ExpenseSummary>
    implements $ExpenseSummaryCopyWith<$Res> {
  _$ExpenseSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlyTotal = null,
    Object? count = null,
    Object? balanceTotal = freezed,
  }) {
    return _then(_value.copyWith(
      monthlyTotal: null == monthlyTotal
          ? _value.monthlyTotal
          : monthlyTotal // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      balanceTotal: freezed == balanceTotal
          ? _value.balanceTotal
          : balanceTotal // ignore: cast_nullable_to_non_nullable
              as Money?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseSummaryImplCopyWith<$Res>
    implements $ExpenseSummaryCopyWith<$Res> {
  factory _$$ExpenseSummaryImplCopyWith(_$ExpenseSummaryImpl value,
          $Res Function(_$ExpenseSummaryImpl) then) =
      __$$ExpenseSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Money monthlyTotal, int count, Money? balanceTotal});
}

/// @nodoc
class __$$ExpenseSummaryImplCopyWithImpl<$Res>
    extends _$ExpenseSummaryCopyWithImpl<$Res, _$ExpenseSummaryImpl>
    implements _$$ExpenseSummaryImplCopyWith<$Res> {
  __$$ExpenseSummaryImplCopyWithImpl(
      _$ExpenseSummaryImpl _value, $Res Function(_$ExpenseSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlyTotal = null,
    Object? count = null,
    Object? balanceTotal = freezed,
  }) {
    return _then(_$ExpenseSummaryImpl(
      monthlyTotal: null == monthlyTotal
          ? _value.monthlyTotal
          : monthlyTotal // ignore: cast_nullable_to_non_nullable
              as Money,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      balanceTotal: freezed == balanceTotal
          ? _value.balanceTotal
          : balanceTotal // ignore: cast_nullable_to_non_nullable
              as Money?,
    ));
  }
}

/// @nodoc

class _$ExpenseSummaryImpl implements _ExpenseSummary {
  const _$ExpenseSummaryImpl(
      {required this.monthlyTotal, required this.count, this.balanceTotal});

  @override
  final Money monthlyTotal;
  @override
  final int count;
  @override
  final Money? balanceTotal;

  @override
  String toString() {
    return 'ExpenseSummary(monthlyTotal: $monthlyTotal, count: $count, balanceTotal: $balanceTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseSummaryImpl &&
            (identical(other.monthlyTotal, monthlyTotal) ||
                other.monthlyTotal == monthlyTotal) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.balanceTotal, balanceTotal) ||
                other.balanceTotal == balanceTotal));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, monthlyTotal, count, balanceTotal);

  /// Create a copy of ExpenseSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseSummaryImplCopyWith<_$ExpenseSummaryImpl> get copyWith =>
      __$$ExpenseSummaryImplCopyWithImpl<_$ExpenseSummaryImpl>(
          this, _$identity);
}

abstract class _ExpenseSummary implements ExpenseSummary {
  const factory _ExpenseSummary(
      {required final Money monthlyTotal,
      required final int count,
      final Money? balanceTotal}) = _$ExpenseSummaryImpl;

  @override
  Money get monthlyTotal;
  @override
  int get count;
  @override
  Money? get balanceTotal;

  /// Create a copy of ExpenseSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseSummaryImplCopyWith<_$ExpenseSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
