import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/presentation/transaction_list_tile.dart';
import '../domain/trip.dart';

/// Expandable card showing a trip's net spend for the given [transactions].
///
/// Pure widget: the caller decides the scope (selected period on the
/// dashboard, all months on the trips tab) and describes it via [subtitle].
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.transactions,
    required this.subtitle,
  });

  final Trip trip;
  final List<Transaction> transactions;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'sv',
      symbol: 'kr',
      decimalDigits: 0,
    );
    // Net spend: expenses are negative amounts, so a refund subtracts
    final total = transactions.fold<double>(0, (sum, t) => sum - t.amount);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
              (t) => TransactionListTile(
                transaction: t,
                showTrip: false,
                unsignedAmount: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
