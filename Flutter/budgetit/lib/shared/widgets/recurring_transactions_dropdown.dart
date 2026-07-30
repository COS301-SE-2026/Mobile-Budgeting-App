import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';


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


}