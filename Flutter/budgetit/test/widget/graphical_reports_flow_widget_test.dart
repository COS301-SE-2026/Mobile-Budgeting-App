import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/graphical_reports/graphical_reports_screen.dart';

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

    // 1. Screen loads.
    expect(find.text('Graphical Reports'), findsOneWidget);

    // 2. Reporting period selector loads.
    expect(find.byType(ChoiceChip), findsNWidgets(3));

    // 3. Empty/mock database state is shown.
    expect(
      find.text('No financial data is available for the selected period.'),
      findsOneWidget,
    );
    expect(
      find.text('Select another reporting period or add transactions.'),
      findsOneWidget,
    );

    final chips = find.byType(ChoiceChip);

    // 4. First reporting period can be selected.
    await tester.tap(chips.at(0));
    await tester.pumpAndSettle();

    expect(find.byType(ChoiceChip), findsNWidgets(3));

    // 5. Second reporting period can be selected.
    await tester.tap(chips.at(1));
    await tester.pumpAndSettle();

    expect(find.byType(ChoiceChip), findsNWidgets(3));

    // 6. Third reporting period can be selected.
    await tester.tap(chips.at(2));
    await tester.pumpAndSettle();

    expect(find.byType(ChoiceChip), findsNWidgets(3));
  });
}
