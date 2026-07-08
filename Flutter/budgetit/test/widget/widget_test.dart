import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/main.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';


import '../support/mock_db.dart';

void main() {
  testWidgets('Budget manager screen loads', (WidgetTester tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          Provider<AppDatabase>.value(value: database),
        ],
        child: MaterialApp(
          home: BudgetManagerScreen(database: database),
        ),
      ).
    );
      //BudgetApp(db: database));


    await tester.pumpAndSettle();

    // The app should start with the shared bottom navigation.
    //expect(find.byType(NavigationBar), findsOneWidget);
    //expect(find.byType(NavigationDestination), findsNWidgets(3));
    //await tester.pumpWidget(
      //MaterialApp(home: BudgetManagerScreen(database: database)),
   // );

    //await tester.pumpAndSettle();

    expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);
  });

  testWidgets('app shows the bottom navigation shell', (tester) async {
    final mock = MockDb();

    await tester.pumpWidget(BudgetApp(db: mock.db));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
  }, skip: true); // Skip for now, needs mock auth integration.
}