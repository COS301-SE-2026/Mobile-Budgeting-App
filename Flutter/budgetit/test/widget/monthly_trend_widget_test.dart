import 'package:budgetit/shared/widgets/monthly_trend_widget.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget _wrap(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
      ),
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
}

List<MonthData> _months() {
  return const [
    MonthData(month: 'March', shortMonth: 'Mar', income: 10000, spent: 3000),
    MonthData(month: 'April', shortMonth: 'Apr', income: 12000, spent: 5000),
    MonthData(month: 'May', shortMonth: 'May', income: 15000, spent: 9000),
  ];
}

void main() {
  group('MonthlyTrendWidget', () {
    testWidgets('shows monthly spending heading and range', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: _months(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Monthly Spending'), findsOneWidget);
      expect(find.text('Mar 2026 - May 2026'), findsOneWidget);
    });

    testWidgets('shows y-axis labels and month labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: _months(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('R15K'), findsOneWidget);
      expect(find.text('R10K'), findsOneWidget);
      expect(find.text('R5K'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      expect(find.text('Mar'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
      expect(find.text('May'), findsOneWidget);
    });

    testWidgets('shows spending amounts above bars', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: _months(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('R3000'), findsOneWidget);
      expect(find.text('R5000'), findsOneWidget);
      expect(find.text('R9000'), findsOneWidget);
    });

    testWidgets('left and right arrows change displayed month range', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: _months(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mar 2026 - May 2026'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.text('Feb 2026 - Apr 2026'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(find.text('Mar 2026 - May 2026'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      expect(find.text('Apr 2026 - Jun 2026'), findsOneWidget);
    });

    testWidgets('tapping a bar selects the month without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: _months(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Apr'));
      await tester.pumpAndSettle();

      expect(find.text('Monthly Spending'), findsOneWidget);
      expect(find.text('Apr'), findsOneWidget);
    });

    testWidgets('handles zero spending without crashing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MonthlyTrendWidget(
            selectedDate: DateTime(2026, 5, 1),
            months: const [
              MonthData(month: 'March', shortMonth: 'Mar', income: 0, spent: 0),
              MonthData(month: 'April', shortMonth: 'Apr', income: 0, spent: 0),
              MonthData(month: 'May', shortMonth: 'May', income: 0, spent: 0),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Monthly Spending'), findsOneWidget);
      expect(find.text('R0'), findsNWidgets(3));
    });
  });
}
