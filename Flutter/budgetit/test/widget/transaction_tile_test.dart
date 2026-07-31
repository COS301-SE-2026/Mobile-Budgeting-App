import 'package:budgetit/shared/widgets/transaction_tile.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme:
          theme ??
          ThemeData(
            extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
          ),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('TransactionTile', () {
    testWidgets('shows transaction label and expense details', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.shopping_cart,
            title: 'Groceries',
            subtitle: 'Food and household items',
            amount: '-R500.00',
            isExpense: true,
          ),
        ),
      );

      expect(find.text('TRANSACTION'), findsOneWidget);
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Food and household items'), findsOneWidget);
      expect(find.text('-R500.00'), findsOneWidget);
      expect(find.text('expense'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('shows income details', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.payments,
            title: 'Salary',
            subtitle: 'Monthly income',
            amount: '+R12000.00',
            isExpense: false,
          ),
        ),
      );

      expect(find.text('TRANSACTION'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Monthly income'), findsOneWidget);
      expect(find.text('+R12000.00'), findsOneWidget);
      expect(find.text('income'), findsOneWidget);
      expect(find.byIcon(Icons.payments), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.restaurant,
            title: 'Dinner',
            subtitle: 'Restaurant',
            amount: '-R250.00',
            isExpense: true,
          ),
          theme: ThemeData.dark().copyWith(
            extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
          ),
        ),
      );

      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Restaurant'), findsOneWidget);
      expect(find.text('-R250.00'), findsOneWidget);
      expect(find.text('expense'), findsOneWidget);
    });

    testWidgets('renders long title and subtitle without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const TransactionTile(
            icon: Icons.receipt_long,
            title: 'Very long transaction title for testing layout',
            subtitle: 'Very long transaction subtitle for checking overflow',
            amount: '-R999.99',
            isExpense: true,
          ),
        ),
      );

      expect(
        find.text('Very long transaction title for testing layout'),
        findsOneWidget,
      );
      expect(
        find.text('Very long transaction subtitle for checking overflow'),
        findsOneWidget,
      );
      expect(find.text('-R999.99'), findsOneWidget);
    });
  });
}
