import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/graphical_reports/graphical_reports_screen.dart';
import 'package:budgetit/models/reporting_period.dart';

import '../support/mock_db.dart';

void main() {
  testWidgets('Graphical Reports screen full flow works', (
    WidgetTester tester,
  ) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: GraphicalReportsScreen(database: mock.db),
      ),
    );

    await tester.pumpAndSettle();

    // 1Screen loading
    expect(find.text('Graphical Reports'), findsOneWidget);

    // 2.Reporting period selector load
    expect(find.byType(DropdownButton<ReportingPeriod>), findsOneWidget);

    // 3Empty/mock database state
    expect(
      find.text('No financial data is available for the selected period.'),
      findsOneWidget,
    );
    expect(
      find.text('Select another reporting period or add transactions.'),
      findsOneWidget,
    );

    Future<void> selectPeriod(ReportingPeriod period) async {
      await tester.tap(find.byType(DropdownButton<ReportingPeriod>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(period.label).last);
      await tester.pumpAndSettle();
    }

    // 4–6. Every reporting period selection
    await selectPeriod(ReportingPeriod.weekly);
    await selectPeriod(ReportingPeriod.monthly);
    await selectPeriod(ReportingPeriod.yearly);

    expect(find.byType(DropdownButton<ReportingPeriod>), findsOneWidget);
  });
}
