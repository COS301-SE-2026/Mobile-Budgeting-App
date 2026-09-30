import 'dart:async';

import 'package:budgetit/auth/data/cognito_auth_service.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/services/friend_service.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/icon_mapper.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' show TableUpdate, TableUpdateQuery;
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

  final List<GoalMember> members;

  final bool isOwner;

  final Decimal mySavedAmount;

  const _GoalItem({
    required this.template,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.savedAmount,
    required this.contributions,
    required this.members,
    required this.isOwner,
    required this.mySavedAmount,
  });

  List<GoalMember> get acceptedMembers => members
      .where((member) => member.status == GoalMemberStatus.accepted)
      .toList();

  List<GoalMember> get pendingMembers => members
      .where((member) => member.status == GoalMemberStatus.pending)
      .toList();

  bool get isShared => members.isNotEmpty;

  double get saved => savedAmount.toDouble();

  double get mySaved => mySavedAmount.toDouble();

  double get target => template.targetAmount.toDouble();

  double get remaining => target - saved <= 0 ? 0 : target - saved;

  double get progress => target <= 0 ? 0 : (saved / target).clamp(0.0, 1.0);

  int get percent => (progress * 100).round();

  bool get isComplete => target > 0 && saved >= target;
}

class _GoalInvite {
  final GoalMember membership;
  final GoalTemplate template;
  final String title;

  const _GoalInvite({
    required this.membership,
    required this.template,
    required this.title,
  });
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
  StreamSubscription<Set<TableUpdate>>? _updatesSub;
  Timer? _reloadDebounce;
  bool _loading = true;
  bool _busy = false;
  String _searchQuery = '';
  _GoalView _view = _GoalView.progress;
  List<_GoalItem> _goals = const [];
  List<_GoalInvite> _invites = const [];
  List<Category> _categories = const [];
  String? _currentUserId;
  List<String> _friendIds = const [];
  Map<String, String> _codeByUserId = const {};
  Decimal _surplus = Decimal.zero;

  @override
  void initState() {
    super.initState();
    _db = context.read<AppDatabase>();
    _updatesSub = _db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            _db.goalTemplates,
            _db.goalContributions,
            _db.goalMembers,
            _db.transactions,
          ]),
        )
        .listen((_) => _scheduleReload());
    _load();
  }

  @override
  void dispose() {
    _updatesSub?.cancel();
    _reloadDebounce?.cancel();
    _goalNameController.dispose();
    _goalTargetController.dispose();
    _allocateAmountController.dispose();
    _allocateNoteController.dispose();
    super.dispose();
  }

  void _scheduleReload() {
    _reloadDebounce?.cancel();
    _reloadDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) _load();
    });
  }

  Future<String?> _resolveCurrentUserId() async {
    final cached = _currentUserId;
    if (cached != null) return cached;
    final fromSession = await CognitoAuthService().getCurrentUserId();
    if (fromSession != null) return fromSession;
    try {
      return await FriendService.instance.getMyUserId();
    } catch (_) {
      return null;
    }
  }

  Future<Decimal> _calculateSurplus() async {
    final transactions = await _db.transactionDao.getAllTransactions();
    return transactions.fold<Decimal>(
      Decimal.zero,
      (sum, row) => row.type == TransactionType.income
          ? sum + row.amount
          : sum - row.amount,
    );
  }

  bool get _hasSurplus => _surplus > Decimal.zero;

  String _signedMoney(Decimal amount) {
    final value = amount.toDouble();
    return value < 0 ? '-${_money(value.abs())}' : _money(value);
  }

  String _surplusLimitMessage(Decimal surplus) => surplus <= Decimal.zero
      ? 'You have no surplus to allocate. Add income first.'
      : 'You only have ${_money(surplus.toDouble())} surplus available.';

  Future<void> _load() async {
    final me = await _resolveCurrentUserId();
    final templates = await _db.goalDao.getAllGoalTemplates();
    final categories = await _db.categoryDao.getAllCategories();
    final membersByGoal = await _db.sharingDao.getGoalMembersForTemplates(
      templates.map((template) => template.id),
    );
    final friendships = await _db.friendsDao.getFriends();
    final profiles = await _db.friendsDao.getAllProfiles();
    final surplus = await _calculateSurplus();

    final items = <_GoalItem>[];
    final invites = <_GoalInvite>[];

    for (final template in templates) {
      final members = membersByGoal[template.id] ?? const <GoalMember>[];
      final isOwner = template.userId == null || template.userId == me;
      GoalMember? myMembership;
      for (final member in members) {
        if (member.userId == me) myMembership = member;
      }

      final title = _titleFor(template, categories);

      if (!isOwner) {
        if (myMembership == null) continue;
        if (myMembership.status == GoalMemberStatus.pending) {
          invites.add(
            _GoalInvite(
              membership: myMembership,
              template: template,
              title: title,
            ),
          );
          continue;
        }
        if (myMembership.status != GoalMemberStatus.accepted) continue;
      }

      final contributions = await _db.goalDao.getContributionsForTemplate(
        template.id,
      );
      final saved = contributions.fold<Decimal>(
        Decimal.zero,
        (sum, row) => sum + row.amount,
      );
      final mySaved = contributions
          .where((row) => _isMine(row, me))
          .fold<Decimal>(Decimal.zero, (sum, row) => sum + row.amount);

      items.add(
        _GoalItem(
          template: template,
          title: title,
          subtitle: members.isEmpty
              ? '${_periodLabel(template.periodType)} Goal'
              : '${_periodLabel(template.periodType)} · Shared Goal',
          icon: _iconFor(template, categories),
          savedAmount: saved,
          contributions: contributions,
          members: members,
          isOwner: isOwner,
          mySavedAmount: mySaved,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _currentUserId = me;
      _goals = items;
      _invites = invites;
      _categories = categories;
      _friendIds = [
        for (final friendship in friendships)
          if (me != null)
            friendship.userA == me ? friendship.userB : friendship.userA,
      ];
      _codeByUserId = {
        for (final profile in profiles)
          if (profile.userId != null) profile.userId!: profile.friendCode,
      };
      _surplus = surplus;
      _loading = false;
    });
  }

  String _titleFor(GoalTemplate template, List<Category> categories) {
    final name = template.name;
    if (name != null) return name;
    final categoryId = template.categoryId;
    for (final category in categories) {
      if (category.id == categoryId) return category.name;
    }
    return 'Goal';
  }

  IconData _iconFor(GoalTemplate template, List<Category> categories) {
    final categoryId = template.categoryId;
    for (final category in categories) {
      if (category.id == categoryId) {
        return category.iconData ?? Icons.flag_outlined;
      }
    }
    return Icons.flag_outlined;
  }

  bool _isMine(GoalContribution contribution, [String? me]) {
    final userId = contribution.userId;
    return userId == null || userId == (me ?? _currentUserId);
  }

  String _nameFor(String? userId) {
    if (userId == null || userId == _currentUserId) return 'You';
    final code = _codeByUserId[userId];
    return code == null ? 'Member' : 'Friend $code';
  }

  String? _ownerIdOf(_GoalItem goal) =>
      goal.isOwner ? _currentUserId : goal.template.userId;

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

  String _contributionLabel(GoalContribution contribution, bool shared) {
    final parts = [
      if (shared) _nameFor(contribution.userId),
      _formatDate(contribution.contributedAt),
      if (contribution.note != null) contribution.note!,
    ];
    return parts.join(' · ');
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
    final defaultBudget = await _db.budgetDao.getOrCreateDefaultBudget();
    final created = await _db.categoryDao.insertCategory(
      name: name,
      type: type,
      budgetTemplateId: defaultBudget.id,
      icon: icon,
      color: '#137E84',
    );
    return created.id;
  }

  void _notify(String message) {
    if (!mounted) return;
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? colours.secondary : colours.background;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? colours.blendedprimary : colours.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 3),
        ),
        content: Text(message, style: colours.b1.copyWith(color: foreground)),
      ),
    );
  }

  Future<void> _allocate(_GoalItem goal, Decimal amount, String? note) async {
    setState(() => _busy = true);
    try {
      final surplus = await _calculateSurplus();
      if (amount > surplus) {
        if (mounted) setState(() => _surplus = surplus);
        _notify(_surplusLimitMessage(surplus));
        return;
      }
      final categoryId = await _ensureCategoryId(
        _savingsCategoryName,
        CategoryType.expense,
        Icons.savings_outlined,
      );
      final defaultBudget = await _db.budgetDao.getOrCreateDefaultBudget();
      final transaction = await _db.transactionDao.insertTransaction(
        amount: amount,
        type: TransactionType.expense,
        shortDescription: _clip('Goal: ${goal.title}'),
        longDescription: note,
        transactionDate: DateTime.now(),
        source: TransactionSource.manual,
        currency: goal.template.currency,
        budgetTemplateId: defaultBudget.id,
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
        userId: _currentUserId,
      );
      await _load();
      _notify('${_money(amount.toDouble())} allocated to ${goal.title}.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _undoContribution(GoalContribution contribution) async {
    if (!_isMine(contribution)) {
      _notify('Only the member who made an allocation can undo it.');
      return;
    }
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

  Future<Decimal> _releaseMyFunds(_GoalItem goal) async {
    final amount = goal.isShared ? goal.mySavedAmount : goal.savedAmount;
    if (amount <= Decimal.zero) return Decimal.zero;

    final categoryId = await _ensureCategoryId(
      _releaseCategoryName,
      CategoryType.income,
      Icons.undo,
    );
    final defaultBudget = await _db.budgetDao.getOrCreateDefaultBudget();
    final transaction = await _db.transactionDao.insertTransaction(
      amount: amount,
      type: TransactionType.income,
      shortDescription: _clip('Goal released: ${goal.title}'),
      longDescription: goal.isComplete
          ? 'Completed goal released back into available income.'
          : 'Cancelled goal released back into available income.',
      transactionDate: DateTime.now(),
      source: TransactionSource.manual,
      currency: goal.template.currency,
      budgetTemplateId: defaultBudget.id,
    );
    await _db.transactionDao.assignCategory(
      transactionId: transaction.id,
      categoryId: categoryId,
      assignmentSource: AssignmentSource.manual,
    );
    await _db.goalDao.clearContributionsForTemplate(
      goal.template.id,
      userId: goal.isShared ? _currentUserId : null,
    );
    return amount;
  }

  Future<void> _releaseGoal(_GoalItem goal, {required bool delete}) async {
    setState(() => _busy = true);
    try {
      final released = await _releaseMyFunds(goal);

      if (delete) {
        for (final pending in goal.pendingMembers) {
          final userId = pending.userId;
          if (userId != null) {
            await _db.sharingDao.removeGoalMember(goal.template.id, userId);
          }
        }
        await _db.goalDao.softDeleteGoalTemplate(goal.template.id);
      }

      await _load();
      _notify(
        released > Decimal.zero
            ? '${_money(released.toDouble())} returned to income.'
            : delete
            ? 'Goal deleted.'
            : 'Nothing of yours to release.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _inviteFriends(_GoalItem goal, List<String> friendIds) async {
    final me = _currentUserId;
    if (me == null) {
      _notify('Sign in again to share goals.');
      return;
    }
    for (final friendId in friendIds) {
      await _db.sharingDao.inviteToGoal(
        goalTemplateId: goal.template.id,
        inviteeId: friendId,
        invitedBy: me,
      );
    }
  }

  Future<void> _respondToInvite(_GoalInvite invite, bool accept) async {
    setState(() => _busy = true);
    try {
      await _db.sharingDao.respondToGoalInvite(
        invite.membership.id,
        accept: accept,
      );
      await _load();
      _notify(
        accept
            ? 'You joined "${invite.title}".'
            : 'Invite to "${invite.title}" declined.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _leaveGoal(_GoalItem goal) async {
    final me = _currentUserId;
    if (me == null) return;
    setState(() => _busy = true);
    try {
      final released = await _releaseMyFunds(goal);
      await _db.sharingDao.removeGoalMember(goal.template.id, me);
      await _load();
      _notify(
        released > Decimal.zero
            ? 'You left "${goal.title}". '
                  '${_money(released.toDouble())} returned to income.'
            : 'You left "${goal.title}".',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeMember(_GoalItem goal, GoalMember member) async {
    final userId = member.userId;
    if (userId == null) return;
    final hasContributions = goal.contributions.any((c) => c.userId == userId);
    if (hasContributions) {
      _notify(
        '${_nameFor(userId)} still has money in this goal. They need to '
        'release it or leave the goal themselves.',
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await _db.sharingDao.removeGoalMember(goal.template.id, userId);
      await _load();
      _notify(
        member.status == GoalMemberStatus.pending
            ? 'Invite cancelled.'
            : '${_nameFor(userId)} removed from the goal.',
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
                      _surplusCard(),
                      const SizedBox(height: 14),
                      _createGoalButton(),
                      if (_invites.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text('GOAL INVITES', style: colours.h2),
                        const SizedBox(height: 12),
                        for (final invite in _invites) ...[
                          _inviteCard(invite),
                          const SizedBox(height: 14),
                        ],
                      ],
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
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _money(_totalSaved),
              style: colours.h2.copyWith(
                color: cardTextColor,
                fontSize: 40,
                letterSpacing: -1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
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
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Left to save: ${_money(_totalRemaining)}',
            style: colours.h2.copyWith(
              color: cardTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_goals.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: Colors.black, width: 2),
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

  Widget _surplusCard() {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? colours.background : colours.cardText,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: isDark ? colours.cardText : cardColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AVAILABLE SURPLUS',
                  style: colours.h2.copyWith(
                    color: cardTextColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _hasSurplus
                      ? 'What you can still allocate to goals'
                      : 'Add income to start allocating',
                  style: colours.b5.copyWith(
                    color: cardTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                _signedMoney(_surplus),
                maxLines: 1,
                style: colours.h2.copyWith(
                  color: _hasSurplus ? colours.greenAccents : colours.error,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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

  Widget _inviteCard(_GoalInvite invite) {
    final colours = context.colours;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardColor = isLight ? colours.secondary : colours.blendedprimary;
    final cardTextColor = isLight ? colours.background : colours.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [BoxShadow(offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group_add_outlined, color: cardTextColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  invite.title,
                  style: colours.budgetheader.copyWith(
                    color: cardTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_nameFor(invite.membership.invitedBy)} invited you to save '
            'towards ${_money(invite.template.targetAmount.toDouble())} '
            'together.',
            style: colours.b5.copyWith(color: cardTextColor, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: _busy ? null : () => _respondToInvite(invite, false),
                child: Text(
                  'Decline',
                  style: colours.b1.copyWith(color: cardTextColor),
                ),
              ),
              _dialogAction(
                label: 'Join goal',
                background: cardTextColor,
                foreground: cardColor,
                onPressed: () {
                  if (!_busy) _respondToInvite(invite, true);
                },
              ),
            ],
          ),
        ],
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
    final isActive = _view != _GoalView.progress;
    final foreground = isLight ? colours.secondary : colours.cardText;
    final background = isActive
        ? colours.informational
        : isLight
        ? colours.cardText
        : colours.searchBar;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_GoalView>(
          value: _view,
          isExpanded: true,
          dropdownColor: isLight ? colours.cardText : colours.searchBar,
          iconEnabledColor: foreground,
          style: colours.b1.copyWith(color: foreground),
          items: _GoalView.values
              .map(
                (view) => DropdownMenuItem<_GoalView>(
                  value: view,
                  child: Row(
                    children: [
                      Icon(
                        view == _GoalView.reached
                            ? Icons.check_circle_outline
                            : view == _GoalView.newest
                            ? Icons.schedule
                            : Icons.trending_up,
                        size: 18,
                        color: foreground,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _viewLabel(view),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (view) {
            if (view != null) setState(() => _view = view);
          },
        ),
      ),
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
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: colours.b1.copyWith(color: colours.textPrimary),
      ),
    );
  }

  Widget _tag(String label, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      color: background,
      child: Text(
        label,
        style: context.colours.b5.copyWith(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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
    final memberCount = goal.acceptedMembers.length + 1;

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
                if (goal.isComplete || goal.isShared)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 6,
                      children: [
                        if (goal.isShared)
                          _tag(
                            'SHARED · $memberCount',
                            colours.blue,
                            colours.whiteAccents,
                          ),
                        if (goal.isComplete)
                          _tag(
                            'GOAL REACHED',
                            colours.greenAccents,
                            colours.category,
                          ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isLight
                            ? colours.secondary
                            : colours.blendedprimary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(
                        goal.icon,
                        color: isLight ? colours.background : colours.cardText,
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
                          style: colours.b4.copyWith(
                            color: cardTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: _busy
                              ? null
                              : () => goal.isOwner
                                    ? _confirmDeleteGoal(goal)
                                    : _confirmLeaveGoal(goal),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              goal.isOwner
                                  ? Icons.delete_outline
                                  : Icons.logout,
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
                    border: Border.all(color: Colors.black, width: 1.5),
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
                    Opacity(
                      opacity: _hasSurplus ? 1 : 0.45,
                      child: InkWell(
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

  Widget _friendPicker({
    required List<String> friendIds,
    required Set<String> selected,
    required Color textColor,
    required void Function(void Function()) setDialogState,
  }) {
    final colours = context.colours;
    return Column(
      children: [
        for (final friendId in friendIds)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: selected.contains(friendId),
            activeColor: textColor,
            checkColor: Colors.black,
            side: BorderSide(color: textColor, width: 2),
            title: Text(
              _nameFor(friendId),
              style: colours.b1.copyWith(color: textColor),
            ),
            onChanged: (checked) => setDialogState(() {
              if (checked ?? false) {
                selected.add(friendId);
              } else {
                selected.remove(friendId);
              }
            }),
          ),
      ],
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
    final shareWith = <String>{};

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
            if (existing == null && _friendIds.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'SHARE WITH FRIENDS (OPTIONAL)',
                style: colours.b5.copyWith(
                  color: cardTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              _friendPicker(
                friendIds: _friendIds,
                selected: shareWith,
                textColor: cardTextColor,
                setDialogState: setDialogState,
              ),
            ],
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
      final template = await _db.goalDao.insertGoalTemplate(
        name: name.isEmpty ? null : name,
        targetAmount: amount,
        periodType: period,
        categoryId: categoryId,
      );
      if (shareWith.isNotEmpty) {
        final me = _currentUserId;
        if (me != null) {
          for (final friendId in shareWith) {
            await _db.sharingDao.inviteToGoal(
              goalTemplateId: template.id,
              inviteeId: friendId,
              invitedBy: me,
            );
          }
          _notify(
            shareWith.length == 1
                ? 'Goal created. Invite sent.'
                : 'Goal created. ${shareWith.length} invites sent.',
          );
        }
      }
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

  Future<void> _showInviteDialog(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    final ownerId = _ownerIdOf(goal);
    final alreadyIn = {
      ?ownerId,
      for (final member in goal.members) ?member.userId,
    };
    final candidates = _friendIds
        .where((friendId) => !alreadyIn.contains(friendId))
        .toList();
    final selected = <String>{};

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setDialogState) => _dialogShell(
          title: 'SHARE ${goal.title.toUpperCase()}',
          children: [
            Text(
              candidates.isEmpty
                  ? (_friendIds.isEmpty
                        ? 'Add friends first (Profile › Friends) to share '
                              'goals with them.'
                        : 'All your friends are already on this goal.')
                  : 'Invited friends can allocate towards this goal once '
                        'they accept. Everyone sees the shared progress.',
              style: colours.b1.copyWith(color: cardTextColor),
            ),
            if (candidates.isNotEmpty) ...[
              const SizedBox(height: 12),
              _friendPicker(
                friendIds: candidates,
                selected: selected,
                textColor: cardTextColor,
                setDialogState: setDialogState,
              ),
            ],
          ],
          actions: [
            _dialogCancel(dialogContext, cardTextColor),
            if (candidates.isNotEmpty)
              _dialogAction(
                label: 'Send invites',
                background: cardTextColor,
                foreground: cardColor,
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted || selected.isEmpty) return;
    setState(() => _busy = true);
    try {
      await _inviteFriends(goal, selected.toList());
      await _load();
      _notify(
        selected.length == 1
            ? 'Invite sent.'
            : '${selected.length} invites sent.',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showAllocateDialog(_GoalItem goal) async {
    if (!_hasSurplus) {
      _notify(_surplusLimitMessage(_surplus));
      return;
    }

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
          const SizedBox(height: 14),
          _detailRow(
            'Available surplus',
            _money(_surplus.toDouble()),
            cardTextColor,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _allocateAmountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: colours.b1.copyWith(color: cardTextColor),
            decoration: _fieldDecoration(
              'Amount',
              cardTextColor,
              helper: goal.isComplete
                  ? 'This goal has already been reached. '
                        'Max ${_money(_surplus.toDouble())}.'
                  : 'Left to save: ${_money(goal.remaining)} · '
                        'Max ${_money(_surplus.toDouble())}',
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
    if (amount > _surplus) {
      _notify(_surplusLimitMessage(_surplus));
      return;
    }

    await _allocate(goal, amount, note.isEmpty ? null : note);
  }

  Widget _memberRow({
    required String label,
    required Color textColor,
    String? tag,
    VoidCallback? onRemove,
    String removeTooltip = 'Remove',
  }) {
    final colours = context.colours;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: 18, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: colours.b1.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (tag != null)
            Text(
              tag,
              style: colours.b5.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          if (onRemove != null)
            IconButton(
              tooltip: removeTooltip,
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 16, color: textColor),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  Future<void> _showGoalDetails(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? colours.blendedprimary : colours.secondary;
    final cardTextColor = isDark ? colours.secondary : colours.background;
    final canRelease = goal.isShared ? goal.mySaved > 0 : goal.saved > 0;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: goal.title.toUpperCase(),
        children: [
          _detailRow('Target', _money(goal.target), cardTextColor),
          _detailRow('Saved', _money(goal.saved), cardTextColor),
          if (goal.isShared)
            _detailRow('Saved by you', _money(goal.mySaved), cardTextColor),
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
            'MEMBERS',
            style: colours.b5.copyWith(
              color: cardTextColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          _memberRow(
            label: _nameFor(_ownerIdOf(goal)),
            tag: 'OWNER',
            textColor: cardTextColor,
          ),
          for (final member in goal.members)
            _memberRow(
              label: _nameFor(member.userId),
              tag: member.status == GoalMemberStatus.pending ? 'INVITED' : null,
              textColor: cardTextColor,
              removeTooltip: member.status == GoalMemberStatus.pending
                  ? 'Cancel invite'
                  : 'Remove member',
              onRemove: goal.isOwner
                  ? () {
                      Navigator.of(dialogContext).pop();
                      _removeMember(goal, member);
                    }
                  : null,
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
                                    _contributionLabel(
                                      contribution,
                                      goal.isShared,
                                    ),
                                    style: colours.b5.copyWith(
                                      color: cardTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (_isMine(contribution))
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
          if (!goal.isOwner)
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _confirmLeaveGoal(goal);
              },
              child: Text(
                'Leave',
                style: colours.b1.copyWith(color: cardTextColor),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _showInviteDialog(goal);
            },
            child: Text(
              'Share',
              style: colours.b1.copyWith(color: cardTextColor),
            ),
          ),
          if (canRelease)
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
            goal.isShared
                ? 'The ${_money(goal.mySaved)} you put in will be booked back '
                      'as income. Other members keep their allocations and '
                      'the goal itself is kept.'
                : '${_money(goal.saved)} will be booked back as income and '
                      'the goal will reset to zero. The goal itself is kept.',
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

  Future<void> _confirmLeaveGoal(_GoalItem goal) async {
    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardTextColor = isDark ? colours.secondary : colours.background;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: 'LEAVE GOAL',
        children: [
          Text(
            goal.mySaved > 0
                ? 'Leave "${goal.title}"? The ${_money(goal.mySaved)} you put '
                      'in will be booked back as income.'
                : 'Leave "${goal.title}"? You will need a new invite to '
                      'rejoin.',
            style: colours.b1.copyWith(color: cardTextColor),
          ),
        ],
        actions: [
          _dialogCancel(dialogContext, cardTextColor),
          _dialogAction(
            label: 'Leave',
            background: colours.error,
            foreground: colours.whiteAccents,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _leaveGoal(goal);
    }
  }

  Future<void> _confirmDeleteGoal(_GoalItem goal) async {
    if (goal.acceptedMembers.isNotEmpty) {
      _notify(
        'Other members are still on this goal. Remove them (or ask them to '
        'leave) before deleting it.',
      );
      return;
    }

    final colours = context.colours;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardTextColor = isDark ? colours.secondary : colours.background;
    final releasable = goal.isShared ? goal.mySaved : goal.saved;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _dialogShell(
        title: 'DELETE GOAL',
        children: [
          Text(
            releasable > 0
                ? 'Delete "${goal.title}"? The ${_money(releasable)} set '
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
