import 'package:freezed_annotation/freezed_annotation.dart';
import '../../transactions/domain/category.dart';
import '../../transactions/domain/subcategory.dart';

part 'expense_analytics.freezed.dart';

/// Summary of expenses for a single month
@freezed
abstract class MonthSummary with _$MonthSummary {
  const factory MonthSummary({
    required int year,
    required int month,
    required double income,
    required double expenses,
    required Map<Category, double> categoryBreakdown,
    required Map<Subcategory, double> subcategoryBreakdown,
  }) = _MonthSummary;
}

/// Complete analytics data for all expenses
@freezed
abstract class ExpenseAnalytics with _$ExpenseAnalytics {
  const ExpenseAnalytics._();

  const factory ExpenseAnalytics({
    required List<MonthSummary> monthSummaries,
    required Map<Category, double> categoryTotals,
    required double totalIncome,
    required double totalExpenses,
    required List<String> compactTransactions,
  }) = _ExpenseAnalytics;

  /// Convert analytics to a markdown string for LLM context
  String toMarkdownPrompt() {
    final buffer = StringBuffer();

    buffer.writeln('## Månadsöversikt');
    buffer.writeln('');

    // Sort months chronologically (newest first)
    final sortedMonths = [...monthSummaries]
      ..sort((a, b) {
        final yearCmp = b.year.compareTo(a.year);
        if (yearCmp != 0) return yearCmp;
        return b.month.compareTo(a.month);
      });

    for (final m in sortedMonths) {
      final monthName = _monthName(m.month);
      final netResult = m.income - m.expenses;
      final netSign = netResult >= 0 ? '+' : '';
      buffer.writeln(
        '### $monthName ${m.year}: Inkomst ${m.income.toStringAsFixed(0)} kr, Utgifter ${m.expenses.toStringAsFixed(0)} kr (Netto: $netSign${netResult.toStringAsFixed(0)} kr)',
      );

      // Top 3 categories for this month
      final sortedCats = m.categoryBreakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final cat in sortedCats.take(5)) {
        buffer.writeln(
          '  - ${cat.key.displayName}: ${cat.value.toStringAsFixed(0)} kr',
        );
      }

      // Top 5 subcategories for this month
      final sortedSubcats = m.subcategoryBreakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final sub in sortedSubcats.take(5)) {
        buffer.writeln(
          '    * ${sub.key.displayName}: ${sub.value.toStringAsFixed(0)} kr',
        );
      }

      buffer.writeln('');
    }

    buffer.writeln('## Totaler (alla perioder)');
    buffer.writeln('- Total inkomst: ${totalIncome.toStringAsFixed(0)} kr');
    buffer.writeln('- Totala utgifter: ${totalExpenses.toStringAsFixed(0)} kr');
    buffer.writeln(
      '- Nettoresultat: ${(totalIncome - totalExpenses).toStringAsFixed(0)} kr',
    );

    buffer.writeln('');
    buffer.writeln('## Transaktioner (CSV-format)');
    buffer.writeln('Datum;Belopp;Kategori;Underkategori;Beskrivning');
    for (final t in compactTransactions) {
      buffer.writeln(t);
    }

    return buffer.toString();
  }

  String _monthName(int month) {
    const names = [
      '',
      'Januari',
      'Februari',
      'Mars',
      'April',
      'Maj',
      'Juni',
      'Juli',
      'Augusti',
      'September',
      'Oktober',
      'November',
      'December',
    ];
    return names[month];
  }
}
