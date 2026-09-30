import 'package:budgetit/auth/providers/auth_provider.dart';
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

    final ai = await dao.getSetting('ai_categorisation');
    if (!mounted) return;
    setState(() {

      _aiEnabled = ai != 'false';
      _isLoading = false;
    });
  }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Default currency set to $value')));
  Future<void> _saveAiEnabled(bool value) async {
    setState(() => _aiEnabled = value);
    await context.read<AppDatabase>().settingsDao.setSetting(
      'ai_categorisation',
      value.toString(),
  }

    await context.read<AppDatabase>().settingsDao.setSetting(
      'ai_categorisation',
      value.toString(),
    );
  Future<void> _toggleBiometricLock(
    BuildContext context,
    AppAuthProvider auth,
  ) async {
    final changed = await auth.setBiometricLockEnabled(
      !auth.biometricLockEnabled,
    );
    if (!changed && context.mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final theme = context.watch<ThemeProvider>();
    final auth = context.watch<AppAuthProvider>();

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
            ? Center(child: CircularProgressIndicator(color: colours.secondary))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
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
                                  style: colours.b1.copyWith(
                                    color: colours.cardText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Resets to dark each time the app starts.',
                                  style: colours.b2.copyWith(
                                    color: colours.cardText.withValues(
                                      alpha: 0.7,
                                    ),
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
                                  style: colours.b1.copyWith(
                                    color: colours.cardText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Suggest categories for imported transactions. Runs on this device.',
                                  style: colours.b2.copyWith(
                                    color: colours.cardText.withValues(
                                      alpha: 0.7,
                                    ),
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colours.background,
                          border: Border.all(color: colours.warning, width: 3),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: colours.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Changes to synced data upload when connected, including changes made offline.',
                                style: colours.b1.copyWith(
                                  color: colours.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_seedActionBusy) ...[
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          label: 'Seed operation in progress',
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: colours.secondary,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Seed operation in progress',
                                style: colours.b1,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _createSeedAction(() {
                                final db = context.read<AppDatabase>();
                                final seeder = DatabaseSeeder(db);
                                return _applySeedChange(() async {
                                  await seeder.resetSettings();
                                  await _loadSettings();
                                }, 'Settings restored to defaults');
                              }),
                              style: _seedButtonStyle(colours),
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
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton(
                                    onPressed: _createSeedAction(
                                      () => _seedScope(scope),
                                    ),
                                    style: _seedButtonStyle(colours),
                                    child: Text('Seed ${scope.label}'),
                                  ),
                                  OutlinedButton(
                                    onPressed: _createSeedAction(
                                      () => _deleteScope(scope),
                                    ),
                                    style: _deleteSeedButtonStyle(colours),
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
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton(
                                  onPressed: _createSeedAction(_seedAll),
                                  style: _seedButtonStyle(colours),
                                  child: const Text('Seed all'),
                                ),
                                OutlinedButton(
                                  onPressed: _createSeedAction(_deleteAll),
                                  style: _deleteSeedButtonStyle(colours),
                                  child: const Text('Delete all'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (auth.isLoggedIn) ...[
                      _sectionTitle(context, 'SECURITY'),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: colours.primary,
                          border: Border.all(color: Colors.black, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: auth.isLoading
                              ? null
                              : () => _toggleBiometricLock(context, auth),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'BIOMETRIC LOCK',
                                        style: colours.h4.copyWith(
                                          color: colours.cardText,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Require Android biometrics when reopening the app',
                                        style: colours.b1.copyWith(
                                          color: colours.cardText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: auth.biometricLockEnabled
                                        ? colours.cardText
                                        : colours.background,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    auth.biometricLockEnabled ? 'ON' : 'OFF',
                                    style: colours.b1.copyWith(
                                      color: auth.biometricLockEnabled
                                          ? colours.primary
                                          : colours.cardText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
    required bool destructive,
  }) async {
    final colours = context.colours;
    ButtonStyle confirmButtonStyle = _seedButtonStyle(colours);
    if (destructive) {
      confirmButtonStyle = _deleteConfirmButtonStyle(colours);
    }

    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: colours.background,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 4),
            ),
            title: Text(title, style: colours.h2),
            content: SingleChildScrollView(
              child: Text(details, style: colours.b1),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                style: TextButton.styleFrom(
                  foregroundColor: colours.textPrimary,
                  textStyle: colours.b1,
                ),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: confirmButtonStyle,
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
        action: 'Review deletion',
        destructive: false,
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
        destructive: true,
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
      destructive: true,
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
        destructive: false,
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
      destructive: true,
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

  ButtonStyle _seedButtonStyle(MyColours colours) {
    return FilledButton.styleFrom(
      backgroundColor: colours.secondary,
      foregroundColor: colours.background,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 3),
      ),
      textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  ButtonStyle _deleteSeedButtonStyle(MyColours colours) {
    return OutlinedButton.styleFrom(
      backgroundColor: colours.background,
      foregroundColor: colours.error,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      side: BorderSide(color: colours.error, width: 3),
      textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  ButtonStyle _deleteConfirmButtonStyle(MyColours colours) {
    return FilledButton.styleFrom(
      backgroundColor: colours.error,
      foregroundColor: colours.whiteAccents,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 3),
      ),
      textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
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
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: child,
    );
  }

}
