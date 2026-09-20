import 'package:book_market/features/counter/counter.dart';
import 'package:book_market/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => CounterCubit(), child: const CounterView());
}

class CounterView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            tooltip: l10n.incrementTooltip,
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            tooltip: l10n.decrementTooltip,
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final count = context.select<CounterCubit, int>((cubit) => cubit.state);
    return Semantics(
      label: l10n.currentCount(count),
      child: Text('$count', style: theme.textTheme.displayLarge),
    );
  }
}
