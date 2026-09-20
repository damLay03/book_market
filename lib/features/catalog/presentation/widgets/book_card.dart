import 'package:book_market/core/theme/app_spacing.dart';
import 'package:book_market/features/catalog/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookCard extends StatelessWidget {
  const new({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toLanguageTag(),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: const SizedBox.square(
                dimension: 56,
                child: Icon(Icons.menu_book),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              currency.format(book.price),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
