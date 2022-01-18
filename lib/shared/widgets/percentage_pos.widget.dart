import 'package:flutter/material.dart';

class PercentagePosWidget extends StatelessWidget {
  final Widget child;
  final double? percentageLeft; //0->1
  final double? percentageRight; //0->1
  final double? percentageTop; //0->1
  final double? percentageBottom; //0->1

  PercentagePosWidget({
    required this.child,
    this.percentageLeft,
    this.percentageRight,
    this.percentageTop,
    this.percentageBottom
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var left = percentageLeft != null? percentageLeft! * size.width: null;
    var right = percentageRight != null? percentageRight! * size.width: null;
    var top = percentageTop != null? percentageTop! * size.height: null;
    var bottom = percentageBottom != null? percentageBottom! * size.height: null;

    return Positioned(
      child: child,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    );
  }
}
