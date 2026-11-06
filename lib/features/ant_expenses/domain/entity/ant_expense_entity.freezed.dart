// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ant_expense_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AntExpense {
  String get id => throw _privateConstructorUsedError;
  Money get amount => throw _privateConstructorUsedError;
  AntExpenseCategory get category => throw _privateConstructorUsedError;

  /// Day of the purchase, as a local date.
  DateTime get spentOn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get open => throw _privateConstructorUsedError;
  String? get budgetId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of AntExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AntExpenseCopyWith<AntExpense> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AntExpenseCopyWith<$Res> {
  factory $AntExpenseCopyWith(
          AntExpense value, $Res Function(AntExpense) then) =
      _$AntExpenseCopyWithImpl<$Res, AntExpense>;
  @useResult
  $Res call(
      {String id,
      Money amount,
      AntExpenseCategory category,
      DateTime spentOn,
      String? description,
      bool open,
      String? budgetId,
      DateTime? createdAt});
}

/// @nodoc
class _$AntExpenseCopyWithImpl<$Res, $Val extends AntExpense>
    implements $AntExpenseCopyWith<$Res> {
  _$AntExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AntExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? spentOn = null,
    Object? description = freezed,
    Object? open = null,
    Object? budgetId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory,
      spentOn: null == spentOn
          ? _value.spentOn
          : spentOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetId: freezed == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AntExpenseImplCopyWith<$Res>
    implements $AntExpenseCopyWith<$Res> {
  factory _$$AntExpenseImplCopyWith(
          _$AntExpenseImpl value, $Res Function(_$AntExpenseImpl) then) =
      __$$AntExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Money amount,
      AntExpenseCategory category,
      DateTime spentOn,
      String? description,
      bool open,
      String? budgetId,
      DateTime? createdAt});
}

/// @nodoc
class __$$AntExpenseImplCopyWithImpl<$Res>
    extends _$AntExpenseCopyWithImpl<$Res, _$AntExpenseImpl>
    implements _$$AntExpenseImplCopyWith<$Res> {
  __$$AntExpenseImplCopyWithImpl(
      _$AntExpenseImpl _value, $Res Function(_$AntExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AntExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? spentOn = null,
    Object? description = freezed,
    Object? open = null,
    Object? budgetId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AntExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as AntExpenseCategory,
      spentOn: null == spentOn
          ? _value.spentOn
          : spentOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as bool,
      budgetId: freezed == budgetId
          ? _value.budgetId
          : budgetId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$AntExpenseImpl extends _AntExpense {
  const _$AntExpenseImpl(
      {required this.id,
      required this.amount,
      required this.category,
      required this.spentOn,
      this.description,
      this.open = true,
      this.budgetId,
      this.createdAt})
      : super._();

  @override
  final String id;
  @override
  final Money amount;
  @override
  final AntExpenseCategory category;

  /// Day of the purchase, as a local date.
  @override
  final DateTime spentOn;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool open;
  @override
  final String? budgetId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AntExpense(id: $id, amount: $amount, category: $category, spentOn: $spentOn, description: $description, open: $open, budgetId: $budgetId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AntExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.spentOn, spentOn) || other.spentOn == spentOn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, amount, category, spentOn,
      description, open, budgetId, createdAt);

  /// Create a copy of AntExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AntExpenseImplCopyWith<_$AntExpenseImpl> get copyWith =>
      __$$AntExpenseImplCopyWithImpl<_$AntExpenseImpl>(this, _$identity);
}

abstract class _AntExpense extends AntExpense {
  const factory _AntExpense(
      {required final String id,
      required final Money amount,
      required final AntExpenseCategory category,
      required final DateTime spentOn,
      final String? description,
      final bool open,
      final String? budgetId,
      final DateTime? createdAt}) = _$AntExpenseImpl;
  const _AntExpense._() : super._();

  @override
  String get id;
  @override
  Money get amount;
  @override
  AntExpenseCategory get category;

  /// Day of the purchase, as a local date.
  @override
  DateTime get spentOn;
  @override
  String? get description;
  @override
  bool get open;
  @override
  String? get budgetId;
  @override
  DateTime? get createdAt;

  /// Create a copy of AntExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AntExpenseImplCopyWith<_$AntExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
