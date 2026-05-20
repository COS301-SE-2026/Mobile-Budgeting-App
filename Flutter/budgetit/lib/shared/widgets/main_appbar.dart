import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
       
        backgroundColor: MyColours().background,
        elevation: 0,
        leading: Icon(Icons.menu, color: MyColours().textPrimary),
        title: Text(
          "Budget IT",
          style: TextStyle(
            color: MyColours().textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Icon(Icons.account_circle_outlined, color: MyColours().textPrimary),
          const SizedBox(width: 12),
          Icon(Icons.settings_outlined, color: MyColours().textPrimary),
          const SizedBox(width: 12),
        ],
      
    );
  }
}