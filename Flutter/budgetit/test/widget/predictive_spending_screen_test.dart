import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';
import 'package:budgetit/shared/widgets/predictive_spending_screen.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget _wrap({
  required AppDatabase database,
  required BackgroundAnomalyScanner scanner,
  ThemeProvider? themeProvider,
}) {
  return MultiProvider(
    providers: [
      Provider<AppDatabase>.value(value: database),
      ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider ?? ThemeProvider(),
      ),
      ChangeNotifierProvider<BackgroundAnomalyScanner>.value(value: scanner),
    ],
    child: MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
      ),
      home: const PredictiveSpendingScreen(),
    ),
  );
}

SpendingPrediction _prediction() {
  return const SpendingPrediction(
    year: 2026,
    month: 7,
    predictedAmount: 4200,
    lowerBound: 3500,
    upperBound: 5000,
    confidence: 0.75,
    monthsUsed: 3,
  );
}

AnomalyResult _anomaly({AnomalySeverity severity = AnomalySeverity.high}) {
  return AnomalyResult(
    categoryName: 'Groceries',
    monthLabel: 'July 2026',
    actualAmount: 950,
    historicalAverage: 400,
    zScore: 2.5,
    severity: severity,
    title: 'Unusual grocery spend',
    body: 'Groceries are much higher than usual.',
    transactionDescription: 'Checkers',
    transactionCategory: 'Groceries',
    transactionAmount: 950,
    transactionDate: DateTime(2026, 7, 20),
  );
}

void main() {
  late AppDatabase database;
  late BackgroundAnomalyScanner scanner;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    scanner = BackgroundAnomalyScanner(database);
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('shows fallback insights when there is not enough data', (
    tester,
  ) async {
    scanner.setTestState(lastScanned: DateTime.now());

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pumpAndSettle();

    expect(find.text('SPENDING INSIGHTS'), findsOneWidget);
    expect(find.text('SPENDING PREDICTION'), findsOneWidget);
    expect(find.text('Not enough data yet'), findsOneWidget);
    expect(find.text('ANOMALY DETECTION'), findsOneWidget);
    expect(find.text('Building your financial picture'), findsOneWidget);

    expect(find.text('HOW THIS WORKS'), findsOneWidget);
    expect(find.textContaining('Last updated:'), findsOneWidget);
  });

  testWidgets('shows prediction details when prediction exists', (
    tester,
  ) async {
    scanner.setTestState(
      prediction: _prediction(),
      lastScanned: DateTime.now(),
    );

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pumpAndSettle();

    expect(find.text('JULY 2026'), findsOneWidget);
    expect(find.text('R4200.00'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Based on 3 months of history'), findsOneWidget);
    expect(find.text('JULY 2026'), findsOneWidget);
    expect(find.text('R4200.00'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Based on 3 months of history'), findsOneWidget);
  });

  testWidgets('shows analysis error when scanner has lastError', (
    tester,
  ) async {
    scanner.setTestState(
      lastScanned: DateTime.now(),
      lastError: 'Something went wrong',
      prediction: _prediction(),
    );

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pumpAndSettle();

    expect(find.text('Analysis Error: Something went wrong'), findsOneWidget);
  });

  testWidgets('shows loading indicator while scanning with no anomalies', (
    tester,
  ) async {
    scanner.setTestState(isScanning: true);

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('Analysing your spending'), findsOneWidget);
  });

  testWidgets('shows anomaly insights when anomalies exist', (tester) async {
    scanner.setTestState(
      lastScanned: DateTime.now(),
      anomalies: [
        _anomaly(severity: AnomalySeverity.high),
        _anomaly(severity: AnomalySeverity.medium),
        _anomaly(severity: AnomalySeverity.low),
      ],
      prediction: _prediction(),
    );

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pumpAndSettle();

    expect(find.text('Unusual grocery spend'), findsWidgets);
    expect(find.text('Groceries are much higher than usual.'), findsWidgets);
    expect(find.text('Checkers'), findsWidgets);
    expect(find.text('Groceries'), findsWidgets);
  });

  testWidgets('refresh icon triggers scanner scan', (tester) async {
    scanner.setTestState(lastScanned: DateTime.now());

    await tester.pumpWidget(_wrap(database: database, scanner: scanner));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    expect(find.text('SPENDING INSIGHTS'), findsOneWidget);
  });

  testWidgets('back button pops the screen', (tester) async {
    scanner.setTestState(lastScanned: DateTime.now());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: database),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<BackgroundAnomalyScanner>.value(
            value: scanner,
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PredictiveSpendingScreen(),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('SPENDING INSIGHTS'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
  });
}
