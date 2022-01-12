import 'package:flutter/material.dart';

class PercentageSizeWidget extends StatelessWidget {
  final Widget? child;
  final double percentageWidth; //0->1
  final double percentageHeight; //0->1

  PercentageSizeWidget({
      this.child,
      this.percentageWidth = 1,
      this.percentageHeight = 1
      });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    //calculate size base on percentage
    final size = Size(screenSize.width*percentageWidth, screenSize.height*percentageHeight);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: child,
    );
  }
}
