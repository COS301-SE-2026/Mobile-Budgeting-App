import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/components/balance_card.dart';
import 'package:budgetit/components/bill_item.dart';
import 'package:budgetit/components/insight_widget.dart';
import 'package:budgetit/components/monthly_trend_widget.dart';
import 'package:budgetit/components/quick_stats_widgets.dart';
import 'package:budgetit/components/transaction_tile.dart';
import 'package:budgetit/screens/dashboard.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  
  // Dashboard — integration-level: full screen renders correctly
  
  group('Dashboard', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets('shows Upcoming Bills and Recent Transactions section headings',
        (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.text('Upcoming Bills'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
    });

    testWidgets('contains BalanceCard, QuickStatsWidget, MonthlyTrendWidget and InsightWidget',
        (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.byType(BalanceCard), findsOneWidget);
      expect(find.byType(QuickStatsWidget), findsOneWidget);
      expect(find.byType(MonthlyTrendWidget), findsOneWidget);
      expect(find.byType(InsightWidget), findsOneWidget);
    });

    testWidgets('shows Electricity and Netflix bill items', (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.text('Electricity'), findsOneWidget);
      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('shows Groceries and Salary transaction tiles', (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('body is scrollable', (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      // No layout exception = scrolling works
    });
  });

  
  // BalanceCard
  
  group('BalanceCard', () {
    testWidgets('shows monthly spending header text', (tester) async {
      await tester.pumpWidget(_wrap(const BalanceCard()));
      await tester.pump();
      expect(find.text('MONTHLY SPENDING MAY 2026'), findsOneWidget);
    });

    testWidgets('shows current spending amount', (tester) async {
      await tester.pumpWidget(_wrap(const BalanceCard()));
      await tester.pump();
      expect(find.text('R1,850.00'), findsOneWidget);
    });

    testWidgets('shows target amount', (tester) async {
      await tester.pumpWidget(_wrap(const BalanceCard()));
      await tester.pump();
      expect(find.text('Target: R1,950.00'), findsOneWidget);
    });
  });

  
  // QuickStatsWidget
  
  group('QuickStatsWidget', () {
    testWidgets('shows Spending by Category heading', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));
      await tester.pump();
      expect(find.text('Spending by Category'), findsOneWidget);
    });

    testWidgets('shows TOTAL label and R4.2k value in chart centre',
        (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));
      await tester.pump();
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('R4.2k'), findsOneWidget);
    });

    testWidgets('shows all three category rows with correct percentages',
        (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));
      await tester.pump();
      expect(find.text('Housing'), findsOneWidget);
      expect(find.text('30%'), findsOneWidget);
      expect(find.text('Dining'), findsOneWidget);
      expect(find.text('25%'), findsOneWidget);
      expect(find.text('Others'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
    });
  });

  
  // MonthlyTrendWidget
  
  group('MonthlyTrendWidget', () {
    const threeMonths = [
      MonthData(month: 'January 2026', shortMonth: 'Jan', income: 5000, spent: 3000),
      MonthData(month: 'February 2026', shortMonth: 'Feb', income: 5000, spent: 4000),
      MonthData(month: 'March 2026', shortMonth: 'Mar', income: 5000, spent: 2000),
    ];

    testWidgets('shows Monthly Trend heading', (tester) async {
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: threeMonths)));
      await tester.pump();
      expect(find.text('Monthly Trend'), findsOneWidget);
    });

    testWidgets('renders a label for each month provided', (tester) async {
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: threeMonths)));
      await tester.pump();
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
    });

    testWidgets('tapping a month bar does not throw', (tester) async {
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: threeMonths)));
      await tester.pump();
      await tester.tap(find.text('Jan'));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping each bar in sequence rebuilds without error',
        (tester) async {
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: threeMonths)));
      await tester.pump();
      for (final label in ['Jan', 'Feb', 'Mar']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('works with a single month entry', (tester) async {
      const single = [
        MonthData(month: 'Jan 2026', shortMonth: 'Jan', income: 1000, spent: 500),
      ];
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: single)));
      await tester.pump();
      expect(find.text('Jan'), findsOneWidget);
    });

    testWidgets('renders all dashboard months (Mar, Apr, May)', (tester) async {
      const dashboardMonths = [
        MonthData(month: 'March 2026', shortMonth: 'Mar', income: 22000, spent: 14200),
        MonthData(month: 'April 2026', shortMonth: 'Apr', income: 22000, spent: 12800),
        MonthData(month: 'May 2026', shortMonth: 'May', income: 22000, spent: 10000),
      ];
      await tester.pumpWidget(_wrap(MonthlyTrendWidget(months: dashboardMonths)));
      await tester.pump();
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
      expect(find.text('May'), findsOneWidget);
    });
  });

  
 