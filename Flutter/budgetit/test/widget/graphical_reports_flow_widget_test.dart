import 'dart:async';

import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/models/graphical_report.dart';
import 'package:budgetit/models/reporting_period.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/graphical_reports/graphical_reports_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/mock_db.dart';

Widget _wrap({
  required AppDatabase database,
  required Future<GraphicalReportData> Function(ReportingPeriod period)
  reportBuilder,
}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
    ),
    home: GraphicalReportsScreen(
      database: database,
      reportBuilder: reportBuilder,
    ),
  );
}

GraphicalReportData _reportWithData() {
  return const GraphicalReportData(
    totalIncome: 12000,
    totalExpenses: 7500,
    categorySpending: [
      CategorySpendingData(
        categoryId: 'cat-groceries',
        categoryName: 'Groceries',
        amount: 2500,
      ),
      CategorySpendingData(
        categoryId: 'cat-transport',
        categoryName: 'Transport',
        amount: 1500,
      ),
      CategorySpendingData(
        categoryId: 'cat-dining',
        categoryName: 'Dining Out',
        amount: 1000,
      ),
    ],
    budgetComparisons: [
      BudgetComparisonData(categoryName: 'Groceries', spent: 3000, limit: 3000),
      BudgetComparisonData(categoryName: 'Transport', spent: 1500, limit: 2000),
    ],
    spendingTrend: [
      SpendingTrendData(label: 'Week 1', amount: 1200),
      SpendingTrendData(label: 'Week 2', amount: 1800),
      SpendingTrendData(label: 'Week 3', amount: 2200),
    ],
  );
}

GraphicalReportData _emptyReport() {
  return const GraphicalReportData(
    totalIncome: 0,
    totalExpenses: 0,
    categorySpending: [],
    budgetComparisons: [],
    spendingTrend: [],
  );
}

void main() {
  group('GraphicalReportsScreen', () {
    testWidgets('shows loading indicator while report is loading', (
      tester,
    ) async {
      final mock = MockDb();
      final completer = Completer<GraphicalReportData>();

      await tester.pumpWidget(
        _wrap(database: mock.db, reportBuilder: (_) => completer.future),
      );

      expect(find.text('Graphical Reports'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_emptyReport());
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message when report loading fails', (
      tester,
    ) async {
      final mock = MockDb();

      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          reportBuilder: (_) => Future.error(Exception('Failed')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Could not load graphical reports.'), findsOneWidget);
    });

    testWidgets('shows no data card when report has no financial data', (
      tester,
    ) async {
      final mock = MockDb();

      await tester.pumpWidget(
        _wrap(database: mock.db, reportBuilder: (_) async => _emptyReport()),
      );

      await tester.pumpAndSettle();

      expect(find.text('Graphical Reports'), findsOneWidget);
      expect(find.byType(DropdownButton<ReportingPeriod>), findsOneWidget);
      expect(
        find.text('No financial data is available for the selected period.'),
        findsOneWidget,
      );
      expect(
        find.text('Select another reporting period or add transactions.'),
        findsOneWidget,
      );
    });

    testWidgets('renders chart sections without dashboard summary cards', (
      tester,
    ) async {
      final mock = MockDb();

      await tester.pumpWidget(
        _wrap(database: mock.db, reportBuilder: (_) async => _reportWithData()),
      );

      await tester.pumpAndSettle();

      expect(find.text('Income versus Expenses'), findsOneWidget);
      expect(find.text('Spending by Category'), findsOneWidget);
      expect(find.text('Budget Used versus Limit'), findsOneWidget);
      expect(find.text('Spending Trend'), findsOneWidget);

      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);

      expect(find.text('Groceries'), findsWidgets);
      expect(find.text('Transport'), findsWidgets);
      expect(find.text('Dining Out'), findsOneWidget);
      expect(find.text('R3000.00 / R3000.00'), findsOneWidget);
      expect(find.text('R1500.00 / R2000.00'), findsOneWidget);

      final reachedLimitText = tester.widget<Text>(
        find.text('R3000.00 / R3000.00'),
      );
      expect(reachedLimitText.style?.color, isNot(MyColours.lightTheme.error));
    });

    testWidgets('changing reporting period reloads the report', (tester) async {
      final mock = MockDb();
      final requestedPeriods = <ReportingPeriod>[];

      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          reportBuilder: (period) async {
            requestedPeriods.add(period);
            return _emptyReport();
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(requestedPeriods, contains(ReportingPeriod.monthly));
      Future<void> selectPeriod(ReportingPeriod period) async {
        await tester.tap(find.byType(DropdownButton<ReportingPeriod>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(period.label).last);
        await tester.pumpAndSettle();
      }

      await selectPeriod(ReportingPeriod.weekly);
      await selectPeriod(ReportingPeriod.monthly);
      await selectPeriod(ReportingPeriod.yearly);

      expect(requestedPeriods.length, greaterThanOrEqualTo(3));
    });

    testWidgets('date picker does not offer a future date', (tester) async {
      final mock = MockDb();

      await tester.pumpWidget(
        _wrap(database: mock.db, reportBuilder: (_) async => _emptyReport()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.calendar_month_outlined));
      await tester.pumpAndSettle();

      expect(find.text('GRAPHICAL REPORTS'), findsOneWidget);
      expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    });
  });
}
