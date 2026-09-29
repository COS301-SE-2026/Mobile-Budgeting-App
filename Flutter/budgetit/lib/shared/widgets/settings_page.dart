import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/database_seeder.dart';

import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _currencies = ['ZAR', 'USD', 'EUR', 'GBP'];

  String _currency = 'ZAR';
  bool _isLoading = true;
  bool _aiEnabled = true;
  bool _seedActionBusy = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final dao = context.read<AppDatabase>().settingsDao;
    final currency = await dao.getDefaultCurrency();
    final ai = await dao.getSetting('ai_categorisation');
    if (!mounted) return;
    setState(() {
      _currency = _currencies.contains(currency) ? currency : 'ZAR';
      _aiEnabled = ai != 'false';
      _isLoading = false;
    });
  }

  Future<void> _saveCurrency(String value) async {
    setState(() => _currency = value);
    await context.read<AppDatabase>().settingsDao.setDefaultCurrency(value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Default currency set to $value')),
    );
  }

  Future<void> _saveAiEnabled(bool value) async {
    setState(() => _aiEnabled = value);
    await context
        .read<AppDatabase>()
        .settingsDao
        .setSetting('ai_categorisation', value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colours.background,
      appBar: AppBar(
        backgroundColor: colours.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colours.secondary),
        title: Text('Settings', style: colours.title),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: colours.secondary),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(context, 'APPEARANCE'),
                    const SizedBox(height: 12),
                    _card(
                      context,
                      child: Row(
                        children: [
                          Icon(
                            theme.isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: colours.cardText,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  theme.isDark ? 'Dark mode' : 'Light mode',
                                  style: colours.b1
                                      .copyWith(color: colours.cardText),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Resets to dark each time the app starts.',
                                  style: colours.b2.copyWith(
                                    color: colours.cardText
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: theme.isDark,
                            activeThumbColor: colours.greenAccents,
                            onChanged: (_) =>
                                context.read<ThemeProvider>().toggle(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle(context, 'PREFERENCES'),
                    const SizedBox(height: 12),
                    _card(
                      context,
                      child: _dropdownRow(
                        context,
                        icon: Icons.payments_outlined,
                        label: 'Default currency',
                        value: _currency,
                        options: _currencies,
                        onChanged: _saveCurrency,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      context,
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, color: colours.cardText),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI categorisation',
                                  style: colours.b1
                                      .copyWith(color: colours.cardText),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Suggest categories for imported transactions. Runs on this device.',
                                  style: colours.b2.copyWith(
                                    color: colours.cardText
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _aiEnabled,
                            activeThumbColor: colours.greenAccents,
                            onChanged: _saveAiEnabled,
                          ),
                        ],
                      ),
                    ),                    
                    const SizedBox(height: 24),
                    if (kDebugMode) ...[
                      _sectionTitle(context, 'SEED DATA'),
                      const SizedBox(height: 12),
                      Text(
                        'Changes to synced data will upload when connected, including changes made offline.',
                        style: colours.b2,
                      ),
                      const SizedBox(height: 12),
                      _card(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: colours.b1.copyWith(
                                color: colours.cardText,
                              ),
                            ),
                            FilledButton(
                              onPressed: _createSeedAction(() {
                                final db = context.read<AppDatabase>();
                                final seeder = DatabaseSeeder(db);
                                return _applySeedChange(
                                  seeder.resetSettings,
                                  'Settings restored to defaults',
                                );
                              }),
                              child: const Text('Reset settings to defaults'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final scope in SeedScope.values) ...[
                        _card(
                          context,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scope.label,
                                style: colours.b1.copyWith(
                                  color: colours.cardText,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                children: [
                                  FilledButton(
                                    onPressed: _createSeedAction(
                                      () => _seedScope(scope),
                                    ),
                                    child: Text('Seed ${scope.label}'),
                                  ),
                                  OutlinedButton(
                                    onPressed: _createSeedAction(
                                      () => _deleteScope(scope),
                                    ),
                                    child: Text('Delete all ${scope.label}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _card(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All seed data',
                              style: colours.b1.copyWith(
                                color: colours.cardText,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                FilledButton(
                                  onPressed: _createSeedAction(_seedAll),
                                  child: const Text('Seed all'),
                                ),
                                OutlinedButton(
                                  onPressed: _createSeedAction(_deleteAll),
                                  child: const Text('Delete all'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_seedActionBusy)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  VoidCallback? _createSeedAction(Future<void> Function() action) {
    final controlsAreBusy = _seedActionBusy;
    if (controlsAreBusy) {
      return null;
    }
    return () => _runSeedAction(action);
  }

  Future<void> _runSeedAction(Future<void> Function() action) async {
    final controlsUnavailable = !kDebugMode || _seedActionBusy;
    if (controlsUnavailable) {
      return;
    }
    setState(() => _seedActionBusy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) {
        setState(() => _seedActionBusy = false);
      }
    }
  }

  Future<void> _applySeedChange(
    Future<void> Function() operation,
    String success,
  ) async {
    await operation();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$success. Changes sync when connected.')),
      );
    }
  }

  Future<bool> _confirmSeedChange({
    required String title,
    required String details,
    required String action,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(child: Text(details)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _seedScope(SeedScope scope) async {
    final seeder = DatabaseSeeder(context.read<AppDatabase>());
    final existing = await seeder.getScopeCounts();
    if (!mounted) {
      return;
    }
    if (existing[scope]! > 0) {
      final proceed = await _confirmSeedChange(
        title: '${scope.label} already contains data',
        details:
            '${existing[scope]} rows exist (including deleted records). Seeding cannot run while ${scope.label} contains data. Use Delete all ${scope.label} first.',
        action: 'Delete all ${scope.label}',
      );
      final confirmedWhileMounted = proceed && mounted;
      if (confirmedWhileMounted) {
        await _deleteScope(scope);
      }
      return;
    }
    final missing = await seeder.listMissingCategories(scope);
    if (!mounted) {
      return;
    }
    final requiresCategoryReplacement =
        scope != SeedScope.categories && missing.isNotEmpty;
    if (requiresCategoryReplacement) {
      final categoryDeletionDetails = await seeder.getDeletionDetails(
        SeedScope.categories,
      );
      if (!mounted) {
        return;
      }
      final details =
          'Missing: ${missing.join(', ')}. Seed the required categories? Existing categories, budgets and dependent recurring schedules will be deleted. Linked transactions will remain but lose their category assignments.\n\n$categoryDeletionDetails';
      final proceed = await _confirmSeedChange(
        title: 'Required categories are missing',
        details: details,
        action: 'Replace and seed categories',
      );
      final cancelledOrDisposed = !proceed || !mounted;
      if (cancelledOrDisposed) {
        return;
      }
      await _applySeedChange(
        () => seeder.seedScope(
          scope,
          replaceCategories: true,
          expectedCounts: existing,
        ),
        '${scope.label} and required categories seeded',
      );
      return;
    }
    await _applySeedChange(
      () => seeder.seedScope(scope),
      '${scope.label} seeded',
    );
  }

  Future<void> _deleteScope(SeedScope scope) async {
    final seeder = DatabaseSeeder(context.read<AppDatabase>());
    final existing = await seeder.getScopeCounts();
    if (!mounted) {
      return;
    }
    final details = await seeder.getDeletionDetails(scope);
    if (!mounted) {
      return;
    }
    final proceed = await _confirmSeedChange(
      title: 'Delete all ${scope.label}?',
      details: details,
      action: 'Delete all ${scope.label}',
    );
    final cancelledOrDisposed = !proceed || !mounted;
    if (cancelledOrDisposed) return;
    await _applySeedChange(
      () => seeder.deleteScope(scope, expectedCounts: existing),
      '${scope.label} deleted',
    );
  }

  Future<void> _seedAll() async {
    final seeder = DatabaseSeeder(context.read<AppDatabase>());
    final existing = await seeder.getScopeCounts();
    if (!mounted) {
      return;
    }
    final conflicts = existing.entries
        .where((entry) => entry.value > 0)
        .toList();
    if (conflicts.isNotEmpty) {
      final conflictLabels = conflicts
          .map((entry) => '${entry.key.label}: ${entry.value}')
          .join(', ');
      await _confirmSeedChange(
        title: 'Seed all cannot run',
        details:
            'These scopes contain data (including deleted records): $conflictLabels. Use their Delete all buttons or the confirmed Delete all action first.',
        action: 'OK',
      );
      return;
    }
    await _applySeedChange(seeder.seedAll, 'All seed data seeded');
  }

  Future<void> _deleteAll() async {
    final seeder = DatabaseSeeder(context.read<AppDatabase>());
    final existing = await seeder.getScopeCounts();
    final details = await seeder.getDeleteAllDetails();
    if (!mounted) {
      return;
    }
    final proceed = await _confirmSeedChange(
      title: 'Delete all seed data?',
      details: details,
      action: 'Delete all',
    );
    final cancelledOrDisposed = !proceed || !mounted;
    if (cancelledOrDisposed) {
      return;
    }
    await _applySeedChange(
      () => seeder.deleteAll(expectedCounts: existing),
      'All seed data deleted',
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: context.colours.h2);
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colours.blendedprimary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
        ],
      ),
      child: child,
    );
  }

  Widget _dropdownRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required List<String> options,
    required Future<void> Function(String) onChanged,
  }) {
    final colours = context.colours;
    return Row(
      children: [
        Icon(icon, color: colours.cardText),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: colours.b1.copyWith(color: colours.cardText),
          ),
        ),
        DropdownButton<String>(
          value: value,
          dropdownColor: colours.blendedprimary,
          underline: const SizedBox.shrink(),
          iconEnabledColor: colours.cardText,
          style: colours.b1.copyWith(color: colours.cardText),
          items: options
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}