import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Widget? child;

  CircleWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(90.0),
      ),
      child: child,
    );
  }
}
