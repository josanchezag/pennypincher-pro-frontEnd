import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';

/// Screens of the net worth section, each with a fresh bloc that starts
/// loading as soon as the screen opens and closes with it.
abstract final class NetWorthPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.netWorthAssets: (_) => BlocProvider<AssetBloc>(
          create: (_) =>
              getIt<AssetBloc>()..add(const CrudLoadRequested<AssetCategory>()),
          child: const AssetsScreen(),
        ),
  };
}
