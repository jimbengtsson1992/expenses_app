import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../routing/routes.dart';

import '../../../common_widgets/month_selector.dart';
import '../../dashboard/presentation/dashboard_screen.dart'; // Import provider
import '../data/expenses_providers.dart';
import '../domain/category.dart';
import '../domain/transaction_type.dart';
import '../domain/account.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({
    super.key,
    this.initialCategory,
    this.filterType,
    this.initialAccount,
  });

  final Category? initialCategory;
  final TransactionType? filterType;
  final Account? initialAccount;

  @override
  ConsumerState<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends ConsumerState<TransactionsListScreen> {
  late TextEditingController _searchController;
  TransactionType? _filterType;
  Category? _filterCategory;
  Account? _filterAccount;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Initialize filters from widget params
    _filterCategory = widget.initialCategory;
    _filterType = widget.filterType;
    _filterAccount = widget.initialAccount;
  }

  @override
  void didUpdateWidget(TransactionsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory ||
        widget.filterType != oldWidget.filterType ||
        widget.initialAccount != oldWidget.initialAccount) {
      setState(() {
        _filterCategory = widget.initialCategory;
        _filterType = widget.filterType;
        _filterAccount = widget.initialAccount;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _filterType = null;
      _filterCategory = null;
      _filterAccount = null;
    });
    // Also clear query params by navigating to base route? 
    // Or just let local state override? 
    // For now, local state override is fine, but maybe we should update URL?
    // Simplified: Just reset state.
  }

  @override
  Widget build(BuildContext context) {
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
          // --- Filter Logic ---
          var filteredExpenses = expenses;

          // 1. Search (Description)
          final searchText = _searchController.text.toLowerCase();
          if (searchText.isNotEmpty) {
            filteredExpenses = filteredExpenses.where((e) => e.description.toLowerCase().contains(searchText)).toList();
          }

          // 2. Type Filter
          if (_filterType != null) {
            filteredExpenses = filteredExpenses.where((e) => e.type == _filterType).toList();
          }

          // 3. Category Filter
          if (_filterCategory != null) {
            filteredExpenses = filteredExpenses.where((e) => e.category == _filterCategory).toList();
          }

          // 4. Account Filter
          if (_filterAccount != null) {
            filteredExpenses = filteredExpenses.where((e) => e.sourceAccount == _filterAccount).toList();
          }

          final currency = NumberFormat.currency(locale: 'sv', symbol: 'kr', decimalDigits: 0);
          final dateFormat = DateFormat('d MMM', 'sv');

          return Column(
            children: [
              // --- Build Filter UI ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Sök...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty 
                          ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchController.clear())) 
                          : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Type Filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: DropdownButton<TransactionType?>(
                              value: _filterType,
                              hint: const Text('Typ'),
                              underline: Container(),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('Alla typer')),
                                DropdownMenuItem(value: TransactionType.income, child: Text('Inkomst')),
                                DropdownMenuItem(value: TransactionType.expense, child: Text('Utgift')),
                              ],
                              onChanged: (val) => setState(() => _filterType = val),
                            ),
                          ),
                          // Category Filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: DropdownButton<Category?>(
                              value: _filterCategory,
                              hint: const Text('Kategori'),
                              underline: Container(),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('Alla kategorier')),
                                ...Category.values.map((c) => DropdownMenuItem(
                                  value: c, 
                                  child: Text('${c.emoji} ${c.displayName}'),
                                )),
                              ],
                              onChanged: (val) => setState(() => _filterCategory = val),
                            ),
                          ),
                           // Account Filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: DropdownButton<Account?>(
                              value: _filterAccount,
                              hint: const Text('Konto'),
                              underline: Container(),
                              items: [
                                const DropdownMenuItem(value: null, child: Text('Alla konton')),
                                ...Account.values.map((a) => DropdownMenuItem(
                                  value: a, 
                                  child: Text(a.displayName),
                                )),
                              ],
                              onChanged: (val) => setState(() => _filterAccount = val),
                            ),
                          ),
                          if (_filterType != null || _filterCategory != null || _filterAccount != null)
                             TextButton(onPressed: _clearFilters, child: const Text('Rensa')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (filteredExpenses.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Inga transaktioner matchar filtret'),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredExpenses.length,
                    separatorBuilder: (c, i) => const Divider(height: 1, indent: 70),
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      final isIncome = expense.type == TransactionType.income;
                      final amountStr = currency.format(expense.amount);
                      final color = isIncome ? Colors.green : Colors.white; // Is dark mode default? Assuming user wants clean UI.

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(expense.category.colorValue).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(expense.category.emoji, style: const TextStyle(fontSize: 24)),
                        ),
                        title: Text(expense.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Row(
                          children: [
                             Text(dateFormat.format(expense.date)),
                             const SizedBox(width: 8),
                             Text('• ${expense.sourceAccount.displayName}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
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
