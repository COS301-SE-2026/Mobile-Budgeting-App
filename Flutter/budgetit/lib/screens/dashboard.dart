import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';
// import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/insight_widget.dart';
import '../components/monthly_trend_widget.dart';
import '../components/spending_chart.dart';
import '../components/transaction_tile.dart';
import '../database/app_database.dart';
import '../database/schema.dart';
import 'package:budgetit/services/analysis/background_anomaly_scanner.dart';
import 'package:budgetit/screens/predictive_spending_screen.dart';

class Dashboard extends StatefulWidget {
  final AppDatabase? database;
  const Dashboard({super.key, this.database});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AppDatabase db;
  late final bool _ownsDb;
  bool isLoading = true;
  

  String? loadError;
  double dailySpending = 0;
  double monthlySpending = 0;
  List<MonthData> dashboardMonths = []; 
  List<SpendingCategory> spendingCategories = [];
  List<Transaction> recentTransactions = []; 

  @override
  void initState() {
    super.initState();

    _ownsDb = widget.database == null;
    db = widget.database ?? AppDatabase();
    dashboardMonths = _emptyMonthlyTrends();
    spendingCategories = [
      SpendingCategory(
        label: 'No spending',
        percentage: 100, 
        color: MyColours().informational.withValues(alpha: 0.35),
      ),
    ];
    _loadDashboardData(); 
  }

  @override
  void dispose() {
    if (_ownsDb) {
      db.close();
    }

    super.dispose();
  }

  String selectedFilter = "All";

  DateTime selectedDate = DateTime.now();

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  DateTime _startOfMonth(DateTime date) => DateTime(date.year, date.month);

  DateTime _endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }

  String _shortMonthName(int month) => _monthName(month).substring(0, 3);

  double _amountAsDouble(Transaction transaction) =>
      double.parse(transaction.amount.toString());

  double _sumTransactions(
    List<Transaction> transactions,
    TransactionType type,
  ) {
    return transactions
        .where((transaction) => transaction.type == type)
        .fold<double>(
          0,
          (total, transaction) => total + _amountAsDouble(transaction),
        );
  }

  String _formatCurrency(double amount) {
    final fixedAmount = amount.toStringAsFixed(2);
    final parts = fixedAmount.split('.');
    final whole = parts.first;
    final cents = parts.last;
    final buffer = StringBuffer();

    for (var index = 0; index < whole.length; index++) {
      final remaining = whole.length - index;
      buffer.write(whole[index]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(',');
      }
    }

    return 'R${buffer.toString()}.$cents';
  }

  String _formatCompactCurrency(double amount) {
    if (amount >= 1000) {
      final thousands = amount / 1000;
      final text = thousands == thousands.roundToDouble()
          ? thousands.toStringAsFixed(0)
          : thousands.toStringAsFixed(1);

      return 'R${text}K';
    }

    return 'R${amount.toStringAsFixed(0)}';
  }

  String _transactionSubtitle(Transaction transaction) {
    final transactionDay = _startOfDay(transaction.transactionDate);
    final selectedDay = _startOfDay(selectedDate);
    final yesterday = selectedDay.subtract(const Duration(days: 1));

    if (transactionDay == selectedDay) {
      return 'Today';
    }

    if (transactionDay == yesterday) {
      return 'Yesterday';
    }

    return '${transaction.transactionDate.day}/'
        '${transaction.transactionDate.month}/'
        '${transaction.transactionDate.year}';
  }

  IconData _transactionIcon(Transaction transaction) {
    if (transaction.type == TransactionType.income) {
      return Icons.payments;
    }

    return Icons.shopping_cart;
  }

  Future<List<SpendingCategory>> _loadSpendingCategories(
    List<Transaction> transactions,
    MyColours colours,
  ) async {
    final expenseTransactions = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();
    final total = _sumTransactions(
      expenseTransactions,
      TransactionType.expense,
    );

    if (expenseTransactions.isEmpty || total == 0) {
      return [
        SpendingCategory(
          label: 'No spending',
          percentage: 100,
          color: colours.primary,
        ),
      ];
    }

    final totalsByCategory = <String, double>{};

    for (final transaction in expenseTransactions) {
      final mapping = await db.transactionDao.getCategoryForTransaction(
        transaction.id,
      );
      final category = mapping == null
          ? null
          : await db.categoryDao.getCategoryById(mapping.categoryId);
      final label = category?.name ?? 'Uncategorised';

      totalsByCategory[label] =
          (totalsByCategory[label] ?? 0) + _amountAsDouble(transaction);
    }

    final palette = [
      colours.informational,
      colours.secondary,
      colours.primary,
      Colors.redAccent,
    ];
    final entries = totalsByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final visibleEntries = entries.take(3).toList();
    final otherTotal = entries
        .skip(3)
        .fold<double>(0, (total, entry) => total + entry.value);

    if (otherTotal > 0) {
      visibleEntries.add(MapEntry('Others', otherTotal));
    }

    return visibleEntries.asMap().entries.map((entry) {
      final categoryTotal = entry.value.value;

      return SpendingCategory(
        label: entry.value.key,
        percentage: (categoryTotal / total) * 100,
        color: palette[entry.key % palette.length],
      );
    }).toList();
  }

  List<MonthData> _emptyMonthlyTrends() {
    final startMonth = DateTime(selectedDate.year, selectedDate.month - 2);

    return List.generate(3, (index) {
      final month = DateTime(startMonth.year, startMonth.month + index);

      return MonthData(
        month: _monthName(month.month),
        shortMonth: _shortMonthName(month.month),
        income: 0,
        spent: 0,
      );
    });
  }

  Future<List<MonthData>> _loadMonthlyTrends() async {
    final startMonth = DateTime(selectedDate.year, selectedDate.month - 2);
    final months = <MonthData>[];

    for (var index = 0; index < 3; index++) {
      final month = DateTime(startMonth.year, startMonth.month + index);
      final transactions = await db.transactionDao.getTransactionsByDateRange(
        _startOfMonth(month),
        _endOfMonth(month),
      );

      months.add(
        MonthData(
          month: _monthName(month.month),
          shortMonth: _shortMonthName(month.month),
          income: _sumTransactions(transactions, TransactionType.income),
          spent: _sumTransactions(transactions, TransactionType.expense),
        ),
      );
    }

    return months;
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });

    try {
      final colours = MyColours();
      final dayTransactions = await db.transactionDao
          .getTransactionsByDateRange(
            _startOfDay(selectedDate),
            _endOfDay(selectedDate),
          );
      final monthTransactions = await db.transactionDao
          .getTransactionsByDateRange(
            _startOfMonth(selectedDate),
            _endOfMonth(selectedDate),
          );
      final allTransactions = await db.transactionDao.getAllTransactions();
      final categories = await _loadSpendingCategories(
        monthTransactions,
        colours,
      );
      final trends = await _loadMonthlyTrends();

      if (!mounted) {
        return;
      }

      setState(() {
        dailySpending = _sumTransactions(
          dayTransactions,
          TransactionType.expense,
        );
        monthlySpending = _sumTransactions(
          monthTransactions,
          TransactionType.expense,
        );
        spendingCategories = categories;
        dashboardMonths = trends;
        recentTransactions = allTransactions.take(3).toList();
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        loadError = error.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildDailySpendingCard(MyColours colours) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colours.secondary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            
            offset: const Offset(6 ,6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DAILY SPENDING FOR ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: TextStyle(
              color: colours.background,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatCurrency(dailySpending),
            style: TextStyle(
              color: colours.background,
              fontSize: 52,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Monthly total: ${_formatCurrency(monthlySpending)}",
            style: TextStyle(
              color: colours.background.withValues(alpha: 0.8),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = MyColours();

    return Scaffold(
      backgroundColor: colours.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "DASHBOARD",

                        style: colours.h2,
                      ),

                      GestureDetector(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,

                            initialDate: selectedDate,

                            firstDate: DateTime(2024),

                            lastDate: DateTime(2035),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                            _loadDashboardData();
                          }
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          
                          decoration: BoxDecoration(
                            color: colours.bg2,

                            border: Border.all(color: Colors.black, width: 4),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: colours.textPrimary,
                                size: 18,
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                                style: colours.b1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (isLoading)
                  LinearProgressIndicator(
                    color: colours.secondary,
                    backgroundColor: colours.primary,
                  ),

                if (loadError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Could not load dashboard data.',
                      style: TextStyle(
                        color: colours.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                
                _buildDailySpendingCard(colours),

                const SizedBox(height: 10),

               
                

                
                

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      TextButton(
                        onPressed: () {
                          final scanner = context.read<BackgroundAnomalyScanner>();
                          if (scanner.isStale()) scanner.scan();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PredictiveSpendingScreen(),
                            ),
                          );
                        },
                        child: 
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Container(
                          height: MediaQuery.heightOf(context) * 0.08,
                          width: MediaQuery.widthOf(context) * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(color:Colors.black, width: 4),
                            color: colours.secondary,
                            
                            
                          ),
                          child: 
                          
                          Padding(
                            padding: EdgeInsetsGeometry.directional(top: 25),
                            child: 
                          Text(
                            "INSIGHTS",
                            textAlign: TextAlign.center,
                            
                            style: colours.b3,
                          ),
                          ),
                        ),

                        SizedBox(width:  MediaQuery.widthOf(context) * 0.10,),
                         Container(
                          height: MediaQuery.heightOf(context) * 0.08,
                          width: MediaQuery.widthOf(context) * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(color:Colors.black, width: 4),
                            color: colours.secondary,
                            
                            
                          ),
                          child: 
                          
                          Padding(
                            padding: EdgeInsetsGeometry.directional(top: 25),
                            child: 
                          Text(
                            "REPORTS",
                            textAlign: TextAlign.center,
                            
                            style: colours.b3,
                          ),
                          ),
                        ),
                          
                          ],
                          
                          ),
                      
                      ),
                  
                  
                    ]
                  )
                ),
            
                
                const SizedBox(height: 25), 

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Text(
                    "RECENT TRANSACTIONS",

                    style: colours.h2,
                  ),
                ),

                const SizedBox(height: 10),

                
                if (recentTransactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'No recent transactions yet.',
                      style: TextStyle(color: colours.textPrimary),
                    ),
                  )
                else
                  ...recentTransactions.map((transaction) {
                    final isExpense =
                        transaction.type == TransactionType.expense;
                    final prefix = isExpense ? '- ' : '+ ';

                    return TransactionTile(
                      icon: _transactionIcon(transaction),
                      title: transaction.shortDescription,
                      subtitle: _transactionSubtitle(transaction),
                      amount:
                          '$prefix${_formatCurrency(_amountAsDouble(transaction))}',
                      isExpense: isExpense,
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
