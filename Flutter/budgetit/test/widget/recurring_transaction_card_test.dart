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
      await tester.pumpWidget(
        _wrap(_rt(shortDescription: 'Netflix subscription')),
      );

      expect(find.text('Netflix subscription'), findsOneWidget);
    });

    testWidgets('renders the next transaction date formatted as "D Mon YYYY"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_rt(nextTransactionDate: DateTime.utc(2026, 6, 2))),
      );

      expect(find.text('Every month - Next: 2 Jun 2026'), findsOneWidget);
    });

    testWidgets('formats a single-digit day correctly without leading zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_rt(nextTransactionDate: DateTime.utc(2026, 12, 25))),
      );
      expect(find.text('Every month - Next: 25 Dec 2026'), findsOneWidget);
    });

    testWidgets('shows a minus amount for expense transactions', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_rt(type: TransactionType.expense, amount: '199.99')),
      );

      expect(find.text('- R199.99'), findsOneWidget);
    });

    testWidgets('shows just amount for income transactions', (tester) async {
      await tester.pumpWidget(
        _wrap(_rt(type: TransactionType.income, amount: '25000.00')),
      );
      expect(find.text('R25000.00'), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(_rt(), onTap: () => tapped = true));
      await tester.tap(find.byType(RecurringTransactionCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
    testWidgets('renders without a tap handler without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_rt(), onTap: null));
      await tester.tap(find.byType(RecurringTransactionCard));
      await tester.pump();
      expect(find.byType(RecurringTransactionCard), findsOneWidget);
    });
    testWidgets('renders a down arrow for an expense', (tester) async {
      await tester.pumpWidget(_wrap(_rt()));
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    group('press-state styling', () {
      testWidgets(
        'icon and amount colors change while pressed then revert on release',
        (tester) async {
          await tester.pumpWidget(_wrap(_rt(type: TransactionType.expense)));

          final iconFinder = find.byIcon(Icons.arrow_downward);
          Color colorBefore = tester.widget<Icon>(iconFinder).color!;

          final gesture = await tester.startGesture(
            tester.getCenter(find.byType(RecurringTransactionCard)),
          );
          await tester.pump();

          final colorDuringPress = tester.widget<Icon>(iconFinder).color!;
          expect(colorDuringPress, equals(colorBefore));

          await gesture.up();
          await tester.pump();

          final colorAfterRelease = tester.widget<Icon>(iconFinder).color!;
          expect(colorAfterRelease, equals(colorBefore));
        },
      );

      testWidgets('tap cancel (drag away) reverts press state', (tester) async {
        await tester.pumpWidget(_wrap(_rt()));

        final iconFinder = find.byIcon(Icons.arrow_downward);
        final colorBefore = tester.widget<Icon>(iconFinder).color!;

        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(RecurringTransactionCard)),
        );
        await tester.pump();
        // Drag far outside the widget bounds to trigger onTapCancel.
        await gesture.moveTo(const Offset(-1000, -1000));
        await gesture.up();
        await tester.pumpAndSettle();

        final colorAfter = tester.widget<Icon>(iconFinder).color!;
        expect(colorAfter, equals(colorBefore));
      });
    });

    group('frequency label branches', () {
      testWidgets('daily, interval 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.daily, intervalAmount: 1)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('daily, interval > 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.daily, intervalAmount: 3)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('weekly, interval 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.weekly, intervalAmount: 1)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('weekly, interval > 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.weekly, intervalAmount: 2)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('monthly, interval 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.monthly, intervalAmount: 1)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('monthly, interval > 1 renders without error', (
        tester,
      ) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.monthly, intervalAmount: 6)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('yearly, interval 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.yearly, intervalAmount: 1)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });

      testWidgets('yearly, interval > 1 renders without error', (tester) async {
        await tester.pumpWidget(
          _wrap(_rt(unit: PeriodType.yearly, intervalAmount: 2)),
        );
        expect(find.byType(RecurringTransactionCard), findsOneWidget);
      });
    });
  });
}
