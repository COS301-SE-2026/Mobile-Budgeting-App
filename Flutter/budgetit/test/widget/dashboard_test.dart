import 'package:budgetit/shared/widgets/predictive_spending_screen.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../support/mock_db.dart';

late MockDb _dashMock;

Widget _wrapWithMockDb(
  Widget child, {
  ThemeMode themeMode = ThemeMode.light,
}) {
  return MaterialApp(
    themeMode: themeMode,
    theme: ThemeData(
      brightness: Brightness.light,
      extensions: <ThemeExtension<dynamic>>[
        MyColours.lightTheme,
      ],
    ),
    home: wrapWithProviders(
      Scaffold(body: child),
      db: _dashMock.db,
    ),
  );
}

void main() {
  group('Dashboard', () {
    setUp(() {
      _dashMock = MockDb();

      when(
        _dashMock.transactionDao.getAllTransactions(),
      ).thenAnswer((_) async => []);

      when(
        _dashMock.transactionDao.getTransactionsByDateRange(any, any),
      ).thenAnswer((_) async => []);
    });

    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Dashboard), findsOneWidget);
    });

    testWidgets('shows dashboard heading', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(find.text('DASHBOARD'), findsOneWidget);
    });

    testWidgets('shows recent transactions heading', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('RECENT TRANSACTIONS'),
        findsOneWidget,
      );
    });

    testWidgets('shows daily spending section', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining('DAILY SPENDING FOR'),
        findsOneWidget,
      );
    });

    testWidgets('shows zero daily spending initially', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('R0.00'),
        findsWidgets,
      );
    });

    testWidgets('shows monthly total', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining('Monthly total:'),
        findsOneWidget,
      );
    });

    testWidgets('shows View Insights button', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('VIEW INSIGHTS'),
        findsOneWidget,
      );
    });

    testWidgets('shows View Reports button', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('VIEW REPORTS'),
        findsOneWidget,
      );
    });

    testWidgets(
      'shows empty transaction message when there are no transactions',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMockDb(const Dashboard()),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('No recent transactions yet.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('shows View More Transactions button', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('VIEW MORE TRANSACTIONS'),
        findsOneWidget,
      );
    });

    testWidgets(
      'calls onViewTransactions when View More Transactions is tapped',
      (tester) async {
        var wasTapped = false;

        await tester.pumpWidget(
          _wrapWithMockDb(
            Dashboard(
              onViewTransactions: () {
                wasTapped = true;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text('VIEW MORE TRANSACTIONS'),
          300,
        );

        await tester.tap(
          find.text('VIEW MORE TRANSACTIONS'),
        );

        await tester.pump();

        expect(wasTapped, isTrue);
      },
    );

    testWidgets('opens dashboard date picker', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(Icons.calendar_month),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('SELECT DASHBOARD DATE'),
        findsOneWidget,
      );

      expect(
        find.byType(CalendarDatePicker),
        findsOneWidget,
      );
    });

    testWidgets('date picker can be cancelled', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byIcon(Icons.calendar_month),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('SELECT DASHBOARD DATE'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('Cancel'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('SELECT DASHBOARD DATE'),
        findsNothing,
      );
    });

    testWidgets('dashboard body is scrollable', (tester) async {
      await tester.pumpWidget(
        _wrapWithMockDb(const Dashboard()),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(SingleChildScrollView),
        findsWidgets,
      );

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -400),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(Dashboard),
        findsOneWidget,
      );
    });
  });
}