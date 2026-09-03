import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/add_edit_recurring_transaction_dialog.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<AppDatabase> _freshDb() async {
  return AppDatabase.forTesting(NativeDatabase.memory());
}

Widget _wrap(
  AppDatabase db, {
  RecurringTransaction? existing,
  VoidCallback? onSaved,
  VoidCallback? onDeleted,
}) {
  return Provider<AppDatabase>.value(
    value: db,
    child: MaterialApp(
      home: Scaffold(
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
    testWidgets(
      'shows "Add Recurring Transaction" title and no delete button',
      (tester) async {
        await tester.pumpWidget(_wrap(db));
        await _openDialog(tester);

        expect(find.text('Add Recurring Transaction'), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsNothing);
        expect(find.text('Add'), findsOneWidget);
      },
    );

    testWidgets('defaults to Expense and Monthly recurrence', (tester) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);

      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Repeats every month'), findsOneWidget);
    });

    testWidgets('shows validation errors when saving with empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Description is required'), findsOneWidget);
      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('rejects a description longer than 100 characters', (
      tester,
    ) async {
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
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Gym membership',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '0');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid amount'), findsOneWidget);
    });

    testWidgets('switching to Income updates the type toggle selection', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Income'));
      await tester.pump();

      expect(find.text('Income'), findsOneWidget);
    });

    testWidgets('recurrence dropdown changes the selected repeat unit', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);

      expect(find.text('Monthly'), findsOneWidget);
      await tester.tap(find.text('Monthly'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();
      expect(find.text('Repeats every week'), findsOneWidget);
    });

    testWidgets('recurrence dropdown supports a fortnightly preset', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);

      await tester.tap(find.text('Monthly'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Every 2 weeks'));
      await tester.pumpAndSettle();
      expect(find.text('Repeats fortnightly'), findsOneWidget);
    });

    testWidgets('Cancel closes the dialog without creating a record', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Add Recurring Transaction'), findsNothing);
      final all = await db.recurringTransactionDao
          .getAllRecurringTransactions();
      expect(all, isEmpty);
    });

    testWidgets(
      'saving a valid new recurring transaction persists it, closes, and calls onSaved',
      (tester) async {
        var savedCalled = false;
        await tester.pumpWidget(_wrap(db, onSaved: () => savedCalled = true));
        await _openDialog(tester);
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Spotify subscription',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '99.00');
        await tester.tap(find.text('Monthly'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Every 2 weeks'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Add'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        expect(find.text('Add Recurring Transaction'), findsNothing);
        expect(savedCalled, isTrue);
        final all = await db.recurringTransactionDao
            .getAllRecurringTransactions();
        expect(all, hasLength(1));
        final rt = all.first;
        expect(rt.shortDescription, equals('Spotify subscription'));
        expect(rt.amount.toStringAsFixed(2), equals('99.00'));
        expect(rt.unit, equals(PeriodType.weekly));
        expect(rt.intervalAmount, equals(2));
        expect(rt.type, equals(TransactionType.expense));
        expect(rt.nextTransactionDate, equals(rt.startDate));
      },
    );

    testWidgets(
      'saving a new income recurring transaction stores TransactionType.income',
      (tester) async {
        await tester.pumpWidget(_wrap(db));
        await _openDialog(tester);
        await tester.tap(find.text('Income'));
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Freelance retainer',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '5000.00');
        await tester.ensureVisible(find.text('Add'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        final all = await db.recurringTransactionDao
            .getAllRecurringTransactions();
        expect(all, hasLength(1));
        expect(all.first.type, equals(TransactionType.income));
      },
    );
  });
  group('edit mode', () {
    testWidgets(
      'shows "Edit Recurring Transaction" title, a delete button, pre-filled fields, and "Save"',
      (tester) async {
        final existing = await _seedExisting(
          db,
          shortDescription: 'Netflix subscription',
          amount: '199.00',
        );
        await tester.pumpWidget(_wrap(db, existing: existing));
        await _openDialog(tester);

        expect(find.text('Edit Recurring Transaction'), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        final descField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(0),
        );
        expect(descField.controller?.text, equals('Netflix subscription'));
        final amountField = tester.widget<TextFormField>(
          find.byType(TextFormField).at(1),
        );
        expect(amountField.controller?.text, equals('199.00'));
      },
    );

    testWidgets('pre-selects the existing unit and interval', (tester) async {
      final existing = await _seedExisting(
        db,
        unit: PeriodType.yearly,
        intervalAmount: 3,
      );
      await tester.pumpWidget(_wrap(db, existing: existing));
      await _openDialog(tester);

      expect(find.text('Every 3 years'), findsOneWidget);
      expect(find.text('Current custom schedule'), findsOneWidget);
    });

    testWidgets('saving edits updates the existing record in place', (
      tester,
    ) async {
      final existing = await _seedExisting(
        db,
        shortDescription: 'Old name',
        amount: '50.00',
      );
      var savedCalled = false;
      await tester.pumpWidget(
        _wrap(db, existing: existing, onSaved: () => savedCalled = true),
      );
      await _openDialog(tester);
      final descField = find.byType(TextFormField).at(0);
      await tester.enterText(descField, '');
      await tester.enterText(descField, 'Updated name');
      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '');
      await tester.enterText(amountField, '75.50');
      await tester.ensureVisible(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedCalled, isTrue);
      final all = await db.recurringTransactionDao
          .getAllRecurringTransactions();
      expect(all, hasLength(1));
      expect(all.first.id, equals(existing.id));
      expect(all.first.shortDescription, equals('Updated name'));
      expect(all.first.amount.toStringAsFixed(2), equals('75.50'));
    });

    testWidgets(
      'tapping the delete icon soft-deletes the record, closes, and calls onDeleted',
      (tester) async {
        final existing = await _seedExisting(db);
        var deletedCalled = false;
        await tester.pumpWidget(
          _wrap(db, existing: existing, onDeleted: () => deletedCalled = true),
        );
        await _openDialog(tester);
        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        expect(find.text('Edit Recurring Transaction'), findsNothing);
        expect(deletedCalled, isTrue);
        final active = await db.recurringTransactionDao
            .getAllRecurringTransactions();
        expect(active, isEmpty);
        final includingDeleted = await db.recurringTransactionDao
            .getAllRecurringTransactions(includeDeleted: true);
        expect(includingDeleted, hasLength(1));
        expect(includingDeleted.first.deletedAt, isNotNull);
      },
    );

    testWidgets('Cancel in edit mode leaves the existing record untouched', (
      tester,
    ) async {
      final existing = await _seedExisting(db, shortDescription: 'Untouched');
      await tester.pumpWidget(_wrap(db, existing: existing));
      await _openDialog(tester);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Should not be saved',
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      final all = await db.recurringTransactionDao
          .getAllRecurringTransactions();

      expect(all.first.shortDescription, equals('Untouched'));
    });
  });
}
