import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';

class MockAssetBloc extends MockBloc<CrudEvent<CategorizedDraft<AssetCategory>>,
    CrudState<Asset>> implements AssetBloc {}

class MockLiabilityBloc extends MockBloc<
    CrudEvent<CategorizedDraft<LiabilityCategory>>,
    CrudState<Liability>> implements LiabilityBloc {}

class MockNetWorthBloc extends MockBloc<NetWorthEvent, NetWorthState>
    implements NetWorthBloc {}

class MockNetWorthReportBloc
    extends MockBloc<NetWorthReportEvent, NetWorthReportState>
    implements NetWorthReportBloc {}

/// Registers [bloc] in the service locator, where the route builders read
/// it from, staying in [state] and then emitting [stream]. The locator is
/// reset after the test.
B registerBloc<B extends BlocBase<S>, S>(
  B bloc,
  S state, {
  Stream<S> stream = const Stream.empty(),
}) {
  whenListen(bloc, stream, initialState: state);
  getIt.registerFactory<B>(() => bloc);
  addTearDown(getIt.reset);
  return bloc;
}

MockAssetBloc registerAssetBloc(
  CrudState<Asset> state, {
  Stream<CrudState<Asset>> stream = const Stream.empty(),
}) =>
    registerBloc<AssetBloc, CrudState<Asset>>(
      MockAssetBloc(),
      state,
      stream: stream,
    ) as MockAssetBloc;

MockLiabilityBloc registerLiabilityBloc(
  CrudState<Liability> state, {
  Stream<CrudState<Liability>> stream = const Stream.empty(),
}) =>
    registerBloc<LiabilityBloc, CrudState<Liability>>(
      MockLiabilityBloc(),
      state,
      stream: stream,
    ) as MockLiabilityBloc;

MockNetWorthBloc registerNetWorthBloc(
  NetWorthState state, {
  Stream<NetWorthState> stream = const Stream.empty(),
}) =>
    registerBloc<NetWorthBloc, NetWorthState>(
      MockNetWorthBloc(),
      state,
      stream: stream,
    ) as MockNetWorthBloc;

MockNetWorthReportBloc registerNetWorthReportBloc(
  NetWorthReportState state, {
  Stream<NetWorthReportState> stream = const Stream.empty(),
}) =>
    registerBloc<NetWorthReportBloc, NetWorthReportState>(
      MockNetWorthReportBloc(),
      state,
      stream: stream,
    ) as MockNetWorthReportBloc;
