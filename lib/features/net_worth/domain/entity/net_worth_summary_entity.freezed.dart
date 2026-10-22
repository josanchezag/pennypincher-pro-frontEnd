// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NetWorthSummary {
  Money get totalAssets => throw _privateConstructorUsedError;
  Money get totalLiabilities => throw _privateConstructorUsedError;
  Money get netWorth => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthSummaryCopyWith<NetWorthSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthSummaryCopyWith<$Res> {
  factory $NetWorthSummaryCopyWith(
          NetWorthSummary value, $Res Function(NetWorthSummary) then) =
      _$NetWorthSummaryCopyWithImpl<$Res, NetWorthSummary>;
  @useResult
  $Res call({Money totalAssets, Money totalLiabilities, Money netWorth});
}

/// @nodoc
class _$NetWorthSummaryCopyWithImpl<$Res, $Val extends NetWorthSummary>
    implements $NetWorthSummaryCopyWith<$Res> {
  _$NetWorthSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthSummaryImplCopyWith<$Res>
    implements $NetWorthSummaryCopyWith<$Res> {
  factory _$$NetWorthSummaryImplCopyWith(_$NetWorthSummaryImpl value,
          $Res Function(_$NetWorthSummaryImpl) then) =
      __$$NetWorthSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Money totalAssets, Money totalLiabilities, Money netWorth});
}

/// @nodoc
class __$$NetWorthSummaryImplCopyWithImpl<$Res>
    extends _$NetWorthSummaryCopyWithImpl<$Res, _$NetWorthSummaryImpl>
    implements _$$NetWorthSummaryImplCopyWith<$Res> {
  __$$NetWorthSummaryImplCopyWithImpl(
      _$NetWorthSummaryImpl _value, $Res Function(_$NetWorthSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
  }) {
    return _then(_$NetWorthSummaryImpl(
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
    ));
  }
}

/// @nodoc

class _$NetWorthSummaryImpl implements _NetWorthSummary {
  const _$NetWorthSummaryImpl(
      {required this.totalAssets,
      required this.totalLiabilities,
      required this.netWorth});

  @override
  final Money totalAssets;
  @override
  final Money totalLiabilities;
  @override
  final Money netWorth;

  @override
  String toString() {
    return 'NetWorthSummary(totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthSummaryImpl &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, totalAssets, totalLiabilities, netWorth);

  /// Create a copy of NetWorthSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthSummaryImplCopyWith<_$NetWorthSummaryImpl> get copyWith =>
      __$$NetWorthSummaryImplCopyWithImpl<_$NetWorthSummaryImpl>(
          this, _$identity);
}

abstract class _NetWorthSummary implements NetWorthSummary {
  const factory _NetWorthSummary(
      {required final Money totalAssets,
      required final Money totalLiabilities,
      required final Money netWorth}) = _$NetWorthSummaryImpl;

  @override
  Money get totalAssets;
  @override
  Money get totalLiabilities;
  @override
  Money get netWorth;

  /// Create a copy of NetWorthSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthSummaryImplCopyWith<_$NetWorthSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
