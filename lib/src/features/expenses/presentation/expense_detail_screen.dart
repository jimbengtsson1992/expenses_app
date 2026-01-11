import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/expenses_providers.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({super.key, required this.expenseId});
  final String expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseByIdProvider(expenseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaktionsdetaljer')),
      body: expenseAsync.when(
        data: (expense) {
          if (expense == null) return const Center(child: Text('Transaktion hittades inte'));

          final currency = NumberFormat.currency(locale: 'sv', symbol: 'kr');
          final dateFormat = DateFormat('d MMMM yyyy', 'sv');

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Amount Header
              Center(
                child: Text(
                  currency.format(expense.amount),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: expense.amount < 0 ? Colors.white : Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  expense.description,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text(dateFormat.format(expense.date))),
              
              const SizedBox(height: 48),

              // Category Field
              _DetailRow(
                label: 'Kategori',
                content: Row(
                  children: [
                    Text(expense.category.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(expense.category.displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.blue)), // TODO: Implement edit
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Source Account Field (Highlighted as requested)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Konto', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.credit_card, size: 20, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(expense.sourceAccount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Raw Data (Debug/Extra info)
              ExpansionTile(
                title: const Text('Original Fil', style: TextStyle(fontSize: 14)),
                children: [
                  ListTile(title: Text(expense.sourceFilename)),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.content});
  final String label;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: content,
        ),
      ],
    );
  }
}
