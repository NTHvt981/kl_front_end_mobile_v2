
import 'package:do_an_ui/shared/zoomable_widget.dart';
import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'movable_item_widget.dart';

class ArMovableItemWidget extends StatefulWidget {
  final MovableItemWidget item;
  final Function(ArMovableItemWidget _this) onPositionPress;

  ArMovableItemWidget({
    Key? key,
    required this.item,
    required this.onPositionPress
  }): super(key: key);

  @override
  _ArMovableItemWidgetState createState() => _ArMovableItemWidgetState(item);
}

class _ArMovableItemWidgetState extends State<ArMovableItemWidget> {
  Offset hatOffset = Offset(0, 0);
  late MovableItemWidget item;

  _ArMovableItemWidgetState(_item) {
    item = _item;
    debugPrint("[DEBUG]" + item.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Center(
        child: GestureDetector(
            onTapDown: (details) {
              widget.onPositionPress(widget);
            },
            onPanUpdate: (details) {
              setState(() {
                hatOffset = Offset(hatOffset.dx + details.delta.dx, hatOffset.dy + details.delta.dy);
              });
            },
            child: Image.network(
              item.imageUrl, width: item.width, height: item.height,
            )
        ),
      ),
      left: hatOffset.dx,
      top: hatOffset.dy,
    );
  }
}