import 'dart:math';

import 'package:do_an_ui/models/vector.type.dart';
import 'package:flutter/material.dart';

class ArItemWidget extends StatelessWidget {
  final Vect2 position;
  final Size size;
  final String url;

  ArItemWidget(this.position, this.size, this.url);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.y,
      right: position.x,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Image.network(
          url,
        ),
      ),
    );
  }
}

class ArItem {
  Vect2 position = Vect2();
  Size _size = Size(20, 20);

  Size get size => _size;

  set size(Size size) {
    _size = Size(max(size.width, 30), max(size.height, 30));
  }
  String? imageUrl = null;
}

enum ArItemType {
  shirt,
  pants,
  hat,
  shoes,
  backpack
}