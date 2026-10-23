import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// JSON shape of a balance item: `{id, name, <monthlyKey>, <balanceKey>}`.
/// Only the names of the amount fields change between resources, so one
/// codec serves all of them.
class BalanceJsonCodec<T extends BalanceItem>
    implements ItemJsonCodec<T, BalanceDraft> {
  const BalanceJsonCodec({
    required this.monthlyKey,
    required this.balanceKey,
    required this.build,
  });

  final String monthlyKey;
  final String balanceKey;

  /// Creates the entity with [id] from the parsed fields.
  final T Function(String id, BalanceDraft fields) build;

  @override
  T fromJson(JsonMap json) => build(
        json[ItemJsonKeys.id] as String,
        BalanceDraft(
          name: json[ItemJsonKeys.name] as String,
          monthlyAmount: Money.fromJson(json[monthlyKey]),
          balance: Money.fromJson(json[balanceKey]),
        ),
      );

  @override
  JsonMap toJson(BalanceDraft draft) => {
        ItemJsonKeys.name: draft.name,
        monthlyKey: draft.monthlyAmount.toJson(),
        balanceKey: draft.balance.toJson(),
      };
}
