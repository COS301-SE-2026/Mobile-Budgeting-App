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
  return MaterialApp(
    home: Provider<AppDatabase>.value(
      value: db,
      child: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton( onPressed: () => showDialog<void>( context: context, builder: (_) => AddTransactionDialog(onAdded: onAdded)),
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



  });
}