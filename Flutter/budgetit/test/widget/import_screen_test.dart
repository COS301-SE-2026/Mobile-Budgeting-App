import 'package:budgetit/shared/widgets/import/import_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/mock_db.dart';

Widget _wrap() {
  final mock = MockDb();

  return MaterialApp(home: ImportScreen(db: mock.db));
}

void main() {
  group('ImportScreen', () {
    testWidgets('shows import statement app bar title', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.text('Import Statement'), findsOneWidget);
    });

    testWidgets('shows import bank statement information', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.byIcon(Icons.account_balance_outlined), findsOneWidget);
      expect(find.text('Import Bank Statement'), findsOneWidget);
      expect(
        find.text(
          'Transactions are extracted and categorized on your device. No data is sent to any server.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows supported formats', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.text('Supported Formats'), findsOneWidget);
      expect(find.text('CSV'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
      expect(find.byIcon(Icons.table_chart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
    });

    testWidgets('shows choose file button', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.byIcon(Icons.upload_file_outlined), findsOneWidget);
      expect(find.text('Choose File.'), findsOneWidget);
    });
  });
}
