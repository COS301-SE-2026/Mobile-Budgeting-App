import '../../database/app_database.dart';
import '../../models/recurring/recurring_transaction_catch_up_result.dart';

class RecurringTransactionCatchUpService {
  RecurringTransactionCatchUpService(this._database);

  // ignore: unused_field
  final AppDatabase _database;

  /// True when a recurring transaction catch-up run is already running.

  bool get isRunning {
    throw UnimplementedError();
  }

  /// Generates all due recurring transactions up to the user's
  /// local calendar day.
  ///
  /// If another run is already running, this returns a skipped result
  /// instead of throwing.
  ///
  /// Partial failures are  reported in the returned [CatchUpResult].
  Future<CatchUpResult> catchUpDueRecurringTransactions({
    CatchUpTrigger trigger = CatchUpTrigger.manual,
    DateTime? localTodayOverride,
  }) {
    throw UnimplementedError();
  }
}
