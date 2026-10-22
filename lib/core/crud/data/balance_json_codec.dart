import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// JSON shape of a balance item: `{id, name, <monthlyKey>, <balanceKey>}`,
/// plus the optional `<originalAmountKey>` for resources that track it.
/// Only the names of the amount fields change between resources, so one
/// codec serves all of them.
class BalanceJsonCodec<T extends BalanceItem>
    implements ItemJsonCodec<T, BalanceDraft> {
  const BalanceJsonCodec({
    required this.monthlyKey,
    required this.balanceKey,
    required this.build,
    this.originalAmountKey,
  });

  final String monthlyKey;
  final String balanceKey;

  /// Key of the optional original amount; null when it is not tracked.
  final String? originalAmountKey;

  /// Creates the entity with [id] from the parsed fields.
  final T Function(String id, BalanceDraft fields) build;

  @override
  T fromJson(JsonMap json) => build(
        json[ItemJsonKeys.id] as String,
        BalanceDraft(
          name: json[ItemJsonKeys.name] as String,
          monthlyAmount: Money.fromJson(json[monthlyKey]),
          balance: Money.fromJson(json[balanceKey]),
          originalAmount: _optionalAmount(json),
        ),
      );

  Money? _optionalAmount(JsonMap json) {
    final key = originalAmountKey;
    final value = key == null ? null : json[key];
    return value == null ? null : Money.fromJson(value);
  }

  @override
  JsonMap toJson(BalanceDraft draft) => {
        ItemJsonKeys.name: draft.name,
        monthlyKey: draft.monthlyAmount.toJson(),
        balanceKey: draft.balance.toJson(),
        if (originalAmountKey case final key?)
          key: draft.originalAmount?.toJson(),
      };
}
