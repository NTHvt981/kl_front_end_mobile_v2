import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final Function() onTap;
  final Color borderColor;
  final Color backgroundColor;
  final double roundness; //0->180
  final Widget? child;

  RoundedButtonWidget({
      required this.onTap,
      required this.borderColor,
      this.roundness = 90,
      required this.backgroundColor,
      this.child
      });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: child,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundness),
        ),
        side: BorderSide(color: borderColor, width: 2),
        primary: backgroundColor,
        shadowColor: Colors.transparent
      ),
    );
  }
}
