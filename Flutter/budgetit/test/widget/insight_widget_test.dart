import 'package:budgetit/shared/widgets/insight_widget.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
    ),
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

BudgetInsight _insight({
  required String title,
  required String body,
  InsightSeverity severity = InsightSeverity.tip,
  Color accentColor = Colors.blue,
}) {
  return BudgetInsight(
    title: title,
    body: body,
    icon: Icons.lightbulb_outline,
    accentColor: accentColor,
    severity: severity,
  );
}

BudgetInsight _transactionInsight() {
  return BudgetInsight(
    title: 'Unusual grocery spend',
    body: 'Groceries are higher than normal.',
    icon: Icons.warning_rounded,
    accentColor: Colors.redAccent,
    severity: InsightSeverity.alert,
    transactionDescription: 'Checkers Hyper',
    transactionCategory: 'Groceries',
    transactionAmount: 950,
    transactionDate: DateTime(2026, 7, 20),
  );
}

void main() {
  group('InsightWidget', () {
    testWidgets('renders nothing when insights list is empty', (tester) async {
      await tester.pumpWidget(_wrap(const InsightWidget(insights: [])));

      expect(find.text('Insight'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('shows single insight title, body and severity badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          InsightWidget(
            insights: [
              _insight(
                title: 'Budget tip',
                body: 'You are spending less than expected.',
                severity: InsightSeverity.tip,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Insight'), findsOneWidget);
      expect(find.text('Budget tip'), findsOneWidget);
      expect(find.text('You are spending less than expected.'), findsOneWidget);
      expect(find.text('Tip'), findsOneWidget);
      expect(find.text('1/1'), findsNothing);
    });

    testWidgets('shows warning and alert severity badges', (tester) async {
      await tester.pumpWidget(
        _wrap(
          InsightWidget(
            insights: [
              _insight(
                title: 'Warning insight',
                body: 'Spending is increasing.',
                severity: InsightSeverity.warning,
                accentColor: Colors.orange,
              ),
              _insight(
                title: 'Alert insight',
                body: 'Spending is unusually high.',
                severity: InsightSeverity.alert,
                accentColor: Colors.red,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('1/2'), findsOneWidget);
      expect(find.text('Warning'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('2/2'), findsOneWidget);
      expect(find.text('Alert insight'), findsOneWidget);
      expect(find.text('Alert'), findsOneWidget);
    });

    testWidgets('navigates between multiple insights', (tester) async {
      await tester.pumpWidget(
        _wrap(
          InsightWidget(
            insights: [
              _insight(title: 'First insight', body: 'First body'),
              _insight(title: 'Second insight', body: 'Second body'),
              _insight(title: 'Third insight', body: 'Third body'),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('First insight'), findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('Second insight'), findsOneWidget);
      expect(find.text('2/3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('First insight'), findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);
    });

    testWidgets('shows anomalous transaction details when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(InsightWidget(insights: [_transactionInsight()])),
      );

      await tester.pumpAndSettle();

      expect(find.text('Unusual grocery spend'), findsOneWidget);
      expect(find.text('Groceries are higher than normal.'), findsOneWidget);
      expect(find.text('Anomolous Transaction'), findsOneWidget);
      expect(find.text('Checkers Hyper'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('R950.00'), findsOneWidget);
      expect(find.text('20/7/2026'), findsOneWidget);
    });
  });
}
