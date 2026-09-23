import 'package:flutter/material.dart';
import 'package:budgetit/auth/providers/auth_provider.dart';

import 'package:provider/provider.dart';
import '../../utils/app_colour.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedCurrency = 'ZAR (\R)';
  // bool _darkModeEnabled = true;
  bool _billAlertsEnabled = true;
  // bool _biometricUnlockEnabled = false;
  bool _twoFactorEnabled = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.colours.blendedprimary,
          content: Text(
            message,
            style: context.colours.b1.copyWith(
              color: context.colours.textPrimary,
            ),
          ),
        ),
      );
  }

  Future<void> _showCurrencyPicker() async {
    final currencies = ['ZAR (R)'];

    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;
        final auth = context.watch<AppAuthProvider>();

        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: Colors.black, width: 4),
          ),
          title: Text('Select Currency', style: colours.h2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: currencies.map((currency) {
              return ListTile(
                title: Text(currency, style: colours.b1),
                trailing: _selectedCurrency == currency
                    ? Icon(Icons.check, color: colours.informational)
                    : null,
                onTap: () {
                  Navigator.of(dialogContext).pop(currency);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedCurrency = selected;
    });

    _showMessage('Currency changed to $selected');
  }

  void _toggleAppearance() {
    widget.onToggleTheme();

    _showMessage(
      widget.isDarkMode ? 'Light mode enabled' : 'Dark mode enabled',
    );
  }

  void _showBillAlertsDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;

        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: Colors.black, width: 4),
          ),
          title: Text('Bill Alerts', style: colours.h2),
          content: Text(
            _billAlertsEnabled
                ? 'Daily bill summaries are currently enabled.'
                : 'Bill alerts are currently disabled.',
            style: colours.b1,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Close', style: colours.b1),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                setState(() {
                  _billAlertsEnabled = !_billAlertsEnabled;
                });

                _showMessage(
                  _billAlertsEnabled
                      ? 'Bill alerts enabled'
                      : 'Bill alerts disabled',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.secondary,
                foregroundColor: colours.background,
              ),
              child: Text(
                _billAlertsEnabled ? 'Disable' : 'Enable',
                style: colours.b1.copyWith(
                  color: colours.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleTwoFactorAuth() {
    setState(() {
      _twoFactorEnabled = !_twoFactorEnabled;
    });

    _showMessage(
      _twoFactorEnabled
          ? '2-Factor authentication enabled'
          : '2-Factor authentication disabled',
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colours = context.colours;

        return AlertDialog(
          backgroundColor: colours.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: Colors.black, width: 4),
          ),
          title: Text('Logout', style: colours.h2),
          content: Text('Are you sure you want to logout?', style: colours.b1),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('Cancel', style: colours.b1),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.error,
                foregroundColor: colours.whiteAccents,
              ),
              child: Text(
                'Logout',
                style: colours.b1.copyWith(
                  color: colours.whiteAccents,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    _showMessage(
      'Logout selected. Connect this to Amplify sign out if needed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _profileHeader(context),
                    const SizedBox(height: 22),
                    _sectionTitle(context, 'PREFERENCES'),
                    const SizedBox(height: 12),
                    _menuCard(
                      context,
                      icon: Icons.payments_outlined,
                      title: 'Currency',
                      subtitle: _selectedCurrency,
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colours.textPrimary,
                        size: 22,
                      ),
                      onTap: _showCurrencyPicker,
                    ),
                    const SizedBox(height: 12),
                    _menuCard(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Appearance',
                      subtitle: widget.isDarkMode
                          ? 'Dark Mode (Enabled)'
                          : 'Light Mode (Selected)',
                      trailing: _toggle(context, isOn: widget.isDarkMode),
                      onTap: _toggleAppearance,
                    ),
                    const SizedBox(height: 12),
                    _menuCard(
                      context,
                      icon: Icons.notifications_none_outlined,
                      title: 'Bill Alerts',
                      subtitle: _billAlertsEnabled
                          ? 'Daily Summaries'
                          : 'Disabled',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colours.textPrimary,
                        size: 22,
                      ),
                      onTap: _showBillAlertsDialog,
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle(context, 'SECURITY'),
                    const SizedBox(height: 12),
                    _menuCard(
                      context,
                      icon: Icons.fingerprint,
                      title: 'Biometric Unlock',
                      trailing: _toggle(
                        context,
                        isOn: auth.biometricLockEnabled,
                      ),
                      onTap: () async {
                        final newValue = !auth.biometricLockEnabled;

                        final changed = await context
                            .read<AppAuthProvider>()
                            .setBiometricLockEnabled(newValue);

                        if (!mounted) return;

                        if (changed) {
                          _showMessage(
                            newValue
                                ? 'Biometric unlock enabled'
                                : 'Biometric unlock disabled',
                          );
                        } else {
                          _showMessage(
                            context.read<AppAuthProvider>().errorMessage ??
                                'Unable to change biometric setting',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _menuCard(
                      context,
                      icon: Icons.shield_outlined,
                      title: '2-Factor Auth',
                      trailing: Icon(
                        _twoFactorEnabled
                            ? Icons.verified_user_outlined
                            : Icons.shield_outlined,
                        color: colours.textPrimary,
                        size: 19,
                      ),
                      onTap: _toggleTwoFactorAuth,
                    ),
                    const SizedBox(height: 30),
                    _logoutButton(context),
                    const SizedBox(height: 22),
                    Center(
                      child: Text(
                        'VERSION 4.2.0-STABLE  •  MADE BY BUDGET.IT',
                        style: colours.b5.copyWith(
                          color: colours.textMuted,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final colours = context.colours;

    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
          bottom: BorderSide(color: Colors.black, width: 4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Icon(Icons.menu, color: colours.textPrimary, size: 18),
          const SizedBox(width: 12),
          Text(
            'Budget.IT',
            style: colours.b1.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Icon(
            Icons.notifications_none_outlined,
            color: colours.informational,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    final colours = context.colours;

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 7,
                top: 7,
                child: Container(width: 82, height: 82, color: Colors.black),
              ),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: colours.primary,
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/profile_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: colours.textPrimary,
                        size: 42,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colours.informational,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Text(
                    'PRO MEMBER',
                    style: colours.b5.copyWith(
                      color: colours.whiteAccents,
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            'Alex Smith',
            style: colours.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'alex.smith@example.com',
            style: colours.b5.copyWith(
              color: colours.textMuted,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final colours = context.colours;

    return Row(
      children: [
        Container(width: 5, height: 20, color: colours.informational),
        const SizedBox(width: 7),
        Text(
          title,
          style: colours.h4.copyWith(
            color: colours.informational,
            fontSize: 15,
            letterSpacing: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    final colours = context.colours;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(5, 5),
              child: Container(color: Colors.black),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: colours.blendedprimary,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: Row(
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: colours.secondary,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(icon, color: colours.background, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: subtitle == null
                      ? Text(
                          title,
                          style: colours.b1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: colours.b1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: colours.b5.copyWith(
                                color: colours.textMuted,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                ),
                trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(BuildContext context, {required bool isOn}) {
    final colours = context.colours;

    return Container(
      width: 37,
      height: 17,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 13,
          height: 11,
          color: isOn ? colours.informational : colours.secondary,
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final colours = context.colours;

    return Stack(
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(5, 5),
            child: Container(color: Colors.black),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _confirmLogout,
            icon: Icon(Icons.logout, color: colours.whiteAccents, size: 16),
            label: Text(
              'LOGOUT',
              style: colours.b1.copyWith(
                color: colours.whiteAccents,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colours.error,
              foregroundColor: colours.whiteAccents,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: const BorderSide(color: Colors.black, width: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
