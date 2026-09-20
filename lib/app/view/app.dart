import 'package:book_market/core/config/app_config.dart';
import 'package:book_market/core/config/app_flavor.dart';
import 'package:book_market/core/routing/app_router.dart';
import 'package:book_market/core/theme/app_theme.dart';
import 'package:book_market/core/theme/theme_cubit.dart';
import 'package:book_market/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const new({
    required this.config,
    required this.appRouter,
    required this.themeCubit,
    super.key,
  });

  final AppConfig config;
  final AppRouter appRouter;
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: themeCubit,
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) => MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: !config.flavor.isProduction,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: switch (themeMode) {
            AppThemeMode.system => ThemeMode.system,
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
