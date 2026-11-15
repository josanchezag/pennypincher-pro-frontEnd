import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/time/api_date.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/snapshot_ant_cut_entity.dart';

/// Keys of the `antExpenseCut` object of the snapshot response.
abstract final class SnapshotAntCutJsonKeys {
  static const String antExpenseCut = 'antExpenseCut';
  static const String status = 'status';
  static const String month = 'month';
  static const String budgetId = 'budgetId';
  static const String itemsTaken = 'itemsTaken';
  static const String amountTaken = 'amountTaken';
  static const String antExpenseTotal = 'antExpenseTotal';
}

/// Reads the ant expense cut of a `POST /net-worth/snapshots` response.
///
/// The snapshot is already saved when the response arrives, so its
/// report never fails: a response without `antExpenseCut` (a backend
/// that does not send it yet), with `null`, with an unknown status or an
/// unexpected shape gives `null`, and the plain confirmation is shown.
abstract final class SnapshotAntCutJson {
  /// The cut in the `data` object of [body], or `null`.
  static SnapshotAntCut? fromResponse(Object? body) {
    final data = body is Map ? body[ApiEnvelopeKeys.data] : null;
    final cut = data is Map ? data[SnapshotAntCutJsonKeys.antExpenseCut] : null;
    if (cut is! Map) {
      return null;
    }
    try {
      return fromJson(Map<String, dynamic>.from(cut));
    } on TypeError {
      return null;
    } on FormatException {
      return null;
    }
  }

  /// Parses one `antExpenseCut` object; `null` for an unknown status.
  /// Throws [TypeError] or [FormatException] on an unexpected shape.
  static SnapshotAntCut? fromJson(JsonMap json) {
    final status = _status(json[SnapshotAntCutJsonKeys.status]);
    if (status == null) {
      return null;
    }
    return SnapshotAntCut(
      status: status,
      month:
          ApiDate.parse('${json[SnapshotAntCutJsonKeys.month] as String}-01'),
      budgetId: json[SnapshotAntCutJsonKeys.budgetId] as String?,
      itemsTaken:
          (json[SnapshotAntCutJsonKeys.itemsTaken] as num?)?.toInt() ?? 0,
      amountTaken:
          Money.fromOptionalJson(json[SnapshotAntCutJsonKeys.amountTaken]) ??
              Money.zero,
      antExpenseTotal:
          Money.fromOptionalJson(json[SnapshotAntCutJsonKeys.antExpenseTotal]),
    );
  }

  static SnapshotAntCutStatus? _status(Object? json) {
    if (json is! String) {
      throw FormatException('Invalid ant expense cut status', json);
    }
    for (final status in SnapshotAntCutStatus.values) {
      if (ApiEnum.nameOf(status) == json) {
        return status;
      }
    }
    return null;
  }
}
