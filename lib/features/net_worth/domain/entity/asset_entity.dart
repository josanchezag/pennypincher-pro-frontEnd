import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'asset_entity.freezed.dart';

/// Kinds of things the user owns.
enum AssetCategory {
  realEstate,
  vehicle,
  business,
  cash,
  savings,
  equipment,
  other
}

/// Something the user owns, at its current estimated market value.
@freezed
class Asset with _$Asset implements CategorizedItem<AssetCategory> {
  const factory Asset({
    required String id,
    required String name,
    required Money value,
    required AssetCategory category,
  }) = _Asset;

  const Asset._();

  @override
  Money get amount => value;
}
