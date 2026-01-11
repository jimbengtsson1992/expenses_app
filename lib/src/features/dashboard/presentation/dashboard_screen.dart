import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common_widgets/month_selector.dart';
import '../../expenses/data/expenses_providers.dart';
import '../../expenses/domain/category.dart';
import '../../expenses/domain/expense.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dashboard_screen.g.dart';

// State for selected month (Shared between Dashboard and List for consistency)
@riverpod
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() => DateTime.now();

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void nextMonth() {
    state = DateTime(state.year, state.month + 1);
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

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
        data: (expenses) => _DashboardContent(expenses: expenses),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.expenses});
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    // Calculate Totals
    double totalIncome = 0;
    double totalExpenses = 0;
    final categoryTotals = <Category, double>{};

    for (final e in expenses) {
      if (e.category == Category.income) {
        // Income is positive in CSV but logic calls it income.
        // Wait, repository inverted expenses to negative.
        // But for income... 
        // Lön is usually +Amount. Repo: "If amount > 0... return Category.income".
        // Repo code for Nordea: "amount = double.parse...". If file says 40000 -> 40000.
        // Repo code for SAS: Inverted.
        // So Income should be positive. Expense negative.
        
        // Wait, I need to check my Repo Logic again for Nordea.
        // Nordea: "2000,00" -> 2000.00.
        // "Expense" usually implies cost.
        // In this app, let's say:
        // Income = +
        // Expense = -
        
        if (e.amount > 0) {
           totalIncome += e.amount;
        } else {
           totalExpenses += e.amount.abs();
           
           // Category Totals (using abs)
           categoryTotals.update(e.category, (val) => val + e.amount.abs(), ifAbsent: () => e.amount.abs());
        }
      } else {
         // Non-income category
         if (e.amount < 0) {
            totalExpenses += e.amount.abs();
            categoryTotals.update(e.category, (val) => val + e.amount.abs(), ifAbsent: () => e.amount.abs());
         } else {
            // Refund? Treat as negative expense? Or Income?
            // "Refund to card" -> +Amount. Reduces expense.
            // Let's subtract from total expenses.
            totalExpenses -= e.amount;
            categoryTotals.update(e.category, (val) => val - e.amount, ifAbsent: () => -e.amount);
         }
      }
    }

    final netResult = totalIncome - totalExpenses;
    final isSaved = netResult >= 0;
    
    // Sort categories
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Formatter
    final currency = NumberFormat.currency(locale: 'sv', symbol: 'kr', decimalDigits: 0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Inkomst', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          currency.format(totalIncome),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Utgifter', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          currency.format(totalExpenses),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSaved ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${isSaved ? 'Sparat' : 'Överkonsumtion'} ${isSaved ? '+' : ''}${currency.format(netResult)}',
                    style: TextStyle(color: isSaved ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Utgifter per Kategori', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        
        // Category List
        ...sortedCategories.map((e) {
             final cat = e.key;
             final amount = e.value;
             final percentage = totalExpenses > 0 ? amount / totalExpenses : 0.0;
             
             return Padding(
               padding: const EdgeInsets.only(bottom: 16),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(color: Color(cat.colorValue).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                         child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                       ),
                       const SizedBox(width: 12),
                       Expanded(child: Text(cat.displayName, style: const TextStyle(fontWeight: FontWeight.w600))),
                       Text(currency.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                     ],
                   ),
                   const SizedBox(height: 8),
                   LinearProgressIndicator(
                     value: percentage,
                     backgroundColor: Colors.grey[800],
                     color: Color(cat.colorValue),
                     borderRadius: BorderRadius.circular(4),
                   ),
                 ],
               ),
             );
        }),
      ],
    );
  }
}
