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
  static const _currencies = ['ZAR', 'USD', 'EUR', 'GBP'];

  String _currency = 'ZAR';
  bool _isLoading = true;
  bool _aiEnabled = true;

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