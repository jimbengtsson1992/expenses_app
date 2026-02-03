import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_period.freezed.dart';

@freezed
abstract class DatePeriod with _$DatePeriod {
  const DatePeriod._();

  const factory DatePeriod.month(int year, int month) = _Month;
  const factory DatePeriod.year(int year) = _Year;

  DatePeriod next() {
    return map(
      month: (value) {
        if (value.month == 12) {
          return DatePeriod.month(value.year + 1, 1);
        }
        return DatePeriod.month(value.year, value.month + 1);
      },
      year: (value) => DatePeriod.year(value.year + 1),
    );
  }

  DatePeriod previous() {
    return map(
      month: (value) {
        if (value.month == 1) {
          return DatePeriod.month(value.year - 1, 12);
        }
        return DatePeriod.month(value.year, value.month - 1);
      },
      year: (value) => DatePeriod.year(value.year - 1),
    );
  }

  DateTime get startDate {
    return map(
      month: (value) => DateTime(value.year, value.month),
      year: (value) => DateTime(value.year),
    );
  }

  DateTime get endDate {
    return map(
      month: (value) {
        final nextMonth = value.month == 12
            ? DateTime(value.year + 1, 1)
            : DateTime(value.year, value.month + 1);
        return nextMonth.subtract(const Duration(microseconds: 1));
      },
      year: (value) => DateTime(value.year, 12, 31, 23, 59, 59),
    );
  }
}
