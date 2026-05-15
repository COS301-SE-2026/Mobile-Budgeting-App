import 'package:budgetit/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAB extends StatefulWidget {
  const FAB({super.key});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      
      child: Container(
        width: MediaQuery.of( context).size.width * 0.17,
        height: MediaQuery.of( context).size.height * 0.08,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.width * 0.01),
          borderRadius: BorderRadius.circular(10),
          color: _pressed ?   Colors.white : MyTheme().softLighGreen,
          shape: BoxShape.rectangle,
          boxShadow: _pressed ? null : [
            BoxShadow(
              color: Colors.black,
              
              offset:  Offset(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.width * 0.01),
            ),
          ] ,
        ),
        child: Align (
            alignment: const Alignment(-0.1,-0.1),
          child: Icon(Icons.add, color: Colors.black, size: MediaQuery.of(context).size.width * 0.08, fontWeight: FontWeight.w700,),
        ),
      ),
    );
  }
}