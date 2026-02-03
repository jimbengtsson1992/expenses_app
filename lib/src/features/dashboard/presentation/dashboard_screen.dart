import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/presentation/period_selector.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';
import '../../transactions/domain/transaction.dart';
import '../../transactions/domain/transaction_type.dart';
import '../../estimation/application/monthly_estimate_provider.dart';
import '../../estimation/domain/monthly_estimate.dart';
import '../../shared/domain/excluded_from_estimates.dart';

import '../application/date_period_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../routing/routes.dart';

import '../../../common_widgets/net_result_badge.dart';

part 'dashboard_screen.g.dart';

@riverpod
class DashboardIncludeRenovationAndLoan
    extends _$DashboardIncludeRenovationAndLoan {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPeriod = ref.watch(datePeriodProvider);
    final expensesAsync = ref.watch(expensesForPeriodProvider(currentPeriod));

    return Scaffold(
      appBar: AppBar(
        title: const PeriodSelector(),
        actions: [
          Row(
            children: [
              Text(
                'Renovering & Lån',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Switch(
                value: ref.watch(dashboardIncludeRenovationAndLoanProvider),
                onChanged: (_) => ref
                    .read(dashboardIncludeRenovationAndLoanProvider.notifier)
                    .toggle(),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final estimateAsync = ref.watch(monthlyEstimateProvider(currentPeriod));
          return estimateAsync.when(
            data: (estimate) => _DashboardContent(expenses: expenses, estimate: estimate),
            loading: () => _DashboardContent(expenses: expenses, estimate: null),
            error: (_, __) => _DashboardContent(expenses: expenses, estimate: null),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.expenses, this.estimate});
  final List<Transaction> expenses;
  final MonthlyEstimate? estimate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate Totals
    double totalIncome = 0;
    double totalExpenses = 0;

    final categoryTotals = <Category, double>{};
    final incomeCategoryTotals = <Category, double>{};

    final categoryCounts = <Category, int>{};
    final incomeCategoryCounts = <Category, int>{};

    // Map<Category, Map<Subcategory, double>>
    final expenseSubcategoryTotals = <Category, Map<Subcategory, double>>{};
    final incomeSubcategoryTotals = <Category, Map<Subcategory, double>>{};

    final expenseSubcategoryCounts = <Category, Map<Subcategory, int>>{};
    final incomeSubcategoryCounts = <Category, Map<Subcategory, int>>{};

    final includeRenovationAndLoan = ref.watch(
      dashboardIncludeRenovationAndLoanProvider,
    );

    for (final e in expenses) {
      if (e.excludeFromOverview) continue;

      if (!includeRenovationAndLoan) {
        if (isExcludedFromEstimates(e.category, e.subcategory)) {
          continue;
        }
      }

      if (e.type == TransactionType.income) {
        totalIncome += e.amount.abs();
        incomeCategoryTotals.update(
          e.category,
          (val) => val + e.amount.abs(),
          ifAbsent: () => e.amount.abs(),
        );
        incomeCategoryCounts.update(
          e.category,
          (val) => val + 1,
          ifAbsent: () => 1,
        );

        if (!incomeSubcategoryTotals.containsKey(e.category)) {
          incomeSubcategoryTotals[e.category] = {};
          incomeSubcategoryCounts[e.category] = {};
        }
        incomeSubcategoryTotals[e.category]!.update(
          e.subcategory,
          (val) => val + e.amount.abs(),
          ifAbsent: () => e.amount.abs(),
        );
        incomeSubcategoryCounts[e.category]!.update(
          e.subcategory,
          (val) => val + 1,
          ifAbsent: () => 1,
        );
      } else {
        // Expense transaction
        totalExpenses += e.amount.abs();
        categoryTotals.update(
          e.category,
          (val) => val + e.amount.abs(),
          ifAbsent: () => e.amount.abs(),
        );
        categoryCounts.update(
          e.category,
          (val) => val + 1,
          ifAbsent: () => 1,
        );

        if (!expenseSubcategoryTotals.containsKey(e.category)) {
          expenseSubcategoryTotals[e.category] = {};
          expenseSubcategoryCounts[e.category] = {};
        }
        expenseSubcategoryTotals[e.category]!.update(
          e.subcategory,
          (val) => val + e.amount.abs(),
          ifAbsent: () => e.amount.abs(),
        );
        expenseSubcategoryCounts[e.category]!.update(
          e.subcategory,
          (val) => val + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final netResult = totalIncome - totalExpenses;

    // Include categories from estimates that have estimated values but no actuals yet
    if (estimate != null) {
      for (final entry in estimate!.categoryEstimates.entries) {
        final cat = entry.key;
        final catEstimate = entry.value;
        // Add category with 0 actual if it has an estimated value but isn't in actuals
        if (cat != Category.income && 
            !categoryTotals.containsKey(cat) && 
            catEstimate.estimated > 0) {
          categoryTotals[cat] = 0;
        }
        if (cat == Category.income && 
            !incomeCategoryTotals.containsKey(cat) && 
            catEstimate.estimated > 0) {
          incomeCategoryTotals[cat] = 0;
        }
      }
    }

    // Sort categories
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) {
        // Sort by estimated value if available, otherwise actual
        final aVal = estimate?.categoryEstimates[a.key]?.estimated ?? a.value;
        final bVal = estimate?.categoryEstimates[b.key]?.estimated ?? b.value;
        return bVal.compareTo(aVal);
      });

    final sortedIncomeCategories = incomeCategoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Formatter
    final currency = NumberFormat.currency(
      locale: 'sv',
      symbol: 'kr',
      decimalDigits: 0,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => const TransactionsListRoute(
                        filterType: TransactionType.income,
                      ).go(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Inkomst',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(totalIncome),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                            ),
                            if (estimate != null) ...[                            
                              const SizedBox(height: 4),
                              Text(
                                '→ ${currency.format(estimate!.estimatedIncome)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.greenAccent.withValues(alpha: 0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => const TransactionsListRoute(
                        filterType: TransactionType.expense,
                      ).go(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Utgifter',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currency.format(totalExpenses),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (estimate != null) ...[                            
                              const SizedBox(height: 4),
                              Text(
                                '→ ${currency.format(estimate!.estimatedExpenses)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.withValues(alpha: 0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                NetResultBadge(netResult: netResult),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Utgifter per Kategori',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Category List
        ...sortedCategories.map((e) {
          final cat = e.key;
          final amount = e.value;
          final percentage = totalExpenses > 0 ? amount / totalExpenses : 0.0;
          final subs = Map<Subcategory, double>.from(expenseSubcategoryTotals[cat] ?? {});
          final count = categoryCounts[cat] ?? 0;

          // Include subcategories from estimates that have no actual transactions
          if (estimate != null) {
            final catEstimate = estimate!.categoryEstimates[cat];
            if (catEstimate != null) {
              for (final subEntry in catEstimate.subcategoryEstimates.entries) {
                if (!subs.containsKey(subEntry.key) && subEntry.value.estimated > 0) {
                  subs[subEntry.key] = 0; // Add with 0 actual
                }
              }
            }
          }

          // Sort subs by estimated value if available, otherwise actual
          final sortedSubs = subs.entries.toList()
            ..sort((a, b) {
              final aEst = estimate?.categoryEstimates[cat]?.subcategoryEstimates[a.key]?.estimated ?? a.value;
              final bEst = estimate?.categoryEstimates[cat]?.subcategoryEstimates[b.key]?.estimated ?? b.value;
              return bEst.compareTo(aEst);
            });

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              // Use Card for elevation and shape
              elevation: 2, // Slight elevation
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ), // Hide ExpansionTile border
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(cat.colorValue).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      cat.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${cat.displayName} ($count)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currency.format(amount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (estimate?.categoryEstimates[cat] != null &&
                              estimate!.categoryEstimates[cat]!.estimated > amount)
                            Text(
                              '→ ${currency.format(estimate!.categoryEstimates[cat]!.estimated)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.withValues(alpha: 0.7),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: sortedSubs.map((subEntry) {
                            final subData = subEntry.key;
                            final subAmount = subEntry.value;
                            final subName = subData.displayName;
                            final subCount =
                                expenseSubcategoryCounts[cat]?[subData] ?? 0;
                            final subEstimate = estimate?.categoryEstimates[cat]?.subcategoryEstimates[subData];

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 48,
                                  ), // Indent to align text
                                  Expanded(
                                    child: Text(
                                      '$subName ($subCount)',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        currency.format(subAmount),
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (subEstimate != null &&
                                          subEstimate.estimated > subAmount)
                                        Text(
                                          '→ ${currency.format(subEstimate.estimated)}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.withValues(alpha: 0.5),
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    // Link to list
                    TextButton(
                      onPressed: () => TransactionsListRoute(
                        category: cat,
                        filterType: TransactionType.expense,
                      ).go(context),
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
          Text(
            'Inkomster per Kategori',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...sortedIncomeCategories.map((e) {
            final cat = e.key;
            final amount = e.value;
            final percentage = totalIncome > 0 ? amount / totalIncome : 0.0;
            final subs = Map<Subcategory, double>.from(incomeSubcategoryTotals[cat] ?? {});
            final count = incomeCategoryCounts[cat] ?? 0;

            // Include subcategories from estimates that have no actual transactions
            if (estimate != null) {
              final catEstimate = estimate!.categoryEstimates[cat];
              if (catEstimate != null) {
                for (final subEntry in catEstimate.subcategoryEstimates.entries) {
                  if (!subs.containsKey(subEntry.key) && subEntry.value.estimated > 0) {
                    subs[subEntry.key] = 0; // Add with 0 actual
                  }
                }
              }
            }

            // Sort subs by estimated value if available, otherwise actual
            final sortedSubs = subs.entries.toList()
              ..sort((a, b) {
                final aEst = estimate?.categoryEstimates[cat]?.subcategoryEstimates[a.key]?.estimated ?? a.value;
                final bEst = estimate?.categoryEstimates[cat]?.subcategoryEstimates[b.key]?.estimated ?? b.value;
                return bEst.compareTo(aEst);
              });

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(cat.colorValue).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cat.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${cat.displayName} ($count)',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currency.format(amount),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (estimate?.categoryEstimates[cat] != null &&
                                estimate!.categoryEstimates[cat]!.estimated > amount)
                              Text(
                                '→ ${currency.format(estimate!.categoryEstimates[cat]!.estimated)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.greenAccent.withValues(alpha: 0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            children: sortedSubs.map((subEntry) {
                              final subData = subEntry.key;
                              final subAmount = subEntry.value;
                              final subName = subData.displayName;
                              final subCount =
                                  incomeSubcategoryCounts[cat]?[subData] ?? 0;
                              final subEstimate = estimate?.categoryEstimates[cat]?.subcategoryEstimates[subData];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 48,
                                    ), // Indent to align text
                                    Expanded(
                                      child: Text(
                                        '$subName ($subCount)',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          currency.format(subAmount),
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (subEstimate != null &&
                                            subEstimate.estimated > subAmount)
                                          Text(
                                            '→ ${currency.format(subEstimate.estimated)}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.greenAccent.withValues(alpha: 0.5),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      // Link to list
                      TextButton(
                        onPressed: () => TransactionsListRoute(
                          category: cat,
                          filterType: TransactionType.income,
                        ).go(context),
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
