// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_expense_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FixedExpense {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Money get monthlyAmount => throw _privateConstructorUsedError;
  FixedExpenseCategory get category => throw _privateConstructorUsedError;

  /// Create a copy of FixedExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedExpenseCopyWith<FixedExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedExpenseCopyWith<$Res> {
  factory $FixedExpenseCopyWith(
          FixedExpense value, $Res Function(FixedExpense) then) =
      _$FixedExpenseCopyWithImpl<$Res, FixedExpense>;
  @useResult
  $Res call(
      {String id,
      String name,
      Money monthlyAmount,
      FixedExpenseCategory category});
}

/// @nodoc
class _$FixedExpenseCopyWithImpl<$Res, $Val extends FixedExpense>
    implements $FixedExpenseCopyWith<$Res> {
  _$FixedExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? monthlyAmount = null,
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
      monthlyAmount: null == monthlyAmount
          ? _value.monthlyAmount
          : monthlyAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as FixedExpenseCategory,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FixedExpenseImplCopyWith<$Res>
    implements $FixedExpenseCopyWith<$Res> {
  factory _$$FixedExpenseImplCopyWith(
          _$FixedExpenseImpl value, $Res Function(_$FixedExpenseImpl) then) =
      __$$FixedExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Money monthlyAmount,
      FixedExpenseCategory category});
}

/// @nodoc
class __$$FixedExpenseImplCopyWithImpl<$Res>
    extends _$FixedExpenseCopyWithImpl<$Res, _$FixedExpenseImpl>
    implements _$$FixedExpenseImplCopyWith<$Res> {
  __$$FixedExpenseImplCopyWithImpl(
      _$FixedExpenseImpl _value, $Res Function(_$FixedExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FixedExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? monthlyAmount = null,
    Object? category = null,
  }) {
    return _then(_$FixedExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyAmount: null == monthlyAmount
          ? _value.monthlyAmount
          : monthlyAmount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as FixedExpenseCategory,
    ));
  }
}

/// @nodoc

class _$FixedExpenseImpl extends _FixedExpense {
  const _$FixedExpenseImpl(
      {required this.id,
      required this.name,
      required this.monthlyAmount,
      required this.category})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final Money monthlyAmount;
  @override
  final FixedExpenseCategory category;

  @override
  String toString() {
    return 'FixedExpense(id: $id, name: $name, monthlyAmount: $monthlyAmount, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.monthlyAmount, monthlyAmount) ||
                other.monthlyAmount == monthlyAmount) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, monthlyAmount, category);

  /// Create a copy of FixedExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedExpenseImplCopyWith<_$FixedExpenseImpl> get copyWith =>
      __$$FixedExpenseImplCopyWithImpl<_$FixedExpenseImpl>(this, _$identity);
}

abstract class _FixedExpense extends FixedExpense {
  const factory _FixedExpense(
      {required final String id,
      required final String name,
      required final Money monthlyAmount,
      required final FixedExpenseCategory category}) = _$FixedExpenseImpl;
  const _FixedExpense._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  Money get monthlyAmount;
  @override
  FixedExpenseCategory get category;

  /// Create a copy of FixedExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedExpenseImplCopyWith<_$FixedExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
