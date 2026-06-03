import 'package:budgetit/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/shared/widgets/badge.dart';
import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/shared/widgets/edit_transaction_dialogue.dart';
import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:mockito/mockito.dart';

import 'support/fixtures.dart';
import 'support/mock_db.dart';

late MockDb _mock;

Widget _screen(Widget child) => wrapWithProviders(child, db: _mock.db);

Widget _widget(Widget child) => wrapWithTheme(child);

void _usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
}

Future<void> _openEditDialog(
  WidgetTester tester, {
  String name = 'Coffee',
  double amount = 5.50,
  String category = 'Food',
  List<String> categories = const ['Food', 'Transport'],
  void Function(String, double, IconData, String)? onSave,
  VoidCallback? onDelete,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (ctx) => TextButton(
          onPressed: () => showDialog(
            context: ctx,
            builder: (_) => EditTransactionDialog(
              name: name,
              amount: amount,
              icon: Icons.coffee,
              category: category,
              categories: categories,
              onSave: onSave ?? (n, a, i, c) {},
              onDelete: onDelete,
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  group('TransactionManager', () {
    setUp(() {
      _mock = MockDb();
      final transactions = [
        transactionFixture(id: 't1', shortDescription: 'Water'),
        transactionFixture(id: 't2', shortDescription: 'Electricity'),
        transactionFixture(id: 't3', shortDescription: 'Groceries'),
      ];
      when(
        _mock.transactionDao.getAllTransactions(),
      ).thenAnswer((_) async => transactions);
      when(
        _mock.transactionDao.getTransactionsByType(any),
      ).thenAnswer((_) async => transactions);
    });
    testWidgets('renders without error', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pumpAndSettle();
      expect(find.byType(TransactionManager), findsOneWidget);
    });

    testWidgets('shows search box with hint text', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, 'Search for Transaction');
    });

    testWidgets('shows All, Income, and Expenses filter badges', (
      tester,
    ) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('shows Recent Transactions heading', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      expect(find.text('Recent Transactions'), findsOneWidget);
    });

    testWidgets('shows date header with day and date', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('18 May 2026'), findsOneWidget);
    });

    testWidgets('shows Water, Electricity, and Groceries transactions', (
      tester,
    ) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      expect(find.text('Water'), findsOneWidget);
      expect(find.text('Electricity'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);
    });

    testWidgets('has a floating action button with add icon', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(_screen(const TransactionManager()));
      await tester.pump();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  // SearchBox

  group('SearchBox', () {
    testWidgets('shows hint text when not focused', (tester) async {
      await tester.pumpWidget(
        _widget(
          SearchBox(hintText: 'Search for Transaction', onChanged: (_) {}),
        ),
      );
      await tester.pump();
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, 'Search for Transaction');
    });

    testWidgets('shows search icon when not focused', (tester) async {
      await tester.pumpWidget(
        _widget(SearchBox(hintText: 'Search', onChanged: (_) {})),
      );
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('hides hint text and search icon when focused', (tester) async {
      await tester.pumpWidget(
        _widget(SearchBox(hintText: 'Search', onChanged: (_) {})),
      );
      await tester.pump();

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, isNull);
      expect(find.byIcon(Icons.search), findsNothing);
    });

    testWidgets('onChanged fires with entered text', (tester) async {
      String? captured;
      await tester.pumpWidget(
        _widget(
          SearchBox(hintText: 'Search', onChanged: (val) => captured = val),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'coffee');
      expect(captured, 'coffee');
    });
  });

  // MyBadge

  group('MyBadge', () {
    testWidgets('shows the provided text', (tester) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'All')));
      await tester.pump();
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('starts in unselected state (background fill colour)', (
      tester,
    ) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'Income')));
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MyBadge),
              matching: find.byType(Container),
            )
            .first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().background);
    });

    testWidgets('selected state uses secondary fill', (tester) async {
      await tester.pumpWidget(
        _widget(MyBadge(text: 'Expenses', isSelected: true)),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MyBadge),
              matching: find.byType(Container),
            )
            .first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().secondary);
    });

    testWidgets('unselected badge uses background fill', (tester) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'All')));
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MyBadge),
              matching: find.byType(Container),
            )
            .first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().background);
    });
  });

  // MyBox

  group('MyBox', () {
    Widget makeBox({
      String text = 'Coffee',
      double amount = 5.50,
      String category = 'Food',
      List<String> categories = const ['Food', 'Transport'],
      void Function(String, double, IconData, String)? onEdited,
      VoidCallback? onDelete,
    }) => _widget(
      MyBox(
        text: text,
        amount: amount,
        icon: Icons.coffee,
        category: category,
        categories: categories,
        onEdited: onEdited ?? (n, a, i, c) {},
        onDelete: onDelete ?? () {},
      ),
    );

    testWidgets('shows transaction name', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox(text: 'Coffee'));
      await tester.pump();
      expect(find.text('Coffee'), findsOneWidget);
    });

    testWidgets('shows formatted amount', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox(amount: 5.50));
      await tester.pump();
      expect(find.text('R5.50'), findsOneWidget);
    });

    testWidgets('shows category label when provided', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox(category: 'Food'));
      await tester.pump();
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('tapping opens EditTransactionDialog', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox());
      await tester.pump();

      await tester.tap(find.byType(MyBox));
      await tester.pumpAndSettle();

      expect(find.text('Edit Transaction'), findsOneWidget);
    });

    testWidgets('saving in dialog updates the displayed name', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox(text: 'Coffee'));
      await tester.pump();

      await tester.tap(find.byType(MyBox));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Tea');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Tea'), findsOneWidget);
      expect(find.text('Coffee'), findsNothing);
    });

    testWidgets('cancel in dialog leaves name unchanged', (tester) async {
      _usePhoneSize(tester);
      await tester.pumpWidget(makeBox(text: 'Coffee'));
      await tester.pump();

      await tester.tap(find.byType(MyBox));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Tea');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Tea'), findsNothing);
    });

    testWidgets('delete button in dialog triggers onDelete callback', (
      tester,
    ) async {
      _usePhoneSize(tester);
      bool deleted = false;
      await tester.pumpWidget(makeBox(onDelete: () => deleted = true));
      await tester.pump();

      await tester.tap(find.byType(MyBox));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });
  });

  // EditTransactionDialog

  group('EditTransactionDialog', () {
    testWidgets('shows Edit Transaction title', (tester) async {
      await _openEditDialog(tester);
      expect(find.text('Edit Transaction'), findsOneWidget);
    });

    testWidgets('pre-fills name field with provided name', (tester) async {
      await _openEditDialog(tester, name: 'Coffee');
      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );
      expect(nameField.controller?.text, 'Coffee');
    });

    testWidgets('pre-fills amount field with provided amount', (tester) async {
      await _openEditDialog(tester, amount: 12.50);
      final amountField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(1),
      );
      expect(amountField.controller?.text, '12.50');
    });

    testWidgets('shows category dropdown when categories are provided', (
      tester,
    ) async {
      await _openEditDialog(
        tester,
        categories: ['Food', 'Transport'],
        category: 'Food',
      );
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('shows no dropdown when categories list is empty', (
      tester,
    ) async {
      await _openEditDialog(tester, categories: []);
      expect(find.byType(DropdownButton<String>), findsNothing);
    });

    testWidgets('empty name fails validation and shows error', (tester) async {
      await _openEditDialog(tester, name: 'Coffee');
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('amount field rejects non-numeric input via formatter', (
      tester,
    ) async {
      await _openEditDialog(tester, amount: 5.50);
      await tester.enterText(find.byType(TextFormField).at(1), 'abc');
      await tester.pump();
      final field = tester.widget<TextFormField>(
        find.byType(TextFormField).at(1),
      );
      expect(field.controller?.text, isNot('abc'));
    });

    testWidgets('empty amount fails validation and shows error', (
      tester,
    ) async {
      await _openEditDialog(tester);
      await tester.enterText(find.byType(TextFormField).at(1), '');
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('cancel closes dialog without calling onSave', (tester) async {
      bool saved = false;
      await _openEditDialog(tester, onSave: (n, a, i, c) => saved = true);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Edit Transaction'), findsNothing);
      expect(saved, isFalse);
    });

    testWidgets('save calls onSave with correct name and amount', (
      tester,
    ) async {
      String? capturedName;
      double? capturedAmount;

      await _openEditDialog(
        tester,
        name: 'Coffee',
        amount: 5.50,
        onSave: (n, a, i, c) {
          capturedName = n;
          capturedAmount = a;
        },
      );

      await tester.enterText(find.byType(TextFormField).first, 'Tea');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(capturedName, 'Tea');
      expect(capturedAmount, 5.50);
    });

    testWidgets('delete button visible when onDelete provided', (tester) async {
      await _openEditDialog(tester, onDelete: () {});
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('delete button absent when onDelete is null', (tester) async {
      await _openEditDialog(tester, onDelete: null);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });

  // FABMenu

  group('FABMenu', () {
    testWidgets('shows Add Transaction option', (tester) async {
      await tester.pumpWidget(_widget(const FABMenu()));
      await tester.pump();
      expect(find.text('Add Transaction'), findsOneWidget);
    });

    testWidgets('shows Import PDF/CSV option', (tester) async {
      await tester.pumpWidget(_widget(const FABMenu()));
      await tester.pump();
      expect(find.text('Import PDF/CSV'), findsOneWidget);
    });
  });
}
