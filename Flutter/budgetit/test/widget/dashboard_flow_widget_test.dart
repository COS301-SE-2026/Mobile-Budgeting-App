import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/dashboard/dashboard.dart';

import '../support/mock_db.dart';

void main() {
  testWidgets('Dashboard full flow works', (WidgetTester tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(const Dashboard(), db: mock.db),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Dashboard loads.
    expect(find.text('DASHBOARD'), findsOneWidget);

    // 2. Daily spending card loads.
    expect(find.textContaining('DAILY SPENDING FOR'), findsOneWidget);
    expect(find.textContaining('Monthly total:'), findsOneWidget);

    // 3. Dashboard action buttons load.
    expect(find.text('VIEW INSIGHTS'), findsWidgets);
    expect(find.text('VIEW REPORTS'), findsOneWidget);

    // 4. Recent transactions section loads.
    expect(find.text('RECENT TRANSACTIONS'), findsOneWidget);

    // 5. Financial Health section loads.
    expect(find.text('FINANCIAL HEALTH'), findsOneWidget);
    expect(find.textContaining('/ 100'), findsOneWidget);
    expect(find.text('VIEW HEALTH ANALYSIS'), findsOneWidget);

    // 6. Open Financial Health dialog.
    await tester.tap(find.text('VIEW HEALTH ANALYSIS'));
    await tester.pumpAndSettle();

    // 7. Confirm dialog opened.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Financial Health Analysis'), findsOneWidget);
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Risk Level'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Net Balance'), findsOneWidget);
    expect(find.text('INSIGHTS'), findsWidgets);
    expect(find.text('RECOMMENDATIONS'), findsOneWidget);

    // 8. Close dialog.
    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Dashboard daily filter opens the styled date picker', (
    WidgetTester tester,
  ) async {
    final mock = MockDb();
    final now = DateTime.now();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(const Dashboard(), db: mock.db),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('${now.day}/${now.month}/${now.year}'));
    await tester.pumpAndSettle();

    expect(find.text('SELECT DASHBOARD DATE'), findsOneWidget);
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
