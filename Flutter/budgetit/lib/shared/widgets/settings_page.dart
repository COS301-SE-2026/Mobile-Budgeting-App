import 'package:budgetit/auth/providers/auth_provider.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
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

  Future<void> _saveAiEnabled(bool value) async {
    setState(() => _aiEnabled = value);
    await context.read<AppDatabase>().settingsDao.setSetting(
      'ai_categorisation',
      value.toString(),
    );
  }

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
