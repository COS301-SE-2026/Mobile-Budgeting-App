class MonthlySpendingSummary {
    final int year;
    final int month;
    final double totalExpenses;
    final double totalIncome;
    final Map<String, double> expensesByCategory;
    final int transactionCount;
    final String? largestTransactionDescription;
    final String? largestTransactionCategory;
    final double? largestTransactionAmount;
    final DateTime? largestTransactionDate;

    const MonthlySpendingSummary({
        required this.year,
        required this.month,
        required this.totalExpenses,
        required this.totalIncome,
        required this.expensesByCategory,
        required this.transactionCount,
        required this.largestTransactionDescription,
        required this.largestTransactionCategory,
        required this.largestTransactionAmount,
        required this.largestTransactionDate,
    });

    double get netAmount => totalIncome - totalExpenses;

    String get label {
        const months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return '${months[month-1]} $year'; //mmonth and year
    }

    String get shortLabel {
        const months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return months[month-1]; //just month
    }

    @override
    String toString() =>
        'MonthlySpendingSummary($label, expenses: $totalExpenses, income: $totalIncome, categories: ${expensesByCategory.length})';
        
}