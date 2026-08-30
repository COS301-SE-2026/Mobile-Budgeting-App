import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/balance_card.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mockito/mockito.dart';

import '../support/fixtures.dart';
import '../support/mock_db.dart';

late MockDb _dashMock;

Widget _wrapWithMockDb(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
    ),
    home: wrapWithProviders(Scaffold(body: child), db: _dashMock.db),
  );
}

void main() {
  group('Dashboard', () {
    setUp(() {
      _dashMock = MockDb();

      when(_dashMock.transactionDao.getAllTransactions()).thenAnswer(
        (_) async => [
          transactionFixture(id: 'd1', shortDescription: 'Groceries'),
          transactionFixture(
            id: 'd2',
            shortDescription: 'Salary',
            type: TransactionType.income,
          ),
        ],
      );

      when(
        _dashMock.transactionDao.getTransactionsByDateRange(any, any),
      ).thenAnswer(
        (_) async => [transactionFixture(id: 'd3', shortDescription: 'Rent')],
      );
    });

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrapWithMockDb(const Dashboard()));
      await tester.pumpAndSettle();

      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets('shows dashboard headings', (tester) async {
      await tester.pumpWidget(_wrapWithMockDb(const Dashboard()));
      await tester.pumpAndSettle();

      expect(find.text('DASHBOARD'), findsOneWidget);
      expect(find.text('RECENT TRANSACTIONS'), findsOneWidget);
    });

    testWidgets('shows Groceries and Salary transaction tiles', (tester) async {
      await tester.pumpWidget(_wrapWithMockDb(const Dashboard()));
      await tester.pumpAndSettle();

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('financial health analysis dialog opens and closes', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithMockDb(const Dashboard()));
      await tester.pumpAndSettle();

      expect(find.text('FINANCIAL HEALTH'), findsOneWidget);
      expect(find.text('VIEW HEALTH ANALYSIS'), findsOneWidget);

      await tester.tap(find.text('VIEW HEALTH ANALYSIS'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Financial Health Analysis'), findsOneWidget);

      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('body is scrollable', (tester) async {
      await tester.pumpWidget(_wrapWithMockDb(const Dashboard()));
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dashboard), findsOneWidget);
    });
  });

  group('BalanceCard', () {
    testWidgets('shows daily spending header text', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );

      expect(find.text('DAILY SPENDING FOR 1/5/2026'), findsOneWidget);
    });

    testWidgets('shows current spending amount', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );

      expect(find.text('R1,850.00'), findsOneWidget);
    });

    testWidgets('shows target amount', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );

      expect(find.text('Target: R1,950.00'), findsOneWidget);
    });
  });
}
