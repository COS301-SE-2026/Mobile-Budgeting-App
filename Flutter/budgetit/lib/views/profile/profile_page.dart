import 'package:flutter/material.dart';

import '../../utils/app_colour.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

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
                      subtitle: 'USD (\$)',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colours.textPrimary,
                        size: 22,
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    _menuCard(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Appearance',
                      subtitle: 'Dark Mode (Enabled)',
                      trailing: _toggle(context, isOn: true),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    _menuCard(
                      context,
                      icon: Icons.notifications_none_outlined,
                      title: 'Bill Alerts',
                      subtitle: 'Daily Summaries',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: colours.textPrimary,
                        size: 22,
                      ),
                      onTap: () {},
                    ),

                    const SizedBox(height: 20),

                    _sectionTitle(context, 'SECURITY'),
                    const SizedBox(height: 12),

                    _menuCard(
                      context,
                      icon: Icons.fingerprint,
                      title: 'Biometric Unlock',
                      trailing: _toggle(context, isOn: false),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    _menuCard(
                      context,
                      icon: Icons.shield_outlined,
                      title: '2-Factor Auth',
                      trailing: Icon(
                        Icons.verified_user_outlined,
                        color: colours.textPrimary,
                        size: 19,
                      ),
                      onTap: () {},
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.asset(
                      'assets/images/profile_avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: colours.primary,
                          child: Icon(
                            Icons.person,
                            color: colours.textPrimary,
                            size: 42,
                          ),
                        );
                      },
                    ),
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
          const SizedBox(height: 2),
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
            onPressed: () {},
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
