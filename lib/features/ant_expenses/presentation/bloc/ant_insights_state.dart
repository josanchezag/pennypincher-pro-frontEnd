part of 'ant_insights_cubit.dart';

/// The parts of the ant expenses screen around the list, and the progress
/// of saving the monthly limit.
final class AntInsightsState extends Equatable {
  const AntInsightsState({
    required this.today,
    this.summary = const AntSectionLoading(),
    this.trend = const AntSectionLoading(),
    this.cuts = const AntSectionLoading(),
    this.trendMonths = AntExpenseLimits.shortTrendMonths,
    this.savingLimit = false,
    this.limitError,
  });

  /// The device's local day when the screen opened: the latest day a new
  /// expense can have and the reference of `Today` and `Yesterday`.
  final DateTime today;

  final AntSection<AntSummary> summary;

  /// The last [trendMonths] months, oldest first.
  final AntSection<List<AntTrendMonth>> trend;

  /// Newest month first.
  final AntSection<List<AntCut>> cuts;
  final int trendMonths;
  final bool savingLimit;

  /// Why the last change of the limit failed.
  final String? limitError;

  AntInsightsState copyWith({
    AntSection<AntSummary>? summary,
    AntSection<List<AntTrendMonth>>? trend,
    AntSection<List<AntCut>>? cuts,
    int? trendMonths,
    bool? savingLimit,
    String? Function()? limitError,
  }) =>
      AntInsightsState(
        today: today,
        summary: summary ?? this.summary,
        trend: trend ?? this.trend,
        cuts: cuts ?? this.cuts,
        trendMonths: trendMonths ?? this.trendMonths,
        savingLimit: savingLimit ?? this.savingLimit,
        limitError: limitError == null ? this.limitError : limitError(),
      );

  @override
  List<Object?> get props =>
      [today, summary, trend, cuts, trendMonths, savingLimit, limitError];
}
