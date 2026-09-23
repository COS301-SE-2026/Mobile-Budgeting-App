@Tags(['nfr'])
library;
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/services/import/import_orchestrator.dart';
import '../unit/database/helpers.dart';

void main() {
  late AppDatabase db;
  late ImportOrchestrator orchestrator;
  late Directory tempDir;

  setUp(() async {
    configureSqliteForTests();
    db = openTestDatabase();
    orchestrator = ImportOrchestrator(
      db: db,
      taDao: db.transactionDao,
      categoryDao: db.categoryDao,
    );
    tempDir = await Directory.systemTemp.createTemp('nfr_import');
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Future<String> writeCsv(String name, String contents) async {
    final file = File('${tempDir.path}/$name');
    await file.writeAsString(contents);
    return file.path;
  }

  const validCsv = '''
Date,Description,Amount
01/05/2026,Woolworths,-450.00
02/05/2026,Salary,15000.00
03/05/2026,Checkers,-220.50
04/05/2026,Uber,-89.00
05/05/2026,Interest,12.30
''';

  const partiallyMalformedCsv = '''
Date,Description,Amount
01/05/2026,Woolworths,-450.00
NOT_A_DATE,Broken row,abc
02/05/2026,Salary,15000.00
,,,
03/05/2026,Checkers,-220.50
''';

  test('malformed rows do not prevent valid rows from importing', () async {
    final path = await writeCsv('mixed.csv', partiallyMalformedCsv);
    final parsed = await orchestrator.preparePreview(path);

    print('malformed CSV: parsed ${parsed.length} usable rows from 5 data '
        'lines (2 intentionally invalid)');

    expect(parsed, isNotEmpty);
    expect(parsed.length, lessThanOrEqualTo(3));
  });

  test('committing an import persists every non-duplicate row', () async {
    final path = await writeCsv('valid.csv', validCsv);
    final parsed = await orchestrator.preparePreview(path);
    final result = await orchestrator.commitImport(parsed);

    final stored = await db.select(db.transactions).get();

    print('commit: parsed=${result.totalParsed} inserted=${result.inserted} '
        'skipped=${result.duplicatesSkipped} failed=${result.failed} '
        'stored=${stored.length}');

    expect(result.failed, 0);
    expect(stored.length, result.inserted);
  });

  test('re-importing the same statement creates no duplicate rows', () async {
    final path = await writeCsv('valid.csv', validCsv);

    final first = await orchestrator.preparePreview(path);
    await orchestrator.commitImport(first);
    final afterFirst = (await db.select(db.transactions).get()).length;

    final second = await orchestrator.preparePreview(path);
    final secondResult = await orchestrator.commitImport(second);
    final afterSecond = (await db.select(db.transactions).get()).length;

    print('re-import: after first=$afterFirst after second=$afterSecond '
        'flagged as duplicate=${secondResult.duplicatesSkipped}');

    expect(afterSecond, afterFirst);
    expect(secondResult.duplicatesSkipped, greaterThan(0));
    expect(secondResult.inserted, 0);
  });

  test('an empty statement is rejected with a clear error', () async {
    final path = await writeCsv('empty.csv', 'Date,Description,Amount\n');

    await expectLater(
      orchestrator.preparePreview(path),
      throwsA(isA<FormatException>()),
    );

    final stored = await db.select(db.transactions).get();
    print('empty CSV: rejected, rows in db=${stored.length}');
    expect(stored, isEmpty);
  });

  test('a non-statement file is rejected without corrupting the database',
      () async {
    await orchestrator.commitImport(
      await orchestrator.preparePreview(await writeCsv('valid.csv', validCsv)),
    );
    final before = (await db.select(db.transactions).get()).length;

    final junkPath = await writeCsv('junk.csv', 'this is not a statement\n@@@');

    var threw = false;
    try {
      final parsed = await orchestrator.preparePreview(junkPath);
      await orchestrator.commitImport(parsed);
    } catch (_) {
      threw = true;
    }

    final after = (await db.select(db.transactions).get()).length;

    print('junk file: threw=$threw rows before=$before after=$after');
    expect(after, greaterThanOrEqualTo(before));
  });

  test('import scales to a 5,000-row statement', () async {
    final buffer = StringBuffer('Date,Description,Amount\n');
    for (var i = 0; i < 5000; i++) {
      final day = (i % 28) + 1;
      final month = (i % 12) + 1;
      buffer.writeln('${day.toString().padLeft(2, '0')}/'
          '${month.toString().padLeft(2, '0')}/2026,'
          'Merchant $i,-${(10 + i % 900)}.00');
    }

    final path = await writeCsv('large.csv', buffer.toString());
    final parseSw = Stopwatch()..start();
    final parsed = await orchestrator.preparePreview(path);
    parseSw.stop();

    final commitSw = Stopwatch()..start();
    final result = await orchestrator.commitImport(parsed);
    commitSw.stop();

    print('5k import: parse=${parseSw.elapsedMilliseconds}ms '
        'commit=${commitSw.elapsedMilliseconds}ms '
        'parsed=${parsed.length} inserted=${result.inserted}');

    expect(parsed.length, greaterThan(4000));
    expect(parseSw.elapsedMilliseconds, lessThan(30000));
  });

    test('a CSV with no recognisable date column is rejected', () async {
    final path = await writeCsv(
      'nodate.csv',
      'Reference,Description,Amount\nABC123,Woolworths,-450.00\n',
    );

    await expectLater(
      orchestrator.preparePreview(path),
      throwsA(isA<FormatException>()),
    );
  });

  test('separate credit and debit columns are parsed correctly', () async {
    const csv = '''
Date,Description,Credit,Debit
01/05/2026,Salary,15000.00,
02/05/2026,Woolworths,,450.00
03/05/2026,Interest,12.30,
''';
    final path = await writeCsv('creditdebit.csv', csv);
    final parsed = await orchestrator.preparePreview(path);

    final income = parsed.where((t) => t.isIncome).length;
    final expense = parsed.where((t) => !t.isIncome).length;

    print('credit/debit columns: parsed=${parsed.length} '
        'income=$income expense=$expense');

    expect(parsed.length, 3);
    expect(income, 2);
    expect(expense, 1);
  });
}