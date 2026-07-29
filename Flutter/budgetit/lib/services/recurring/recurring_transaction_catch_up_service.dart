import '../../database/app_database.dart';
import '../../models/recurring/recurring_transaction_catch_up_result.dart';

class RecurringTransactionCatchUpService {
  RecurringTransactionCatchUpService(this._database);

  // ignore: unused_field
  final AppDatabase _database;

  bool _isRunning = false;

  /// True when a recurring transaction catch-up run is already running.
  bool get isRunning => _isRunning;

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
  }) async {
    final localToday = localTodayOverride ?? DateTime.now();

    if (_isRunning) {
      return CatchUpResult.skippedAlreadyRunning(
        trigger: trigger,
        localToday: localToday,
        skippedAt: DateTime.now(),
      );
    }

    _isRunning = true;
    final startedAt = DateTime.now();
    final localTodayEndOfDay = DateTime(
      localToday.year,
      localToday.month,
      localToday.day,
      23,
      59,
      59,
      999,
      999,
    );

    try {
      final dueRecurringTransactions = await _database.recurringTransactionDao
          .getDueRecurringTransactions(localTodayEndOfDay);

      if (dueRecurringTransactions.isNotEmpty) {
        throw UnimplementedError();
      }

      return CatchUpResult.completed(
        trigger: trigger,
        localToday: localToday,
        startedAt: startedAt,
        finishedAt: DateTime.now(),
        templates: const [],
      );
    } on Object catch (error, stackTrace) {
      return CatchUpResult.completed(
        trigger: trigger,
        localToday: localToday,
        startedAt: startedAt,
        finishedAt: DateTime.now(),
        templates: const [],
        runFailure: CatchUpFailure(
          type: CatchUpFailureType.unknown,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } finally {
      _isRunning = false;
    }
  }
}
