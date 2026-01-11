import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/month_selector.dart';
import '../../dashboard/presentation/dashboard_screen.dart'; // Import provider
import '../data/expenses_providers.dart';
import '../domain/category.dart';

class ExpensesListScreen extends ConsumerWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);
    final expensesAsync = ref.watch(expensesForMonthProvider(currentDate));

    return Scaffold(
      appBar: AppBar(
        title: MonthSelector(
          currentDate: currentDate,
          onPrevious: () => ref.read(currentDateProvider.notifier).previousMonth(),
          onNext: () => ref.read(currentDateProvider.notifier).nextMonth(),
        ),
        centerTitle: true,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('Inga transaktioner denna månad'));
          }
          
          final currency = NumberFormat.currency(locale: 'sv', symbol: 'kr', decimalDigits: 0);
          final dateFormat = DateFormat('d MMM', 'sv');

          return ListView.separated(
            itemCount: expenses.length,
            separatorBuilder: (c, i) => const Divider(height: 1, indent: 70),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final isIncome = expense.category == Category.income;
              // Display logic: Expense amounts are negative in model (-120). 
              // We want to show them as "-120 kr".
              // Income is positive.
              final amountStr = currency.format(expense.amount);
              final color = isIncome ? Colors.green : Colors.white;

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(expense.category.colorValue).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(expense.category.emoji, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(expense.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(dateFormat.format(expense.date)),
                trailing: Text(
                  amountStr,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () => context.go('/expenses/detail/${expense.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
