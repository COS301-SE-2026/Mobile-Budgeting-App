enum CatchUpTrigger { startup, foreground, manual, test }

enum CatchUpRunStatus { completed, skipped }

enum OccurrenceStatus { created, failed }

enum CatchUpFailureType {
  transactionInsertFailed,
  categoryAssignmentFailed,
  advanceNextDateFailed,
  unknown,
}

class CatchUpResult {
  final CatchUpRunStatus status;
  final CatchUpTrigger trigger;

  final DateTime localToday;

  final DateTime startedAt;
  final DateTime finishedAt;

  final List<TemplateCatchUpResult> _templates;

  List<TemplateCatchUpResult> get templates => _templates;

  CatchUpResult.completed({
    required this.trigger,
    required this.localToday,
    required this.startedAt,
    required this.finishedAt,
    required List<TemplateCatchUpResult> templates,
  }) : status = CatchUpRunStatus.completed,
       _templates = List.unmodifiable(templates);

  CatchUpResult.skippedAlreadyRunning({
    required this.trigger,
    required this.localToday,
    required DateTime skippedAt,
  }) : status = CatchUpRunStatus.skipped,
       startedAt = skippedAt,
       finishedAt = skippedAt,
       _templates = const [];

  bool get wasSkipped => status == CatchUpRunStatus.skipped;

  bool get completed => status == CatchUpRunStatus.completed;

  bool get hadWork => templates.isNotEmpty;

  bool get hasFailures => templates.any((template) => template.hasFailures);

  bool get completedWithNoWork => completed && !hadWork;

  bool get completedSuccessfully => completed && hadWork && !hasFailures;

  bool get completedWithFailures => completed && hasFailures;

  Duration get duration => finishedAt.difference(startedAt);

  int get templateCount => templates.length;

  int get attemptedOccurrenceCount => templates.fold(
    0,
    (total, template) => total + template.attemptedOccurrenceCount,
  );

  int get successfulOccurrenceCount => templates.fold(
    0,
    (total, template) => total + template.successfulOccurrenceCount,
  );

  int get failedOccurrenceCount => templates.fold(
    0,
    (total, template) => total + template.failedOccurrenceCount,
  );

  @override
  String toString() =>
      'CatchUpResult('
      'status: $status, '
      'trigger: $trigger, '
      'localToday: $localToday, '
      'duration: $duration, '
      'templates: $templateCount, '
      'attempted: $attemptedOccurrenceCount, '
      'created: $successfulOccurrenceCount, '
      'failed: $failedOccurrenceCount'
      ')';
}

class TemplateCatchUpResult {
  final String recurringTransactionId;
  final String shortDescription;
  final DateTime initialNextTransactionDate;
  final DateTime finalNextTransactionDate;
  final List<OccurrenceCatchUpResult> _occurrences;

  List<OccurrenceCatchUpResult> get occurrences => _occurrences;

  TemplateCatchUpResult({
    required this.recurringTransactionId,
    required this.shortDescription,
    required this.initialNextTransactionDate,
    required this.finalNextTransactionDate,
    required List<OccurrenceCatchUpResult> occurrences,
  }) : _occurrences = List.unmodifiable(occurrences);

  bool get hasFailures => occurrences.any(
    (occurrence) => occurrence.status == OccurrenceStatus.failed,
  );

  bool get stoppedAfterFailure => hasFailures;

  int get attemptedOccurrenceCount => occurrences.length;

  int get successfulOccurrenceCount => occurrences
      .where((occurrence) => occurrence.status == OccurrenceStatus.created)
      .length;

  int get failedOccurrenceCount => occurrences
      .where((occurrence) => occurrence.status == OccurrenceStatus.failed)
      .length;

  @override
  String toString() =>
      'TemplateCatchUpResult('
      'recurringTransactionId: $recurringTransactionId, '
      'shortDescription: $shortDescription, '
      'initialNextTransactionDate: $initialNextTransactionDate, '
      'finalNextTransactionDate: $finalNextTransactionDate, '
      'attempted: $attemptedOccurrenceCount, '
      'created: $successfulOccurrenceCount, '
      'failed: $failedOccurrenceCount'
      ')';
}

class OccurrenceCatchUpResult {
  final DateTime dueDate;
  final OccurrenceStatus status;
  final String? transactionId;
  final CatchUpFailure? failure;

  const OccurrenceCatchUpResult.created({
    required this.dueDate,
    required String this.transactionId,
  }) : status = OccurrenceStatus.created,
       failure = null;

  const OccurrenceCatchUpResult.failed({
    required this.dueDate,
    required CatchUpFailure this.failure,
  }) : status = OccurrenceStatus.failed,
       transactionId = null;

  @override
  String toString() =>
      'OccurrenceCatchUpResult('
      'dueDate: $dueDate, '
      'status: $status, '
      'transactionId: $transactionId, '
      'failure: $failure'
      ')';
}

class CatchUpFailure {
  final CatchUpFailureType type;

  final Object error;

  final StackTrace stackTrace;

  const CatchUpFailure({
    required this.type,
    required this.error,
    required this.stackTrace,
  });

  String get message => error.toString();

  @override
  String toString() =>
      'CatchUpFailure('
      'type: $type, '
      'message: $message'
      ')';
}
