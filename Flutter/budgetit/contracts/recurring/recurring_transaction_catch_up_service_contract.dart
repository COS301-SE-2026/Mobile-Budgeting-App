import 'package:budgetit/models/recurring/recurring_transaction_catch_up_result.dart';

abstract interface class RecurringTransactionCatchUpServiceContract {
  bool get isRunning;

  Future<CatchUpResult> catchUpDueRecurringTransactions({
    CatchUpTrigger trigger = CatchUpTrigger.manual,
    DateTime? localTodayOverride,
  });
}
