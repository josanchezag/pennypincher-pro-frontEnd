// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BudgetComponent {
  BudgetComponentType get type => throw _privateConstructorUsedError;
  Money get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  double? get idealPercentage => throw _privateConstructorUsedError;

  /// Create a copy of BudgetComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetComponentCopyWith<BudgetComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetComponentCopyWith<$Res> {
  factory $BudgetComponentCopyWith(
          BudgetComponent value, $Res Function(BudgetComponent) then) =
      _$BudgetComponentCopyWithImpl<$Res, BudgetComponent>;
  @useResult
  $Res call(
      {BudgetComponentType type,
      Money amount,
      double percentage,
      double? idealPercentage});
}

/// @nodoc
class _$BudgetComponentCopyWithImpl<$Res, $Val extends BudgetComponent>
    implements $BudgetComponentCopyWith<$Res> {
  _$BudgetComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amount = null,
    Object? percentage = null,
    Object? idealPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetComponentType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      idealPercentage: freezed == idealPercentage
          ? _value.idealPercentage
          : idealPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetComponentImplCopyWith<$Res>
    implements $BudgetComponentCopyWith<$Res> {
  factory _$$BudgetComponentImplCopyWith(_$BudgetComponentImpl value,
          $Res Function(_$BudgetComponentImpl) then) =
      __$$BudgetComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BudgetComponentType type,
      Money amount,
      double percentage,
      double? idealPercentage});
}

/// @nodoc
class __$$BudgetComponentImplCopyWithImpl<$Res>
    extends _$BudgetComponentCopyWithImpl<$Res, _$BudgetComponentImpl>
    implements _$$BudgetComponentImplCopyWith<$Res> {
  __$$BudgetComponentImplCopyWithImpl(
      _$BudgetComponentImpl _value, $Res Function(_$BudgetComponentImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? amount = null,
    Object? percentage = null,
    Object? idealPercentage = freezed,
  }) {
    return _then(_$BudgetComponentImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetComponentType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      idealPercentage: freezed == idealPercentage
          ? _value.idealPercentage
          : idealPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$BudgetComponentImpl implements _BudgetComponent {
  const _$BudgetComponentImpl(
      {required this.type,
      required this.amount,
      required this.percentage,
      this.idealPercentage});

  @override
  final BudgetComponentType type;
  @override
  final Money amount;
  @override
  final double percentage;
  @override
  final double? idealPercentage;

  @override
  String toString() {
    return 'BudgetComponent(type: $type, amount: $amount, percentage: $percentage, idealPercentage: $idealPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetComponentImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.idealPercentage, idealPercentage) ||
                other.idealPercentage == idealPercentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, amount, percentage, idealPercentage);

  /// Create a copy of BudgetComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetComponentImplCopyWith<_$BudgetComponentImpl> get copyWith =>
      __$$BudgetComponentImplCopyWithImpl<_$BudgetComponentImpl>(
          this, _$identity);
}

abstract class _BudgetComponent implements BudgetComponent {
  const factory _BudgetComponent(
      {required final BudgetComponentType type,
      required final Money amount,
      required final double percentage,
      final double? idealPercentage}) = _$BudgetComponentImpl;

  @override
  BudgetComponentType get type;
  @override
  Money get amount;
  @override
  double get percentage;
  @override
  double? get idealPercentage;

  /// Create a copy of BudgetComponent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetComponentImplCopyWith<_$BudgetComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BudgetSettings {
  Money? get exchangeRate => throw _privateConstructorUsedError;
  int? get workDays => throw _privateConstructorUsedError;

  /// Create a copy of BudgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetSettingsCopyWith<BudgetSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetSettingsCopyWith<$Res> {
  factory $BudgetSettingsCopyWith(
          BudgetSettings value, $Res Function(BudgetSettings) then) =
      _$BudgetSettingsCopyWithImpl<$Res, BudgetSettings>;
  @useResult
  $Res call({Money? exchangeRate, int? workDays});
}

/// @nodoc
class _$BudgetSettingsCopyWithImpl<$Res, $Val extends BudgetSettings>
    implements $BudgetSettingsCopyWith<$Res> {
  _$BudgetSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exchangeRate = freezed,
    Object? workDays = freezed,
  }) {
    return _then(_value.copyWith(
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Money?,
      workDays: freezed == workDays
          ? _value.workDays
          : workDays // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetSettingsImplCopyWith<$Res>
    implements $BudgetSettingsCopyWith<$Res> {
  factory _$$BudgetSettingsImplCopyWith(_$BudgetSettingsImpl value,
          $Res Function(_$BudgetSettingsImpl) then) =
      __$$BudgetSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Money? exchangeRate, int? workDays});
}

/// @nodoc
class __$$BudgetSettingsImplCopyWithImpl<$Res>
    extends _$BudgetSettingsCopyWithImpl<$Res, _$BudgetSettingsImpl>
    implements _$$BudgetSettingsImplCopyWith<$Res> {
  __$$BudgetSettingsImplCopyWithImpl(
      _$BudgetSettingsImpl _value, $Res Function(_$BudgetSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exchangeRate = freezed,
    Object? workDays = freezed,
  }) {
    return _then(_$BudgetSettingsImpl(
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Money?,
      workDays: freezed == workDays
          ? _value.workDays
          : workDays // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$BudgetSettingsImpl implements _BudgetSettings {
  const _$BudgetSettingsImpl({this.exchangeRate, this.workDays});

  @override
  final Money? exchangeRate;
  @override
  final int? workDays;

  @override
  String toString() {
    return 'BudgetSettings(exchangeRate: $exchangeRate, workDays: $workDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetSettingsImpl &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.workDays, workDays) ||
                other.workDays == workDays));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exchangeRate, workDays);

  /// Create a copy of BudgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetSettingsImplCopyWith<_$BudgetSettingsImpl> get copyWith =>
      __$$BudgetSettingsImplCopyWithImpl<_$BudgetSettingsImpl>(
          this, _$identity);
}

abstract class _BudgetSettings implements BudgetSettings {
  const factory _BudgetSettings(
      {final Money? exchangeRate, final int? workDays}) = _$BudgetSettingsImpl;

  @override
  Money? get exchangeRate;
  @override
  int? get workDays;

  /// Create a copy of BudgetSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetSettingsImplCopyWith<_$BudgetSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthlyBudget {
  String get id => throw _privateConstructorUsedError;

  /// First day of the month the budget belongs to.
  DateTime get month => throw _privateConstructorUsedError;
  BudgetSettings get settings => throw _privateConstructorUsedError;
  Money get totalIncome => throw _privateConstructorUsedError;
  Money get totalExpenses => throw _privateConstructorUsedError;
  Money get monthlyCashFlow => throw _privateConstructorUsedError;
  List<BudgetComponent> get components => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyBudgetCopyWith<MonthlyBudget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyBudgetCopyWith<$Res> {
  factory $MonthlyBudgetCopyWith(
          MonthlyBudget value, $Res Function(MonthlyBudget) then) =
      _$MonthlyBudgetCopyWithImpl<$Res, MonthlyBudget>;
  @useResult
  $Res call(
      {String id,
      DateTime month,
      BudgetSettings settings,
      Money totalIncome,
      Money totalExpenses,
      Money monthlyCashFlow,
      List<BudgetComponent> components});

  $BudgetSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$MonthlyBudgetCopyWithImpl<$Res, $Val extends MonthlyBudget>
    implements $MonthlyBudgetCopyWith<$Res> {
  _$MonthlyBudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? month = null,
    Object? settings = null,
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? monthlyCashFlow = null,
    Object? components = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BudgetSettings,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as Money,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyCashFlow: null == monthlyCashFlow
          ? _value.monthlyCashFlow
          : monthlyCashFlow // ignore: cast_nullable_to_non_nullable
              as Money,
      components: null == components
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as List<BudgetComponent>,
    ) as $Val);
  }

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetSettingsCopyWith<$Res> get settings {
    return $BudgetSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthlyBudgetImplCopyWith<$Res>
    implements $MonthlyBudgetCopyWith<$Res> {
  factory _$$MonthlyBudgetImplCopyWith(
          _$MonthlyBudgetImpl value, $Res Function(_$MonthlyBudgetImpl) then) =
      __$$MonthlyBudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime month,
      BudgetSettings settings,
      Money totalIncome,
      Money totalExpenses,
      Money monthlyCashFlow,
      List<BudgetComponent> components});

  @override
  $BudgetSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$MonthlyBudgetImplCopyWithImpl<$Res>
    extends _$MonthlyBudgetCopyWithImpl<$Res, _$MonthlyBudgetImpl>
    implements _$$MonthlyBudgetImplCopyWith<$Res> {
  __$$MonthlyBudgetImplCopyWithImpl(
      _$MonthlyBudgetImpl _value, $Res Function(_$MonthlyBudgetImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? month = null,
    Object? settings = null,
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? monthlyCashFlow = null,
    Object? components = null,
  }) {
    return _then(_$MonthlyBudgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BudgetSettings,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as Money,
      totalExpenses: null == totalExpenses
          ? _value.totalExpenses
          : totalExpenses // ignore: cast_nullable_to_non_nullable
              as Money,
      monthlyCashFlow: null == monthlyCashFlow
          ? _value.monthlyCashFlow
          : monthlyCashFlow // ignore: cast_nullable_to_non_nullable
              as Money,
      components: null == components
          ? _value._components
          : components // ignore: cast_nullable_to_non_nullable
              as List<BudgetComponent>,
    ));
  }
}

/// @nodoc

class _$MonthlyBudgetImpl implements _MonthlyBudget {
  const _$MonthlyBudgetImpl(
      {required this.id,
      required this.month,
      required this.settings,
      required this.totalIncome,
      required this.totalExpenses,
      required this.monthlyCashFlow,
      required final List<BudgetComponent> components})
      : _components = components;

  @override
  final String id;

  /// First day of the month the budget belongs to.
  @override
  final DateTime month;
  @override
  final BudgetSettings settings;
  @override
  final Money totalIncome;
  @override
  final Money totalExpenses;
  @override
  final Money monthlyCashFlow;
  final List<BudgetComponent> _components;
  @override
  List<BudgetComponent> get components {
    if (_components is EqualUnmodifiableListView) return _components;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_components);
  }

  @override
  String toString() {
    return 'MonthlyBudget(id: $id, month: $month, settings: $settings, totalIncome: $totalIncome, totalExpenses: $totalExpenses, monthlyCashFlow: $monthlyCashFlow, components: $components)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyBudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.monthlyCashFlow, monthlyCashFlow) ||
                other.monthlyCashFlow == monthlyCashFlow) &&
            const DeepCollectionEquality()
                .equals(other._components, _components));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      month,
      settings,
      totalIncome,
      totalExpenses,
      monthlyCashFlow,
      const DeepCollectionEquality().hash(_components));

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyBudgetImplCopyWith<_$MonthlyBudgetImpl> get copyWith =>
      __$$MonthlyBudgetImplCopyWithImpl<_$MonthlyBudgetImpl>(this, _$identity);
}

abstract class _MonthlyBudget implements MonthlyBudget {
  const factory _MonthlyBudget(
      {required final String id,
      required final DateTime month,
      required final BudgetSettings settings,
      required final Money totalIncome,
      required final Money totalExpenses,
      required final Money monthlyCashFlow,
      required final List<BudgetComponent> components}) = _$MonthlyBudgetImpl;

  @override
  String get id;

  /// First day of the month the budget belongs to.
  @override
  DateTime get month;
  @override
  BudgetSettings get settings;
  @override
  Money get totalIncome;
  @override
  Money get totalExpenses;
  @override
  Money get monthlyCashFlow;
  @override
  List<BudgetComponent> get components;

  /// Create a copy of MonthlyBudget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyBudgetImplCopyWith<_$MonthlyBudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
