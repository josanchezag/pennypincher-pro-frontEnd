import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/calendar_month.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/usecase/ant_expense_use_cases.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';

part 'ant_insights_state.dart';

/// Everything around the list of the ant expenses screen: the totals of
/// the current period, the trend per month and the history of cuts, each
/// loaded and retried on its own, and the monthly soft limit. The trend
/// ends at the current month of the device's local clock. A new instance
/// is created per screen.
@injectable
class AntInsightsCubit extends Cubit<AntInsightsState> {
  AntInsightsCubit(
    this._getSummary,
    this._getTrend,
    this._getCuts,
    this._saveLimit,
    Clock clock,
  ) : super(AntInsightsState(today: DayFormat.dayOf(clock.now())));

  final GetAntSummary _getSummary;
  final GetAntTrend _getTrend;
  final GetAntCuts _getCuts;
  final SaveAntLimit _saveLimit;

  /// Loads every part.
  Future<void> load() => Future.wait([_summary(), _trend(), _cuts()]);

  Future<void> retrySummary() {
    _emit(state.copyWith(summary: const AntSectionLoading()));
    return _summary();
  }

  Future<void> retryTrend() {
    _emit(state.copyWith(trend: const AntSectionLoading()));
    return _trend();
  }

  Future<void> retryCuts() {
    _emit(state.copyWith(cuts: const AntSectionLoading()));
    return _cuts();
  }

  /// Shows the last [months] months in the trend.
  Future<void> changeTrendMonths(int months) {
    if (months == state.trendMonths) {
      return Future.value();
    }
    _emit(
      state.copyWith(trendMonths: months, trend: const AntSectionLoading()),
    );
    return _trend();
  }

  /// The open expenses changed: loads the totals and the trend again,
  /// keeping the current figures on screen until the new ones arrive.
  Future<void> refreshPeriod() => Future.wait([_summary(), _trend()]);

  /// Stores [monthlyLimit] as the monthly soft limit, or removes it when
  /// `null`, and then loads the totals again. A failure is kept in
  /// [AntInsightsState.limitError].
  Future<void> saveLimit(Money? monthlyLimit) async {
    if (state.savingLimit) {
      return;
    }
    _emit(state.copyWith(savingLimit: true, limitError: () => null));
    final result = await _saveLimit(monthlyLimit);
    await result.fold(
      (failure) async => _emit(
        state.copyWith(savingLimit: false, limitError: () => failure.message),
      ),
      (_) async {
        _emit(state.copyWith(savingLimit: false));
        await _summary();
      },
    );
  }

  Future<void> _summary() async {
    final result = await _getSummary();
    _emit(state.copyWith(summary: _section(result)));
  }

  Future<void> _trend() async {
    final months = state.trendMonths;
    final result = await _getTrend(CalendarMonth.of(state.today), months);
    if (months == state.trendMonths) {
      _emit(state.copyWith(trend: _section(result)));
    }
  }

  Future<void> _cuts() async {
    final result = await _getCuts();
    _emit(state.copyWith(cuts: _section(result)));
  }

  static AntSection<T> _section<T>(Either<Failure, T> result) => result.fold(
        (failure) => AntSectionFailure<T>(failure.message),
        AntSectionLoaded<T>.new,
      );

  void _emit(AntInsightsState next) {
    if (!isClosed) {
      emit(next);
    }
  }
}
