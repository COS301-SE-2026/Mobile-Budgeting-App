import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';
import 'package:budgetit/models/anomaly_result.dart';

@GenerateMocks([AppDatabase, TransactionDao, CategoryDao])
import 'background_anomaly_scanner_test.mocks.dart';

void main() {
    late MockAppDatabase mockDb;
    late MockTransactionDao mockTxDao;
    late MockCategoryDao mockCategoryDao;
    late BackgroundAnomalyScanner scanner;

    setUp((){
        mockDb = MockAppDatabase();
        mockTxDao = MockTransactionDao();
        mockCategoryDao = MockCategoryDao();


        when(mockDb.transactionDao).thenReturn(mockTxDao);
        when(mockDb.categoryDao).thenReturn(mockCategoryDao);
        when(mockTxDao.getTransactionsByDateRange(any,any),).thenAnswer((_) async => []);
        scanner = BackgroundAnomalyScanner(mockDb);
    });

    tearDown(() {
        scanner.dispose();

    });

    group('BackgroundAnomalyScanner', (){
        test('initial state has empty anomalies and null prediction', () {
            expect(scanner.anomalies, isEmpty);
            expect(scanner.prediction, isNull);
            expect(scanner.isScanning, isFalse);
            expect(scanner.lastScanned, isNull);
            expect(scanner.lastError, isNull);
        });

        test('isStale return true before the first scan', () {
            expect(scanner.isStale(), isTrue);
        });

        test('scan completes and sets lastScannned', () async{
            await scanner.scan();
            expect(scanner.isScanning, isFalse);
            expect(scanner.lastScanned, isNotNull);
            expect(scanner.lastError, isNull);
        });

        test('scan with no history reutrns empty anomalies and null predicition', () async{
            await scanner.scan();
            expect(scanner.anomalies, isEmpty);
            expect(scanner.prediction, isNull);
        });

        test('concurrent scan calls are ignored', () async {
            int notifyCount = 0;
            scanner.addListener(() => notifyCount++);
            final f1 = scanner.scan();
            final f2 = scanner.scan();
            await Future.wait([f1, f2]);

            expect(notifyCount, lessThanOrEqualTo(3));
        });

        test('clear resets alls tate', () async {
            await scanner.scan();
            scanner.clear();

            expect(scanner.anomalies, isEmpty);
            expect(scanner.prediction, isNull);
            expect(scanner.lastScanned, isNull);
            expect(scanner.lastError, isNull);
        });

        test('isStale resunts false immediately after scan', () async{
            await scanner.scan();
            expect(scanner.isStale(maxAge: const Duration(minutes: 30)), isFalse);
        });
        test('isStale returns true when maxAge is exceeded', () async {
            await scanner.scan();
            expect(scanner.isStale(maxAge: Duration.zero), isTrue);
        });

        test('anomalies list is unmodifiable', () async {
            await scanner.scan();
            expect(() => (scanner.anomalies as List).add(null), throwsUnsupportedError);
        });

        test('notifies listeners when scan completes', () async {
            bool notified = false;
            scanner.addListener(() => notified = true);
            await scanner.scan();
            expect(notified, isTrue);
        });





    });
}