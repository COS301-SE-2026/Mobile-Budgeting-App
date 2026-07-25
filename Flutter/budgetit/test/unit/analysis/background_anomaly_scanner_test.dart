import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';

@GenerateMocks([AppDatabase, TransactionDao, CategoryDao])
import 'background_anomaly_scanner_test.mocks.dart';

void main() {
    late MockAppDatabase mockDb;
    late MockTransactionDao mockTxDao;
    late MockCategoryDao mockCategoryDao;
    late BackgroundAnomalyScanner scanner;

    setup((){
        mockDb = MockAppDatabase();
        mockTxDao = MockTransactionDao();
        mockCategoryDao = MockCategoryDao();


        when(mockDb.transactionDao).thenReturn(mockTxDao);
        when(mockDb.categoryDao).thenreturn(mockCategoryDao);
        when(mockTxDao.getTransactionByDateRange(any,any),).thenAnswer((_) async => []);
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




        
    })
}