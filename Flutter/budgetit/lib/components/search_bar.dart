import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),

      height: 55,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: Color(0xFF04240C),
        ),
      ),

      child: Row(
        children: [

          Icon(Icons.search),

          SizedBox(width: 10),

          Text(
            "Search transactions...",
          ),

        ],
      ),
    );
  }
}