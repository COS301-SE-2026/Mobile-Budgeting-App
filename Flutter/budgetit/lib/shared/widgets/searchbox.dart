import 'package:budgetit/components/spending_chart.dart';
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
        
        fillColor: MyColours().searchBar,
         border: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: Colors.black,
      width: 4,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: Colors.black,
      width: 4,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: Colors.black,
      width: 4,
    ),
  ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        
      ),
       
    ),
      ],
    );

  }
}
