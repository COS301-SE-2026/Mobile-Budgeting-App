import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/schema.dart';
import 'searchbox.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

enum _GoalView { progress, newest, reached }

class _GoalItem {
  final GoalTemplate template;
  final String title;
  final String subtitle;
  final IconData icon;
  final Decimal savedAmount;
  final List<GoalContribution> contributions;

  const _GoalItem({
    required this.template,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.savedAmount,
    required this.contributions,
  });

  double get saved => savedAmount.toDouble();

  double get target => template.targetAmount.toDouble();

  double get remaining => target - saved <= 0 ? 0 : target - saved;

  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);

  int get percent => (progress * 100).round();

  bool get isComplete => target > 0 && saved >= target;
}

class _GoalsPageState extends State<GoalsPage> {
  static const _savingsCategoryName = 'Goals & Savings';
  static const _releaseCategoryName = 'Goal Release';

  late final AppDatabase _db;
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _goalTargetController = TextEditingController();
  final TextEditingController _allocateAmountController =
      TextEditingController();
  final TextEditingController _allocateNoteController = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  String _searchQuery = '';
  _GoalView _view = _GoalView.progress;
  List<_GoalItem> _goals = const [];
  List<Category> _categories = const [];

  @override
  void initState() {
    super.initState();
    _db = context.read<AppDatabase>();
    _load();
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _goalTargetController.dispose();
    _allocateAmountController.dispose();
    _allocateNoteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final templates = await _db.goalDao.getAllGoalTemplates();
    final categories = await _db.categoryDao.getAllCategories();
    final items = <_GoalItem>[];

    for (final template in templates) {
      final contributions = await _db.goalDao.getContributionsForTemplate(
        template.id,
      );
      final saved = contributions.fold<Decimal>(
        Decimal.zero,
        (sum, row) => sum + row.amount,
      );

      var icon = Icons.flag_outlined;
      var title = template.name ?? 'Goal';

      final categoryId = template.categoryId;
      if (categoryId != null) {
        for (final category in categories) {
          if (category.id != categoryId) continue;
          icon = category.iconData ?? icon;
          if (template.name == null) title = category.name;
          break;
        }
      }

      items.add(
        _GoalItem(
          template: template,
          title: title,
          subtitle: '${_periodLabel(template.periodType)} Goal',
          icon: icon,
          savedAmount: saved,
          contributions: contributions,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _goals = items;
      _categories = categories;
      _loading = false;
    });
  }

  double get _totalSaved =>
      _goals.fold<double>(0, (sum, goal) => sum + goal.saved);

  double get _totalTarget =>
      _goals.fold<double>(0, (sum, goal) => sum + goal.target);

  double get _totalRemaining =>
      _goals.fold<double>(0, (sum, goal) => sum + goal.remaining);

  int get _reachedCount => _goals.where((goal) => goal.isComplete).length;

  List<Category> get _pickableCategories => _categories
      .where(
        (category) =>
            category.name != _savingsCategoryName &&
            category.name != _releaseCategoryName,
      )
      .toList();

  List<_GoalItem> get _filteredGoals => _goals
      .where((goal) => goal.title.toLowerCase().contains(_searchQuery))
      .toList();

  List<_GoalItem> _ordered(List<_GoalItem> goals) {
    final ordered = [...goals];
    switch (_view) {
      case _GoalView.progress:
        ordered.sort((a, b) => b.progress.compareTo(a.progress));
      case _GoalView.newest:
      case _GoalView.reached:
        ordered.sort(
          (a, b) => b.template.createdAt.compareTo(a.template.createdAt),
        );
    }
    return ordered;
  }

  String _viewLabel(_GoalView view) {
    switch (view) {
      case _GoalView.progress:
        return 'PROGRESS';
      case _GoalView.newest:
        return 'NEWEST';
      case _GoalView.reached:
        return 'REACHED';
    }
  }

  String _goalProgressLabel(_GoalItem goal) {
    if (goal.isComplete) return '100% · Goal reached';
    return '${goal.percent}% · ${_money(goal.remaining)} to go';
  }

  String? _paceValue(_GoalItem goal) {
    if (goal.isComplete || goal.saved <= 0 || goal.contributions.isEmpty) {
      return null;
    }
    final first = goal.contributions.last.contributedAt;
    final days = DateTime.now().toUtc().difference(first).inDays;
    final months = days < 30 ? 1.0 : days / 30;
    final perMonth = goal.saved / months;
    if (perMonth <= 0) return null;
    final monthsLeft = (goal.remaining / perMonth).ceil();
    if (monthsLeft <= 0) return null;
    if (monthsLeft > 120) return 'Over 10 years';
    return monthsLeft == 1 ? '~1 month' : '~$monthsLeft months';
  }

  String _periodLabel(PeriodType period) {
    switch (period) {
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

  String _money(double amount) => 'R${amount.toStringAsFixed(2)}';

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  String _contributionLabel(GoalContribution contribution) {
    final date = _formatDate(contribution.contributedAt);
    final note = contribution.note;
    return note == null ? date : '$date · $note';
  }

  String _clip(String value) =>
      value.length <= 100 ? value : '${value.substring(0, 97)}...';

  Future<String> _ensureCategoryId(
    String name,
    CategoryType type,
    IconData icon,
  ) async {
    final existing = await _db.categoryDao.getCategoriesByType(type);
    for (final category in existing) {
      if (category.name.toLowerCase() == name.toLowerCase()) {
        return category.id;
      }
    }
    final created = await _db.categoryDao.insertCategory(
      name: name,
      type: type,
      icon: icon,
      color: '#137E84',
    );
    return created.id;
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.colours.primary,
        content: Text(
          message,
          style: context.colours.b1.copyWith(color: context.colours.cardText),
        ),
      ),
    );
  }

  Future<void> _allocate(_GoalItem goal, Decimal amount, String? note) async {
    setState(() => _busy = true);
    try {
      final categoryId = await _ensureCategoryId(
        _savingsCategoryName,
        CategoryType.expense,
        Icons.savings_outlined,
      );
      final transaction = await _db.transactionDao.insertTransaction(
        amount: amount,
        type: TransactionType.expense,
        shortDescription: _clip('Goal: ${goal.title}'),
        longDescription: note,
        transactionDate: DateTime.now(),
        source: TransactionSource.manual,
        currency: goal.template.currency,
      );
      await _db.transactionDao.assignCategory(
        transactionId: transaction.id,
        categoryId: categoryId,
        assignmentSource: AssignmentSource.manual,
      );
      await _db.goalDao.insertGoalContribution(
        templateId: goal.template.id,
        amount: amount,
        note: note,
        transactionId: transaction.id,
      );
      await _load();
      _notify('${_money(amount.toDouble())} allocated to ${goal.title}.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _undoContribution(GoalContribution contribution) async {
    setState(() => _busy = true);
    try {
      final transactionId = contribution.transactionId;
      if (transactionId != null) {
        await _db.transactionDao.softDeleteTransaction(transactionId);
      }
      await _db.goalDao.softDeleteGoalContribution(contribution.id);
      await _load();
      _notify('Allocation removed.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _releaseGoal(_GoalItem goal, {required bool delete}) async {
    setState(() => _busy = true);
    try {
      if (goal.saved > 0) {
        final categoryId = await _ensureCategoryId(
          _releaseCategoryName,
          CategoryType.income,
          Icons.undo,
        );
        final transaction = await _db.transactionDao.insertTransaction(
          amount: goal.savedAmount,
          type: TransactionType.income,
          shortDescription: _clip('Goal released: ${goal.title}'),
          longDescription: goal.isComplete
              ? 'Completed goal released back into available income.'
              : 'Cancelled goal released back into available income.',
          transactionDate: DateTime.now(),
          source: TransactionSource.manual,
          currency: goal.template.currency,
        );
        await _db.transactionDao.assignCategory(
          transactionId: transaction.id,
          categoryId: categoryId,
          assignmentSource: AssignmentSource.manual,
        );
        await _db.goalDao.clearContributionsForTemplate(goal.template.id);
      }

      if (delete) {
        await _db.goalDao.softDeleteGoalTemplate(goal.template.id);
      }

      await _load();
      _notify(
        goal.saved > 0
            ? '${_money(goal.saved)} returned to income.'
            : 'Goal deleted.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _load,
              color: colours.secondary,
              backgroundColor: colours.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      const SizedBox(height: 18),
                      _overviewCard(),
                      const SizedBox(height: 14),
                      _createGoalButton(),
                      const SizedBox(height: 18),
                      Text('YOUR GOALS', style: colours.h2),
                      const SizedBox(height: 12),
                      SearchBox(
                        hintText: 'Search goals',
                        onChanged: (value) => setState(
                          () => _searchQuery = value.trim().toLowerCase(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _goalList(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            if (_busy)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: colours.secondary,
                  borderRadius: BorderRadius.zero,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final colours = context.colours;

    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colours.primary,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: Icon(Icons.arrow_back, color: colours.cardText, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('SAVINGS GOALS', style: colours.h2),
          ),
        ),
      ],
    );
  }

  Widget _overviewCard() {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = isLight ? colours.secondary : colours.blendedprimary;
    final cardTextColor = isLight ? colours.background : colours.secondary;

    final progress = _totalTarget <= 0
        ? 0.0
        : (_totalSaved / _totalTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL SAVED',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _money(_totalSaved),
              style: colours.bigDisplay.copyWith(color: cardTextColor),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: cardTextColor, width: 1.5),
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: cardTextColor.withValues(alpha: 0.25),
              valueColor: AlwaysStoppedAnimation<Color>(colours.blue),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Goal target: ${_money(_totalTarget)}',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
          const SizedBox(height: 6),
          Text(
            'Left to save: ${_money(_totalRemaining)}',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
          if (_goals.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: cardTextColor, width: 2),
              ),
              child: Text(
                '$_reachedCount OF ${_goals.length} GOALS REACHED',
                style: colours.b5.copyWith(
                  color: cardTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _createGoalButton() {
    final colours = context.colours;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _busy ? null : () => _showGoalFormDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colours.background,
          foregroundColor: colours.secondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 4),
          ),
          textStyle: colours.b3.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        child: const Text('CREATE NEW GOAL'),
      ),
    );
  }

  Widget _goalList() {
    final colours = context.colours;

    if (_loading) {
      return Center(
        child: LinearProgressIndicator(
          color: colours.secondary,
          borderRadius: BorderRadius.zero,
        ),
      );
    }

    if (_goals.isEmpty) {
      return _emptyState(
        'No goals yet. Use the button above to set one up, then allocate '
        'surplus to it whenever you have some.',
      );
    }

    final filtered = _filteredGoals;
    if (filtered.isEmpty) {
      return _emptyState('No goals match "$_searchQuery".');
    }

    final reached = _ordered(
      filtered.where((goal) => goal.isComplete).toList(),
    );

    if (_view == _GoalView.reached) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _viewBar(),
          const SizedBox(height: 14),
          if (reached.isEmpty)
            _emptyState('No goals reached yet. Keep allocating.'),
          for (final goal in reached) ...[
            _goalCard(goal),
            const SizedBox(height: 14),
          ],
        ],
      );
    }

    final active = _ordered(
      filtered.where((goal) => !goal.isComplete).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _viewBar(),
        const SizedBox(height: 14),
        for (final goal in active) ...[
          _goalCard(goal),
          const SizedBox(height: 14),
        ],
        if (active.isEmpty)
          _emptyState('Every goal here has been reached. Nice.'),
        if (reached.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('REACHED', style: colours.h2),
          const SizedBox(height: 12),
          for (final goal in reached) ...[
            _goalCard(goal),
            const SizedBox(height: 14),
          ],
        ],
      ],
    );
  }

  Widget _viewBar() {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = isLight ? colours.secondary : colours.blendedprimary;
    final cardTextColor = isLight ? colours.background : colours.secondary;

    return Row(
      children: [
        for (final view in _GoalView.values) ...[
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _view = view),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _view == view ? cardColor : colours.background,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  _viewLabel(view),
                  style: colours.b5.copyWith(
                    color: _view == view ? cardTextColor : colours.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
          if (view != _GoalView.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _emptyState(String message) {
    final colours = context.colours;
    final cardColor = Theme.of(context).brightness == Brightness.light
        ? colours.background
        : colours.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: colours.secondary, width: 1),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colours.textPrimary, fontSize: 13),
      ),
    );
  }

  Widget _goalCard(_GoalItem goal) {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = isLight ? colours.secondary : colours.blendedprimary;
    final cardTextColor = isLight ? colours.background : colours.secondary;
    final trackColor = isLight ? colours.background : colours.secondary;
    final valueColor = goal.isComplete
        ? colours.greenAccents
        : goal.saved <= 0
        ? colours.cardText
        : colours.blue;

    return InkWell(
      onTap: () => _showGoalDetails(goal),
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(6, 6),
              child: Container(color: Colors.black),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Column(
              children: [
                if (goal.isComplete)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: colours.greenAccents,
                      child: Text(
                        'GOAL REACHED',
                        style: TextStyle(
                          color: colours.category,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colours.secondary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        goal.icon,
                        color: colours.background,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: colours.budgetheader.copyWith(
                              color: cardTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            goal.subtitle,
                            style: colours.b5.copyWith(
                              color: cardTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'R${goal.saved.toInt()} / R${goal.target.toInt()}',
                          style: colours.h2.copyWith(
                            color: cardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: _busy ? null : () => _confirmDeleteGoal(goal),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline,
                              color: colours.error,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: trackColor, width: 1.5),
                  ),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 6,
                    backgroundColor: trackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(valueColor),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _goalProgressLabel(goal),
                        style: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _busy ? null : () => _showAllocateDialog(goal),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: cardTextColor,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14, color: cardColor),
                            const SizedBox(width: 6),
                            Text(
                              'ALLOCATE',
                              style: colours.b5.copyWith(
                                color: cardColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogShell({
    required String title,
    required List<Widget> children,
    required List<Widget> actions,
  }) {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: colours.h2.copyWith(color: cardTextColor)),
              const SizedBox(height: 18),
              ...children,
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    String label,
    Color textColor, {
    String? helper,
  }) {
    final colours = context.colours;
    return InputDecoration(
      labelText: label,
      labelStyle: colours.b1.copyWith(color: textColor),
      helperText: helper,
      helperMaxLines: 2,
      helperStyle: colours.b5.copyWith(color: textColor),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.black, width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: textColor, width: 3),
      ),
    );
  }

  Widget _dialogCancel(BuildContext dialogContext, Color textColor) {
    return TextButton(
      onPressed: () => Navigator.of(dialogContext).pop(),
      child: Text(
        'Cancel',
        style: context.colours.b1.copyWith(color: textColor),
      ),
    );
  }

  Widget _dialogAction({
    required String label,
    required VoidCallback onPressed,
    required Color background,
    required Color foreground,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        textStyle: context.colours.b1.copyWith(fontWeight: FontWeight.bold),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 3),
        ),
      ),
      child: Text(label),
    );
  }

  Future<void> _showGoalFormDialog({_GoalItem? existing}) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    _goalNameController.text = existing?.template.name ?? '';
    _goalTargetController.text = existing == null
        ? ''
        : existing.template.targetAmount.toString();
    var period = existing?.template.periodType ?? PeriodType.monthly;
    final pickable = _pickableCategories;
    var categoryId = existing?.template.categoryId;
    if (categoryId != null &&
        !pickable.any((category) => category.id == categoryId)) {
      categoryId = null;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setDialogState) => _dialogShell(
          title: existing == null ? 'NEW GOAL' : 'EDIT GOAL',
          children: [
            TextField(
              controller: _goalNameController,
              style: colours.b1.copyWith(color: cardTextColor),
              decoration: _fieldDecoration('Goal name', cardTextColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalTargetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: colours.b1.copyWith(color: cardTextColor),
              decoration: _fieldDecoration(
                'Target amount',
                cardTextColor,
                helper: 'What the goal costs in full.',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<PeriodType>(
              initialValue: period,
              dropdownColor: cardColor,
              style: colours.b1.copyWith(color: cardTextColor),
              icon: Icon(Icons.keyboard_arrow_down, color: cardTextColor),
              decoration: _fieldDecoration('Period', cardTextColor),
              items: PeriodType.values
                  .map(
                    (value) => DropdownMenuItem<PeriodType>(
                      value: value,
                      child: Text(_periodLabel(value)),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setDialogState(() => period = value ?? period),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String?>(
              initialValue: categoryId,
              isExpanded: true,
              dropdownColor: cardColor,
              style: colours.b1.copyWith(color: cardTextColor),
              icon: Icon(Icons.keyboard_arrow_down, color: cardTextColor),
              decoration: _fieldDecoration('Category', cardTextColor),
              items: [
                DropdownMenuItem<String?>(
                  child: Text('None', style: colours.b1),
                ),
                for (final category in pickable)
                  DropdownMenuItem<String?>(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(
                          category.iconData ?? Icons.category_outlined,
                          size: 18,
                          color: cardTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) => setDialogState(() => categoryId = value),
            ),
          ],
          actions: [
            _dialogCancel(dialogContext, cardTextColor),
            _dialogAction(
              label: existing == null ? 'Create' : 'Save',
              background: cardTextColor,
              foreground: cardColor,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        ),
      ),
    );

    final name = _goalNameController.text.trim();
    final amount = _parseAmount(_goalTargetController.text);

    if (confirmed != true || !mounted) return;
    if (amount == null) {
      _notify('Enter a target amount greater than zero.');
      return;
    }

    if (existing == null) {
      await _db.goalDao.insertGoalTemplate(
        name: name.isEmpty ? null : name,
        targetAmount: amount,
        periodType: period,
        categoryId: categoryId,
      );
    } else {
      await _db.goalDao.updateGoalTemplate(
        existing.template.id,
        name: name.isEmpty ? null : name,
        targetAmount: amount,
        periodType: period,
        categoryId: categoryId,
        clearName: name.isEmpty,
        clearCategory: categoryId == null,
      );
    }
    await _load();
  }

  Future<void> _showAllocateDialog(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    _allocateAmountController.clear();
    _allocateNoteController.clear();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: 'ALLOCATE TO ${goal.title.toUpperCase()}',
        children: [
          Text(
            'Set aside surplus you already have. The amount is recorded as an '
            'expense, so it leaves your spendable balance immediately.',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _allocateAmountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: colours.b1.copyWith(color: cardTextColor),
            decoration: _fieldDecoration(
              'Amount',
              cardTextColor,
              helper: goal.isComplete
                  ? 'This goal has already been reached.'
                  : 'Left to save: ${_money(goal.remaining)}',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _allocateNoteController,
            style: colours.b1.copyWith(color: cardTextColor),
            decoration: _fieldDecoration('Note (optional)', cardTextColor),
          ),
        ],
        actions: [
          _dialogCancel(dialogContext, cardTextColor),
          _dialogAction(
            label: 'Allocate',
            background: cardTextColor,
            foreground: cardColor,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    final amount = _parseAmount(_allocateAmountController.text);
    final note = _allocateNoteController.text.trim();

    if (confirmed != true || !mounted) return;
    if (amount == null) {
      _notify('Enter an amount greater than zero.');
      return;
    }

    await _allocate(goal, amount, note.isEmpty ? null : note);
  }

  Future<void> _showGoalDetails(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: goal.title.toUpperCase(),
        children: [
          _detailRow('Target', _money(goal.target), cardTextColor),
          _detailRow('Saved', _money(goal.saved), cardTextColor),
          _detailRow('Left to save', _money(goal.remaining), cardTextColor),
          _detailRow('Progress', '${goal.percent}%', cardTextColor),
          if (_paceValue(goal) != null)
            _detailRow('At this rate', _paceValue(goal)!, cardTextColor),
          _detailRow(
            'Repeats',
            _periodLabel(goal.template.periodType),
            cardTextColor,
          ),
          const SizedBox(height: 18),
          Text(
            'ALLOCATION HISTORY',
            style: colours.b5.copyWith(
              color: cardTextColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          if (goal.contributions.isEmpty)
            Text(
              'Nothing allocated yet.',
              style: colours.b1.copyWith(color: cardTextColor),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final contribution in goal.contributions)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: cardTextColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _money(contribution.amount.toDouble()),
                                    style: colours.b1.copyWith(
                                      color: cardTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _contributionLabel(contribution),
                                    style: colours.b5.copyWith(
                                      color: cardTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Undo this allocation',
                              icon: Icon(
                                Icons.undo,
                                size: 18,
                                color: cardTextColor,
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _undoContribution(contribution);
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
        actions: [
          if (goal.saved > 0)
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _confirmReleaseGoal(goal);
              },
              child: Text(
                'Release funds',
                style: colours.b1.copyWith(color: cardTextColor),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _showGoalFormDialog(existing: goal);
            },
            child: Text(
              'Edit',
              style: colours.b1.copyWith(color: cardTextColor),
            ),
          ),
          _dialogAction(
            label: 'Close',
            background: cardTextColor,
            foreground: cardColor,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, Color textColor) {
    final colours = context.colours;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: colours.b1.copyWith(color: textColor)),
          Text(
            value,
            style: colours.b1.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReleaseGoal(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: 'RELEASE FUNDS',
        children: [
          Text(
            '${_money(goal.saved)} will be booked back as income and the goal '
            'will reset to zero. The goal itself is kept.',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
        ],
        actions: [
          _dialogCancel(dialogContext, cardTextColor),
          _dialogAction(
            label: 'Release',
            background: cardTextColor,
            foreground: cardColor,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _releaseGoal(goal, delete: false);
    }
  }

  Future<void> _confirmDeleteGoal(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: 'DELETE GOAL',
        children: [
          Text(
            goal.saved > 0
                ? 'Delete "${goal.title}"? The ${_money(goal.saved)} set '
                      'aside will be booked back as income.'
                : 'Delete "${goal.title}"?',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
        ],
        actions: [
          _dialogCancel(dialogContext, cardTextColor),
          _dialogAction(
            label: 'Delete',
            background: colours.error,
            foreground: colours.whiteAccents,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _releaseGoal(goal, delete: true);
    }
  }

  Decimal? _parseAmount(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    try {
      final value = Decimal.parse(text);
      return value <= Decimal.zero ? null : value;
    } catch (_) {
      return null;
    }
  }
}
