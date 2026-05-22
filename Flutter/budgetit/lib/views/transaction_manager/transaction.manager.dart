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
    final dao = context.read<AppDatabase>().transactionDao;
    final List<Transaction> txns;
    switch (_filter) {
      case _TransactionFilter.income:
        txns = await dao.getTransactionsByType(TransactionType.income);
      case _TransactionFilter.expense:
        txns = await dao.getTransactionsByType(TransactionType.expense);
      case _TransactionFilter.all:
        txns = await dao.getAllTransactions();
    }
    if (!mounted) return;
    setState(() {
      _transactions = txns;
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
    final colours = MyColours();
    final grouped = _groupByDate(_filtered);

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: colours.headingFontSize2,
                        color: colours.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: CircularProgressIndicator(color: colours.secondary),
                )
              else if (grouped.isEmpty)
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
                ...grouped.entries.map((entry) {
                  final date = entry.key;
                  final txns = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dayNames[date.weekday - 1],
                              style: TextStyle(
                                fontSize: colours.headingFontSize3,
                                color: colours.textPrimary,
                              ),
                            ),
                            Text(
                              '${date.day} ${_monthNames[date.month - 1]} ${date.year}',
                              style: TextStyle(
                                fontSize: colours.bodyFontSize,
                                color: colours.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...txns.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MyBox(
                            key: ValueKey(t.id),
                            text: t.shortDescription,
                            amount: t.amount.toDouble(),
                            icon: t.type == TransactionType.income
                                ? Icons.arrow_circle_up_outlined
                                : Icons.arrow_circle_down_outlined,
                            category: t.type == TransactionType.income
                                ? 'Income'
                                : 'Expense',
                            categories: const [],
                            onEdited: (name, amount, icon, category) =>
                                _handleEdit(t.id, name, amount),
                            onDelete: () => _handleDelete(t.id),
                          ),
                        ),
                      ),
                    ],
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
