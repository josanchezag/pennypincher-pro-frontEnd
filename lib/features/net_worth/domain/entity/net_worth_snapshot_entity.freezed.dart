// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth_snapshot_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NetWorthSnapshot {
  String get id => throw _privateConstructorUsedError;

  /// First day of the month the snapshot belongs to.
  DateTime get snapshotDate => throw _privateConstructorUsedError;
  Money get totalAssets => throw _privateConstructorUsedError;
  Money get totalLiabilities => throw _privateConstructorUsedError;
  Money get netWorth => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthSnapshotCopyWith<NetWorthSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthSnapshotCopyWith<$Res> {
  factory $NetWorthSnapshotCopyWith(
          NetWorthSnapshot value, $Res Function(NetWorthSnapshot) then) =
      _$NetWorthSnapshotCopyWithImpl<$Res, NetWorthSnapshot>;
  @useResult
  $Res call(
      {String id,
      DateTime snapshotDate,
      Money totalAssets,
      Money totalLiabilities,
      Money netWorth});
}

/// @nodoc
class _$NetWorthSnapshotCopyWithImpl<$Res, $Val extends NetWorthSnapshot>
    implements $NetWorthSnapshotCopyWith<$Res> {
  _$NetWorthSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? snapshotDate = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotDate: null == snapshotDate
          ? _value.snapshotDate
          : snapshotDate // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthSnapshotImplCopyWith<$Res>
    implements $NetWorthSnapshotCopyWith<$Res> {
  factory _$$NetWorthSnapshotImplCopyWith(_$NetWorthSnapshotImpl value,
          $Res Function(_$NetWorthSnapshotImpl) then) =
      __$$NetWorthSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime snapshotDate,
      Money totalAssets,
      Money totalLiabilities,
      Money netWorth});
}

/// @nodoc
class __$$NetWorthSnapshotImplCopyWithImpl<$Res>
    extends _$NetWorthSnapshotCopyWithImpl<$Res, _$NetWorthSnapshotImpl>
    implements _$$NetWorthSnapshotImplCopyWith<$Res> {
  __$$NetWorthSnapshotImplCopyWithImpl(_$NetWorthSnapshotImpl _value,
      $Res Function(_$NetWorthSnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? snapshotDate = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? netWorth = null,
  }) {
    return _then(_$NetWorthSnapshotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      snapshotDate: null == snapshotDate
          ? _value.snapshotDate
          : snapshotDate // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc

class _$NetWorthSnapshotImpl extends _NetWorthSnapshot {
  const _$NetWorthSnapshotImpl(
      {required this.id,
      required this.snapshotDate,
      required this.totalAssets,
      required this.totalLiabilities,
      required this.netWorth})
      : super._();

  @override
  final String id;

  /// First day of the month the snapshot belongs to.
  @override
  final DateTime snapshotDate;
  @override
  final Money totalAssets;
  @override
  final Money totalLiabilities;
  @override
  final Money netWorth;

  @override
  String toString() {
    return 'NetWorthSnapshot(id: $id, snapshotDate: $snapshotDate, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, netWorth: $netWorth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthSnapshotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.snapshotDate, snapshotDate) ||
                other.snapshotDate == snapshotDate) &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, snapshotDate, totalAssets, totalLiabilities, netWorth);

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthSnapshotImplCopyWith<_$NetWorthSnapshotImpl> get copyWith =>
      __$$NetWorthSnapshotImplCopyWithImpl<_$NetWorthSnapshotImpl>(
          this, _$identity);
}

abstract class _NetWorthSnapshot extends NetWorthSnapshot {
  const factory _NetWorthSnapshot(
      {required final String id,
      required final DateTime snapshotDate,
      required final Money totalAssets,
      required final Money totalLiabilities,
      required final Money netWorth}) = _$NetWorthSnapshotImpl;
  const _NetWorthSnapshot._() : super._();

  @override
  String get id;

  /// First day of the month the snapshot belongs to.
  @override
  DateTime get snapshotDate;
  @override
  Money get totalAssets;
  @override
  Money get totalLiabilities;
  @override
  Money get netWorth;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthSnapshotImplCopyWith<_$NetWorthSnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
