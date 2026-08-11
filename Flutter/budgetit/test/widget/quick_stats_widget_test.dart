import 'package:budgetit/shared/widgets/quick_stats_widgets.dart';
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
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('QuickStatsWidget', () {
    testWidgets('shows spending by category heading', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));

      expect(find.text('Spending by Category'), findsOneWidget);
    });

    testWidgets('shows total spending amount', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));

      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('R4.2k'), findsOneWidget);
    });

    testWidgets('shows all category labels', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));

      expect(find.text('Housing'), findsOneWidget);
      expect(find.text('Dining'), findsOneWidget);
      expect(find.text('Others'), findsOneWidget);
    });

    testWidgets('shows all category percentages', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));

      expect(find.text('30%'), findsOneWidget);
      expect(find.text('25%'), findsOneWidget);
      expect(find.text('45%'), findsOneWidget);
    });

    testWidgets('renders circular progress indicators', (tester) async {
      await tester.pumpWidget(_wrap(const QuickStatsWidget()));

      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });
  });
}
