// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_exchange_rates_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TodayExchangeRates {
  /// Day the rates were asked for, in Colombian time.
  DateTime get date => throw _privateConstructorUsedError;
  Money? get usdCop => throw _privateConstructorUsedError;
  Money? get eurCop => throw _privateConstructorUsedError;

  /// The source failed and these are the last good rates of an earlier
  /// day.
  bool get stale => throw _privateConstructorUsedError;

  /// Create a copy of TodayExchangeRates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodayExchangeRatesCopyWith<TodayExchangeRates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayExchangeRatesCopyWith<$Res> {
  factory $TodayExchangeRatesCopyWith(
          TodayExchangeRates value, $Res Function(TodayExchangeRates) then) =
      _$TodayExchangeRatesCopyWithImpl<$Res, TodayExchangeRates>;
  @useResult
  $Res call({DateTime date, Money? usdCop, Money? eurCop, bool stale});
}

/// @nodoc
class _$TodayExchangeRatesCopyWithImpl<$Res, $Val extends TodayExchangeRates>
    implements $TodayExchangeRatesCopyWith<$Res> {
  _$TodayExchangeRatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodayExchangeRates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? usdCop = freezed,
    Object? eurCop = freezed,
    Object? stale = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usdCop: freezed == usdCop
          ? _value.usdCop
          : usdCop // ignore: cast_nullable_to_non_nullable
              as Money?,
      eurCop: freezed == eurCop
          ? _value.eurCop
          : eurCop // ignore: cast_nullable_to_non_nullable
              as Money?,
      stale: null == stale
          ? _value.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodayExchangeRatesImplCopyWith<$Res>
    implements $TodayExchangeRatesCopyWith<$Res> {
  factory _$$TodayExchangeRatesImplCopyWith(_$TodayExchangeRatesImpl value,
          $Res Function(_$TodayExchangeRatesImpl) then) =
      __$$TodayExchangeRatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, Money? usdCop, Money? eurCop, bool stale});
}

/// @nodoc
class __$$TodayExchangeRatesImplCopyWithImpl<$Res>
    extends _$TodayExchangeRatesCopyWithImpl<$Res, _$TodayExchangeRatesImpl>
    implements _$$TodayExchangeRatesImplCopyWith<$Res> {
  __$$TodayExchangeRatesImplCopyWithImpl(_$TodayExchangeRatesImpl _value,
      $Res Function(_$TodayExchangeRatesImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodayExchangeRates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? usdCop = freezed,
    Object? eurCop = freezed,
    Object? stale = null,
  }) {
    return _then(_$TodayExchangeRatesImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usdCop: freezed == usdCop
          ? _value.usdCop
          : usdCop // ignore: cast_nullable_to_non_nullable
              as Money?,
      eurCop: freezed == eurCop
          ? _value.eurCop
          : eurCop // ignore: cast_nullable_to_non_nullable
              as Money?,
      stale: null == stale
          ? _value.stale
          : stale // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TodayExchangeRatesImpl extends _TodayExchangeRates {
  const _$TodayExchangeRatesImpl(
      {required this.date, this.usdCop, this.eurCop, this.stale = false})
      : super._();

  /// Day the rates were asked for, in Colombian time.
  @override
  final DateTime date;
  @override
  final Money? usdCop;
  @override
  final Money? eurCop;

  /// The source failed and these are the last good rates of an earlier
  /// day.
  @override
  @JsonKey()
  final bool stale;

  @override
  String toString() {
    return 'TodayExchangeRates(date: $date, usdCop: $usdCop, eurCop: $eurCop, stale: $stale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayExchangeRatesImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.usdCop, usdCop) || other.usdCop == usdCop) &&
            (identical(other.eurCop, eurCop) || other.eurCop == eurCop) &&
            (identical(other.stale, stale) || other.stale == stale));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, usdCop, eurCop, stale);

  /// Create a copy of TodayExchangeRates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayExchangeRatesImplCopyWith<_$TodayExchangeRatesImpl> get copyWith =>
      __$$TodayExchangeRatesImplCopyWithImpl<_$TodayExchangeRatesImpl>(
          this, _$identity);
}

abstract class _TodayExchangeRates extends TodayExchangeRates {
  const factory _TodayExchangeRates(
      {required final DateTime date,
      final Money? usdCop,
      final Money? eurCop,
      final bool stale}) = _$TodayExchangeRatesImpl;
  const _TodayExchangeRates._() : super._();

  /// Day the rates were asked for, in Colombian time.
  @override
  DateTime get date;
  @override
  Money? get usdCop;
  @override
  Money? get eurCop;

  /// The source failed and these are the last good rates of an earlier
  /// day.
  @override
  bool get stale;

  /// Create a copy of TodayExchangeRates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodayExchangeRatesImplCopyWith<_$TodayExchangeRatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
