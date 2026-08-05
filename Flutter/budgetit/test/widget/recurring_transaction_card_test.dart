import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/recurring_transaction_card.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

RecurringTransaction _rt({
  String id = 'rt-1',
  String amount = '100.00',
  TransactionType type = TransactionType.expense,
  String shortDescription = 'Netflix subscription',
  DateTime? nextTransactionDate,
  PeriodType unit = PeriodType.monthly,
  int intervalAmount = 1,
  String? categoryId,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return RecurringTransaction(
    id: id,
    amount: Decimal.parse(amount),
    type: type,
    shortDescription: shortDescription,
    longDescription: null,
    nextTransactionDate: nextTransactionDate ?? DateTime.utc(2026, 6, 2),
    createdAt: now,
    updatedAt: now,
    deletedAt: null,
    currency: 'ZAR',
    unit: unit,
    intervalAmount: intervalAmount,
    startDate: now,
    categoryId: categoryId,
  );
}

Widget _wrap(RecurringTransaction rt, {VoidCallback? onTap}) {
  return MaterialApp(
    home: Scaffold(
      body: RecurringTransactionCard(recurringTransaction: rt, onTap: onTap),

    ),
  );
}

void main() {
  group('RecurringTransactionCard', () {
    testWidgets('renders the short description', (tester) async {
      await tester.pumpWidget(_wrap(_rt(shortDescription: 'Netflix subscription')));

      expect(find.text('Netflix subscription'), findsOneWidget);
    });

    testWidgets('renders the next transaction date formatted as "D Mon YYYY"', (
      tester,
    ) async {
      await tester.pumpWidget( _wrap(_rt(nextTransactionDate: DateTime.utc(2026, 6, 2))));

      expect(find.text('Next: 2 Jun 2026'), findsOneWidget);
    });

    testWidgets('formats a single-digit day correctly without leading zero', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_rt(nextTransactionDate: DateTime.utc(2026, 12, 25))));
      expect(find.text('Next: 25 Dec 2026'), findsOneWidget);
    });

    testWidgets('shows a minus amount for expense transactions', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_rt(type: TransactionType.expense, amount: '199.99')));

      expect(find.text('- R199.99'), findsOneWidget);
    });

    testWidgets('shows just amount for income transactions', (
      tester,
    ) async {
      await tester.pumpWidget( _wrap(_rt(type: TransactionType.income, amount: '25000.00')));
      expect(find.text('R25000.00'), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(_rt(), onTap: () => tapped = true));
      await tester.tap(find.byType(RecurringTransactionCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
    testWidgets('renders without a tap handler without throwing', (tester) async {
      await tester.pumpWidget(_wrap(_rt(), onTap: null));
      await tester.tap(find.byType(RecurringTransactionCard));
      await tester.pump();
      expect(find.byType(RecurringTransactionCard), findsOneWidget);
    });
    testWidgets('renders the autorenew icon', (tester) async {
      await tester.pumpWidget(_wrap(_rt()));
      expect(find.byIcon(Icons.autorenew), findsOneWidget);
    });



  });
}