import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';

class LabelWidget1 extends StatelessWidget {
  final String text;

  LabelWidget1({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextWidget(
        text: text,
        size: FONT_SIZE_2,
        bold: true,
      ),
    );
  }
}
