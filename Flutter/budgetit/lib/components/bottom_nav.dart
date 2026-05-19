import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),

        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,

          colors: [Color(0xFF5E6E4C), Color(0xFF3F4F31)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: const [
          _NavItem(
            icon: Icons.dashboard_rounded,
            label: "DASHBOARD",
            isActive: true,
          ),

          _NavItem(icon: Icons.receipt_long_rounded, label: "TRANSACTIONS"),

          _NavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: "BUDGETS",
          ),

          _NavItem(icon: Icons.person_outline_rounded, label: "PROFILE"),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  static const Color darkGreen = Color(0xFF04240C);
  static const Color cream = Color(0xFFDDD6AE);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Color(0x3304240C), width: 1)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 22, color: isActive ? darkGreen : cream),

            const SizedBox(height: 6),

            Text(
              label,

              style: TextStyle(
                color: isActive ? darkGreen : cream,

                fontSize: 10,

                fontWeight: FontWeight.bold,

                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
