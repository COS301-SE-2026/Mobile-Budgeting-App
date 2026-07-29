import '../../database/app_database.dart';
import '../../database/schema.dart';
import '../../models/recurring/recurring_transaction_catch_up_result.dart';

class RecurringTransactionCatchUpService {
  RecurringTransactionCatchUpService(this._database);

  final AppDatabase _database;

  bool _isRunning = false;

  /// True when a recurring transaction catch-up run is already running.
  bool get isRunning => _isRunning;

  DateTime _endOfLocalDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }

  Future<_OccurrenceCreationResult> _createOccurrence(
    RecurringTransaction recurringTransaction,
  ) async {
    CatchUpFailure? occurrenceFailure;
    late final Transaction insertedTransaction;
    late final RecurringTransaction advancedRecurringTransaction;

    try {
      await _database.transaction(() async {
        try {
          insertedTransaction = await _database.transactionDao
              .insertTransaction(
                amount: recurringTransaction.amount,
                type: recurringTransaction.type,
                shortDescription: recurringTransaction.shortDescription,
                longDescription: recurringTransaction.longDescription,
                transactionDate: recurringTransaction.nextTransactionDate,
                source: TransactionSource.recurring,
                currency: recurringTransaction.currency,
                recurringId: recurringTransaction.id,
              );
        } catch (error, stackTrace) {
          occurrenceFailure = CatchUpFailure(
            type: CatchUpFailureType.transactionInsertFailed,
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }

        if (recurringTransaction.categoryId != null) {
          try {
            await _database.transactionDao.assignCategory(
              transactionId: insertedTransaction.id,
              categoryId: recurringTransaction.categoryId!,
              assignmentSource: AssignmentSource.manual,
            );
          } catch (error, stackTrace) {
            occurrenceFailure = CatchUpFailure(
              type: CatchUpFailureType.categoryAssignmentFailed,
              error: error,
              stackTrace: stackTrace,
            );
            rethrow;
          }
        }

        try {
          advancedRecurringTransaction = await _database.recurringTransactionDao
              .advanceNextDate(recurringTransaction.id);
        } catch (error, stackTrace) {
          occurrenceFailure = CatchUpFailure(
            type: CatchUpFailureType.advanceNextDateFailed,
            error: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
      });
    } catch (error, stackTrace) {
      throw _OccurrenceCreationFailure(
        occurrenceFailure ??
            CatchUpFailure(
              type: CatchUpFailureType.unknown,
              error: error,
              stackTrace: stackTrace,
            ),
      );
    }

    return _OccurrenceCreationResult(
      transactionId: insertedTransaction.id,
      advancedRecurringTransaction: advancedRecurringTransaction,
    );
  }

  Future<TemplateCatchUpResult> _catchUpRecurringTransaction(
    RecurringTransaction recurringTransaction,
    DateTime localTodayEndOfDay,
  ) async {
    final initialNextTransactionDate = recurringTransaction.nextTransactionDate;
    final occurrences = <OccurrenceCatchUpResult>[];
    var current = recurringTransaction;

    while (!current.nextTransactionDate.isAfter(localTodayEndOfDay)) {
      final dueDate = current.nextTransactionDate;

      try {
        final result = await _createOccurrence(current);

        occurrences.add(
          OccurrenceCatchUpResult.created(
            dueDate: dueDate,
            transactionId: result.transactionId,
          ),
        );
        current = result.advancedRecurringTransaction;
      } on _OccurrenceCreationFailure catch (error) {
        occurrences.add(
          OccurrenceCatchUpResult.failed(
            dueDate: dueDate,
            failure: error.failure,
          ),
        );
        break;
      }
    }

    return TemplateCatchUpResult(
      recurringTransactionId: recurringTransaction.id,
      shortDescription: recurringTransaction.shortDescription,
      initialNextTransactionDate: initialNextTransactionDate,
      finalNextTransactionDate: current.nextTransactionDate,
      occurrences: occurrences,
    );
  }

  /// Generates all due recurring transactions up to the user's
  /// local calendar day.
  ///
  /// If another run is already running, this returns a skipped result
  /// instead of throwing.
  ///
  /// Partial failures are reported in the returned [CatchUpResult].
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
    final localTodayEndOfDay = _endOfLocalDay(localToday);

    try {
      final dueRecurringTransactions = await _database.recurringTransactionDao
          .getDueRecurringTransactions(localTodayEndOfDay);
      final templates = <TemplateCatchUpResult>[];

      for (final recurringTransaction in dueRecurringTransactions) {
        templates.add(
          await _catchUpRecurringTransaction(
            recurringTransaction,
            localTodayEndOfDay,
          ),
        );
      }

      return CatchUpResult.completed(
        trigger: trigger,
        localToday: localToday,
        startedAt: startedAt,
        finishedAt: DateTime.now(),
        templates: templates,
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

class _OccurrenceCreationResult {
  const _OccurrenceCreationResult({
    required this.transactionId,
    required this.advancedRecurringTransaction,
  });

  final String transactionId;
  final RecurringTransaction advancedRecurringTransaction;
}

class _OccurrenceCreationFailure implements Exception {
  const _OccurrenceCreationFailure(this.failure);

  final CatchUpFailure failure;
}
