@Tags(['nfr'])
library;
import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/models/import/statement_schema.dart';
import '../unit/database/helpers.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    configureSqliteForTests();
    tempDir = await Directory.systemTemp.createTemp('nfr_migration');
  });

  tearDown(() async {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  File dbFile(String name) => File('${tempDir.path}/$name.sqlite');

  test('a fresh database is created at the current schema version', () async {
    final db = openTestDatabase();
    await db.customSelect('SELECT 1').get();

    final version = await db
        .customSelect('PRAGMA user_version')
        .map((r) => r.read<int>('user_version'))
        .getSingle();
    print('fresh database user_version=$version '
        '(expected ${db.schemaVersion})');
    expect(version, db.schemaVersion);
    await db.close();
  });

  test('every declared table exists after creation', () async {
    final db = openTestDatabase();
    await db.customSelect('SELECT 1').get();
    final names = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type='table'")
        .map((r) => r.read<String>('name'))
        .get();
    final expected = db.allTables.map((t) => t.actualTableName).toList();
    print('tables created: ${expected.length} -> $expected');
    for (final table in expected) {
      expect(names, contains(table), reason: 'missing table $table');
    }
    await db.close();
  });

  test('data written before a reopen survives the migration path', () async {
    final file = dbFile('persist');
    final first = AppDatabase.forTesting(NativeDatabase(file));
    await first.transactionDao.insertTransaction(
      amount: Decimal.parse('123.45'),
      type: TransactionType.expense,
      shortDescription: 'Pre-migration row',
      transactionDate: DateTime(2026, 5, 1),
      source: TransactionSource.manual,
    );
    final before = await first.transactionDao.getAllTransactions();
    await first.close();
    final second = AppDatabase.forTesting(NativeDatabase(file));
    final after = await second.transactionDao.getAllTransactions();

    print('reopen: rows before=${before.length} after=${after.length} '
        'amount=${after.first.amount}');
    expect(after.length, before.length);
    expect(after.first.amount, Decimal.parse('123.45'));
    await second.close();
  });

  test('the schema cache table is usable after migration', () async {
    final db = openTestDatabase();
    await db.schemaCacheDao.put(
      'test-fingerprint',
      const StatementSchema(signConvention: SignConvention.crSuffixMeansIncome),
    );
    final retrieved = await db.schemaCacheDao.get('test-fingerprint');

    print('schema cache round-trip: ${retrieved?.signConvention}');
    expect(retrieved, isNot(null));
    expect(retrieved!.signConvention, SignConvention.crSuffixMeansIncome);
    await db.close();
  });

  test('reopening an already-migrated database is a no-op', () async {
    final file = dbFile('idempotent');
    final first = AppDatabase.forTesting(NativeDatabase(file));
    await first.customSelect('SELECT 1').get();
    await first.close();
    final second = AppDatabase.forTesting(NativeDatabase(file));
    final version = await second
        .customSelect('PRAGMA user_version')
        .map((r) => r.read<int>('user_version'))
        .getSingle();
    await second.close();
    final third = AppDatabase.forTesting(NativeDatabase(file));
    final rows = await third.transactionDao.getAllTransactions();

    print('reopened twice: version=$version rows=${rows.length}');
    expect(version, 3);
    await third.close();
  });
}