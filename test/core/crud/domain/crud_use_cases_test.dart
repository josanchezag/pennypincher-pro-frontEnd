import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';

import '../../../helpers/net_worth_fixtures.dart';

class _MockAssetRepository extends Mock implements AssetRepository {}

void main() {
  late _MockAssetRepository repository;
  final draft = CategorizedDraft(
    name: car.name,
    amount: car.value,
    category: car.category,
  );

  setUp(() => repository = _MockAssetRepository());

  test('GetItems loads every item', () async {
    when(repository.getAll).thenAnswer((_) async => const Right([car]));

    final result =
        await GetItems<Asset, CategorizedDraft<AssetCategory>>(repository)();

    expect(result.getOrElse(() => []), [car]);
  });

  test('SaveItem creates without an id and updates with one', () async {
    when(() => repository.create(draft))
        .thenAnswer((_) async => const Right(car));
    when(() => repository.update('a2', draft))
        .thenAnswer((_) async => const Right(car));
    final save = SaveItem<Asset, CategorizedDraft<AssetCategory>>(repository);

    await save(draft);
    await save(draft, id: 'a2');

    verify(() => repository.create(draft)).called(1);
    verify(() => repository.update('a2', draft)).called(1);
  });

  test('DeleteItem removes the item', () async {
    when(() => repository.delete('a2'))
        .thenAnswer((_) async => const Right(unit));

    final result = await DeleteItem<Asset, CategorizedDraft<AssetCategory>>(
      repository,
    )('a2');

    expect(result, const Right<Object, Unit>(unit));
  });
}
