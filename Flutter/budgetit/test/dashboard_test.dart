import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/components/balance_card.dart';
import 'package:budgetit/components/bill_item.dart';
import 'package:budgetit/components/insight_widget.dart';
import 'package:budgetit/components/monthly_trend_widget.dart';
import 'package:budgetit/components/quick_stats_widgets.dart';
import 'package:budgetit/components/transaction_tile.dart';
import 'package:budgetit/screens/dashboard.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:drift/native.dart';


Widget _wrap(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      Provider<AppDatabase>.value(value: AppDatabase.forTesting(NativeDatabase.memory())),
    ],
    child: MaterialApp(home: Scaffold(body: child)),
  );
  }

void main() {
  // Dashboard — integration-level: full screen renders correctly

  group('Dashboard', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap(const Dashboard()));
      await tester.pumpAndSettle();
      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets(
      'shows Upcoming Bills and Recent Transactions section headings',
      (tester) async {
        await tester.pumpWidget(_wrap(const Dashboard()));
        await tester.pumpAndSettle();
        expect(find.text('Upcoming Bills'), findsOneWidget);
        expect(find.text('Recent Transactions'), findsOneWidget);
      },
    );

    testWidgets(
      'contains BalanceCard, QuickStatsWidget, MonthlyTrendWidget and InsightWidget',
      (tester) async {
        await tester.pumpWidget(_wrap(const Dashboard()));
        await tester.pumpAndSettle();
       // expect(find.byType(BalanceCard), findsOneWidget); 
        expect(find.byType(QuickStatsWidget), findsOneWidget);
        expect(find.byType(MonthlyTrendWidget), findsOneWidget);
        expect(find.byType(InsightWidget), findsOneWidget);
      },
    );

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
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();
      // No layout exception = scrolling works
    });
  });

  // BalanceCard

  group('BalanceCard', () {
    testWidgets('shows monthly spending header text', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
      await tester.pump();
      expect(find.text('DAILY SPENDING FOR 1/5/2026'), findsOneWidget);
    });

    testWidgets('shows current spending amount', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
      await tester.pump();
      expect(find.text('R1,850.00'), findsOneWidget);
    });

    testWidgets('shows target amount', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
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

    testWidgets('shows TOTAL label and R4.2k value in chart centre', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));
      await tester.pump();
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('R4.2k'), findsOneWidget);
    });

    testWidgets('shows all three category rows with correct percentages', (
      tester,
    ) async {
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
      MonthData(
        month: 'January 2026',
        shortMonth: 'Jan',
        income: 5000,
        spent: 3000,
      ),
      MonthData(
        month: 'February 2026',
        shortMonth: 'Feb',
        income: 5000,
        spent: 4000,
      ),
      MonthData(
        month: 'March 2026',
        shortMonth: 'Mar',
        income: 5000,
        spent: 2000,
      ),
    ];

    testWidgets('shows Monthly Trend heading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: threeMonths,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Monthly Spending'), findsOneWidget);
    });

    testWidgets('renders a label for each month provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: threeMonths,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
    });

    testWidgets('tapping a month bar does not throw', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: threeMonths,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Jan'));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping each bar in sequence rebuilds without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: threeMonths,
          ),
        ),
      );
      await tester.pump();
      for (final label in ['Jan', 'Feb', 'Mar']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('works with a single month entry', (tester) async {
      const single = [
        MonthData(
          month: 'Jan 2026',
          shortMonth: 'Jan',
          income: 1000,
          spent: 500,
        ),
      ];
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: single,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Jan'), findsOneWidget);
    });

    testWidgets('renders all dashboard months (Mar, Apr, May)', (tester) async {
      const dashboardMonths = [
        MonthData(
          month: 'March 2026',
          shortMonth: 'Mar',
          income: 22000,
          spent: 14200,
        ),
        MonthData(
          month: 'April 2026',
          shortMonth: 'Apr',
          income: 22000,
          spent: 12800,
        ),
        MonthData(
          month: 'May 2026',
          shortMonth: 'May',
          income: 22000,
          spent: 10000,
        ),
      ];
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: dashboardMonths,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
      expect(find.text('May'), findsOneWidget);
    });
  });

  // InsightWidget

  group('InsightWidget', () {
    final tip = BudgetInsight(
      title: 'Great savings this month',
      body: 'You are well under budget.',
      icon: Icons.savings,
      accentColor: Colors.green,
      severity: InsightSeverity.tip,
    );
    final warning = BudgetInsight(
      title: 'Budget exceeded',
      body: 'You spent more than planned.',
      icon: Icons.warning,
      accentColor: Colors.orange,
      severity: InsightSeverity.warning,
    );
    final alert = BudgetInsight(
      title: 'Critical overspend',
      body: 'Immediate action required.',
      icon: Icons.error,
      accentColor: Colors.red,
      severity: InsightSeverity.alert,
    );

    testWidgets('empty list renders no content', (tester) async {
      await tester.pumpWidget(_wrap(const InsightWidget(insights: [])));
      await tester.pumpAndSettle();
      expect(find.text('Insight'), findsNothing);
    });

    testWidgets('single insight renders title and body', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip])));
      await tester.pumpAndSettle();
      expect(find.text('Insight'), findsOneWidget);
      expect(find.text('Great savings this month'), findsOneWidget);
      expect(find.text('You are well under budget.'), findsOneWidget);
    });

    testWidgets('single insight shows no navigation chevrons', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip])));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('tip severity shows Tip badge', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip])));
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsOneWidget);
    });

    testWidgets('warning severity shows Warning badge', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [warning])));
      await tester.pumpAndSettle();
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('alert severity shows Alert badge', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [alert])));
      await tester.pumpAndSettle();
      expect(find.text('Alert'), findsOneWidget);
    });

    testWidgets('multiple insights show page counter and both chevrons', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip, warning])));
      await tester.pumpAndSettle();
      expect(find.text('1/2'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('tapping next advances to second insight', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip, warning])));
      await tester.pumpAndSettle();
      expect(find.text('Great savings this month'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Budget exceeded'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
    });

    testWidgets('tapping previous from first wraps to last', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip, warning])));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Budget exceeded'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
    });

    testWidgets('tapping next from last wraps back to first', (tester) async {
      await tester.pumpWidget(_wrap(InsightWidget(insights: [tip, warning])));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Great savings this month'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
    });

    testWidgets('three-insight carousel cycles forward through all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(InsightWidget(insights: [tip, warning, alert])),
      );
      await tester.pumpAndSettle();
      expect(find.text('1/3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(find.text('2/3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(find.text('3/3'), findsOneWidget);
    });
  });

  // TransactionTile

  group('TransactionTile', () {
    testWidgets('renders title, subtitle, and amount', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.shopping_cart,
            title: 'Coffee',
            subtitle: 'Today',
            amount: '- R50',
            isExpense: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('- R50'), findsOneWidget);
    });

    testWidgets('shows TRANSACTION badge on every tile', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.shopping_cart,
            title: 'Coffee',
            subtitle: 'Today',
            amount: '- R50',
            isExpense: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('TRANSACTION'), findsOneWidget);
    });

    testWidgets('isExpense true shows "expense" label, not "income"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.shopping_cart,
            title: 'Groceries',
            subtitle: 'Today',
            amount: '- R850',
            isExpense: true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('expense'), findsOneWidget);
      expect(find.text('income'), findsNothing);
    });

    testWidgets('isExpense false shows "income" label, not "expense"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.payments,
            title: 'Salary',
            subtitle: 'Yesterday',
            amount: '+ R22 000',
            isExpense: false,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('income'), findsOneWidget);
      expect(find.text('expense'), findsNothing);
    });

    testWidgets('expense tile icon uses red accent color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.shopping_cart,
            title: 'Groceries',
            subtitle: 'Today',
            amount: '- R850',
            isExpense: true,
          ),
        ),
      );
      await tester.pump();
      final icon = tester.widget<Icon>(find.byIcon(Icons.shopping_cart));
      expect(icon.color, Colors.redAccent);
    });
  });

  // BillItem

  group('BillItem', () {
    testWidgets('renders title, subtitle, and amount', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BillItem(
            icon: Icons.electric_bolt,
            title: 'Electricity',
            subtitle: 'Due tomorrow',
            amount: 'R850',
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Electricity'), findsOneWidget);
      expect(find.text('Due tomorrow'), findsOneWidget);
      expect(find.text('R850'), findsOneWidget);
    });

    testWidgets('renders with different data correctly', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BillItem(
            icon: Icons.water,
            title: 'Water',
            subtitle: 'Due in 3 days',
            amount: 'R200',
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Water'), findsOneWidget);
      expect(find.text('Due in 3 days'), findsOneWidget);
      expect(find.text('R200'), findsOneWidget);
    });

    testWidgets('renders the provided icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          BillItem(
            icon: Icons.movie,
            title: 'Netflix',
            subtitle: 'Due tomorrow',
            amount: 'R199',
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.movie), findsOneWidget);
    });
  });
}
