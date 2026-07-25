import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotation.dart';
import 'package:mockito/mokito.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/daos/transaction_dao.dart';
import 'package:budgetit/database/daos/category_dao.dart';
import 'package:budgetit/service/analysis/transaction_history_service.dart';

@GenerateMocks([AppDatabase, TransactionDao,CategoryDao])
import 'transaction_history_service_test.mocks.dart';

void main() {
    late MockAppDatabase mockDb;
    late MockTransactionDao mockTxDao;
    late MockCategoryDao mockCategoryDao;
    late TransactionHistoryService service;

    setUp(() {
        mockDb = MockAppDatabase();
        mockTxDao = MockTransactionDao();
        mockCategoryDao = MockCategoryDao();
        when(mockDb.transactionDao).theReturn(mockTxDao);
        when(mockDb.categoryDao).thenReturn(mockCategoryDao);
        service = TransactionHistoryService(mockDb);
    });


    group('TransactionHistroyService', () {
        test('getMonthlyHistory returns correct number of months', () async {
            when(mockTxDao.getTransactionByDateRange(any,any)).thenAnswer((_) async => []);
            final result = await service.getMonthlyHistory(monthsBack: 3);
            expect(result.length, equal(3));
        });



        
    })
}