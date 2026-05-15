import 'package:budgetit/utils/theme.dart';
import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  final String text;

  const TextArea({super.key, this.text = 'Im a box'});

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11 - 30,
      width: MediaQuery.of(context).size.width * 0.8 - MediaQuery.of(context).size.width * 0.02,
      
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
    top: BorderSide(
      color: Colors.black,
      width: MediaQuery.of(context).size.width * 0.01,
    ),
  ),
        color: Colors.white,
      ),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MyTheme().bodyFontSize.toDouble(),
          color: Colors.black,
          fontFamily: MyTheme().bodyFont,
        ),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final Color color;

  Box({super.key, Color? color}) : color = color ?? MyTheme().softFaintPink;

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: MediaQuery.of(context).size.width * 0.01),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(MediaQuery.of(context).size.width * 0.01, MediaQuery.of(context).size.width * 0.01),
          ),
        ],
        color: widget.color,
      ),
    );
  }
}

class ShowBox extends StatelessWidget {
  final String text;
  final Color? color;

  ShowBox({super.key, this.text = 'Im a box', Color? color}) : color = color ?? MyTheme().softFaintPink;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(-0.028, 0.7),
      children: [
        Box(color: color),
        TextArea(text: text),
      ],
    );
  }
}