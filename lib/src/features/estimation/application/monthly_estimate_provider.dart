import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/data/expenses_providers.dart';
import '../../dashboard/domain/date_period.dart';
import '../domain/monthly_estimate.dart';
import 'estimation_service.dart';

part 'monthly_estimate_provider.g.dart';

@riverpod
Future<MonthlyEstimate?> monthlyEstimate(Ref ref, DatePeriod period) async {
  final allTransactions = await ref.watch(expensesListProvider.future);
  final service = ref.watch(estimationServiceProvider);
  final now = DateTime.now();
  
  return service.calculateEstimate(period, allTransactions, now);
}
