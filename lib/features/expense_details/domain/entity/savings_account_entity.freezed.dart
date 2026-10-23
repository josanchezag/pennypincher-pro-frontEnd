// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SavingsAccount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Money get monthlyContribution => throw _privateConstructorUsedError;
  Money get currentBalance => throw _privateConstructorUsedError;

  /// Create a copy of SavingsAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavingsAccountCopyWith<SavingsAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavingsAccountCopyWith<$Res> {
  factory $SavingsAccountCopyWith(
          SavingsAccount value, $Res Function(SavingsAccount) then) =
      _$SavingsAccountCopyWithImpl<$Res, SavingsAccount>;
  @useResult
  $Res call(
      {String id,
      String name,
      Money monthlyContribution,
      Money currentBalance});
}

/// @nodoc
class _$SavingsAccountCopyWithImpl<$Res, $Val extends SavingsAccount>
    implements $SavingsAccountCopyWith<$Res> {
  _$SavingsAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavingsAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? monthlyContribution = null,
    Object? currentBalance = null,
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
      monthlyContribution: null == monthlyContribution
          ? _value.monthlyContribution
          : monthlyContribution // ignore: cast_nullable_to_non_nullable
              as Money,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as Money,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavingsAccountImplCopyWith<$Res>
    implements $SavingsAccountCopyWith<$Res> {
  factory _$$SavingsAccountImplCopyWith(_$SavingsAccountImpl value,
          $Res Function(_$SavingsAccountImpl) then) =
      __$$SavingsAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Money monthlyContribution,
      Money currentBalance});
}

/// @nodoc
class __$$SavingsAccountImplCopyWithImpl<$Res>
    extends _$SavingsAccountCopyWithImpl<$Res, _$SavingsAccountImpl>
    implements _$$SavingsAccountImplCopyWith<$Res> {
  __$$SavingsAccountImplCopyWithImpl(
      _$SavingsAccountImpl _value, $Res Function(_$SavingsAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavingsAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? monthlyContribution = null,
    Object? currentBalance = null,
  }) {
    return _then(_$SavingsAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyContribution: null == monthlyContribution
          ? _value.monthlyContribution
          : monthlyContribution // ignore: cast_nullable_to_non_nullable
              as Money,
      currentBalance: null == currentBalance
          ? _value.currentBalance
          : currentBalance // ignore: cast_nullable_to_non_nullable
              as Money,
    ));
  }
}

/// @nodoc

class _$SavingsAccountImpl extends _SavingsAccount {
  const _$SavingsAccountImpl(
      {required this.id,
      required this.name,
      required this.monthlyContribution,
      required this.currentBalance})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final Money monthlyContribution;
  @override
  final Money currentBalance;

  @override
  String toString() {
    return 'SavingsAccount(id: $id, name: $name, monthlyContribution: $monthlyContribution, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavingsAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.monthlyContribution, monthlyContribution) ||
                other.monthlyContribution == monthlyContribution) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, monthlyContribution, currentBalance);

  /// Create a copy of SavingsAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavingsAccountImplCopyWith<_$SavingsAccountImpl> get copyWith =>
      __$$SavingsAccountImplCopyWithImpl<_$SavingsAccountImpl>(
          this, _$identity);
}

abstract class _SavingsAccount extends SavingsAccount {
  const factory _SavingsAccount(
      {required final String id,
      required final String name,
      required final Money monthlyContribution,
      required final Money currentBalance}) = _$SavingsAccountImpl;
  const _SavingsAccount._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  Money get monthlyContribution;
  @override
  Money get currentBalance;

  /// Create a copy of SavingsAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavingsAccountImplCopyWith<_$SavingsAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
