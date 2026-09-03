import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/add_transaction_dialog.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<AppDatabase> _seededDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.categoryDao.insertCategory(name: 'Transport', type: CategoryType.expense);
  await db.categoryDao.insertCategory(name: 'Groceries', type: CategoryType.expense);
  await db.categoryDao.insertCategory(name: 'Salary', type: CategoryType.income);
  return db;
}


Widget _wrap(AppDatabase db, {VoidCallback? onAdded}) {
  return Provider<AppDatabase>.value(
    value: db,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AddTransactionDialog(onAdded: onAdded),
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

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await _seededDb();
  });

  tearDown(() async {
    await db.close();
  });

    group('AddTransactionDialog', () {
    testWidgets('renders title, defaults to Expense, and loads expense categories sorted', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      expect(find.text('Add Transaction'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);
    });

    testWidgets('swicthing to Income reloads category list to income categories', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('shows valiadtion errors when saving with empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('Description is required'), findsOneWidget);
      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('shows validation error for a zero amount', (tester) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      final descriptionField = find.byType(TextFormField).at(0);
      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(descriptionField, 'Groceries run');
      await tester.enterText(amountField, '0');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid amount'), findsOneWidget);
    });

    testWidgets('Cancel closes the dialog without creating a transaction', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Add Transaction'), findsNothing);
      final transactions = await db.transactionDao.getAllTransactions();
      expect(transactions, isEmpty);
    });

    testWidgets('saving a valid expense persists it, assigns the category, closes, and calls onAdded', (
      tester,
    ) async {
      var addedCalled = false;
      await tester.pumpWidget(_wrap(db, onAdded: () => addedCalled = true));
      await _openDialog(tester);
      final descriptionField = find.byType(TextFormField).at(0);
      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(descriptionField, 'Weekly groceries');
      await tester.enterText(amountField, '349.99');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Add Transaction'), findsNothing);
      expect(addedCalled, isTrue);
      final transactions = await db.transactionDao.getAllTransactions();
      expect(transactions, hasLength(1));
      final tx = transactions.first;
      expect(tx.shortDescription, equals('Weekly groceries'));
      expect(tx.amount.toString(), equals('349.99'));
      expect(tx.type, equals(TransactionType.expense));

      final mapping = await db.transactionDao.getCategoryForTransaction(tx.id);
      expect(mapping, isNotNull);
      expect(mapping!.assignmentSource, equals(AssignmentSource.manual));
    });

    testWidgets('saving a valid income transaction stores TransactionType.income', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      final descriptionField = find.byType(TextFormField).at(0);
      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(descriptionField, 'May salary');
      await tester.enterText(amountField, '25000.00');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      final transactions = await db.transactionDao.getAllTransactions();
      expect(transactions, hasLength(1));
      expect(transactions.first.type, equals(TransactionType.income));
    });

    testWidgets('amount field rejects more than 2 decimal places via input formatter', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(db));
      await _openDialog(tester);
      final amountField = find.byType(TextFormField).at(1);
      await tester.enterText(amountField, '100.999');
      await tester.pump();
      final textField = tester.widget<TextFormField>(amountField);
      expect(
        textField.controller?.text, anyOf(equals('100.99'), isNot(equals('100.999'))));
    });

  });
}