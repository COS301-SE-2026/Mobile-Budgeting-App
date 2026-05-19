import 'package:budgetit/shared/widgets/transac_menu.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:popover/popover.dart';

class FAB extends StatefulWidget {
  const FAB({super.key});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  bool _pressed = false;
  Color childColour = MyColours().background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
onTap : ()  {
  showPopover(
            context: context,
            bodyBuilder: (context) => FABMenu(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.top,
            backgroundColor: MyColours().secondary,
            width: 150,
            height: 150,
            arrowHeight: 30,
            arrowWidth: 30,
          );
},      


      child: Container(
        
        width: MediaQuery.of( context).size.width * 0.15,
        height: MediaQuery.of( context).size.height * 0.07,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
         
          color: _pressed ?   MyColours().tertiary : MyColours().secondary,
          shape: BoxShape.rectangle,
          
          
        ),
        child: Align (
            alignment: const Alignment(-0.1,-0.1),
          child: Icon(Icons.add,     color: _pressed ? MyColours().secondary : MyColours().background, size: MediaQuery.of(context).size.width * 0.08, fontWeight: FontWeight.w700,),
        ),
      ),
    );
  }
}