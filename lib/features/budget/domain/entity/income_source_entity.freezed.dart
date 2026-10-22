// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_source_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IncomeSource {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Money get amount => throw _privateConstructorUsedError;
  IncomeCategory get category => throw _privateConstructorUsedError;

  /// Create a copy of IncomeSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeSourceCopyWith<IncomeSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeSourceCopyWith<$Res> {
  factory $IncomeSourceCopyWith(
          IncomeSource value, $Res Function(IncomeSource) then) =
      _$IncomeSourceCopyWithImpl<$Res, IncomeSource>;
  @useResult
  $Res call({String id, String name, Money amount, IncomeCategory category});
}

/// @nodoc
class _$IncomeSourceCopyWithImpl<$Res, $Val extends IncomeSource>
    implements $IncomeSourceCopyWith<$Res> {
  _$IncomeSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
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
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IncomeCategory,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeSourceImplCopyWith<$Res>
    implements $IncomeSourceCopyWith<$Res> {
  factory _$$IncomeSourceImplCopyWith(
          _$IncomeSourceImpl value, $Res Function(_$IncomeSourceImpl) then) =
      __$$IncomeSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, Money amount, IncomeCategory category});
}

/// @nodoc
class __$$IncomeSourceImplCopyWithImpl<$Res>
    extends _$IncomeSourceCopyWithImpl<$Res, _$IncomeSourceImpl>
    implements _$$IncomeSourceImplCopyWith<$Res> {
  __$$IncomeSourceImplCopyWithImpl(
      _$IncomeSourceImpl _value, $Res Function(_$IncomeSourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? category = null,
  }) {
    return _then(_$IncomeSourceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IncomeCategory,
    ));
  }
}

/// @nodoc

class _$IncomeSourceImpl implements _IncomeSource {
  const _$IncomeSourceImpl(
      {required this.id,
      required this.name,
      required this.amount,
      required this.category});

  @override
  final String id;
  @override
  final String name;
  @override
  final Money amount;
  @override
  final IncomeCategory category;

  @override
  String toString() {
    return 'IncomeSource(id: $id, name: $name, amount: $amount, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeSourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, amount, category);

  /// Create a copy of IncomeSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeSourceImplCopyWith<_$IncomeSourceImpl> get copyWith =>
      __$$IncomeSourceImplCopyWithImpl<_$IncomeSourceImpl>(this, _$identity);
}

abstract class _IncomeSource implements IncomeSource {
  const factory _IncomeSource(
      {required final String id,
      required final String name,
      required final Money amount,
      required final IncomeCategory category}) = _$IncomeSourceImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  Money get amount;
  @override
  IncomeCategory get category;

  /// Create a copy of IncomeSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeSourceImplCopyWith<_$IncomeSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
