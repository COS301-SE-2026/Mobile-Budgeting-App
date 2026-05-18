import 'package:flutter/material.dart';
import '../components/transaction_tile.dart';
import '../components/balance_card.dart';
import '../components/bill_item.dart';
import '../components/bottom_nav.dart';
import '../components/goal_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xFFDDE5D8),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(
            children: [

              SizedBox(height: 20),

              Text(
                "MAY 2026",
              ),

              BalanceCard(),

              SizedBox(height: 20),

              BillItem(
                icon: Icons.electric_bolt,
                title: "Electricity",
                subtitle: "Due tomorrow",
                amount: "R850",
              ),

              BillItem(
                icon: Icons.movie,
                title: "Netflix",
                subtitle: "Monthly subscription",
                amount: "R199",
              ),
              GoalCard(
                title: "Vacation Fund",
                saved: "R5 000",
                target: "R10 000",
                progress: 0.5,
              ),

              GoalCard(
                title: "New Laptop",
                saved: "R12 000",
                target: "R20 000",
                progress: 0.6,
              ),
              TransactionTile(
                icon: Icons.shopping_cart,
                title: "Groceries",
                subtitle: "Today",
                amount: "- R850",
                isExpense: true,
              ),

              TransactionTile(
                icon: Icons.payments,
                title: "Salary",
                subtitle: "Yesterday",
                amount: "+ R22 000",
                isExpense: false,
              ),
              SizedBox(height: 20),

              BottomNav(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}