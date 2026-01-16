import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common_widgets/month_selector.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_type.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../routing/routes.dart';

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
  final List<Transaction> expenses;

  @override
  Widget build(BuildContext context) {
    // Calculate Totals
    double totalIncome = 0;
    double totalExpenses = 0;

    final categoryTotals = <Category, double>{};
    final incomeCategoryTotals = <Category, double>{};
    
    // Map<Category, Map<Subcategory, double>>
    final subcategoryTotals = <Category, Map<Subcategory, double>>{};

    for (final e in expenses) {
      if (e.excludeFromOverview) continue;

      if (e.type == TransactionType.income) {
        totalIncome += e.amount.abs();
        incomeCategoryTotals.update(e.category, (val) => val + e.amount.abs(), ifAbsent: () => e.amount.abs());
      } else {
        // Expense transaction
        totalExpenses += e.amount.abs();
        categoryTotals.update(e.category, (val) => val + e.amount.abs(), ifAbsent: () => e.amount.abs());
      }

      // Subcategory totals (Applicable for both Income and Expenses)
      if (!subcategoryTotals.containsKey(e.category)) {
        subcategoryTotals[e.category] = {};
      }
      subcategoryTotals[e.category]!.update(e.subcategory, (val) => val + e.amount.abs(), ifAbsent: () => e.amount.abs());
    }

    final netResult = totalIncome - totalExpenses;
    final isSaved = netResult >= 0;
    
    // Sort categories
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedIncomeCategories = incomeCategoryTotals.entries.toList()
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
                    InkWell(
                      onTap: () => const TransactionsListRoute(filterType: TransactionType.income).go(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
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
                      ),
                    ),
                    InkWell(
                      onTap: () => const TransactionsListRoute(filterType: TransactionType.expense).go(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Utgifter', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(totalExpenses),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSaved ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
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
             final subs = subcategoryTotals[cat] ?? {};
             
             // Sort subs by amount
             final sortedSubs = subs.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

             return Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: Card( // Use Card for elevation and shape
                 elevation: 2, // Slight elevation
                 margin: EdgeInsets.zero,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 child: Theme(
                   data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Hide ExpansionTile border
                   child: ExpansionTile(
                     tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     leading: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(color: Color(cat.colorValue).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                         child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                     ),
                     title: Row(
                       children: [
                         Expanded(child: Text(cat.displayName, style: const TextStyle(fontWeight: FontWeight.w600))),
                         Text(currency.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                       ],
                     ),
                     subtitle: Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child: LinearProgressIndicator(
                         value: percentage,
                         backgroundColor: Colors.grey[800],
                         color: Color(cat.colorValue),
                         borderRadius: BorderRadius.circular(4),
                       ),
                     ),
                     children: [
                       if (sortedSubs.isNotEmpty)
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           child: Column(
                             children: sortedSubs.map((subEntry) {
                               final subData = subEntry.key;
                               final subAmount = subEntry.value;
                               final subName = subData.displayName;
                               
                               return Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 4),
                                 child: Row(
                                   children: [
                                     const SizedBox(width: 48), // Indent to align text
                                     Expanded(child: Text(subName, style: TextStyle(color: Colors.grey[400], fontSize: 13))),
                                     Text(currency.format(subAmount), style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                   ],
                                 ),
                               );
                             }).toList(),
                           ),
                         ),
                       // Link to list
                       TextButton(
                         onPressed: () => TransactionsListRoute(category: cat).go(context),
                         child: const Text('Visa alla transaktioner'),
                       ),
                     ],
                   ),
                 ),
               ),
             );
        }),
        const SizedBox(height: 24),

        if (sortedIncomeCategories.isNotEmpty) ...[
          Text('Inkomster per Kategori', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
           ...sortedIncomeCategories.map((e) {
             final cat = e.key;
             final amount = e.value;
             final percentage = totalIncome > 0 ? amount / totalIncome : 0.0;
             final subs = subcategoryTotals[cat] ?? {};
             
             // Sort subs by amount
             final sortedSubs = subs.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

             return Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: Card(
                 elevation: 2,
                 margin: EdgeInsets.zero,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 child: Theme(
                   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                   child: ExpansionTile(
                     tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     leading: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(color: Color(cat.colorValue).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                         child: Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                     ),
                     title: Row(
                       children: [
                         Expanded(child: Text(cat.displayName, style: const TextStyle(fontWeight: FontWeight.w600))),
                         Text(currency.format(amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                       ],
                     ),
                     subtitle: Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child: LinearProgressIndicator(
                         value: percentage,
                         backgroundColor: Colors.grey[800],
                         color: Color(cat.colorValue),
                         borderRadius: BorderRadius.circular(4),
                       ),
                     ),
                     children: [
                       if (sortedSubs.isNotEmpty)
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           child: Column(
                             children: sortedSubs.map((subEntry) {
                               final subData = subEntry.key;
                               final subAmount = subEntry.value;
                               final subName = subData.displayName;
                               
                               return Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 4),
                                 child: Row(
                                   children: [
                                     const SizedBox(width: 48), // Indent to align text
                                     Expanded(child: Text(subName, style: TextStyle(color: Colors.grey[400], fontSize: 13))),
                                     Text(currency.format(subAmount), style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                                   ],
                                 ),
                               );
                             }).toList(),
                           ),
                         ),
                       // Link to list
                       TextButton(
                         onPressed: () => TransactionsListRoute(category: cat).go(context),
                         child: const Text('Visa alla transaktioner'),
                       ),
                     ],
                   ),
                 ),
               ),
             );
          }),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
