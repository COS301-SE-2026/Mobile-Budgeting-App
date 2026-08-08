import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/add_edit_recurring_transaction_dialog.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<AppDatabase> _freshDb() async { return AppDatabase.forTesting(NativeDatabase.memory());}

Widget _wrap(
  AppDatabase db, {
  RecurringTransaction? existing,
  VoidCallback? onSaved,
  VoidCallback? onDeleted,
}) {
  return MaterialApp(
    home: Provider<AppDatabase>.value(
      value: db,
      child: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AddEditRecurringTransactionDialog(
                existing: existing,
                onSaved: onSaved,
                onDeleted: onDeleted,
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}



Future<void> _openDialog(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

Future<RecurringTransaction> _seedExisting(
  AppDatabase db, {
  String shortDescription = 'Netflix subscription',
  String amount = '199.00',
  TransactionType type = TransactionType.expense,
  PeriodType unit = PeriodType.monthly,
  int intervalAmount = 1,
  DateTime? startDate,
}) {
  final start = startDate ?? DateTime.utc(2026, 1, 15);
  return db.recurringTransactionDao.insertRecurringTransaction(
    amount: Decimal.parse(amount),
    type: type,
    shortDescription: shortDescription,
    nextTransactionDate: start,
    unit: unit,
    intervalAmount: intervalAmount,
    startDate: start,
  );
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await _freshDb();
  });

  tearDown(() async {
    await db.close();
  });




}