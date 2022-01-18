import 'package:flutter/material.dart';

class RoundedTwinButtonWidget extends StatelessWidget {
  final Function() onLeftTap;
  final Function() onRightTap;
  final Color leftColor;
  final Color rightColor;
  final Color leftBorderColor;
  final Color rightBorderColor;
  final double roundness; //0->180
  final Widget? leftChild;
  final Widget? rightChild;

  RoundedTwinButtonWidget({
      required this.onLeftTap,
      required this.onRightTap,
      required this.leftColor,
      required this.roundness,
      required this.rightColor,
      this.leftChild,
      this.rightChild,
      required this.leftBorderColor,
      required this.rightBorderColor,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btnLeft(),
        _btnRight(),
      ],
    );
  }

  Widget _btnLeft() {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
          onPressed: onLeftTap,
          child: leftChild,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(roundness),
                  bottomLeft: Radius.circular(roundness)
              ),
            ),
            side: BorderSide(color: leftBorderColor, width: 2),
            primary: leftColor,
            shadowColor: Colors.transparent
          ),
        ),
    );
  }

  Widget _btnRight() {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: onRightTap,
        child: rightChild,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(roundness),
                  bottomRight: Radius.circular(roundness)
              ),
            ),
            side: BorderSide(color: rightBorderColor, width: 2),
            primary: rightColor,
            shadowColor: Colors.transparent
        ),
      ),
    );
  }
}
