@Tags(['nfr'])
library;
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import '../unit/database/helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
  });

  tearDown(() async => db.close());

  Future<void> seed(int count, {int offset = 0}) async {
    final base = DateTime(2025, 1, 1);
    await db.batch((b) {
      for (var i = offset; i < offset + count; i++) {
        final date = base.add(Duration(days: i % 730));
        b.insert(
          db.transactions,
          TransactionsCompanion.insert(
            id: 'scale-$i',
            amount: Decimal.fromInt(10 + (i % 500)),
            type: i % 4 == 0 ? TransactionType.income : TransactionType.expense,
            shortDescription: 'Scale transaction $i',
            transactionDate: date,
            createdAt: date,
            updatedAt: date,
            source: TransactionSource.import,
          ),
        );
      }
    });
  }

  Future<int> medianMicros(Future<void> Function() action,
      {int runs = 5}) async {
    final timings = <int>[];
    for (var i = 0; i < runs; i++) {
      final sw = Stopwatch()..start();
      await action();
      sw.stop();
      timings.add(sw.elapsedMicroseconds);
    }
    timings.sort();
    return timings[timings.length ~/ 2];
  }

  Future<void> dateRangeQuery() async {
    await (db.select(db.transactions)
          ..where((t) => t.transactionDate
              .isBetweenValues(DateTime(2025, 6, 1), DateTime(2025, 6, 30)))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  Future<void> aggregateQuery() async {
    final q = db.selectOnly(db.transactions)
      ..addColumns([db.transactions.id.count()])
      ..where(db.transactions.type.equalsValue(TransactionType.expense));
    await q.getSingle();
  }

  test('date-range query degrades sub-linearly from 10k to 20k', () async {
    await seed(10000);
    final at10k = await medianMicros(dateRangeQuery);

    await seed(10000, offset: 10000);
    final at20k = await medianMicros(dateRangeQuery);

    final ratio = at20k / at10k;
    print('date-range  10k: ${at10k}us   20k: ${at20k}us   '
        'ratio: ${ratio.toStringAsFixed(2)}x');

    expect(ratio, lessThan(2.5));
  });

  test('aggregate degrades sub-linearly from 10k to 20k', () async {
    await seed(10000);
    final at10k = await medianMicros(aggregateQuery);

    await seed(10000, offset: 10000);
    final at20k = await medianMicros(aggregateQuery);

    final ratio = at20k / at10k;
    print('aggregate   10k: ${at10k}us   20k: ${at20k}us   '
        'ratio: ${ratio.toStringAsFixed(2)}x');

    expect(ratio, lessThan(2.5));
  });

  test('insert throughput holds steady as the table grows', () async {
    await seed(10000);

    final sw1 = Stopwatch()..start();
    await seed(10000, offset: 10000);
    sw1.stop();

    final sw2 = Stopwatch()..start();
    await seed(10000, offset: 20000);
    sw2.stop();

    print('insert 10k into 10k table: ${sw1.elapsedMilliseconds}ms   '
        'into 20k table: ${sw2.elapsedMilliseconds}ms');

    expect(sw2.elapsedMilliseconds, lessThan(sw1.elapsedMilliseconds * 3));
  });
}