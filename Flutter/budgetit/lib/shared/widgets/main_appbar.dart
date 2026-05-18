import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('BUDGETIT', style: TextStyle(color: MyColours().textPrimary, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
      backgroundColor: MyColours().background,
      centerTitle: true,
    );
  }
}