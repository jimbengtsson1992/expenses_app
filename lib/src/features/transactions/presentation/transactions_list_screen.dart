import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../routing/routes.dart';

import '../../../common_widgets/month_selector.dart';
import '../../dashboard/presentation/dashboard_screen.dart'; // Import provider
import '../data/expenses_providers.dart';
import '../data/expenses_repository.dart';
import '../data/user_rules_repository.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';
import '../domain/transaction_type.dart';
import '../domain/account.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({
    super.key,
    this.initialCategory,
    this.filterType,
    this.initialAccount,
    this.initialExcludeFromOverview,
  });

  final Category? initialCategory;
  final TransactionType? filterType;
  final Account? initialAccount;
  final bool? initialExcludeFromOverview;

  @override
  ConsumerState<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends ConsumerState<TransactionsListScreen> {
  late TextEditingController _searchController;
  TransactionType? _filterType;
  Category? _filterCategory;
  Account? _filterAccount;
  bool? _filterExcludeFromOverview;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Initialize filters from widget params
    _filterCategory = widget.initialCategory;
    _filterType = widget.filterType;
    _filterAccount = widget.initialAccount;
    _filterExcludeFromOverview = widget.initialExcludeFromOverview;
  }

  @override
  void didUpdateWidget(TransactionsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory ||
        widget.filterType != oldWidget.filterType ||
        widget.initialAccount != oldWidget.initialAccount ||
        widget.initialExcludeFromOverview != oldWidget.initialExcludeFromOverview) {
      setState(() {
        _filterCategory = widget.initialCategory;
        _filterType = widget.filterType;
        _filterAccount = widget.initialAccount;
        _filterExcludeFromOverview = widget.initialExcludeFromOverview;
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
      _filterExcludeFromOverview = null;
    });
  }

  Future<void> _showRulesDialog() async {
    final repo = await ref.read(userRulesRepositoryProvider.future);
    final rules = repo.getAllRules(); // Map<String, (Category, Subcategory)>

    // Group by (Category, Subcategory)
    final grouped = <(Category, Subcategory), List<String>>{};
    for (final entry in rules.entries) {
      final key = entry.value;
      grouped.putIfAbsent(key, () => []).add(entry.key);
    }

    final buffer = StringBuffer();
    buffer.writeln('// Add this to CategorizationService.categorize logic\n');

    for (final entry in grouped.entries) {
      final cat = entry.key.$1;
      final sub = entry.key.$2;
      final keywords = entry.value.map((k) => "'${k.toLowerCase()}'").join(', ');

      buffer.writeln('// ${cat.displayName} - ${sub.displayName}');
      buffer.writeln("if (_matches(lowerDesc, [$keywords])) {");
      buffer.writeln("  return (Category.${cat.name}, Subcategory.${sub.name});");
      buffer.writeln("}");
      buffer.writeln(); // Empty line
    }

    final code = buffer.toString();

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportera Regler'),
        content: SingleChildScrollView(
          child: SelectableText(
            code.isEmpty ? '// Inga regler sparade än.' : code,
            style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
          ),
        ),
        actions: [
          if (code.isNotEmpty)
            TextButton(
              onPressed: () async {
                 // Close dialog first using DIALOG context
                 Navigator.of(ctx).pop(); 
                 
                 // Perform async work
                 await repo.clearAll(); 
                 
                 // Show feedback using WIDGET context if mounted
                 if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Regler raderade')));
                   ref.invalidate(expensesRepositoryProvider);
                 }
              },
              child: const Text('Rensa sparade', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
             onPressed: () => Navigator.of(ctx).pop(), 
             child: const Text('Stäng')
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              // Use main context for snackbar, dialog stays open or we can keep it open
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kopierat till urklipp')));
            },
            child: const Text('Kopiera Kod'),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Exportera Regler',
            onPressed: _showRulesDialog,
          ),
        ],
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

          // 5. Exclusion Filter
          if (_filterExcludeFromOverview != null) {
            filteredExpenses = filteredExpenses.where((e) => e.excludeFromOverview == _filterExcludeFromOverview).toList();
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
                          // Exclusion Filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: DropdownButton<bool?>(
                              value: _filterExcludeFromOverview,
                              hint: const Text('Översikt'),
                              underline: Container(),
                              items: const [
                                DropdownMenuItem(value: null, child: Text('Alla visas')),
                                DropdownMenuItem(value: false, child: Text('Inkluderade')),
                                DropdownMenuItem(value: true, child: Text('Exkluderade')),
                              ],
                              onChanged: (val) => setState(() => _filterExcludeFromOverview = val),
                            ),
                          ),
                          if (_filterType != null || _filterCategory != null || _filterAccount != null || _filterExcludeFromOverview != null)
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
                             if (expense.subcategory != Subcategory.unknown) ...[
                               const SizedBox(width: 8),
                               Text('• ${expense.subcategory.displayName}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                             ],
                             const SizedBox(width: 8),
                             Text('• ${expense.sourceAccount.displayName}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (expense.excludeFromOverview)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.visibility_off, size: 16, color: Colors.grey),
                              ),
                            Text(
                              amountStr,
                              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        onTap: () => ExpenseDetailRoute(id: expense.id).push(context),
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
