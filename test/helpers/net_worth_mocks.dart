import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';

class MockAssetBloc extends MockBloc<CrudEvent<AssetCategory>, CrudState<Asset>>
    implements AssetBloc {}

/// Registers an [AssetBloc] double in the service locator, as the route
/// builders read it from there, staying in [state] and then emitting
/// [stream]. The locator is reset after the test.
MockAssetBloc registerAssetBloc(
  CrudState<Asset> state, {
  Stream<CrudState<Asset>> stream = const Stream.empty(),
}) {
  final bloc = MockAssetBloc();
  whenListen(bloc, stream, initialState: state);
  getIt.registerFactory<AssetBloc>(() => bloc);
  addTearDown(getIt.reset);
  return bloc;
}
