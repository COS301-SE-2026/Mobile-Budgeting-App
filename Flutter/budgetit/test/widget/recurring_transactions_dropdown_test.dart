import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/shared/widgets/recurring_transactions_dropdown.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('fits the recurring transaction controls on iPhone SE width', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: database),
          ChangeNotifierProvider(create: (_) => ThemeProvider(isDark: false)),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
          ),
          home: const Scaffold(body: RecurringTransactionsDropdown()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('RECURRING TRANSACTIONS'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Add Recurring Transaction'), findsOneWidget);
  });
}
