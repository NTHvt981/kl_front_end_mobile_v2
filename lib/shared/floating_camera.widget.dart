import 'package:do_an_ui/shared/colors.dart';
import 'package:flutter/material.dart';

class FloatingCameraWidget extends StatelessWidget {
  final Function() onPress;

  FloatingCameraWidget({required this.onPress});

  @override
  FloatingActionButton build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MEDIUM_BLUE,
      child: Icon(Icons.camera_alt_outlined, color: WHITE,),
      onPressed: onPress,
    );
  }
}
