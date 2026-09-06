import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../routing/routes.dart';
import '../../trips/domain/trip.dart';
import '../domain/subcategory.dart';
import '../domain/transaction.dart';
import '../domain/transaction_type.dart';

/// A single transaction row, shared by the transactions list and trip cards.
///
/// Tapping opens the transaction detail screen. Set [showTrip] to false when
/// the surrounding context already identifies the trip (e.g. inside a
/// [TripCard]). Set [unsignedAmount] to show expenses as positive numbers,
/// matching a card whose total is already presented as net spend.
class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
    this.showTrip = true,
    this.unsignedAmount = false,
  });

  final Transaction transaction;
  final bool showTrip;
  final bool unsignedAmount;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'sv',
      symbol: 'kr',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMM', 'sv');

    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.white;
    final trip = showTrip ? tripById(transaction.tripId) : null;
    final amount = unsignedAmount
        ? transaction.amount.abs()
        : transaction.amount;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(transaction.category.colorValue).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          transaction.category.emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      title: Text(
        transaction.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(dateFormat.format(transaction.date)),
          if (transaction.subcategory != Subcategory.unknown) ...[
            const SizedBox(width: 8),
            Text(
              '• ${transaction.subcategory.displayName}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          if (trip != null) ...[
            const SizedBox(width: 8),
            Text(
              '• ${trip.emoji} ${trip.name}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(width: 8),
          Text(
            '• ${transaction.sourceAccount.displayName}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (transaction.excludeFromOverview)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.visibility_off, size: 16, color: Colors.grey),
            ),
          Text(
            currency.format(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      onTap: () => ExpenseDetailRoute(id: transaction.id).push(context),
    );
  }
}
