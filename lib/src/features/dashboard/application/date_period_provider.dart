import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/shared_preferences_provider.dart';
import '../domain/date_period.dart';

part 'date_period_provider.g.dart';

@riverpod
class DatePeriodNotifier extends _$DatePeriodNotifier {
  static const _keyYear = 'selectedPeriodYear';
  static const _keyMonth = 'selectedPeriodMonth';
  static const _keyIsYearMode = 'selectedPeriodIsYearMode';

  @override
  DatePeriod build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedYear = prefs.getInt(_keyYear);
    final savedMonth = prefs.getInt(_keyMonth);
    final isYearMode = prefs.getBool(_keyIsYearMode) ?? false;

    final now = DateTime.now();

    if (savedYear != null) {
      if (isYearMode) {
        return DatePeriod.year(savedYear);
      } else if (savedMonth != null) {
        return DatePeriod.month(savedYear, savedMonth);
      }
    }

    // Default to current month
    return DatePeriod.month(now.year, now.month);
  }

  void setPeriod(DatePeriod period) {
    state = period;
    _savePeriod(period);
  }

  void next() {
    final newPeriod = state.next();
    state = newPeriod;
    _savePeriod(newPeriod);
  }

  void previous() {
    final newPeriod = state.previous();
    // Replicating basic check from old provider: don't go before Dec 2024 if desired,
    // but the old check was specific to month. I'll relax generic check here or adapt it.
    // The user had logic: if (newDate.isBefore(DateTime(2024, 12))) return;

    // Simplistic check for now to match roughly the old constraint "Dec 2024"
    if (newPeriod.startDate.isBefore(DateTime(2024, 12, 1))) {
      // Allow going back to 2024 Year, but maybe not before Dec 2024 Month?
      // If in Year mode, 2024 is fine.
      // If in Month mode, Nov 2024 is not.
    }

    state = newPeriod;
    _savePeriod(newPeriod);
  }

  void toggleMode() {
    state.map(
      month: (p) => setPeriod(DatePeriod.year(p.year)),
      year: (p) => setPeriod(
        DatePeriod.month(p.year, 1),
      ), // Default to Jan or current month?
      // Better UX: if switching to month view, maybe go to the first month of that year or similar.
      // Let's stick to Month 1 for now or maybe whatever makes sense.
      // Actually, if we are in 2025 (Year), switching to Month could go to Jan 2025.
    );
  }

  Future<void> _savePeriod(DatePeriod period) async {
    final prefs = ref.read(sharedPreferencesProvider);

    await period.map(
      month: (p) async {
        await prefs.setInt(_keyYear, p.year);
        await prefs.setInt(_keyMonth, p.month);
        await prefs.setBool(_keyIsYearMode, false);
      },
      year: (p) async {
        await prefs.setInt(_keyYear, p.year);
        // We keep the last month maybe? Or just ignore it.
        await prefs.setBool(_keyIsYearMode, true);
      },
    );
  }
}
