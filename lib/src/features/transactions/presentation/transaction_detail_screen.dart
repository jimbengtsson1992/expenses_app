import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/expenses_providers.dart';
import '../data/expenses_repository.dart';
import '../data/user_rules_repository.dart';
import '../domain/transaction_type.dart';
import '../domain/transaction.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.expenseId});
  final String expenseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseByIdProvider(expenseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Transaktionsdetaljer')),
      body: expenseAsync.when(
        data: (expense) {
          if (expense == null) {
            return const Center(child: Text('Transaktion hittades inte'));
          }

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
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text(dateFormat.format(expense.date))),

              const SizedBox(height: 48),

              // Transaction Type Field
              _DetailRow(
                label: 'Typ',
                content: Row(
                  children: [
                    Icon(
                      expense.type == TransactionType.income
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: expense.type == TransactionType.income
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      expense.type == TransactionType.income
                          ? 'Inkomst'
                          : 'Utgift',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: expense.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category Field (Editable)
              InkWell(
                onTap: () => _showEditDialog(context, ref, expense),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DetailRow(
                        label: 'Kategori (Klicka för att ändra)',
                        content: Row(
                          children: [
                            Text(
                              expense.category.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              expense.category.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Underkategori',
                        content: Row(
                          children: [
                            Text(
                              expense.subcategory.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    const Text(
                      'Konto',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.credit_card,
                          size: 20,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          expense.sourceAccount.displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Raw Data (Debug/Extra info)
              ExpansionTile(
                title: const Text(
                  'Original Fil & Data',
                  style: TextStyle(fontSize: 14),
                ),
                children: [
                  ListTile(
                    title: Text(expense.sourceFilename),
                    subtitle: const Text('Filnamn'),
                  ),
                  if (expense.rawCsvData != null)
                    ListTile(
                      title: Text(
                        expense.rawCsvData!,
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12,
                        ),
                      ),
                      subtitle: const Text('Raw CSV Data'),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: expense.rawCsvData!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kopierat till urklipp'),
                            ),
                          );
                        },
                      ),
                    ),
                  ListTile(
                    title: const Text('Hantera visning (AI)'),
                    subtitle: Text(
                      ref.watch(userRulesRepositoryProvider).value?.isExcluded(expense.id) ?? false
                          ? 'Visas: NEJ (Tryck för att inkludera)'
                          : 'Visas: JA (Tryck för att exkludera)',
                    ),
                    trailing: Icon(
                      ref.watch(userRulesRepositoryProvider).value?.isExcluded(expense.id) ?? false
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onTap: () async {
                      final repo = await ref.read(
                        userRulesRepositoryProvider.future,
                      );
                      await repo.toggleExclusion(expense.id);
                      ref.invalidate(userRulesRepositoryProvider);
                      ref.invalidate(expensesRepositoryProvider);
                    },
                  ),
                  ListTile(
                    title: SelectableText(
                      expense.id,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                      ),
                    ),
                    subtitle: const Text('Transaction ID'),
                  ),
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

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Transaction expense,
  ) async {
    // 1. Select Category/Subcategory
    final selection = await showDialog<(Category, Subcategory)>(
      context: context,
      builder: (ctx) => _CategorySelectionDialog(
        initialCategory: expense.category,
        initialSubcategory: expense.subcategory,
      ),
    );

    if (selection == null) return; // Cancelled

    // 2. Select Save Mode (Override vs Rule)
    if (!context.mounted) return;

    await _handleSaveOptions(context, ref, expense, selection.$1, selection.$2);
  }

  Future<void> _handleSaveOptions(
    BuildContext context,
    WidgetRef ref,
    Transaction expense,
    Category category,
    Subcategory subcategory,
  ) async {
    final action = await showDialog<_SaveAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Spara ändring'),
        content: const Text(
          'Vill du spara detta endast för denna transaktion, eller skapa en regel baserat på beskrivningen?',
        ),
        actions: [
          TextButton(
            child: const Text('Endast denna (Override)'),
            onPressed: () => Navigator.of(ctx).pop(_SaveAction.override),
          ),
          ElevatedButton(
            child: const Text('Skapa Regel (Beskrivning)'),
            onPressed: () => Navigator.of(ctx).pop(_SaveAction.rule),
          ),
        ],
      ),
    );

    if (action == null) return;

    final repo = await ref.read(userRulesRepositoryProvider.future);

    if (action == _SaveAction.override) {
      await repo.addOverride(expense.id, category, subcategory);

      // Copy code to clipboard
      // Format: yyyy, M, d
      final dateStr =
          'DateTime(${expense.date.year}, ${expense.date.month}, ${expense.date.day})';
      final code =
          "await repo.addOverride('${expense.id}', Category.${category.name}, Subcategory.${subcategory.name}); // Date: $dateStr";
      await Clipboard.setData(ClipboardData(text: code));

      ref.invalidate(expensesRepositoryProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaktion uppdaterad & kod kopierad'),
          ),
        );
      }
    } else if (action == _SaveAction.rule) {
      if (!context.mounted) return;
      await _handleKeywordRule(
        context,
        ref,
        expense.description,
        category,
        subcategory,
      );
    }
  }

  Future<void> _handleKeywordRule(
    BuildContext context,
    WidgetRef ref,
    String originalDescription,
    Category category,
    Subcategory subcategory,
  ) async {
    final keyword = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: originalDescription);
        return AlertDialog(
          title: const Text('Skapa Regel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ange nyckelord att matcha mot:'),
              TextField(controller: controller, autofocus: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(controller.text.trim());
              },
              child: const Text('Spara Regel'),
            ),
          ],
        );
      },
    );

    if (keyword == null || keyword.isEmpty) return;

    final repo = await ref.read(userRulesRepositoryProvider.future);
    await repo.addRule(keyword, category, subcategory);
    ref.invalidate(expensesRepositoryProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Regel sparad')));
    }
  }
}

enum _SaveAction { override, rule }

class _CategorySelectionDialog extends StatefulWidget {
  const _CategorySelectionDialog({
    required this.initialCategory,
    required this.initialSubcategory,
  });
  final Category initialCategory;
  final Subcategory? initialSubcategory;

  @override
  State<_CategorySelectionDialog> createState() =>
      _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<_CategorySelectionDialog> {
  late Category selectedCategory;
  Subcategory? selectedSubcategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    selectedSubcategory = widget.initialSubcategory;
  }

  @override
  Widget build(BuildContext context) {
    // Filter available subcategories
    final available = selectedCategory.subcategories;

    return AlertDialog(
      title: const Text('Ändra Kategori'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Category>(
            isExpanded: true,
            value: selectedCategory,
            items: Category.values
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text('${c.emoji} ${c.displayName}'),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val != null && val != selectedCategory) {
                setState(() {
                  selectedCategory = val;
                  if (!val.subcategories.contains(selectedSubcategory)) {
                    selectedSubcategory = null;
                  }
                });
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButton<Subcategory>(
            isExpanded: true,
            value: selectedSubcategory,
            hint: const Text('Välj underkategori'),
            items: available
                .map(
                  (s) => DropdownMenuItem(value: s, child: Text(s.displayName)),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedSubcategory = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Avbryt'),
        ),
        ElevatedButton(
          onPressed: selectedSubcategory == null
              ? null
              : () {
                  Navigator.of(
                    context,
                  ).pop((selectedCategory, selectedSubcategory!));
                },
          child: const Text('Nästa'),
        ),
      ],
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
