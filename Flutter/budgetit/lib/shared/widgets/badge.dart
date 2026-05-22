import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class MyBadge extends StatefulWidget {
  final String? text;
 

  const MyBadge({super.key, this.text = ''});

  @override
  State<MyBadge> createState() => _MyBadgeState();
}

class _MyBadgeState extends State<MyBadge> {
  
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() => _isPressed = !_isPressed),
      
      child: Container(
       constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.25,
        minHeight: MediaQuery.of(context).size.height * 0.04,
        
        
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        
        border: Border.all(
          color: MyColours().secondary,
          width: 1.5,
        ),

        color: _isPressed ? MyColours().secondary : MyColours().background,
      ),
     
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            

            widget.text ?? '',
            textAlign: TextAlign.center,
            
            style: TextStyle(
              fontSize: MyColours().bodyFontSize,
              
            
              color: _isPressed ? MyColours().background : MyColours().textPrimary.withValues(alpha: 0.85),
            ),
          ),
          
        ],
      ),

      
    ),
  );
  }
}

