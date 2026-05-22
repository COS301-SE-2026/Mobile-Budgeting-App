import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/shared/widgets/badge.dart';
import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/shared/widgets/edit_transaction_dialogue.dart';
import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/transaction_manager/transaction.manager.dart';

// Full-screen widget (already has Scaffold)
Widget _screen(Widget child) => MaterialApp(home: child);

// Component widget (needs Scaffold wrapper)
Widget _widget(Widget child) => MaterialApp(home: Scaffold(body: child));

// MyBox uses height * 0.07 and MyBadge uses maxWidth * 0.25.
// Flutter test uses the Ahem font where each glyph is fontSize×fontSize px,
// so "Expenses" (8 chars, 16 px) = 128 px — wider than 25 % of 800 px (200 px ok).
// 800×1200 gives: MyBadge maxWidth=200px > 128px ✓, MyBox height=84px ✓.
void _usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
}

// Opens an EditTransactionDialog via showDialog and settles animations.
Future<void> _openEditDialog(
  WidgetTester tester, {
  String name = 'Coffee',
  double amount = 5.50,
  String category = 'Food',
  List<String> categories = const ['Food', 'Transport'],
  void Function(String, double, IconData, String)? onSave,
  VoidCallback? onDelete,
}) async {
  await tester.pumpWidget(MaterialApp(
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
  ));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  
  // TransactionManager — full screen
  
  group('TransactionManager', () {
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

    testWidgets('shows All, Income, and Expenses filter badges', (tester) async {
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

    testWidgets('shows Water, Electricity, and Groceries transactions',
        (tester) async {
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
      await tester.pumpWidget(_widget(SearchBox(
        hintText: 'Search for Transaction',
        onChanged: (_) {},
      )));
      await tester.pump();
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, 'Search for Transaction');
    });

    testWidgets('shows search icon when not focused', (tester) async {
      await tester.pumpWidget(_widget(SearchBox(
        hintText: 'Search',
        onChanged: (_) {},
      )));
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('hides hint text and search icon when focused', (tester) async {
      await tester.pumpWidget(_widget(SearchBox(
        hintText: 'Search',
        onChanged: (_) {},
      )));
      await tester.pump();

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration?.hintText, isNull);
      expect(find.byIcon(Icons.search), findsNothing);
    });

    testWidgets('onChanged fires with entered text', (tester) async {
      String? captured;
      await tester.pumpWidget(_widget(SearchBox(
        hintText: 'Search',
        onChanged: (val) => captured = val,
      )));
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

    testWidgets('starts in unselected state (primary fill colour)',
        (tester) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'Income')));
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MyBadge),
          matching: find.byType(Container),
        ).first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().primary);
    });

    testWidgets('pressing once toggles to selected state (secondary fill)',
        (tester) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'Expenses')));
      await tester.pump();

      await tester.tap(find.byType(MyBadge));
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MyBadge),
          matching: find.byType(Container),
        ).first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().secondary);
    });

    testWidgets('pressing twice returns to unselected state (primary fill)',
        (tester) async {
      await tester.pumpWidget(_widget(MyBadge(text: 'All')));
      await tester.pump();

      await tester.tap(find.byType(MyBadge));
      await tester.pump();
      await tester.tap(find.byType(MyBadge));
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(MyBadge),
          matching: find.byType(Container),
        ).first,
      );
      final bg = (container.decoration as BoxDecoration).color;
      expect(bg, MyColours().primary);
    });
  });

  
 