import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColours().background,
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}