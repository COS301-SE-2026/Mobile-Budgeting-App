import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchBox({super.key, required this.hintText, required this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late FocusNode _focusNode;   
  bool _isFocused = false;    

  @override
  void initState() {

    super.initState();
    
    _focusNode = FocusNode();   
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();      
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
      children: [
       

        Container(
        height: MediaQuery.of(context).size.height * 0.06 ,
        width: MediaQuery.of(context).size.width * 1 ,
        
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.black,
          boxShadow: [BoxShadow( 
                    offset: const Offset(6, -6),
                    color: Colors.black,
                  )],
        border:Border.all(
            color: Colors.black,
            width: 4.0,
          ),   
              
          
        )),

          Container(
            padding: const EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 1,
        
        alignment: Alignment.center,
        decoration: BoxDecoration(
          
          shape: BoxShape.rectangle,
          color: MyColours().background,
          boxShadow: [BoxShadow( 
                    offset: Offset(6, -6),
                    color: Colors.black,
                    
                  )],
                
              
          
        )),

    TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: _isFocused ? null : widget.hintText,
        hintStyle: MyColours().searchtext,
        prefixIcon: _isFocused
            ? null
            : Icon(Icons.search, color: MyColours().textMuted),
        filled: true,
        
        fillColor: MyColours().primary,
        border: InputBorder.none,
        isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        
      ),
       
    ),
      ],
    );

  }
}