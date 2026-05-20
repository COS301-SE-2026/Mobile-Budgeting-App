import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class MyBox extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final GestureTapCallback ? onTap;

  const MyBox({super.key, this.text = '', this.icon, this.onTap});

  @override
  State<MyBox> createState() => _MyBoxState();
}

class _MyBoxState extends State<MyBox> {
   bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (details) => setState(() => _isPressed = true),
      onTapUp: (details) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
       height: MediaQuery.of(context).size.height * 0.05,
       
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      //  gradient: _isPressed ? null : MyColours().primaryGradient,
        color: MyColours().primary ,
        border: Border.all(
    color: MyColours().secondary, // choose the border color
    width: 1.0,          // choose the border width
  ),
         
      ),
     
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 8),
         
          Icon(
           widget.icon ,
           
            color: _isPressed ? MyColours().background :  MyColours().textPrimary,
            size: MediaQuery.of(context).size.width * 0.04,
          ),
          Text(
            widget.text ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MyColours().bodyFontSize,
              color: _isPressed ? MyColours().background : MyColours().textPrimary,
            ),
          ),
          
        ],
      ),

      ),
    );
  }
}

