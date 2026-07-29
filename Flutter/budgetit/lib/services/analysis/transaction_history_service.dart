import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import '../../models/monthly_spending_summary.dart';


class TransactionHistoryService {
    final AppDatabase _db;

    TransactionHistoryService(this._db);

    Future<List<MonthlySpendingSummary>> getMonthlyHistory ({
        int monthsBack = 6,
    }) async {
        assert(monthsBack >= 1 && monthsBack <= 24);
        final now = DateTime.now();
        final summaries = <MonthlySpendingSummary>[];

        for (var i = monthsBack - 1; i >= 0; i--) {
            final month = DateTime(now.year, now.month - i);
            final summary = await _buildSummaryForMonth(month.year, month.month);
            summaries.add(summary);

        }
        return summaries;
    }

    Future<MonthlySpendingSummary> getSummaryForMonth(
        int year,
        int month,
    ) async {
        return _buildSummaryForMonth(year, month);
    }

    Future<List<MonthlySpendingSummary>> getNonEmptyMonthlyHistory({
        int monthsBack = 12,
    }) async {
        final all = await getMonthlyHistory(monthsBack: monthsBack);
        return all.where((s) => s.transactionCount > 0).toList();
    }


    Future<MonthlySpendingSummary> _buildSummaryForMonth(
        int year,
        int month,
    ) async {
        final start = DateTime(year, month, 1);
        final end = DateTime(year, month +1, 0, 23, 59, 59, 999); //these numbers are the last day of the month, 23:59:59.999 to consider the entire day of the last day of the month.
        final transactions = await _db.transactionDao.getTransactionsByDateRange(
            start,
            end,
        );

        double totalExpenses = 0;
        double totalIncome = 0;
        final expensesByCategory = <String, double>{};
        int transactionCount = 0;

        for (final tx in transactions) {
            final amount = double.parse(tx.amount.toString());
            
            if(tx.type == TransactionType.expense) {
                totalExpenses += amount;
                transactionCount++;

                final mapping = await _db.transactionDao.getCategoryForTransaction(tx.id);
                final categoryName = mapping == null ? 'Uncategorised' : await _resolveCategoryName(mapping.categoryId);
                expensesByCategory[categoryName] = (expensesByCategory[categoryName] ?? 0) + amount;
            } else {
                totalIncome += amount;
            }
        }

        return MonthlySpendingSummary(
            year: year,
            month: month,
            totalExpenses: totalExpenses,
            totalIncome: totalIncome,
            expensesByCategory: expensesByCategory,
            transactionCount: transactionCount,
        );
    }

    Future<String> _resolveCategoryName(String categoryId) async {
        final category = await _db.categoryDao.getCategoryById(categoryId);
        return category?.name ?? 'Unrecognised';
    }

}