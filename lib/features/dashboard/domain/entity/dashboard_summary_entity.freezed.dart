// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DashboardSummary {
  /// First day of the month the budget belongs to.
  DateTime get referenceMonth => throw _privateConstructorUsedError;
  NetWorthOverview get netWorth => throw _privateConstructorUsedError;
  MonthBudgetOverview get budget => throw _privateConstructorUsedError;
  List<GoalSummary> get goals => throw _privateConstructorUsedError;

  /// Up to the last 12 monthly snapshots, from the oldest.
  List<NetWorthPoint> get recentSnapshots => throw _privateConstructorUsedError;
  UserProfile get user => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryCopyWith<DashboardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryCopyWith<$Res> {
  factory $DashboardSummaryCopyWith(
          DashboardSummary value, $Res Function(DashboardSummary) then) =
      _$DashboardSummaryCopyWithImpl<$Res, DashboardSummary>;
  @useResult
  $Res call(
      {DateTime referenceMonth,
      NetWorthOverview netWorth,
      MonthBudgetOverview budget,
      List<GoalSummary> goals,
      List<NetWorthPoint> recentSnapshots,
      UserProfile user});

  $NetWorthOverviewCopyWith<$Res> get netWorth;
  $MonthBudgetOverviewCopyWith<$Res> get budget;
  $UserProfileCopyWith<$Res> get user;
}

/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res, $Val extends DashboardSummary>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceMonth = null,
    Object? netWorth = null,
    Object? budget = null,
    Object? goals = null,
    Object? recentSnapshots = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      referenceMonth: null == referenceMonth
          ? _value.referenceMonth
          : referenceMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as NetWorthOverview,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as MonthBudgetOverview,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<GoalSummary>,
      recentSnapshots: null == recentSnapshots
          ? _value.recentSnapshots
          : recentSnapshots // ignore: cast_nullable_to_non_nullable
              as List<NetWorthPoint>,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile,
    ) as $Val);
  }

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetWorthOverviewCopyWith<$Res> get netWorth {
    return $NetWorthOverviewCopyWith<$Res>(_value.netWorth, (value) {
      return _then(_value.copyWith(netWorth: value) as $Val);
    });
  }

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MonthBudgetOverviewCopyWith<$Res> get budget {
    return $MonthBudgetOverviewCopyWith<$Res>(_value.budget, (value) {
      return _then(_value.copyWith(budget: value) as $Val);
    });
  }

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get user {
    return $UserProfileCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardSummaryImplCopyWith<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  factory _$$DashboardSummaryImplCopyWith(_$DashboardSummaryImpl value,
          $Res Function(_$DashboardSummaryImpl) then) =
      __$$DashboardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime referenceMonth,
      NetWorthOverview netWorth,
      MonthBudgetOverview budget,
      List<GoalSummary> goals,
      List<NetWorthPoint> recentSnapshots,
      UserProfile user});

  @override
  $NetWorthOverviewCopyWith<$Res> get netWorth;
  @override
  $MonthBudgetOverviewCopyWith<$Res> get budget;
  @override
  $UserProfileCopyWith<$Res> get user;
}

/// @nodoc
class __$$DashboardSummaryImplCopyWithImpl<$Res>
    extends _$DashboardSummaryCopyWithImpl<$Res, _$DashboardSummaryImpl>
    implements _$$DashboardSummaryImplCopyWith<$Res> {
  __$$DashboardSummaryImplCopyWithImpl(_$DashboardSummaryImpl _value,
      $Res Function(_$DashboardSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referenceMonth = null,
    Object? netWorth = null,
    Object? budget = null,
    Object? goals = null,
    Object? recentSnapshots = null,
    Object? user = null,
  }) {
    return _then(_$DashboardSummaryImpl(
      referenceMonth: null == referenceMonth
          ? _value.referenceMonth
          : referenceMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as NetWorthOverview,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as MonthBudgetOverview,
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<GoalSummary>,
      recentSnapshots: null == recentSnapshots
          ? _value._recentSnapshots
          : recentSnapshots // ignore: cast_nullable_to_non_nullable
              as List<NetWorthPoint>,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile,
    ));
  }
}

/// @nodoc

class _$DashboardSummaryImpl extends _DashboardSummary {
  const _$DashboardSummaryImpl(
      {required this.referenceMonth,
      required this.netWorth,
      required this.budget,
      required final List<GoalSummary> goals,
      required final List<NetWorthPoint> recentSnapshots,
      required this.user})
      : _goals = goals,
        _recentSnapshots = recentSnapshots,
        super._();

  /// First day of the month the budget belongs to.
  @override
  final DateTime referenceMonth;
  @override
  final NetWorthOverview netWorth;
  @override
  final MonthBudgetOverview budget;
  final List<GoalSummary> _goals;
  @override
  List<GoalSummary> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  /// Up to the last 12 monthly snapshots, from the oldest.
  final List<NetWorthPoint> _recentSnapshots;

  /// Up to the last 12 monthly snapshots, from the oldest.
  @override
  List<NetWorthPoint> get recentSnapshots {
    if (_recentSnapshots is EqualUnmodifiableListView) return _recentSnapshots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentSnapshots);
  }

  @override
  final UserProfile user;

  @override
  String toString() {
    return 'DashboardSummary(referenceMonth: $referenceMonth, netWorth: $netWorth, budget: $budget, goals: $goals, recentSnapshots: $recentSnapshots, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryImpl &&
            (identical(other.referenceMonth, referenceMonth) ||
                other.referenceMonth == referenceMonth) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            const DeepCollectionEquality()
                .equals(other._recentSnapshots, _recentSnapshots) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      referenceMonth,
      netWorth,
      budget,
      const DeepCollectionEquality().hash(_goals),
      const DeepCollectionEquality().hash(_recentSnapshots),
      user);

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      __$$DashboardSummaryImplCopyWithImpl<_$DashboardSummaryImpl>(
          this, _$identity);
}

abstract class _DashboardSummary extends DashboardSummary {
  const factory _DashboardSummary(
      {required final DateTime referenceMonth,
      required final NetWorthOverview netWorth,
      required final MonthBudgetOverview budget,
      required final List<GoalSummary> goals,
      required final List<NetWorthPoint> recentSnapshots,
      required final UserProfile user}) = _$DashboardSummaryImpl;
  const _DashboardSummary._() : super._();

  /// First day of the month the budget belongs to.
  @override
  DateTime get referenceMonth;
  @override
  NetWorthOverview get netWorth;
  @override
  MonthBudgetOverview get budget;
  @override
  List<GoalSummary> get goals;

  /// Up to the last 12 monthly snapshots, from the oldest.
  @override
  List<NetWorthPoint> get recentSnapshots;
  @override
  UserProfile get user;

  /// Create a copy of DashboardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryImplCopyWith<_$DashboardSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NetWorthOverview {
  Money get current => throw _privateConstructorUsedError;
  Money get totalAssets => throw _privateConstructorUsedError;
  Money get totalLiabilities => throw _privateConstructorUsedError;
  NetWorthChange? get change => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthOverviewCopyWith<NetWorthOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthOverviewCopyWith<$Res> {
  factory $NetWorthOverviewCopyWith(
          NetWorthOverview value, $Res Function(NetWorthOverview) then) =
      _$NetWorthOverviewCopyWithImpl<$Res, NetWorthOverview>;
  @useResult
  $Res call(
      {Money current,
      Money totalAssets,
      Money totalLiabilities,
      NetWorthChange? change});

  $NetWorthChangeCopyWith<$Res>? get change;
}

/// @nodoc
class _$NetWorthOverviewCopyWithImpl<$Res, $Val extends NetWorthOverview>
    implements $NetWorthOverviewCopyWith<$Res> {
  _$NetWorthOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? change = freezed,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Money,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as Money,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as Money,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as NetWorthChange?,
    ) as $Val);
  }

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NetWorthChangeCopyWith<$Res>? get change {
    if (_value.change == null) {
      return null;
    }

    return $NetWorthChangeCopyWith<$Res>(_value.change!, (value) {
      return _then(_value.copyWith(change: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NetWorthOverviewImplCopyWith<$Res>
    implements $NetWorthOverviewCopyWith<$Res> {
  factory _$$NetWorthOverviewImplCopyWith(_$NetWorthOverviewImpl value,
          $Res Function(_$NetWorthOverviewImpl) then) =
      __$$NetWorthOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Money current,
      Money totalAssets,
      Money totalLiabilities,
      NetWorthChange? change});

  @override
  $NetWorthChangeCopyWith<$Res>? get change;
}

/// @nodoc
class __$$NetWorthOverviewImplCopyWithImpl<$Res>
    extends _$NetWorthOverviewCopyWithImpl<$Res, _$NetWorthOverviewImpl>
    implements _$$NetWorthOverviewImplCopyWith<$Res> {
  __$$NetWorthOverviewImplCopyWithImpl(_$NetWorthOverviewImpl _value,
      $Res Function(_$NetWorthOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? totalAssets = null,
    Object? totalLiabilities = null,
    Object? change = freezed,
  }) {
    return _then(_$NetWorthOverviewImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Money,
      totalAssets: null == totalAssets
          ? _value.totalAssets
          : totalAssets // ignore: cast_nullable_to_non_nullable
              as Money,
      totalLiabilities: null == totalLiabilities
          ? _value.totalLiabilities
          : totalLiabilities // ignore: cast_nullable_to_non_nullable
              as Money,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as NetWorthChange?,
    ));
  }
}

/// @nodoc

class _$NetWorthOverviewImpl implements _NetWorthOverview {
  const _$NetWorthOverviewImpl(
      {required this.current,
      required this.totalAssets,
      required this.totalLiabilities,
      this.change});

  @override
  final Money current;
  @override
  final Money totalAssets;
  @override
  final Money totalLiabilities;
  @override
  final NetWorthChange? change;

  @override
  String toString() {
    return 'NetWorthOverview(current: $current, totalAssets: $totalAssets, totalLiabilities: $totalLiabilities, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthOverviewImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.totalAssets, totalAssets) ||
                other.totalAssets == totalAssets) &&
            (identical(other.totalLiabilities, totalLiabilities) ||
                other.totalLiabilities == totalLiabilities) &&
            (identical(other.change, change) || other.change == change));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, current, totalAssets, totalLiabilities, change);

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthOverviewImplCopyWith<_$NetWorthOverviewImpl> get copyWith =>
      __$$NetWorthOverviewImplCopyWithImpl<_$NetWorthOverviewImpl>(
          this, _$identity);
}

abstract class _NetWorthOverview implements NetWorthOverview {
  const factory _NetWorthOverview(
      {required final Money current,
      required final Money totalAssets,
      required final Money totalLiabilities,
      final NetWorthChange? change}) = _$NetWorthOverviewImpl;

  @override
  Money get current;
  @override
  Money get totalAssets;
  @override
  Money get totalLiabilities;
  @override
  NetWorthChange? get change;

  /// Create a copy of NetWorthOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthOverviewImplCopyWith<_$NetWorthOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NetWorthChange {
  Money get previous => throw _privateConstructorUsedError;
  DateTime get previousDate => throw _privateConstructorUsedError;
  Money get delta => throw _privateConstructorUsedError;
  double? get percentage => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthChangeCopyWith<NetWorthChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthChangeCopyWith<$Res> {
  factory $NetWorthChangeCopyWith(
          NetWorthChange value, $Res Function(NetWorthChange) then) =
      _$NetWorthChangeCopyWithImpl<$Res, NetWorthChange>;
  @useResult
  $Res call(
      {Money previous, DateTime previousDate, Money delta, double? percentage});
}

/// @nodoc
class _$NetWorthChangeCopyWithImpl<$Res, $Val extends NetWorthChange>
    implements $NetWorthChangeCopyWith<$Res> {
  _$NetWorthChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previous = null,
    Object? previousDate = null,
    Object? delta = null,
    Object? percentage = freezed,
  }) {
    return _then(_value.copyWith(
      previous: null == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as Money,
      previousDate: null == previousDate
          ? _value.previousDate
          : previousDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as Money,
      percentage: freezed == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthChangeImplCopyWith<$Res>
    implements $NetWorthChangeCopyWith<$Res> {
  factory _$$NetWorthChangeImplCopyWith(_$NetWorthChangeImpl value,
          $Res Function(_$NetWorthChangeImpl) then) =
      __$$NetWorthChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Money previous, DateTime previousDate, Money delta, double? percentage});
}

/// @nodoc
class __$$NetWorthChangeImplCopyWithImpl<$Res>
    extends _$NetWorthChangeCopyWithImpl<$Res, _$NetWorthChangeImpl>
    implements _$$NetWorthChangeImplCopyWith<$Res> {
  __$$NetWorthChangeImplCopyWithImpl(
      _$NetWorthChangeImpl _value, $Res Function(_$NetWorthChangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previous = null,
    Object? previousDate = null,
    Object? delta = null,
    Object? percentage = freezed,
  }) {
    return _then(_$NetWorthChangeImpl(
      previous: null == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as Money,
      previousDate: null == previousDate
          ? _value.previousDate
          : previousDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as Money,
      percentage: freezed == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$NetWorthChangeImpl implements _NetWorthChange {
  const _$NetWorthChangeImpl(
      {required this.previous,
      required this.previousDate,
      required this.delta,
      this.percentage});

  @override
  final Money previous;
  @override
  final DateTime previousDate;
  @override
  final Money delta;
  @override
  final double? percentage;

  @override
  String toString() {
    return 'NetWorthChange(previous: $previous, previousDate: $previousDate, delta: $delta, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthChangeImpl &&
            (identical(other.previous, previous) ||
                other.previous == previous) &&
            (identical(other.previousDate, previousDate) ||
                other.previousDate == previousDate) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, previous, previousDate, delta, percentage);

  /// Create a copy of NetWorthChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthChangeImplCopyWith<_$NetWorthChangeImpl> get copyWith =>
      __$$NetWorthChangeImplCopyWithImpl<_$NetWorthChangeImpl>(
          this, _$identity);
}

abstract class _NetWorthChange implements NetWorthChange {
  const factory _NetWorthChange(
      {required final Money previous,
      required final DateTime previousDate,
      required final Money delta,
      final double? percentage}) = _$NetWorthChangeImpl;

  @override
  Money get previous;
  @override
  DateTime get previousDate;
  @override
  Money get delta;
  @override
  double? get percentage;

  /// Create a copy of NetWorthChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthChangeImplCopyWith<_$NetWorthChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MonthBudgetOverview {
  DateTime get month => throw _privateConstructorUsedError;
  BudgetFigures? get figures => throw _privateConstructorUsedError;

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthBudgetOverviewCopyWith<MonthBudgetOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthBudgetOverviewCopyWith<$Res> {
  factory $MonthBudgetOverviewCopyWith(
          MonthBudgetOverview value, $Res Function(MonthBudgetOverview) then) =
      _$MonthBudgetOverviewCopyWithImpl<$Res, MonthBudgetOverview>;
  @useResult
  $Res call({DateTime month, BudgetFigures? figures});

  $BudgetFiguresCopyWith<$Res>? get figures;
}

/// @nodoc
class _$MonthBudgetOverviewCopyWithImpl<$Res, $Val extends MonthBudgetOverview>
    implements $MonthBudgetOverviewCopyWith<$Res> {
  _$MonthBudgetOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? figures = freezed,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      figures: freezed == figures
          ? _value.figures
          : figures // ignore: cast_nullable_to_non_nullable
              as BudgetFigures?,
    ) as $Val);
  }

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BudgetFiguresCopyWith<$Res>? get figures {
    if (_value.figures == null) {
      return null;
    }

    return $BudgetFiguresCopyWith<$Res>(_value.figures!, (value) {
      return _then(_value.copyWith(figures: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthBudgetOverviewImplCopyWith<$Res>
    implements $MonthBudgetOverviewCopyWith<$Res> {
  factory _$$MonthBudgetOverviewImplCopyWith(_$MonthBudgetOverviewImpl value,
          $Res Function(_$MonthBudgetOverviewImpl) then) =
      __$$MonthBudgetOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime month, BudgetFigures? figures});

  @override
  $BudgetFiguresCopyWith<$Res>? get figures;
}

/// @nodoc
class __$$MonthBudgetOverviewImplCopyWithImpl<$Res>
    extends _$MonthBudgetOverviewCopyWithImpl<$Res, _$MonthBudgetOverviewImpl>
    implements _$$MonthBudgetOverviewImplCopyWith<$Res> {
  __$$MonthBudgetOverviewImplCopyWithImpl(_$MonthBudgetOverviewImpl _value,
      $Res Function(_$MonthBudgetOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? figures = freezed,
  }) {
    return _then(_$MonthBudgetOverviewImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      figures: freezed == figures
          ? _value.figures
          : figures // ignore: cast_nullable_to_non_nullable
              as BudgetFigures?,
    ));
  }
}

/// @nodoc

class _$MonthBudgetOverviewImpl extends _MonthBudgetOverview {
  const _$MonthBudgetOverviewImpl({required this.month, this.figures})
      : super._();

  @override
  final DateTime month;
  @override
  final BudgetFigures? figures;

  @override
  String toString() {
    return 'MonthBudgetOverview(month: $month, figures: $figures)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthBudgetOverviewImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.figures, figures) || other.figures == figures));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, figures);

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthBudgetOverviewImplCopyWith<_$MonthBudgetOverviewImpl> get copyWith =>
      __$$MonthBudgetOverviewImplCopyWithImpl<_$MonthBudgetOverviewImpl>(
          this, _$identity);
}

abstract class _MonthBudgetOverview extends MonthBudgetOverview {
  const factory _MonthBudgetOverview(
      {required final DateTime month,
      final BudgetFigures? figures}) = _$MonthBudgetOverviewImpl;
  const _MonthBudgetOverview._() : super._();

  @override
  DateTime get month;
  @override
  BudgetFigures? get figures;

  /// Create a copy of MonthBudgetOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthBudgetOverviewImplCopyWith<_$MonthBudgetOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BudgetFigures {
  Money get totalIncome => throw _privateConstructorUsedError;
  Money get totalExpenses => throw _privateConstructorUsedError;
  Money get monthlyCashFlow => throw _privateConstructorUsedError;
  double get cashFlowPercentage => throw _privateConstructorUsedError;

  /// Create a copy of BudgetFigures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetFiguresCopyWith<BudgetFigures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetFiguresCopyWith<$Res> {
  factory $BudgetFiguresCopyWith(
          BudgetFigures value, $Res Function(BudgetFigures) then) =
      _$BudgetFiguresCopyWithImpl<$Res, BudgetFigures>;
  @useResult
  $Res call(
      {Money totalIncome,
      Money totalExpenses,
      Money monthlyCashFlow,
      double cashFlowPercentage});
}

/// @nodoc
class _$BudgetFiguresCopyWithImpl<$Res, $Val extends BudgetFigures>
    implements $BudgetFiguresCopyWith<$Res> {
  _$BudgetFiguresCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetFigures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? monthlyCashFlow = null,
    Object? cashFlowPercentage = null,
  }) {
    return _then(_value.copyWith(
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
      cashFlowPercentage: null == cashFlowPercentage
          ? _value.cashFlowPercentage
          : cashFlowPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetFiguresImplCopyWith<$Res>
    implements $BudgetFiguresCopyWith<$Res> {
  factory _$$BudgetFiguresImplCopyWith(
          _$BudgetFiguresImpl value, $Res Function(_$BudgetFiguresImpl) then) =
      __$$BudgetFiguresImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Money totalIncome,
      Money totalExpenses,
      Money monthlyCashFlow,
      double cashFlowPercentage});
}

/// @nodoc
class __$$BudgetFiguresImplCopyWithImpl<$Res>
    extends _$BudgetFiguresCopyWithImpl<$Res, _$BudgetFiguresImpl>
    implements _$$BudgetFiguresImplCopyWith<$Res> {
  __$$BudgetFiguresImplCopyWithImpl(
      _$BudgetFiguresImpl _value, $Res Function(_$BudgetFiguresImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetFigures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? monthlyCashFlow = null,
    Object? cashFlowPercentage = null,
  }) {
    return _then(_$BudgetFiguresImpl(
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
      cashFlowPercentage: null == cashFlowPercentage
          ? _value.cashFlowPercentage
          : cashFlowPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$BudgetFiguresImpl implements _BudgetFigures {
  const _$BudgetFiguresImpl(
      {required this.totalIncome,
      required this.totalExpenses,
      required this.monthlyCashFlow,
      required this.cashFlowPercentage});

  @override
  final Money totalIncome;
  @override
  final Money totalExpenses;
  @override
  final Money monthlyCashFlow;
  @override
  final double cashFlowPercentage;

  @override
  String toString() {
    return 'BudgetFigures(totalIncome: $totalIncome, totalExpenses: $totalExpenses, monthlyCashFlow: $monthlyCashFlow, cashFlowPercentage: $cashFlowPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetFiguresImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.monthlyCashFlow, monthlyCashFlow) ||
                other.monthlyCashFlow == monthlyCashFlow) &&
            (identical(other.cashFlowPercentage, cashFlowPercentage) ||
                other.cashFlowPercentage == cashFlowPercentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpenses,
      monthlyCashFlow, cashFlowPercentage);

  /// Create a copy of BudgetFigures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetFiguresImplCopyWith<_$BudgetFiguresImpl> get copyWith =>
      __$$BudgetFiguresImplCopyWithImpl<_$BudgetFiguresImpl>(this, _$identity);
}

abstract class _BudgetFigures implements BudgetFigures {
  const factory _BudgetFigures(
      {required final Money totalIncome,
      required final Money totalExpenses,
      required final Money monthlyCashFlow,
      required final double cashFlowPercentage}) = _$BudgetFiguresImpl;

  @override
  Money get totalIncome;
  @override
  Money get totalExpenses;
  @override
  Money get monthlyCashFlow;
  @override
  double get cashFlowPercentage;

  /// Create a copy of BudgetFigures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetFiguresImplCopyWith<_$BudgetFiguresImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GoalSummary {
  String get goalId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get progressPercentage => throw _privateConstructorUsedError;

  /// Create a copy of GoalSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoalSummaryCopyWith<GoalSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalSummaryCopyWith<$Res> {
  factory $GoalSummaryCopyWith(
          GoalSummary value, $Res Function(GoalSummary) then) =
      _$GoalSummaryCopyWithImpl<$Res, GoalSummary>;
  @useResult
  $Res call({String goalId, String name, double progressPercentage});
}

/// @nodoc
class _$GoalSummaryCopyWithImpl<$Res, $Val extends GoalSummary>
    implements $GoalSummaryCopyWith<$Res> {
  _$GoalSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalId = null,
    Object? name = null,
    Object? progressPercentage = null,
  }) {
    return _then(_value.copyWith(
      goalId: null == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalSummaryImplCopyWith<$Res>
    implements $GoalSummaryCopyWith<$Res> {
  factory _$$GoalSummaryImplCopyWith(
          _$GoalSummaryImpl value, $Res Function(_$GoalSummaryImpl) then) =
      __$$GoalSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String goalId, String name, double progressPercentage});
}

/// @nodoc
class __$$GoalSummaryImplCopyWithImpl<$Res>
    extends _$GoalSummaryCopyWithImpl<$Res, _$GoalSummaryImpl>
    implements _$$GoalSummaryImplCopyWith<$Res> {
  __$$GoalSummaryImplCopyWithImpl(
      _$GoalSummaryImpl _value, $Res Function(_$GoalSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalId = null,
    Object? name = null,
    Object? progressPercentage = null,
  }) {
    return _then(_$GoalSummaryImpl(
      goalId: null == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$GoalSummaryImpl implements _GoalSummary {
  const _$GoalSummaryImpl(
      {required this.goalId,
      required this.name,
      required this.progressPercentage});

  @override
  final String goalId;
  @override
  final String name;
  @override
  final double progressPercentage;

  @override
  String toString() {
    return 'GoalSummary(goalId: $goalId, name: $name, progressPercentage: $progressPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalSummaryImpl &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, goalId, name, progressPercentage);

  /// Create a copy of GoalSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalSummaryImplCopyWith<_$GoalSummaryImpl> get copyWith =>
      __$$GoalSummaryImplCopyWithImpl<_$GoalSummaryImpl>(this, _$identity);
}

abstract class _GoalSummary implements GoalSummary {
  const factory _GoalSummary(
      {required final String goalId,
      required final String name,
      required final double progressPercentage}) = _$GoalSummaryImpl;

  @override
  String get goalId;
  @override
  String get name;
  @override
  double get progressPercentage;

  /// Create a copy of GoalSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalSummaryImplCopyWith<_$GoalSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NetWorthPoint {
  DateTime get date => throw _privateConstructorUsedError;
  Money get netWorth => throw _privateConstructorUsedError;

  /// Create a copy of NetWorthPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetWorthPointCopyWith<NetWorthPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetWorthPointCopyWith<$Res> {
  factory $NetWorthPointCopyWith(
          NetWorthPoint value, $Res Function(NetWorthPoint) then) =
      _$NetWorthPointCopyWithImpl<$Res, NetWorthPoint>;
  @useResult
  $Res call({DateTime date, Money netWorth});
}

/// @nodoc
class _$NetWorthPointCopyWithImpl<$Res, $Val extends NetWorthPoint>
    implements $NetWorthPointCopyWith<$Res> {
  _$NetWorthPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetWorthPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? netWorth = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as Money,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetWorthPointImplCopyWith<$Res>
    implements $NetWorthPointCopyWith<$Res> {
  factory _$$NetWorthPointImplCopyWith(
          _$NetWorthPointImpl value, $Res Function(_$NetWorthPointImpl) then) =
      __$$NetWorthPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, Money netWorth});
}

/// @nodoc
class __$$NetWorthPointImplCopyWithImpl<$Res>
    extends _$NetWorthPointCopyWithImpl<$Res, _$NetWorthPointImpl>
    implements _$$NetWorthPointImplCopyWith<$Res> {
  __$$NetWorthPointImplCopyWithImpl(
      _$NetWorthPointImpl _value, $Res Function(_$NetWorthPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetWorthPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? netWorth = null,
  }) {
    return _then(_$NetWorthPointImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      netWorth: null == netWorth
          ? _value.netWorth
          : netWorth // ignore: cast_nullable_to_non_nullable
              as Money,
    ));
  }
}

/// @nodoc

class _$NetWorthPointImpl implements _NetWorthPoint {
  const _$NetWorthPointImpl({required this.date, required this.netWorth});

  @override
  final DateTime date;
  @override
  final Money netWorth;

  @override
  String toString() {
    return 'NetWorthPoint(date: $date, netWorth: $netWorth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetWorthPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, netWorth);

  /// Create a copy of NetWorthPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetWorthPointImplCopyWith<_$NetWorthPointImpl> get copyWith =>
      __$$NetWorthPointImplCopyWithImpl<_$NetWorthPointImpl>(this, _$identity);
}

abstract class _NetWorthPoint implements NetWorthPoint {
  const factory _NetWorthPoint(
      {required final DateTime date,
      required final Money netWorth}) = _$NetWorthPointImpl;

  @override
  DateTime get date;
  @override
  Money get netWorth;

  /// Create a copy of NetWorthPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetWorthPointImplCopyWith<_$NetWorthPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserProfile {
  String get name => throw _privateConstructorUsedError;
  String? get pictureUrl => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({String name, String? pictureUrl});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? pictureUrl = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: freezed == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? pictureUrl});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? pictureUrl = freezed,
  }) {
    return _then(_$UserProfileImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: freezed == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl({required this.name, this.pictureUrl}) : super._();

  @override
  final String name;
  @override
  final String? pictureUrl;

  @override
  String toString() {
    return 'UserProfile(name: $name, pictureUrl: $pictureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, pictureUrl);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String name,
      final String? pictureUrl}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  @override
  String get name;
  @override
  String? get pictureUrl;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
