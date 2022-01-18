import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum EditType {
  Normal,
  PhoneNumber,
  DateTime,
  Gender,
  Multiline
}

class RoundedEditWidget extends StatelessWidget {
  final TextEditingController controller;
  final Color cursorColor;
  final Color borderColor;
  final Color borderSelectedColor;
  final Color borderErrorColor;
  final Color iconColor;
  final double roundness; //0->90
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool hideText;
  final bool readOnly;
  final TextInputType inputType;
  final int minLines;
  final int maxLines;
  final Function(String)? onValueChange;
  final Function()? onTap;

  RoundedEditWidget({
    required this.controller,
    this.cursorColor = Colors.black,
    this.borderColor = Colors.black,
    this.borderSelectedColor = Colors.blue,
    this.borderErrorColor = Colors.red,
    this.iconColor = Colors.black,
    this.roundness = 0,
    this.prefixIcon,
    this.suffixIcon,
    this.hideText = false,
    this.readOnly = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.onValueChange = null,
    this.onTap = null
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      obscureText: hideText, // password option
      readOnly: readOnly,

      keyboardType: inputType,
      onChanged: onValueChange,

      onTap: onTap,

      minLines: minLines,
      maxLines: maxLines,

      controller: controller,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderSelectedColor),
          borderRadius: BorderRadius.all(Radius.circular(roundness))
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(roundness)),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderErrorColor),
            borderRadius: BorderRadius.all(Radius.circular(roundness))
        ),
        prefixIcon: prefixIcon != null? Icon(prefixIcon, color: iconColor,): null,
        suffixIcon: suffixIcon != null? Icon(suffixIcon, color: iconColor,): null,
      ),
    );
  }
}
