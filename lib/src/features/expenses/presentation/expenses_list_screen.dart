import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../routing/routes.dart';

import '../../../common_widgets/month_selector.dart';
import '../../dashboard/presentation/dashboard_screen.dart'; // Import provider
import '../data/expenses_providers.dart';
import '../domain/category.dart';

class ExpensesListScreen extends ConsumerWidget {
  const ExpensesListScreen({
    super.key,
    this.initialCategory,
    this.filterType,
  });

  final String? initialCategory;
  final String? filterType;

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
          // Apply Filters
          var filteredExpenses = expenses;
          String? activeFilterLabel;

          if (initialCategory != null) {
            filteredExpenses = filteredExpenses.where((e) => e.category.name == initialCategory).toList();
            // Find display name
            try {
               final cat = Category.values.firstWhere((c) => c.name == initialCategory);
               activeFilterLabel = 'Kategori: ${cat.displayName}';
            } catch (_) {}
          } else if (filterType != null) {
            if (filterType == 'income') {
              filteredExpenses = filteredExpenses.where((e) => e.category == Category.income).toList();
              activeFilterLabel = 'Visar: Inkomster';
            } else if (filterType == 'expense') {
              filteredExpenses = filteredExpenses.where((e) => e.category != Category.income).toList();
              activeFilterLabel = 'Visar: Utgifter';
            }
          }

          if (filteredExpenses.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (activeFilterLabel != null) ...[
                  Chip(
                    label: Text(activeFilterLabel), 
                    onDeleted: () => const ExpensesListRoute().go(context),
                    deleteIcon: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text('Inga transaktioner matchar filtret'),
              ],
            );
          }
          
          final currency = NumberFormat.currency(locale: 'sv', symbol: 'kr', decimalDigits: 0);
          final dateFormat = DateFormat('d MMM', 'sv');

          return Column(
            children: [
              if (activeFilterLabel != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(activeFilterLabel), 
                    onDeleted: () => const ExpensesListRoute().go(context),
                    deleteIcon: const Icon(Icons.close),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredExpenses.length,
                  separatorBuilder: (c, i) => const Divider(height: 1, indent: 70),
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses[index];
                    final isIncome = expense.category == Category.income;
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
                      onTap: () => ExpenseDetailRoute(id: expense.id).go(context),
                    );
                  },
                ),
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
