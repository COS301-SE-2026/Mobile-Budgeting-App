import 'package:budgetit/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
class TransactionManager extends StatelessWidget{
  const TransactionManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme().softFaintOrange,
      
      body: Center(
        
      ),
      floatingActionButton: const FAB(),
    );
  }
}