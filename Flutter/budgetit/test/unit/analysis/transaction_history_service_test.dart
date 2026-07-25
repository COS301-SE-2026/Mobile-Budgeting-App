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

        test('getMonthlyHistory months are ordered olderst to newest', () async {
            when(mockTxDao.getTransactionByDateRange(any,any)).thenAnswer((_) async => []);
            final result = await service.getMonthlyHistory(monthsBack: 3);
            for (var i=0;1<result.length-1;i++){
                final current = DateTime(result[i].year, result[i].month);
                final next = DateTime(result[i+1].year, result[i+1].month);
                expect(current.isBefore(next), isTrue);

            }
        });

        test('getNonEmptyMonthlyHistory filters out months with no transaction', () async {
            when(mockTxDao.getTransactionsByDateRange(any,any)).thenAnswer((_) async => []);
            final result = await service.getNonEmptyMonthlyHistory(monthsBack: 3);
            expect(result, isEmpty);

        });

        test('summary has zero totals when no transaction exist', () async {
            when(mockTxDao.getTransactionByDateRange(any,any)).thenAnswer((_) async => []);

            final summary = await service.getSummaryForMonth(2026,5);
            expect(summary.totalExpenses, equals(0));
            expect(summary.totalIncome, equals(0));
            expect(summary.transactionCount, equals(0));
            expect(summary.expensesByCategory, isEmpty);
        });



    });
}