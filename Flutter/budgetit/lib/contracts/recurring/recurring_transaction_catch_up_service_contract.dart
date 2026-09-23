import 'package:budgetit/models/recurring/recurring_transaction_catch_up_result.dart';

/// Creates the transactions owed by recurring templates that have fallen due.
///
/// Runs at app start and on demand. A template several intervals overdue
/// produces one transaction per missed occurrence, so a user returning after
/// a month away sees every entry rather than only the most recent.
///
/// Each occurrence is written in its own database transaction, so a failure
/// leaves no half-created record and the template's due date is not advanced
/// past work that did not happen.
///
/// {@category Recurring}
abstract interface class RecurringTransactionCatchUpServiceContract {
  /// Whether a catch-up run is currently in progress.
  bool get isRunning;

  /// Creates every transaction owed up to the end of the local day and
  /// reports the outcome.
  ///
  /// If a run is already in progress this returns immediately with a result
  /// marked as skipped, so overlapping triggers cannot double-create
  /// transactions.
  ///
  /// Never throws: per-template failures are captured in the returned
  /// [CatchUpResult], classified by the step that failed, so one bad template
  /// does not stop the others.
  ///
  /// [trigger] : records what initiated the run, for diagnostics
  /// [localTodayOverride] : treats this date as today; intended for tests
  Future<CatchUpResult> catchUpDueRecurringTransactions({
    CatchUpTrigger trigger = CatchUpTrigger.manual,
    DateTime? localTodayOverride,
  });
}
