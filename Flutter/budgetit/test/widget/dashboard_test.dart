import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgetit/shared/widgets/balance_card.dart';
import 'package:budgetit/shared/widgets/bill_item.dart';
import 'package:budgetit/shared/widgets/insight_widget.dart';
import 'package:budgetit/shared/widgets/monthly_trend_widget.dart';
import 'package:budgetit/shared/widgets/quick_stats_widgets.dart';
import 'package:budgetit/shared/widgets/transaction_tile.dart';
import 'package:budgetit/views/dashboard/dashboard.dart';

import 'package:budgetit/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:drift/native.dart';

import 'package:budgetit/database/schema.dart';
import 'package:mockito/mockito.dart';

import '../support/fixtures.dart';
import '../support/mock_db.dart';
import 'package:budgetit/utils/app_colour.dart';

Widget _wrap(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      Provider<AppDatabase>.value(
        value: AppDatabase.forTesting(NativeDatabase.memory()),
      ),
    ],
    child: MaterialApp(
      theme:   ThemeData(extensions: [MyColours.lightTheme]),
      home: Scaffold(body: child)
      ),
  );
}

late MockDb _dashMock;
void main() {
  // Dashboard — integration-level: full screen renders correctly

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
      await tester.pumpWidget(_wrap(Dashboard()));
      await tester.pumpAndSettle();
      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets(
      'shows Recent Transactions section headings',
      (tester) async {
        await tester.pumpWidget(_wrap(Dashboard()));
        await tester.pumpAndSettle();
      
        expect(find.text('RECENT TRANSACTIONS'), findsOneWidget);
      },
    );

   


    testWidgets('shows Groceries and Salary transaction tiles', (tester) async {
      await tester.pumpWidget(_wrap(Dashboard()));
      await tester.pumpAndSettle();
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('body is scrollable', (tester) async {
      await tester.pumpWidget(_wrap(Dashboard()));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();
      // No layout exception = scrolling works
    });
  });

  // BalanceCard

  group('BalanceCard', () {
    testWidgets('shows monthly spending header text', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
      await tester.pump();
      expect(find.text('DAILY SPENDING FOR 1/5/2026'), findsOneWidget);
    });

    testWidgets('shows current spending amount', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
      await tester.pump();
      expect(find.text('R1,850.00'), findsOneWidget);
    });

    testWidgets('shows target amount', (tester) async {
      await tester.pumpWidget(
        _wrap(BalanceCard(selectedDate: DateTime(2026, 5, 1))),
      );
      await tester.pump();
      expect(find.text('Target: R1,950.00'), findsOneWidget);
    });
  });

  // QuickStatsWidget

  

  // MonthlyTrendWidget

 
}
