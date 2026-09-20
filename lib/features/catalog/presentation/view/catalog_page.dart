import 'dart:async';

import 'package:book_market/features/catalog/catalog.dart';
import 'package:book_market/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
            padding: const EdgeInsets.all(16),
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
    final currency = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    return RefreshIndicator(
      onRefresh: context.read<CatalogCubit>().load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.menu_book)),
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: Text(currency.format(book.price)),
            ),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}
