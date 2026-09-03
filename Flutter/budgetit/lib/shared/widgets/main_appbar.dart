import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/coming_soon_page.dart';
import 'package:budgetit/shared/widgets/profile_page.dart';
import 'package:budgetit/shared/widgets/help_menu_page.dart';
import 'package:provider/provider.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/shared/widgets/settings_page.dart';

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
        builder: (_) =>
            ComingSoonPage(title: title, message: message, icon: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return AppBar(
      backgroundColor: context.colours.background,
      elevation: 0,
      leading: IconButton(
        tooltip: 'Help menu',
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colours.blue,
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: const Icon(Icons.question_mark, color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpMenuPage()),
          );
        },
      ),

      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          "Budget IT",
          softWrap: false,
          overflow: TextOverflow.visible,
          style: context.colours.title.copyWith(fontSize: 14),
        ),
      ),
      actions: [
        IconButton(
          tooltip: theme.isDark ? 'Light mode' : 'Dark mode',
          alignment: Alignment(0, 0),
          
          icon: 
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colours.yellow,
              border: Border.all(color: Colors.black, width: 4),
            ),
          child: Icon(
            theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: Colors.black,
            
          ),
        ),
          onPressed: () => context.read<ThemeProvider>().toggle(),
        ),
        IconButton(
         alignment: Alignment(0, 0),
          
          icon: 
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colours.greenAccents,
              border: Border.all(color: Colors.black, width: 4),
            ),
          child: Icon(
            Icons.person_outline,
            color: Colors.black,
            
          ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),

        IconButton(
          icon: 
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colours.error,
              border: Border.all(color: Colors.black, width: 4),
            ),
          child: Icon(
            Icons.settings_outlined,
            color: Colors.black,
            
          ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
