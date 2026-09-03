import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/badge.dart';
import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/shared/widgets/searchbox.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/shared/widgets/recurring_transactions_dropdown.dart';

enum _TransactionFilter { all, income, expense }

class TransactionManager extends StatefulWidget {
  const TransactionManager({super.key});

  @override
  State<TransactionManager> createState() => _TransactionManagerState();
}

class _TransactionManagerState extends State<TransactionManager> {
  String _searchQuery = '';
  _TransactionFilter _filter = _TransactionFilter.all;
  List<Transaction> _transactions = [];
  Map<String, String> _transactionCategoryNames = {};
  bool _isLoading = true;

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
    static const _fullMonthNames = [
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
  static const _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final db = context.read<AppDatabase>();
    final dao = db.transactionDao;
    final List<Transaction> txns;
    switch (_filter) {
      case _TransactionFilter.income:
        txns = await dao.getTransactionsByType(TransactionType.income);
      case _TransactionFilter.expense:
        txns = await dao.getTransactionsByType(TransactionType.expense);
      case _TransactionFilter.all:
        txns = await dao.getAllTransactions();
    }

    final categoryNames = <String, String>{};
    await Future.wait(
      txns.map((transaction) async {
        final mapping = await dao.getCategoryForTransaction(transaction.id);
        if (mapping == null) return;
        final category = await db.categoryDao.getCategoryById(
          mapping.categoryId,
        );
        if (category != null) {
          categoryNames[transaction.id] = category.name;
        }
      }),
    );

    if (!mounted) return;
    setState(() {
      _transactions = txns;
      _transactionCategoryNames = categoryNames;
      _isLoading = false;
    });
  }

  void _setFilter(_TransactionFilter f) {
    setState(() {
      _filter = f;
      _isLoading = true;
    });
    _loadTransactions();
  }

  List<Transaction> get _filtered {
    if (_searchQuery.isEmpty) return _transactions;
    final q = _searchQuery.toLowerCase();
    return _transactions
        .where((t) => t.shortDescription.toLowerCase().contains(q))
        .toList();
  }

  Map<DateTime, List<Transaction>> _groupByDate(List<Transaction> txns) {
    final map = <DateTime, List<Transaction>>{};
    for (final t in txns) {
      final local = t.transactionDate.toLocal();
      final date = DateTime(local.year, local.month, local.day);
      (map[date] ??= []).add(t);
    }
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
    return sorted;
  }

    Map<DateTime, List<Transaction>> _groupByMonth(List<Transaction> txns) {
    final map = <DateTime, List<Transaction>>{};
    for (final t in txns) {
      final local = t.transactionDate.toLocal();
      final month = DateTime(local.year, local.month);
      (map[month] ??= []).add(t);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  double _monthNet(List<Transaction> txns) {
    var net = 0.0;
    for (final t in txns) {
      final amount = t.amount.toDouble();
      net += t.type == TransactionType.income ? amount : -amount;
    }
    return net;
  }

  String _formatAmount(double amount) {
    final fixed = amount.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first;
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      final remaining = whole.length - i;
      buffer.write(whole[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }

  void _handleEdit(String id, String name, double amount) {
    final dao = context.read<AppDatabase>().transactionDao;
    dao
        .updateTransaction(
          id,
          shortDescription: name,
          amount: Decimal.parse(amount.toStringAsFixed(2)),
        )
        .then((_) => _loadTransactions());
  }

  void _handleDelete(String id) {
    final dao = context.read<AppDatabase>().transactionDao;
    dao.softDeleteTransaction(id).then((_) => _loadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final colours = context.colours;
    final byMonth = _groupByMonth(_filtered);

    return Scaffold(
      backgroundColor: colours.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('TRANSACTION MANAGER', style: context.colours.h2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        hintText: 'Search for Transaction',
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    MyBadge(
                      text: 'All',
                      isSelected: _filter == _TransactionFilter.all,
                      onTap: () => _setFilter(_TransactionFilter.all),
                    ),
                    const SizedBox(width: 8),
                    MyBadge(
                      text: 'Income',
                      isSelected: _filter == _TransactionFilter.income,
                      onTap: () => _setFilter(_TransactionFilter.income),
                    ),
                    const SizedBox(width: 8),
                    MyBadge(
                      text: 'Expenses',
                      isSelected: _filter == _TransactionFilter.expense,
                      onTap: () => _setFilter(_TransactionFilter.expense),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.transparent),
              const RecurringTransactionsDropdown(),
              const  Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('RECENT TRANSACTIONS', style: context.colours.h2),
                  ],
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: CircularProgressIndicator(color: colours.secondary),
                )
              else if (byMonth.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Text(
                    _searchQuery.isNotEmpty
                        ? 'No results for "$_searchQuery"'
                        : 'No transactions yet',
                    style: TextStyle(
                      color: colours.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                )
              else
                ...byMonth.entries.map((monthEntry) {
                  final month = monthEntry.key;
                  final monthTxns = monthEntry.value;
                  final net = _monthNet(monthTxns);
                  final byDay = _groupByDate(monthTxns);

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                    decoration: BoxDecoration(
                      color: colours.blendedprimary,
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${_fullMonthNames[month.month - 1]} ${month.year}'
                                    .toUpperCase(),
                                style: colours.h2.copyWith(
                                  color: colours.cardText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${net < 0 ? '-' : ''}R${_formatAmount(net)}',
                              style: colours.b1.copyWith(
                                color: net < 0
                                    ? colours.warning
                                    : colours.greenAccents,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 3,
                          color: colours.cardText.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 12),
                        ...byDay.entries.map((dayEntry) {
                          final date = dayEntry.key;
                          final txns = dayEntry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${_dayNames[date.weekday - 1]}, ${_monthNames[date.month - 1]} ${date.day}',
                                  style: colours.b2.copyWith(
                                    color: colours.cardText.withValues(
                                      alpha: 0.75,
                                    ),
                                  ),
                                ),
                              ),
                              ...txns.map(
                                (t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: MyBox(
                                    key: ValueKey(t.id),
                                    transactionId: t.id,
                                    text: t.shortDescription,
                                    amount: t.amount.toDouble(),
                                    icon: t.type == TransactionType.income
                                        ? Icons.arrow_circle_up_outlined
                                        : Icons.arrow_circle_down_outlined,
                                    category:
                                        _transactionCategoryNames[t.id] ??
                                        (t.type == TransactionType.income
                                            ? 'Income'
                                            : 'Expense'),
                                    categories: const [],
                                    transactionType: t.type,
                                    date:
                                        '${_dayNames[date.weekday - 1]}, ${_monthNames[date.month - 1]} ${date.day}, ${date.year}',
                                    isExpense:
                                        t.type == TransactionType.expense,
                                    onEdited: (name, amount, icon, category) =>
                                        _handleEdit(t.id, name, amount),
                                    onDelete: () => _handleDelete(t.id),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FAB(onTransactionAdded: _loadTransactions),
    );
  }
}
