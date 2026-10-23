import 'package:bloc_test/bloc_test.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'net_worth_mocks.dart';

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

MockDashboardBloc registerDashboardBloc(
  DashboardState state, {
  Stream<DashboardState> stream = const Stream.empty(),
}) =>
    registerBloc<DashboardBloc, DashboardState>(
      MockDashboardBloc(),
      state,
      stream: stream,
    ) as MockDashboardBloc;
