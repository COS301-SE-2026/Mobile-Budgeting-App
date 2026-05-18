import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final IconData icon;
  final String label;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 90,
      padding: EdgeInsets.symmetric(
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),

          SizedBox(height: 10),

          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}