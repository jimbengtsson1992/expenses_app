import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common_widgets/net_result_badge.dart';
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
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  late TextEditingController _searchController;
  TransactionType? _filterType;
  Category? _filterCategory;
  Account? _filterAccount;
  bool? _filterExcludeFromOverview;
  Set<Subcategory> _filterSubcategories = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Initialize filters from widget params
    _filterCategory = widget.initialCategory;
    _filterType = widget.filterType;
    _filterAccount = widget.initialAccount;
    // Default to 'Included' (false) if not specified
    _filterExcludeFromOverview = widget.initialExcludeFromOverview ?? false;

    if (_filterCategory != null) {
      _filterSubcategories = _filterCategory!.subcategories.toSet();
    }
  }

  @override
  void didUpdateWidget(TransactionsListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != oldWidget.initialCategory ||
        widget.filterType != oldWidget.filterType ||
        widget.initialAccount != oldWidget.initialAccount ||
        widget.initialExcludeFromOverview !=
            oldWidget.initialExcludeFromOverview) {
      setState(() {
        _filterCategory = widget.initialCategory;
        _filterType = widget.filterType;
        _filterAccount = widget.initialAccount;
        // Default to 'Included' (false) if not specified
        _filterExcludeFromOverview = widget.initialExcludeFromOverview ?? false;
        if (_filterCategory != null) {
          _filterSubcategories = _filterCategory!.subcategories.toSet();
        } else {
          _filterSubcategories.clear();
        }
      });
    }
  }

  void _onCategoryChanged(Category? category) {
    setState(() {
      _filterCategory = category;
      if (category != null) {
        _filterSubcategories = category.subcategories.toSet();
      } else {
        _filterSubcategories.clear();
      }
    });
  }

  void _toggleSubcategory(Subcategory sub) {
    setState(() {
      if (_filterSubcategories.contains(sub)) {
        _filterSubcategories.remove(sub);
      } else {
        _filterSubcategories.add(sub);
      }
    });
  }

  void _selectAllSubcategories() {
    if (_filterCategory == null) return;
    setState(() {
      _filterSubcategories = _filterCategory!.subcategories.toSet();
    });
  }

  void _deselectAllSubcategories() {
    setState(() {
      _filterSubcategories.clear();
    });
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
      _filterSubcategories.clear();
    });
  }

  Future<void> _showRulesDialog() async {
    final rulesRepo = await ref.read(userRulesRepositoryProvider.future);
    final rules = rulesRepo.getAllRules();
    final overrides = rulesRepo.getAllOverrides();

    // Fetch all transactions to look up details/CSV data for overrides
    // This ensures we have the data even if it's not in the current month view
    final allExpenses = await ref
        .read(expensesRepositoryProvider)
        .getExpenses();
    final expenseMap = {for (final e in allExpenses) e.id: e};

    final buffer = StringBuffer();
    buffer.writeln(
      'Please update the categorization logic with the following changes.',
    );
    buffer.writeln(
      'IMPORTANT: Create tests for any new or changed logic to prevent regressions.\n',
    );

    // 1. General Rules
    if (rules.isNotEmpty) {
      buffer.writeln('### General Logic (Keywords)');
      // Group by (Category, Subcategory)
      final groupedRules = <(Category, Subcategory), List<String>>{};
      for (final entry in rules.entries) {
        groupedRules.putIfAbsent(entry.value, () => []).add(entry.key);
      }

      for (final entry in groupedRules.entries) {
        final cat = entry.key.$1;
        final sub = entry.key.$2;
        final keywords = entry.value.map((k) => "'$k'").join(', ');
        buffer.writeln(
          '- Assign **Category.${cat.name}** / **Subcategory.${sub.name}** if description contains: $keywords',
        );
      }
      buffer.writeln();
    }

    // 2. Overrides
    if (overrides.isNotEmpty) {
      buffer.writeln('### Specific Exceptions (Overrides)');
      for (final entry in overrides.entries) {
        final id = entry.key;
        final cat = entry.value.$1;
        final sub = entry.value.$2;

        final expense = expenseMap[id];

        if (expense != null && expense.rawCsvData != null) {
          buffer.writeln('- For CSV Row: `${expense.rawCsvData}`');
          buffer.writeln(
            '  -> Assign **Category.${cat.name}** / **Subcategory.${sub.name}**',
          );
        } else if (expense != null) {
          buffer.writeln(
            '- Hardcode Transaction: "${expense.description}" (${expense.date.toString().substring(0, 10)}, ${expense.amount} kr)',
          );
          buffer.writeln(
            '  -> Assign **Category.${cat.name}** / **Subcategory.${sub.name}**',
          );
        } else {
          buffer.writeln('- Hardcode Transaction ID `$id` (Unknown Details)');
          buffer.writeln(
            '  -> Assign **Category.${cat.name}** / **Subcategory.${sub.name}**',
          );
        }
      }
    }

    if (rules.isEmpty && overrides.isEmpty) {
      buffer.writeln('No rules or overrides saved.');
    }

    final code = buffer.toString();

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportera Regler & Overrides'),
        content: SingleChildScrollView(
          child: SelectableText(
            code,
            style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
          ),
        ),
        actions: [
          if (rules.isNotEmpty || overrides.isNotEmpty)
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await rulesRepo.clearAll();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Regler raderade')),
                  );
                  ref.invalidate(expensesRepositoryProvider);
                }
              },
              child: const Text(
                'Rensa sparade',
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Stäng'),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kopierat till urklipp')),
              );
            },
            child: const Text('Kopiera Prompt'),
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
          onPrevious: () =>
              ref.read(currentDateProvider.notifier).previousMonth(),
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
            filteredExpenses = filteredExpenses
                .where((e) => e.description.toLowerCase().contains(searchText))
                .toList();
          }

          // 2. Type Filter
          if (_filterType != null) {
            filteredExpenses = filteredExpenses
                .where((e) => e.type == _filterType)
                .toList();
          }

          // 3. Category Filter
          if (_filterCategory != null) {
            filteredExpenses = filteredExpenses
                .where(
                  (e) =>
                      e.category == _filterCategory &&
                      _filterSubcategories.contains(e.subcategory),
                )
                .toList();
          }

          // 4. Account Filter
          if (_filterAccount != null) {
            filteredExpenses = filteredExpenses
                .where((e) => e.sourceAccount == _filterAccount)
                .toList();
          }

          // 5. Exclusion Filter
          if (_filterExcludeFromOverview != null) {
            filteredExpenses = filteredExpenses
                .where(
                  (e) => e.excludeFromOverview == _filterExcludeFromOverview,
                )
                .toList();
          }

          // --- Calculate Totals for Display ---
          double totalIncome = 0;
          double totalExpenses = 0;

          for (final e in filteredExpenses) {
            if (e.type == TransactionType.income) {
              totalIncome += e.amount.abs();
            } else {
              totalExpenses += e.amount.abs();
            }
          }

          final netResult = totalIncome - totalExpenses;

          final currency = NumberFormat.currency(
            locale: 'sv',
            symbol: 'kr',
            decimalDigits: 0,
          );
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
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    setState(() => _searchController.clear()),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
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
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('Alla typer'),
                                ),
                                DropdownMenuItem(
                                  value: TransactionType.income,
                                  child: Text('Inkomst'),
                                ),
                                DropdownMenuItem(
                                  value: TransactionType.expense,
                                  child: Text('Utgift'),
                                ),
                              ],
                              onChanged: (val) =>
                                  setState(() => _filterType = val),
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
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Alla kategorier'),
                                ),
                                ...Category.values.map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text('${c.emoji} ${c.displayName}'),
                                  ),
                                ),
                              ],
                              onChanged: _onCategoryChanged,
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
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Alla konton'),
                                ),
                                ...Account.values.map(
                                  (a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a.displayName),
                                  ),
                                ),
                              ],
                              onChanged: (val) =>
                                  setState(() => _filterAccount = val),
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
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('Alla visas'),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text('Inkluderade'),
                                ),
                                DropdownMenuItem(
                                  value: true,
                                  child: Text('Exkluderade'),
                                ),
                              ],
                              onChanged: (val) => setState(
                                () => _filterExcludeFromOverview = val,
                              ),
                            ),
                          ),
                          if (_filterType != null ||
                              _filterCategory != null ||
                              _filterAccount != null ||
                              _filterExcludeFromOverview != null)
                            TextButton(
                              onPressed: _clearFilters,
                              child: const Text('Rensa'),
                            ),
                        ],
                      ),
                    ),
                    if (_filterCategory != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _selectAllSubcategories,
                            child: const Text('Markera alla'),
                          ),
                          TextButton(
                            onPressed: _deselectAllSubcategories,
                            child: const Text('Avmarkera alla'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _filterCategory!.subcategories.map((sub) {
                          final isSelected = _filterSubcategories.contains(sub);
                          return FilterChip(
                            label: Text(sub.displayName),
                            selected: isSelected,
                            onSelected: (_) => _toggleSubcategory(sub),
                            backgroundColor: Colors.black,
                            selectedColor: Color(
                              _filterCategory!.colorValue,
                            ).withValues(alpha: 0.3),
                            checkmarkColor: Color(_filterCategory!.colorValue),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // --- Summary Widget ---
              if (filteredExpenses.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: NetResultBadge(netResult: netResult),
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
                    key: const PageStorageKey('transactions_list'),
                    itemCount: filteredExpenses.length,
                    separatorBuilder: (c, i) =>
                        const Divider(height: 1, indent: 70),
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      final isIncome = expense.type == TransactionType.income;
                      final amountStr = currency.format(expense.amount);
                      final color = isIncome
                          ? Colors.green
                          : Colors
                                .white; // Is dark mode default? Assuming user wants clean UI.

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(
                              expense.category.colorValue,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            expense.category.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        title: Text(
                          expense.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          children: [
                            Text(dateFormat.format(expense.date)),
                            if (expense.subcategory != Subcategory.unknown) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• ${expense.subcategory.displayName}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            Text(
                              '• ${expense.sourceAccount.displayName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (expense.excludeFromOverview)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.visibility_off,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            Text(
                              amountStr,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () =>
                            ExpenseDetailRoute(id: expense.id).push(context),
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
