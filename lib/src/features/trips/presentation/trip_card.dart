import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../routing/routes.dart';
import '../application/trip_providers.dart';
import '../domain/trip.dart';

/// Dashboard card showing a trip's total cost across all months,
/// independent of the selected period.
class TripCard extends ConsumerWidget {
  const TripCard({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(tripTransactionsProvider(trip.id));

    return transactionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (transactions) {
        final currency = NumberFormat.currency(
          locale: 'sv',
          symbol: 'kr',
          decimalDigits: 0,
        );
        final dateFormat = DateFormat('d MMM', 'sv');
        // Net spend: expenses are negative amounts, so a refund subtracts
        final total = transactions.fold<double>(0, (sum, t) => sum - t.amount);

        return Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(trip.emoji, style: const TextStyle(fontSize: 20)),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${trip.name} (${transactions.length})',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    currency.format(total),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: const Text(
                'Totalt, alla månader',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              children: [
                if (transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Text(
                      'Inga transaktioner taggade ännu. Tagga via en transaktions detaljvy.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ...transactions.map(
                  (t) => ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 24, right: 16),
                    title: Text(
                      t.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(dateFormat.format(t.date)),
                    trailing: Text(
                      currency.format(t.amount),
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () => ExpenseDetailRoute(id: t.id).push(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
