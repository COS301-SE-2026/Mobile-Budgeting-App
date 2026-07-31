import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/models/import/parsed_transaction.dart';
import 'package:budgetit/services/import/import_orchestrator.dart';
import 'package:budgetit/shared/widgets/import/import_preview_screen.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/database/app_database.dart';
import 'package:drift/native.dart';

ParsedTransaction _parsed({
  required String description,
  required double amount,
  bool isIncome = false,
  bool isDuplicate = false,
  String? categoryName,
}) {
  final tx = ParsedTransaction(
    date: DateTime(2026, 7, 20),
    description: description,
    amount: Decimal.parse(amount.toString()),
    isIncome: isIncome,
    deduplicationHash: description.toLowerCase().replaceAll(' ', '-'),
    rawData: {'description': description},
    categoryName: categoryName,
  );

  tx.isDuplicate = isDuplicate;
  return tx;
}

Widget _wrap({required List<ParsedTransaction> transactions}) {
  final db = AppDatabase.forTesting(NativeDatabase.memory());

  final orchestrator = ImportOrchestrator(
    db: db,
    taDao: TransactionDao(db),
    categoryDao: CategoryDao(db),
  );

  return MaterialApp(
    home: ImportPreviewScreen(
      transactions: transactions,
      orchestrator: orchestrator,
    ),
  );
}

void main() {
  group('ImportPreviewScreen', () {
    testWidgets('shows review heading and new transactions summary', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          transactions: [
            _parsed(description: 'Checkers groceries', amount: 250),
            _parsed(
              description: 'Salary payment',
              amount: 12000,
              isIncome: true,
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Review transactions'), findsOneWidget);
      expect(find.text('2 to import'), findsOneWidget);
      expect(find.text('New Transactions'), findsOneWidget);
      expect(find.text('Checkers groceries'), findsOneWidget);
      expect(find.text('Salary payment'), findsOneWidget);
      expect(find.text('- R 250.00'), findsOneWidget);
      expect(find.text('+ R 12000.00'), findsOneWidget);
      expect(find.text('Import 2 transactions'), findsOneWidget);
    });

    testWidgets('shows duplicate section and duplicate summary', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          transactions: [
            _parsed(description: 'New grocery item', amount: 300),
            _parsed(
              description: 'Duplicate rent',
              amount: 5000,
              isDuplicate: true,
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('1 to import'), findsOneWidget);
      expect(find.text('1 duplicate'), findsOneWidget);
      expect(find.text('Possible Dupliucates'), findsOneWidget);
      expect(
        find.text('These Match transactions already in your records.'),
        findsOneWidget,
      );
      expect(find.text('Duplicate rent'), findsOneWidget);
      expect(find.text('Include'), findsOneWidget);
    });

    testWidgets('duplicate include toggle moves transaction to import list', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          transactions: [
            _parsed(
              description: 'Duplicate transaction',
              amount: 100,
              isDuplicate: true,
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('0 to import'), findsOneWidget);
      expect(find.text('1 duplicate'), findsOneWidget);
      expect(find.text('Import 0 transactions'), findsOneWidget);

      await tester.tap(find.text('Include'));
      await tester.pumpAndSettle();

      expect(find.text('1 to import'), findsOneWidget);
      expect(find.text('New Transactions'), findsOneWidget);
      expect(find.text('Import 1 transaction'), findsOneWidget);
    });

    testWidgets('shows category chip and uncategorised fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          transactions: [
            _parsed(
              description: 'Uber trip',
              amount: 120,
              categoryName: 'Transport',
            ),
            _parsed(description: 'Unknown shop', amount: 80),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Uncategorised'), findsOneWidget);
    });

    testWidgets('tapping category chip shows placeholder snackbar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(transactions: [_parsed(description: 'Coffee shop', amount: 60)]),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Uncategorised'));
      await tester.pumpAndSettle();

      expect(
        find.text('Category picker - wire up your existing dialogue here'),
        findsOneWidget,
      );
    });

    testWidgets('import button is disabled when only duplicates exist', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          transactions: [
            _parsed(
              description: 'Duplicate only',
              amount: 100,
              isDuplicate: true,
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));

      expect(find.text('Import 0 transactions'), findsOneWidget);
      expect(button.onPressed, isNull);
    });
  });
}
