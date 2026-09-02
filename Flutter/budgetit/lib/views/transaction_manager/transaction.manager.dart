import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/box.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/shared/widgets/transaction_filter_bar.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/shared/widgets/recurring_transactions_dropdown.dart';

class TransactionManager extends StatefulWidget {
  const TransactionManager({super.key});

  @override
  State<TransactionManager> createState() => _TransactionManagerState();
}

class _TransactionManagerState extends State<TransactionManager> {
  String _searchQuery = '';
  String _selectedCategory = TransactionFilterBar.allCategories;
  TransactionSort _sort = TransactionSort.newest;
  List<Transaction> _transactions = [];
  Map<String, String> _transactionCategoryNames = {};
  Map<String, IconData> _transactionCategoryIcons = {};
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
    final db = context.read<AppDatabase>();
    final dao = db.transactionDao;
    final txns = await dao.getAllTransactions();

    final categoryNames = <String, String>{};
    final categoryIcons = <String, IconData>{};
    await Future.wait(
      txns.map((transaction) async {
        final mapping = await dao.getCategoryForTransaction(transaction.id);
        if (mapping == null) return;
        final category = await db.categoryDao.getCategoryById(
          mapping.categoryId,
        );
        if (category != null) {
          categoryNames[transaction.id] = category.name;
          categoryIcons[transaction.id] =
              category.iconData ?? Icons.category_outlined;
        }
      }),
    );

    if (!mounted) return;
    final availableCategories = txns.map((transaction) {
      return categoryNames[transaction.id] ??
          (transaction.type == TransactionType.income ? 'Income' : 'Expense');
    }).toSet();
    setState(() {
      _transactions = txns;
      _transactionCategoryNames = categoryNames;
      _transactionCategoryIcons = categoryIcons;
      if (_selectedCategory != TransactionFilterBar.allCategories &&
          !availableCategories.contains(_selectedCategory)) {
        _selectedCategory = TransactionFilterBar.allCategories;
      }
      _isLoading = false;
    });
  }

  List<Transaction> get _filtered {
    final q = _searchQuery.toLowerCase();
    final filtered = _transactions.where((transaction) {
      final category = _categoryFor(transaction);
      final matchesSearch =
          q.isEmpty ||
          transaction.shortDescription.toLowerCase().contains(q) ||
          category.toLowerCase().contains(q);
      final matchesCategory =
          _selectedCategory == TransactionFilterBar.allCategories ||
          category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filtered.sort(
      (a, b) => switch (_sort) {
        TransactionSort.newest => b.transactionDate.compareTo(
          a.transactionDate,
        ),
        TransactionSort.oldest => a.transactionDate.compareTo(
          b.transactionDate,
        ),
        TransactionSort.amountHigh => b.amount.compareTo(a.amount),
        TransactionSort.amountLow => a.amount.compareTo(b.amount),
        TransactionSort.nameAZ => a.shortDescription.toLowerCase().compareTo(
          b.shortDescription.toLowerCase(),
        ),
      },
    );
    return filtered;
  }

  String _categoryFor(Transaction transaction) =>
      _transactionCategoryNames[transaction.id] ??
      (transaction.type == TransactionType.income ? 'Income' : 'Expense');

  IconData _categoryIconFor(Transaction transaction) {
    final categoryIcon = _transactionCategoryIcons[transaction.id];
    if (categoryIcon != null) return categoryIcon;
    return transaction.type == TransactionType.expense
        ? Icons.arrow_downward
        : Icons.arrow_upward;
  }

  List<String> get _categories {
    final values = _transactions.map(_categoryFor).toSet().toList()..sort();
    return values;
  }

  Map<String, IconData> get _categoryIconsByName {
    final icons = <String, IconData>{};
    for (final transaction in _transactions) {
      icons.putIfAbsent(
        _categoryFor(transaction),
        () => _categoryIconFor(transaction),
      );
    }
    return icons;
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
    final filtered = _filtered;

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
                  horizontal: 16,
                  vertical: 5,
                ),
                child: TransactionFilterBar(
                  categories: _categories,
                  categoryIcons: _categoryIconsByName,
                  selectedCategory: _selectedCategory,
                  selectedSort: _sort,
                  onSearchChanged: (value) =>
                      setState(() => _searchQuery = value),
                  onCategoryChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  onSortChanged: (value) => setState(() => _sort = value),
                ),
              ),
              const Divider(color: Colors.transparent),
              const RecurringTransactionsDropdown(),
              const Divider(color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('TRANSACTIONS', style: context.colours.h2)],
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: CircularProgressIndicator(color: colours.secondary),
                )
              else if (filtered.isEmpty)
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
                ...filtered.map((transaction) {
                  final date = transaction.transactionDate.toLocal();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MyBox(
                      key: ValueKey(transaction.id),
                      transactionId: transaction.id,
                      text: transaction.shortDescription,
                      amount: transaction.amount.toDouble(),
                      icon: _categoryIconFor(transaction),
                      category: _categoryFor(transaction),
                      categories: _categories,
                      transactionType: transaction.type,
                      date:
                          '${_dayNames[date.weekday - 1]}, ${_monthNames[date.month - 1]} ${date.day}, ${date.year}',
                      isExpense: transaction.type == TransactionType.expense,
                      onEdited: (name, amount, icon, category) =>
                          _handleEdit(transaction.id, name, amount),
                      onDelete: () => _handleDelete(transaction.id),
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
