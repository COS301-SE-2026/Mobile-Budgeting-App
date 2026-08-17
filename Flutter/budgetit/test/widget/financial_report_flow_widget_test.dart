import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/financial_reports/financial_report_screen.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
      ),
      home: const FinancialReportScreen(),
    );
  }

  testWidgets('Financial Report screen loads export options', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Financial Reports'), findsOneWidget);
    expect(
      find.text(
        'Export this month’s financial report using your saved transactions.',
      ),
      findsOneWidget,
    );
    expect(find.text('Export as PDF'), findsOneWidget);
    expect(find.text('Export as CSV'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
    expect(find.byIcon(Icons.table_chart), findsOneWidget);
  });

  testWidgets('Financial Report screen has no loader before export', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Financial Report PDF export button can be tapped', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Export as PDF'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Financial Report CSV export button can be tapped', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Export as CSV'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
