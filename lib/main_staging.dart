import 'package:book_market/app/app.dart';
import 'package:book_market/bootstrap.dart';
import 'package:book_market/core/config/app_config.dart';
import 'package:book_market/core/config/app_flavor.dart';
import 'package:book_market/core/di/injection.dart';
import 'package:book_market/core/routing/app_router.dart';
import 'package:book_market/core/theme/theme_cubit.dart';

Future<void> main() async {
  final config = AppConfig.fromFlavor(AppFlavor.staging);
  await bootstrap(
    config: config,
    builder: () => App(
      config: config,
      appRouter: getIt<AppRouter>(),
      themeCubit: getIt<ThemeCubit>(),
    ),
  );
}
