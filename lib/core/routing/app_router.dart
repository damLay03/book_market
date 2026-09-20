import 'package:book_market/core/routing/app_routes.dart';
import 'package:book_market/core/theme/theme_cubit.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:book_market/features/counter/counter.dart';
import 'package:book_market/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  new(CatalogRepository catalogRepository)
    : router = GoRouter(
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => BlocProvider(
              create: (_) => CatalogCubit(catalogRepository),
              child: const CatalogPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.counter,
            name: 'counter',
            builder: (context, state) => const CounterPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const _SettingsPage(),
          ),
        ],
        errorBuilder: (context, state) =>
            _NotFoundPage(message: state.error?.toString()),
      );

  final GoRouter router;
}

class _SettingsPage extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.themeMode, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          BlocBuilder<ThemeCubit, AppThemeMode>(
            builder: (context, mode) => SegmentedButton<AppThemeMode>(
              segments: [
                ButtonSegment(
                  value: AppThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: AppThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: AppThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (selection) =>
                  context.read<ThemeCubit>().setThemeMode(selection.single),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const new({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pageNotFoundTitle)),
      body: Center(child: Text(message ?? l10n.pageNotFoundMessage)),
    );
  }
}
