// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liability_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Liability {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Money get currentBalance => throw _privateConstructorUsedError;
  LiabilityCategory get category => throw _privateConstructorUsedError;

  /// Create a copy of Liability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LiabilityCopyWith<Liability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiabilityCopyWith<$Res> {
  factory $LiabilityCopyWith(Liability value, $Res Function(Liability) then) =
      _$LiabilityCopyWithImpl<$Res, Liability>;
  @useResult
  $Res call(
      {String id,
      String name,
      Money currentBalance,
      LiabilityCategory category});
}

/// @nodoc
class _$LiabilityCopyWithImpl<$Res, $Val extends Liability>
    implements $LiabilityCopyWith<$Res> {
  _$LiabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Liability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currentBalance = null,
    Object? category = null,
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
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LiabilityCategory,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiabilityImplCopyWith<$Res>
    implements $LiabilityCopyWith<$Res> {
  factory _$$LiabilityImplCopyWith(
          _$LiabilityImpl value, $Res Function(_$LiabilityImpl) then) =
      __$$LiabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Money currentBalance,
      LiabilityCategory category});
}

/// @nodoc
class __$$LiabilityImplCopyWithImpl<$Res>
    extends _$LiabilityCopyWithImpl<$Res, _$LiabilityImpl>
    implements _$$LiabilityImplCopyWith<$Res> {
  __$$LiabilityImplCopyWithImpl(
      _$LiabilityImpl _value, $Res Function(_$LiabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Liability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? currentBalance = null,
    Object? category = null,
  }) {
    return _then(_$LiabilityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LiabilityCategory,
    ));
  }
}

/// @nodoc

class _$LiabilityImpl extends _Liability {
  const _$LiabilityImpl(
      {required this.id,
      required this.name,
      required this.currentBalance,
      required this.category})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final Money currentBalance;
  @override
  final LiabilityCategory category;

  @override
  String toString() {
    return 'Liability(id: $id, name: $name, currentBalance: $currentBalance, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiabilityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, currentBalance, category);

  /// Create a copy of Liability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LiabilityImplCopyWith<_$LiabilityImpl> get copyWith =>
      __$$LiabilityImplCopyWithImpl<_$LiabilityImpl>(this, _$identity);
}

abstract class _Liability extends Liability {
  const factory _Liability(
      {required final String id,
      required final String name,
      required final Money currentBalance,
      required final LiabilityCategory category}) = _$LiabilityImpl;
  const _Liability._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  Money get currentBalance;
  @override
  LiabilityCategory get category;

  /// Create a copy of Liability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LiabilityImplCopyWith<_$LiabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
