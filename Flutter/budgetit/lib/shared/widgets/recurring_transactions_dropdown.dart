import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_edit_recurring_transaction_dialog.dart';
import 'recurring_transaction_card.dart';

class RecurringTransactionsDropdown extends StatefulWidget {
  const RecurringTransactionsDropdown({super.key});

  @override
  State<RecurringTransactionsDropdown> createState() =>
      _RecurringTransactionsDropdownState();
}

class _RecurringTransactionsDropdownState
    extends State<RecurringTransactionsDropdown> {
  bool _expanded = false;
  bool _isLoading = true;
  List<RecurringTransaction> _recurringTransactions = [];
  List<Transaction> _completedThisMonth = [];

  static const _monthNames = [
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final dao = context.read<AppDatabase>().recurringTransactionDao;
      final database = context.read<AppDatabase>();
      final results = await Future.wait([
        dao.getAllRecurringTransactions(),
        database.transactionDao.getAllTransactions(),
      ]);
      final items = results[0] as List<RecurringTransaction>;
      final transactions = results[1] as List<Transaction>;
      final now = DateTime.now();
      final completed =
          transactions
              .where(
                (transaction) =>
                    transaction.recurringId != null &&
                    transaction.deletedAt == null &&
                    transaction.transactionDate.year == now.year &&
                    transaction.transactionDate.month == now.month,
              )
              .toList()
            ..sort(
              (first, second) =>
                  second.transactionDate.compareTo(first.transactionDate),
            );
      if (!mounted) return;
      setState(() {
        _recurringTransactions = items;
        _completedThisMonth = completed;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _recurringTransactions = [];
        _completedThisMonth = [];
        _isLoading = false;
      });
    }
  }

  void _toggleExpanded() => setState(() => _expanded = !_expanded);
  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditRecurringTransactionDialog(onSaved: _load),
    );
  }

  void _openEditDialog(RecurringTransaction rt) {
    showDialog(
      context: context,
      builder: (_) => AddEditRecurringTransactionDialog(
        existing: rt,
        onSaved: _load,
        onDeleted: _load,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: colours.background,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                height: 52,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colours.secondary,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black, width: 3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.autorenew, color: colours.background),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'RECURRING TRANSACTIONS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: colours.h2.copyWith(
                          color: colours.background,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.expand_more, color: colours.background),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _expanded ? _buildBody(colours) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(MyColours colours) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      child: Column(
        children: [
          GestureDetector(
            onTap: _openAddDialog,
            child: Stack(
              children: [
                Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colours.background,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(5, 5),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 48,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colours.secondary,
                    border: Border.all(color: Colors.black, width: 4.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: colours.background),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Add Recurring Transaction',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colours.background,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(color: colours.secondary),
            )
          else ...[
            _buildCurrentMonthCard(colours),
            const SizedBox(height: 18),
            _buildAllRecurringCard(colours),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCurrentMonthCard(MyColours colours) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcoming =
        _recurringTransactions.where((item) {
          final date = item.nextTransactionDate.toLocal();
          return date.year == now.year &&
              date.month == now.month &&
              !DateTime(date.year, date.month, date.day).isBefore(today);
        }).toList()..sort(
          (first, second) =>
              first.nextTransactionDate.compareTo(second.nextTransactionDate),
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: colours.blendedprimary,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${_monthNames[now.month - 1]} ${now.year}'.toUpperCase(),
            style: colours.h2.copyWith(color: colours.cardText),
          ),
          const SizedBox(height: 10),
          Container(height: 3, color: colours.cardText.withValues(alpha: 0.35)),
          const SizedBox(height: 14),
          _recurringSectionTitle(colours, 'UPCOMING THIS MONTH'),
          const SizedBox(height: 9),
          if (upcoming.isEmpty)
            _emptySectionMessage(
              colours,
              'No more recurring transactions are scheduled this month.',
            )
          else
            ...upcoming.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: RecurringTransactionCard(
                  key: ValueKey(item.id),
                  recurringTransaction: item,
                  onTap: () => _openEditDialog(item),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(height: 2, color: colours.cardText.withValues(alpha: 0.25)),
          const SizedBox(height: 14),
          _recurringSectionTitle(colours, 'COMPLETED THIS MONTH'),
          const SizedBox(height: 9),
          if (_completedThisMonth.isEmpty)
            _emptySectionMessage(
              colours,
              'No recurring transactions have completed this month.',
            )
          else
            ..._completedThisMonth.map(
              (transaction) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _completedTransactionTile(colours, transaction),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAllRecurringCard(MyColours colours) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: colours.blendedprimary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ALL RECURRING TRANSACTIONS',
            style: colours.h2.copyWith(color: colours.cardText, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            '${_recurringTransactions.length} active schedule${_recurringTransactions.length == 1 ? '' : 's'}',
            style: colours.b5.copyWith(
              color: colours.cardText.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 3, color: colours.cardText.withValues(alpha: 0.35)),
          const SizedBox(height: 14),
          if (_recurringTransactions.isEmpty)
            _emptySectionMessage(
              colours,
              'No recurring transactions yet. Add one to automate your budget.',
            )
          else
            ..._recurringTransactions.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: RecurringTransactionCard(
                  key: ValueKey('all-${item.id}'),
                  recurringTransaction: item,
                  onTap: () => _openEditDialog(item),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _recurringSectionTitle(MyColours colours, String title) {
    return Text(
      title,
      style: colours.b2.copyWith(
        color: colours.cardText,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _emptySectionMessage(MyColours colours, String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        message,
        style: colours.b5.copyWith(
          color: colours.cardText.withValues(alpha: 0.65),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _completedTransactionTile(MyColours colours, Transaction transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final date = transaction.transactionDate.toLocal();

    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colours.primary,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colours.secondary,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(
              isExpense ? Icons.arrow_downward : Icons.arrow_upward,
              color: colours.background,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.shortDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: colours.budgetheader.copyWith(
                    color: colours.cardText,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Completed ${date.day} ${_monthNames[date.month - 1]}',
                  style: colours.b5.copyWith(
                    color: colours.cardText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isExpense ? '- ' : ''}R${transaction.amount.toStringAsFixed(2)}',
            style: colours.b4.copyWith(
              color: isExpense ? colours.error : colours.greenAccents,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
