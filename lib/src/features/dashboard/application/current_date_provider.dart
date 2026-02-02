import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/shared_preferences_provider.dart';

part 'current_date_provider.g.dart';

@riverpod
class CurrentDate extends _$CurrentDate {
  static const _key = 'selectedDate';

  @override
  DateTime build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedDate = prefs.getString(_key);
    if (savedDate != null) {
      return DateTime.parse(savedDate);
    }
    return DateTime.now();
  }

  void previousMonth() {
    final newDate = DateTime(state.year, state.month - 1);
    // Keep the minimum date check logic from before
    if (newDate.isBefore(DateTime(2024, 12))) {
      return;
    }
    state = newDate;
    _saveDate(newDate);
  }

  void nextMonth() {
    final newDate = DateTime(state.year, state.month + 1);
    state = newDate;
    _saveDate(newDate);
  }

  Future<void> _saveDate(DateTime date) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, date.toIso8601String());
  }
}
