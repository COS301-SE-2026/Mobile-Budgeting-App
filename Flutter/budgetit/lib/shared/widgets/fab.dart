import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Add transaction
              },
              child: const Text('Add Transaction'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async{
                Navigator.pop(context);
                FilePickerResult? result = await FilePicker.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['pdf','csv'],
              );
              },
              child: const Text('Import PDF'), //TODO Sort Out
            ),
           
           
          ],
        ),
      );
    },
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