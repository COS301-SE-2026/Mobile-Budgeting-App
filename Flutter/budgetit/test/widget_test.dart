import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/main.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:flutter/material.dart';

void main() {
   testWidgets('Budget manager screen loads correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetManagerScreen(), 
      ),
    );

 //   expect(find.text('Budget IT'), findsOneWidget);
    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Dining'), findsOneWidget);
  });
}
