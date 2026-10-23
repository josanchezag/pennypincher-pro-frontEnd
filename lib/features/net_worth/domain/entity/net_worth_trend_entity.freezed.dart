// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth_trend_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NetWorthTrendPoint {
  DateTime get month => throw _privateConstructorUsedError;
  Money get totalAssets => throw _privateConstructorUsedError;
  Money get totalLiabilities => throw _privateConstructorUsedError;
  Money get netWorth => throw _privateConstructorUsedError;
  Money? get delta => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthTrendPointCopyWith<NetWorthTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthTrendPointCopyWith<$Res> {
  factory $NetWorthTrendPointCopyWith(
          NetWorthTrendPoint value, $Res Function(NetWorthTrendPoint) then) =
      _$NetWorthTrendPointCopyWithImpl<$Res, NetWorthTrendPoint>;
  @useResult
  $Res call(
      {DateTime month,
      Money totalAssets,
      Money totalLiabilities,
      Money netWorth,
      Money? delta});
}

/// @nodoc
class _$NetWorthTrendPointCopyWithImpl<$Res, $Val extends NetWorthTrendPoint>
    implements $NetWorthTrendPointCopyWith<$Res> {
  _$NetWorthTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
    Object? delta = freezed,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as Money,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as Money,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as Money,
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as Money?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthTrendPointImplCopyWith<$Res>
    implements $NetWorthTrendPointCopyWith<$Res> {
  factory _$$NetWorthTrendPointImplCopyWith(_$NetWorthTrendPointImpl value,
          $Res Function(_$NetWorthTrendPointImpl) then) =
      __$$NetWorthTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime month,
      Money totalAssets,
      Money totalLiabilities,
      Money netWorth,
      Money? delta});
}

/// @nodoc
class __$$NetWorthTrendPointImplCopyWithImpl<$Res>
    extends _$NetWorthTrendPointCopyWithImpl<$Res, _$NetWorthTrendPointImpl>
    implements _$$NetWorthTrendPointImplCopyWith<$Res> {
  __$$NetWorthTrendPointImplCopyWithImpl(_$NetWorthTrendPointImpl _value,
      $Res Function(_$NetWorthTrendPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
    Object? delta = freezed,
  }) {
    return _then(_$NetWorthTrendPointImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as Money,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as Money,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as Money,
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as Money?,
    ));
  }
}

/// @nodoc

class _$NetWorthTrendPointImpl implements _NetWorthTrendPoint {
  const _$NetWorthTrendPointImpl(
      {required this.month,
      required this.totalAssets,
      required this.totalLiabilities,
      required this.netWorth,
      this.delta});

  @override
  final DateTime month;
  @override
  final Money totalAssets;
  @override
  final Money totalLiabilities;
  @override
  final Money netWorth;
  @override
  final Money? delta;

  @override
  String toString() {
    return 'NetWorthTrendPoint(month: $month, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth, delta: $delta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthTrendPointImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth) &&
            (identical(other.delta, delta) || other.delta == delta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, month, totalAssets, totalLiabilities, netWorth, delta);

  /// Create a copy of NetWorthTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthTrendPointImplCopyWith<_$NetWorthTrendPointImpl> get copyWith =>
      __$$NetWorthTrendPointImplCopyWithImpl<_$NetWorthTrendPointImpl>(
          this, _$identity);
}

abstract class _NetWorthTrendPoint implements NetWorthTrendPoint {
  const factory _NetWorthTrendPoint(
      {required final DateTime month,
      required final Money totalAssets,
      required final Money totalLiabilities,
      required final Money netWorth,
      final Money? delta}) = _$NetWorthTrendPointImpl;

  @override
  DateTime get month;
  @override
  Money get totalAssets;
  @override
  Money get totalLiabilities;
  @override
  Money get netWorth;
  @override
  Money? get delta;

  /// Create a copy of NetWorthTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthTrendPointImplCopyWith<_$NetWorthTrendPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NetWorthTrend {
  List<NetWorthTrendPoint> get points => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthTrendCopyWith<NetWorthTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthTrendCopyWith<$Res> {
  factory $NetWorthTrendCopyWith(
          NetWorthTrend value, $Res Function(NetWorthTrend) then) =
      _$NetWorthTrendCopyWithImpl<$Res, NetWorthTrend>;
  @useResult
  $Res call({List<NetWorthTrendPoint> points});
}

/// @nodoc
class _$NetWorthTrendCopyWithImpl<$Res, $Val extends NetWorthTrend>
    implements $NetWorthTrendCopyWith<$Res> {
  _$NetWorthTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
  }) {
    return _then(_value.copyWith(
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<NetWorthTrendPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthTrendImplCopyWith<$Res>
    implements $NetWorthTrendCopyWith<$Res> {
  factory _$$NetWorthTrendImplCopyWith(
          _$NetWorthTrendImpl value, $Res Function(_$NetWorthTrendImpl) then) =
      __$$NetWorthTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<NetWorthTrendPoint> points});
}

/// @nodoc
class __$$NetWorthTrendImplCopyWithImpl<$Res>
    extends _$NetWorthTrendCopyWithImpl<$Res, _$NetWorthTrendImpl>
    implements _$$NetWorthTrendImplCopyWith<$Res> {
  __$$NetWorthTrendImplCopyWithImpl(
      _$NetWorthTrendImpl _value, $Res Function(_$NetWorthTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
  }) {
    return _then(_$NetWorthTrendImpl(
      null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<NetWorthTrendPoint>,
    ));
  }
}

/// @nodoc

class _$NetWorthTrendImpl extends _NetWorthTrend {
  const _$NetWorthTrendImpl(final List<NetWorthTrendPoint> points)
      : _points = points,
        super._();

  final List<NetWorthTrendPoint> _points;
  @override
  List<NetWorthTrendPoint> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  String toString() {
    return 'NetWorthTrend(points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthTrendImpl &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_points));

  /// Create a copy of NetWorthTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthTrendImplCopyWith<_$NetWorthTrendImpl> get copyWith =>
      __$$NetWorthTrendImplCopyWithImpl<_$NetWorthTrendImpl>(this, _$identity);
}

abstract class _NetWorthTrend extends NetWorthTrend {
  const factory _NetWorthTrend(final List<NetWorthTrendPoint> points) =
      _$NetWorthTrendImpl;
  const _NetWorthTrend._() : super._();

  @override
  List<NetWorthTrendPoint> get points;

  /// Create a copy of NetWorthTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthTrendImplCopyWith<_$NetWorthTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
