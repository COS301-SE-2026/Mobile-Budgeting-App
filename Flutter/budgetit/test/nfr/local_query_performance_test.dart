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

  const int scale = 10000;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
  });

  tearDown(() async => db.close());

  Future<int> seed(int count) async {
    final base = DateTime(2025, 1, 1);
    final sw = Stopwatch()..start();

    await db.batch((b) {
      for (var i = 0; i < count; i++) {
        final date = base.add(Duration(days: i % 730));
        b.insert(
          db.transactions,
          TransactionsCompanion.insert(
            id: 'perf-$i',
            amount: Decimal.fromInt(10 + (i % 500)),
            type: i % 4 == 0 ? TransactionType.income : TransactionType.expense,
            shortDescription: 'Perf transaction $i',
            transactionDate: date,
            createdAt: date,
            updatedAt: date,
            source: TransactionSource.import,
          ),
        );
      }
    });

    sw.stop();
    return sw.elapsedMilliseconds;
  }

  test('NFR-01-a: inserts 10,000 transactions within budget', () async {
    final ms = await seed(scale);
    print('NFR-01-a  insert $scale rows: ${ms}ms');

    final count = await db.transactions.count().getSingle();
    expect(count, scale);
    expect(ms, lessThan(15000));
  });

  test('NFR-01-b: full table read at 10k stays under 1s', () async {
    await seed(scale);

    final sw = Stopwatch()..start();
    final rows = await db.select(db.transactions).get();
    sw.stop();

    print('NFR-01-b  read $scale rows: ${sw.elapsedMilliseconds}ms');
    expect(rows.length, scale);
    expect(sw.elapsedMilliseconds, lessThan(1000));
  });

  test('NFR-01-c: date-range query at 10k stays under 300ms', () async {
    await seed(scale);

    final from = DateTime(2025, 6, 1);
    final to = DateTime(2025, 6, 30);

    final sw = Stopwatch()..start();
    final rows = await (db.select(db.transactions)
          ..where((t) => t.transactionDate.isBetweenValues(from, to))
          ..where((t) => t.deletedAt.isNull()))
        .get();
    sw.stop();

    print('NFR-01-c  date-range query: ${sw.elapsedMilliseconds}ms '
        '(${rows.length} rows)');
    expect(rows, isNotEmpty);
    expect(sw.elapsedMilliseconds, lessThan(300));
  });

  test('NFR-01-d: aggregate over 10k stays under 500ms', () async {
    await seed(scale);

    final sw = Stopwatch()..start();
    final query = db.selectOnly(db.transactions)
      ..addColumns([db.transactions.id.count()])
      ..where(db.transactions.type.equalsValue(TransactionType.expense));
    final result = await query.getSingle();
    sw.stop();

    print('NFR-01-d  aggregate: ${sw.elapsedMilliseconds}ms');
    expect(result.read(db.transactions.id.count()), greaterThan(0));
    expect(sw.elapsedMilliseconds, lessThan(500));
  });
}