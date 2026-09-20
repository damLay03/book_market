import 'dart:async';

import 'package:book_market/core/theme/app_breakpoints.dart';
import 'package:book_market/core/theme/app_spacing.dart';
import 'package:book_market/features/catalog/catalog.dart';
import 'package:book_market/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogPage extends StatefulWidget {
  const new({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(context.read<CatalogCubit>().load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.catalogTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.catalogSearchHint,
              leading: const Icon(Icons.search),
              onSubmitted: (query) =>
                  unawaited(context.read<CatalogCubit>().load(query: query)),
              trailing: [
                IconButton(
                  tooltip: l10n.clearSearch,
                  onPressed: () {
                    _searchController.clear();
                    unawaited(context.read<CatalogCubit>().load());
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<CatalogCubit, CatalogState>(
              builder: (context, state) => switch (state) {
                CatalogInitial() || CatalogLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                CatalogSuccess(:final books) when books.isEmpty =>
                  _EmptyCatalog(
                    onReset: () {
                      _searchController.clear();
                      unawaited(context.read<CatalogCubit>().load());
                    },
                  ),
                CatalogSuccess(:final books) => _BookList(books: books),
                CatalogError(:final query) => _CatalogError(
                  onRetry: () => unawaited(
                    context.read<CatalogCubit>().load(query: query),
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  const new({required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<CatalogCubit>().load,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
              constraints.maxWidth < AppBreakpoints.compact
              ? AppSpacing.md
              : AppSpacing.lg;
          final padding = EdgeInsets.fromLTRB(
            horizontalPadding,
            0,
            horizontalPadding,
            AppSpacing.lg,
          );

          if (constraints.maxWidth < AppBreakpoints.compact) {
            return ListView.separated(
              padding: padding,
              itemCount: books.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) => BookCard(book: books[index]),
            );
          }

          return GridView.builder(
            padding: padding,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 440,
              mainAxisExtent: 112,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) => BookCard(book: books[index]),
          );
        },
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const new({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => _StatusView(
    icon: Icons.search_off,
    title: context.l10n.catalogEmptyTitle,
    message: context.l10n.catalogEmptyMessage,
    actionLabel: context.l10n.clearSearch,
    onAction: onReset,
  );
}

class _CatalogError extends StatelessWidget {
  const new({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _StatusView(
    icon: Icons.cloud_off,
    title: context.l10n.catalogErrorTitle,
    message: context.l10n.catalogErrorMessage,
    actionLabel: context.l10n.retry,
    onAction: onRetry,
  );
}

class _StatusView extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}
