import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Budget manager screen loads', (WidgetTester tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      MaterialApp(
        home: BudgetManagerScreen(database: database),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);
    await database.close();
  });
}