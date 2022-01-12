import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool bold;
  final FontStyle fontStyle;

  TextWidget({
    required this.text,
    this.color = Colors.black,
    required this.size,
    this.bold = false,
    this.fontStyle = FontStyle.normal
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: bold? FontWeight.bold: null,
        fontStyle: fontStyle
      ),
    );
  }
}

class WhiteTextWidget extends StatelessWidget {
  final String text;
  final double size;

  WhiteTextWidget({
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      size: size,
      color: Colors.white,
      bold: false,
    );
  }
}
class WhiteBoldTextWidget extends StatelessWidget {
  final String text;
  final double size;

  WhiteBoldTextWidget({
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      size: size,
      color: Colors.white,
      bold: true,
    );
  }
}