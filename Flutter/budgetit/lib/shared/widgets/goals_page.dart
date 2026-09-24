import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/schema.dart';

/// Income goals: set a target income per period.
class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  bool _loading = true;
  List<GoalTemplate> _goals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final goals = await context.read<AppDatabase>().goalDao.getAllGoalTemplates();
    if (!mounted) return;
    setState(() {
      _goals = goals;
      _loading = false;
    });
  }

  String _periodLabel(PeriodType p) {
    switch (p) {
      case PeriodType.daily:
        return 'Daily';
      case PeriodType.weekly:
        return 'Weekly';
      case PeriodType.monthly:
        return 'Monthly';
      case PeriodType.yearly:
        return 'Yearly';
    }
  }

  Future<void> _showAddGoalDialog() async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    var period = PeriodType.monthly;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name (optional)'),
              ),
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Target amount'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PeriodType>(
                initialValue: period,
                decoration: const InputDecoration(labelText: 'Period'),
                items: PeriodType.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(_periodLabel(p)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => period = v ?? period),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result != true) return;

    final amountText = amountController.text.trim();
    if (amountText.isEmpty) return;
    final Decimal amount;
    try {
      amount = Decimal.parse(amountText);
    } catch (_) {
      return;
    }

    await context.read<AppDatabase>().goalDao.insertGoalTemplate(
          name: nameController.text.trim().isEmpty
              ? null
              : nameController.text.trim(),
          targetAmount: amount,
          periodType: period,
        );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        foregroundColor: colours.textPrimary,
        elevation: 0,
        title: const Text('Goals'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _goals.isEmpty
                  ? ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'No goals yet. Tap + to set an income goal.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        return Card(
                          child: ListTile(
                            title: Text(goal.name ?? 'Goal'),
                            subtitle: Text(
                              '${goal.currency} ${goal.targetAmount} / '
                              '${_periodLabel(goal.periodType)}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
