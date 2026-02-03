import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../dashboard/application/date_period_provider.dart';
import '../../dashboard/domain/date_period.dart';

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPeriod = ref.watch(datePeriodProvider);
    final notifier = ref.read(datePeriodProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => notifier.previous(),
              icon: const Icon(Icons.chevron_left),
            ),
            GestureDetector(
                onTap: () => notifier.toggleMode(),
                child: SizedBox(
                width: 120,
                child: Column(
                  children: [
                    Text(
                      _formatPeriod(currentPeriod),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                     Text(
                      currentPeriod.map(month: (_) => 'Tryck för år', year: (_) => 'Tryck för månad'),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () => notifier.next(),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }

  String _formatPeriod(DatePeriod period) {
    return period.map(
      month: (p) => DateFormat('MMM yyyy', 'sv').format(DateTime(p.year, p.month)),
      year: (p) => p.year.toString(),
    );
  }
}
