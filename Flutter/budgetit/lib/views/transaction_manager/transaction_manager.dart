import 'package:budgetit/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:budgetit/shared/widgets/fab.dart';
import 'package:budgetit/shared/widgets/box.dart';
class TransactionManager extends StatelessWidget{
  const TransactionManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme().softFaintOrange,
      appBar: AppBar(
        title:  Text(MediaQuery.of(context).size.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        
        children: [
           Divider(),
           ShowBox(text: 'Grocery Order - R500', color: MyTheme().softSalmon),
           Divider(),
           ShowBox(text: 'Electricity - R300', color: MyTheme().softFPink),
            Divider(),
            ShowBox(text: 'Water - R200', color: MyTheme().softMutedPurple),



          
          

        ],
      ),
      floatingActionButton: const FAB(),
    );
  }
}