import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/liabilities_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/net_worth_report_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/net_worth_screen.dart';

/// Screens of the net worth section, each with a fresh bloc that starts
/// loading as soon as the screen opens and closes with it.
abstract final class NetWorthPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.netWorth: (_) => BlocProvider<NetWorthBloc>(
          create: (_) =>
              getIt<NetWorthBloc>()..add(const NetWorthLoadRequested()),
          child: const NetWorthScreen(),
        ),
    AppRoute.netWorthAssets: (_) => BlocProvider<AssetBloc>(
          create: (_) => getIt<AssetBloc>()
            ..add(const CrudLoadRequested<CategorizedDraft<AssetCategory>>()),
          child: const AssetsScreen(),
        ),
    AppRoute.netWorthLiabilities: (_) => BlocProvider<LiabilityBloc>(
          create: (_) => getIt<LiabilityBloc>()
            ..add(
              const CrudLoadRequested<CategorizedDraft<LiabilityCategory>>(),
            ),
          child: const LiabilitiesScreen(),
        ),
    AppRoute.netWorthReport: (_) => BlocProvider<NetWorthReportBloc>(
          create: (_) => getIt<NetWorthReportBloc>()
            ..add(const NetWorthReportLoadRequested()),
          child: const NetWorthReportScreen(),
        ),
  };
}
