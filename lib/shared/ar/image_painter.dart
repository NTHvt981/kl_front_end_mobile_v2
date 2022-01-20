import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:do_an_ui/models/item.model.dart';
import 'package:flutter/material.dart' as material;

class ImagePainter extends material.CustomPainter {
  ImagePainter({
    required this.imageSize,
    required this.image,
    required this.bound,
    required this.item,
    this.externalScale = 1
  });
  final Size imageSize;
  final Image image;
  final Item item;
  final Rect bound;
  final double externalScale;

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / imageSize.width;
    double scaleY = size.height / imageSize.height;
    var rect = _scaleRect(
        rect: bound,
        widgetSize: size,
        scaleX: scaleX,
        scaleY: scaleY);
    final imageRect = Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());

    final debugPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = material.Colors.green
      ..strokeWidth = 3.0;

    var rect2 = _resizeOffset(
      rect: rect,
      imageRect: imageRect,
      leftOffset: item.leftOffset,
      topOffset: item.topOffset,
      rightOffset: item.rightOffset,
      bottomOffset: item.bottomOffset,
    );

    rect2 = _scale2Rect(rect: rect2, scale: externalScale);

    log("[DEBUG AR] rect (${rect.left.toString()}, "
        "${rect.top.toString()}, "
        "${rect.right.toString()}, "
        "${rect.bottom.toString()})");
    canvas.drawImageRect(image, imageRect, rect2, new Paint()
    );
    // canvas.drawRect(rect, debugPaint);
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.bound != bound || oldDelegate.image != image;
  }
}

Rect _scaleRect({
      required Rect rect,
      required Size widgetSize,
      required double scaleX,
      required double scaleY
    }) {
  final left = math.max(rect.left, rect.right);
  final right = math.min(rect.left, rect.right);
  return Rect.fromLTRB(
      widgetSize.width - left.toDouble() * scaleX,
      rect.top.toDouble() * scaleY,
      widgetSize.width - right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY);
}

Rect _scale2Rect({
  required Rect rect,
  required double scale,
}) {
  final left = rect.left - (((scale - 1)/2) * rect.width);
  final right = rect.right + (((scale - 1)/2) * rect.width);
  final top = rect.top - (((scale - 1)/2) * rect.height);
  final bottom = rect.bottom + (((scale - 1)/2) * rect.height);
  return Rect.fromLTRB(left, top, right, bottom);
}

Rect _resizeOffset({
    required Rect rect,
    required Rect imageRect,
    required double leftOffset,
    required double rightOffset,
    required double topOffset,
    required double bottomOffset,
    }) {
  final width = rect.width;
  final height = rect.height;
  final newWidth = width / (1 - (leftOffset + rightOffset));
  final newHeight = height / (1 - (topOffset + bottomOffset));
  return Rect.fromLTRB(
    rect.left - newWidth * leftOffset,
    rect.top - newHeight * topOffset,
    rect.right + newWidth * rightOffset,
    rect.bottom + newHeight * bottomOffset,
  );
}