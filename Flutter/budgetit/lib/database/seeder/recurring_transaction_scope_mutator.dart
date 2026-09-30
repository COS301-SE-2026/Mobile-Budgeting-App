part of 'database_seeder.dart';

class _RecurringTransactionScopeMutator implements _SeedScopeMutator {
  _RecurringTransactionScopeMutator(this._db, this._fixtureReader);

  final AppDatabase _db;
  final SeedFixtureReader _fixtureReader;

  @override
  Future<_SeedScopeDeletionImpact> getDeletionImpact() async {
    final deletedRowsByScope = _createEmptyDeletedRowsByScope();
    final recurringTransactionCount = await _db.recurringTransactionDao
        .countRecurringTransactions(includeDeleted: true);
    final generatedTransactionCount = await _db.transactionDao
        .countTransactionsWithRecurringId();
    deletedRowsByScope[SeedScope.recurringTransactions] =
        recurringTransactionCount;

    return _SeedScopeDeletionImpact(
      deletedRowsByScope: deletedRowsByScope,
      effects: [
        _DeletionEffect(
          'Generated transactions unlinked',
          generatedTransactionCount,
        ),
      ],
    );
  }

  @override
  Future<void> seed() async {
    final categoryIds = await _getCategoryIds(_db);
    final schedules = await _fixtureReader.loadFixtureEntries(
      'recurring_transactions',
    );
    for (final schedule in schedules) {
      await _seedRecurringTransaction(schedule, categoryIds);
    }
  }

  Future<void> _seedRecurringTransaction(
    Map<String, dynamic> schedule,
    Map<String, String> categoryIds,
  ) async {
    final categoryId = _getCategoryId(categoryIds, schedule);
    final offset = Map<String, dynamic>.from(
      schedule['next_date_offset'] as Map,
    );
    final nextDate = _getNextRecurringDate(offset, schedule);
    final interval = schedule['interval_amount'];
    if (interval is! int) {
      throw FormatException('Invalid interval_amount: $schedule');
    }
    final hasInvalidInterval = interval <= 0;
    if (hasInvalidInterval) {
      throw FormatException('Invalid interval_amount: $schedule');
    }

    String? longDescription;
    final hasLongDescription = schedule['long_description'] != null;
    if (hasLongDescription) {
      longDescription = _getRequiredFixtureText(schedule, 'long_description');
    }

    final currency = _getFixtureCurrency(schedule);
    await _db.recurringTransactionDao.insertRecurringTransaction(
      amount: _getFixtureAmount(schedule),
      type: _getFixtureEnumValue(TransactionType.values, schedule, 'type'),
      shortDescription: _getRequiredFixtureText(schedule, 'short_description'),
      longDescription: longDescription,
      nextTransactionDate: nextDate,
      startDate: nextDate,
      unit: _getFixtureEnumValue(PeriodType.values, schedule, 'period_type'),
      intervalAmount: interval,
      categoryId: categoryId,
      currency: currency,
    );
  }

  DateTime _getNextRecurringDate(
    Map<String, dynamic> offset,
    Map<String, dynamic> schedule,
  ) {
    final distance = offset['amount'];
    if (distance is! int) {
      throw FormatException('Invalid next_date_offset amount: $schedule');
    }
    final hasInvalidOffset = distance <= 0;
    if (hasInvalidOffset) {
      throw FormatException('Invalid next_date_offset amount: $schedule');
    }

    final now = DateTime.now().toUtc();
    return switch (_getRequiredFixtureText(offset, 'unit')) {
      'days' => now.add(Duration(days: distance)),
      'months' => _getMonthOffset(now, distance, offset['day_of_month']),
      final unit => throw FormatException(
        'Invalid next_date_offset unit: $unit',
      ),
    };
  }

  DateTime _getMonthOffset(DateTime now, int months, Object? day) {
    if (day is! int) {
      throw FormatException('Invalid day_of_month: $day');
    }
    final hasInvalidDayOfMonth = day < 1 || day > 31;
    if (hasInvalidDayOfMonth) {
      throw FormatException('Invalid day_of_month: $day');
    }

    final firstDayOfTargetMonth = DateTime.utc(now.year, now.month + months);
    final lastDayOfTargetMonth = DateTime.utc(
      firstDayOfTargetMonth.year,
      firstDayOfTargetMonth.month + 1,
      0,
    ).day;
    final dayExceedsTargetMonth = day > lastDayOfTargetMonth;
    var adjustedDay = day;
    if (dayExceedsTargetMonth) {
      adjustedDay = lastDayOfTargetMonth;
    }
    return DateTime.utc(
      firstDayOfTargetMonth.year,
      firstDayOfTargetMonth.month,
      adjustedDay,
    );
  }

  @override
  Future<void> deleteAll() async {
    await _db.recurringTransactionDao.hardDeleteAllRecurringTransactions();
  }
}
