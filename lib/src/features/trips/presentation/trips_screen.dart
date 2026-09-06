import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/data/expenses_providers.dart';
import '../application/trip_providers.dart';
import '../domain/trip.dart';
import 'trip_card.dart';

/// Lists every trip in [allTrips] with its total across all months.
class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resor'), centerTitle: true),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (all) {
          final groups = groupByTrip(all);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final trip in allTrips)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TripCard(
                    trip: trip,
                    transactions: groups[trip.id] ?? const [],
                    subtitle: 'Totalt, alla månader',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
