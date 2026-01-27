import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetResultBadge extends StatelessWidget {
  const NetResultBadge({super.key, required this.netResult});

  final double netResult;

  @override
  Widget build(BuildContext context) {
    final isSaved = netResult >= 0;
    final currency = NumberFormat.currency(
      locale: 'sv',
      symbol: 'kr',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSaved
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${isSaved ? 'Sparat' : 'Överkonsumtion'} ${isSaved ? '+' : ''}${currency.format(netResult)}',
        style: TextStyle(
          color: isSaved ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
