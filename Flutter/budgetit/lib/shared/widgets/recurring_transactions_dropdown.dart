import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_edit_recurring_transaction_dialog.dart';
import 'recurring_transaction_card.dart';

class RecurringTransactionsDropdown extends StatefulWidget { const RecurringTransactionsDropdown({super.key});
  @override
  State<RecurringTransactionsDropdown> createState() => _RecurringTransactionsDropdownState();
}

class _RecurringTransactionsDropdown extends State<RecurringTransactionsDropdown> {
  bool _expanded = false;
  bool _isLoading = true;
  List<RecurringTransaction> _recurringTransactions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dao = context.read<AppDatabase>().recurringTransactionDao;
    final items = await dao.getAllRecurringTransactions();
    if(!mounted) return;
    setState((){
      _recurringTransactions = items;
      _isLoading = false;
    });
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
        onDelted: _load,
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final colours = context.colours;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleExpanded,
              child: Stack(
                children: [
                  Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: colours.background,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(6,6),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: colours.primary,
                      border: Border.all(color: Colors.black, width: 4.0),

                    ),
                    child: Row(
                      children: [
                        Icon(Icons.autorenew, color: colours.cardText),
                        const SizedBox(width: 8),
                        Text(
                          _recurringTransactions.isEmpty ? 'RECURRING TRANSACTIONS' : 'RECURRING TRANSACTION (${_recurringTransactions.length})',
                          style: colours.h2,
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 :0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.expand_more,
                            color: colours.cardText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _expanded ? _buildBody(colours) : const SizedBox.shrink(),
            ),


          ],
      ),
    );
  }


}