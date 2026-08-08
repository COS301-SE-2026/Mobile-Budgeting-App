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

group('Add mode', () {
  testWidgets('shows "Add Recurring Transaction" title and no delete button', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    expect(find.text('Add Recurring Transaction'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('defaults to Expense, Monthly, interval 1', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    expect(find.text('1 month'), findsOneWidget);
  });

  testWidgets('shows validation errors when saving with empty fields', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Description is required'), findsOneWidget);
    expect(find.text('Amount is required'), findsOneWidget);
  });

  testWidgets('rejects a description longer than 100 characters', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    final descField = find.byType(TextFormField).at(0);
    await tester.enterText(descField, 'x' * 101);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Must be 100 characters or less'), findsOneWidget);
  });

  testWidgets('rejects a zero amount', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Gym membership');
    await tester.enterText(find.byType(TextFormField).at(1), '0');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid amount'), findsOneWidget);
  });

  testWidgets('switching to Income updates the type toggle selection', (tester) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Income'));
      await tester.pump();

      expect(find.text('Income'), findsOneWidget);
  });

  testWidgets('tapping a period button changes the selected repeat unit', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);
    await tester.tap(find.text('Weekly'));
    await tester.pump();
    expect(find.text('1 week'), findsOneWidget);
  });

  testWidgets('increment button raises the interval and pluralises the noun', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    expect(find.text('1 month'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2 months'), findsOneWidget);
  });

  testWidgets('decrement button never goes below interval 1', (tester) async {
    await tester.pumpWidget(_wrap(db));
    await _openDialog(tester);

    expect(find.text('1 month'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1 month'), findsOneWidget);
  });






});



}