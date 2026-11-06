import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';

/// Keys of the ant expense JSON.
abstract final class AntExpenseJsonKeys {
  static const String id = 'id';
  static const String amount = 'amount';
  static const String description = 'description';
  static const String category = 'category';
  static const String spentOn = 'spentOn';
  static const String open = 'open';
  static const String budgetId = 'budgetId';
  static const String createdAt = 'createdAt';
  static const String total = 'total';
  static const String count = 'count';
  static const String percentage = 'percentage';
  static const String periodStart = 'periodStart';
  static const String periodEnd = 'periodEnd';
  static const String days = 'days';
  static const String dailyAverage = 'dailyAverage';
  static const String topCategory = 'topCategory';
  static const String byCategory = 'byCategory';
  static const String lastCut = 'lastCut';
  static const String daysSinceLastCut = 'daysSinceLastCut';
  static const String limit = 'limit';
  static const String monthlyLimit = 'monthlyLimit';
  static const String usedPercentage = 'usedPercentage';
  static const String remaining = 'remaining';
  static const String year = 'year';
  static const String month = 'month';
  static const String cutAt = 'cutAt';
}

/// JSON of an ant expense, `{id, amount, description, category, spentOn,
/// open, budgetId, createdAt, updatedAt}`, and of the draft that creates
/// or updates one. A category this client does not know yet reads as
/// [AntExpenseCategory.other].
class AntExpenseJsonCodec
    implements ItemJsonCodec<AntExpense, AntExpenseDraft> {
  const AntExpenseJsonCodec();

  @override
  AntExpense fromJson(JsonMap json) {
    final createdAt = json[AntExpenseJsonKeys.createdAt];
    return AntExpense(
      id: json[AntExpenseJsonKeys.id] as String,
      amount: Money.fromJson(json[AntExpenseJsonKeys.amount]),
      category: AntReportJson.category(json[AntExpenseJsonKeys.category]),
      spentOn: ApiDate.parse(json[AntExpenseJsonKeys.spentOn] as String),
      description: json[AntExpenseJsonKeys.description] as String?,
      open: json[AntExpenseJsonKeys.open] as bool,
      budgetId: json[AntExpenseJsonKeys.budgetId] as String?,
      createdAt: createdAt == null ? null : DateTime.parse(createdAt as String),
    );
  }

  /// `spentOn` is always sent, so the day is the device's and not the
  /// server's (UTC).
  @override
  JsonMap toJson(AntExpenseDraft draft) => {
        AntExpenseJsonKeys.amount: draft.amount.toJson(),
        AntExpenseJsonKeys.category: ApiEnum.nameOf(draft.category),
        AntExpenseJsonKeys.description: draft.description,
        AntExpenseJsonKeys.spentOn: ApiDate.format(draft.spentOn),
      };
}

/// Reads the summary, cuts and trend of the ant expenses as the API sends
/// them. Throws [TypeError] or [FormatException] on an unexpected shape.
abstract final class AntReportJson {
  static AntExpenseCategory category(Object? json) => ApiEnum.parse(
        AntExpenseCategory.values,
        json,
        fallback: AntExpenseCategory.other,
      );

  static AntSummary summary(JsonMap json) {
    final lastCut = json[AntExpenseJsonKeys.lastCut];
    final limit = json[AntExpenseJsonKeys.limit];
    return AntSummary(
      total: Money.fromJson(json[AntExpenseJsonKeys.total]),
      count: json[AntExpenseJsonKeys.count] as int,
      days: json[AntExpenseJsonKeys.days] as int,
      dailyAverage: Money.fromJson(json[AntExpenseJsonKeys.dailyAverage]),
      byCategory: _shares(json[AntExpenseJsonKeys.byCategory]),
      periodStart: _optionalDate(json[AntExpenseJsonKeys.periodStart]),
      topCategory: _optionalCategory(json[AntExpenseJsonKeys.topCategory]),
      lastCut: lastCut == null ? null : _lastCut(_map(lastCut)),
      daysSinceLastCut: json[AntExpenseJsonKeys.daysSinceLastCut] as int?,
      limit: limit == null ? null : _limit(_map(limit)),
    );
  }

  static AntCut cut(JsonMap json) => AntCut(
        budgetId: json[AntExpenseJsonKeys.budgetId] as String,
        month: _month(json),
        cutAt: DateTime.parse(json[AntExpenseJsonKeys.cutAt] as String),
        periodStart:
            ApiDate.parse(json[AntExpenseJsonKeys.periodStart] as String),
        periodEnd: ApiDate.parse(json[AntExpenseJsonKeys.periodEnd] as String),
        total: Money.fromJson(json[AntExpenseJsonKeys.total]),
        count: json[AntExpenseJsonKeys.count] as int,
        byCategory: _shares(json[AntExpenseJsonKeys.byCategory]),
        topCategory: _optionalCategory(json[AntExpenseJsonKeys.topCategory]),
      );

  static AntTrendMonth trendMonth(JsonMap json) => AntTrendMonth(
        month: _month(json),
        total: Money.fromJson(json[AntExpenseJsonKeys.total]),
        count: json[AntExpenseJsonKeys.count] as int,
      );

  /// `monthlyLimit` of `GET` or `PUT /ant-expenses/limit`.
  static Money? monthlyLimit(JsonMap json) =>
      Money.fromOptionalJson(json[AntExpenseJsonKeys.monthlyLimit]);

  static List<AntCategoryShare> _shares(Object? json) => [
        for (final share in json! as List) _share(_map(share)),
      ];

  static AntCategoryShare _share(JsonMap json) => AntCategoryShare(
        category: category(json[AntExpenseJsonKeys.category]),
        total: Money.fromJson(json[AntExpenseJsonKeys.total]),
        count: json[AntExpenseJsonKeys.count] as int,
        percentage: (json[AntExpenseJsonKeys.percentage] as num).toDouble(),
      );

  static AntLastCut _lastCut(JsonMap json) => AntLastCut(
        budgetId: json[AntExpenseJsonKeys.budgetId] as String,
        month: _month(json),
        cutAt: DateTime.parse(json[AntExpenseJsonKeys.cutAt] as String),
      );

  static AntLimitUsage _limit(JsonMap json) => AntLimitUsage(
        monthlyLimit: Money.fromJson(json[AntExpenseJsonKeys.monthlyLimit]),
        usedPercentage:
            (json[AntExpenseJsonKeys.usedPercentage] as num).toDouble(),
        remaining: Money.fromJson(json[AntExpenseJsonKeys.remaining]),
      );

  static DateTime _month(JsonMap json) => DateTime(
        json[AntExpenseJsonKeys.year] as int,
        json[AntExpenseJsonKeys.month] as int,
      );

  static DateTime? _optionalDate(Object? json) =>
      json == null ? null : ApiDate.parse(json as String);

  static AntExpenseCategory? _optionalCategory(Object? json) =>
      json == null ? null : category(json);

  static JsonMap _map(Object? json) => Map<String, dynamic>.from(json! as Map);
}
