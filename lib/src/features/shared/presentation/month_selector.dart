import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../dashboard/application/current_date_provider.dart';

class MonthSelector extends ConsumerWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current date
    final currentDate = ref.watch(currentDateProvider);
    final notifier = ref.read(currentDateProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => notifier.previousMonth(),
          icon: const Icon(Icons.chevron_left),
        ),
        SizedBox(
          width: 100,
          child: Text(
            DateFormat('MMM yy', 'sv').format(currentDate),
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () => notifier.nextMonth(),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
