import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/screens/coming_soon_page.dart';
import 'package:budgetit/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _openComingSoonPage(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComingSoonPage(
          title: title,
          message: message,
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return AppBar(
      backgroundColor: MyColours().navBarColor,
      elevation: 0,

      leading: IconButton(
        icon: Icon(Icons.menu, color: MyColours().cardText),
        onPressed: () {
          _openComingSoonPage(
            context,
            title: 'Menu Coming Soon',
            message:
                'The main menu is still being prepared. More navigation options will be added here soon.',
            icon: Icons.menu,
          );
        },
      ),

      title: Text(
        "Budget IT",
        style: TextStyle(
          color: MyColours().cardText,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),

      actions: [
        IconButton(
          tooltip: theme.isDark ? 'Light mode' : 'Dark mode',
          icon: Icon(
            theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: MyColours().cardText,
          ),
          onPressed: () => context.read<ThemeProvider>().toggle(),
        ),
        IconButton(
          icon: Icon(
            Icons.account_circle_outlined,
            color: MyColours().cardText,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),

        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: MyColours().cardText,
          ),
          onPressed: () {
            _openComingSoonPage(
              context,
              title: 'Settings Coming Soon',
              message:
                  'App settings are still under development. Soon you will be able to customise your preferences here.',
              icon: Icons.settings_outlined,
            );
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}