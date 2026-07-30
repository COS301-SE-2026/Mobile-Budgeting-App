import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/transaction_manager/transaction.manager.dart';

import 'package:budgetit/shared/widgets/fab.dart';
import '../support/mock_db.dart';

void main() {
  testWidgets('Transaction Manager full flow works', (
    WidgetTester tester,
  ) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(const TransactionManager(), db: mock.db),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Screen loads with search field.
    expect(find.text('Search for Transaction'), findsOneWidget);

    // 2. Filter badges are visible.
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);

    // 3. Recent transactions section loads.
    expect(find.text('RECENT TRANSACTIONS'), findsOneWidget);

    // 4. Empty database state is shown.
    expect(find.text('No transactions yet'), findsOneWidget);

    // 5. Search works and updates empty-state message.
    await tester.enterText(find.byType(TextField), 'groceries');
    await tester.pumpAndSettle();

    expect(find.text('No results for "groceries"'), findsOneWidget);

    // 6. Income filter can be tapped.
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();

    expect(find.text('Income'), findsOneWidget);

    // 7. Expenses filter can be tapped.
    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();

    expect(find.text('Expenses'), findsOneWidget);

    // 8. All filter can be tapped again.
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);

    // 9. Floating action button exists.
    expect(find.byType(FAB), findsWidgets);
  });
}
