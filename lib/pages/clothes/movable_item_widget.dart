import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/material.dart';

class MovableItemWidget extends StatefulWidget {
  final double width;
  final double height;
  final String type;
  late String imageUrl;
  final Function(String _type) onPress;
  final Function(MovableItemWidget _this) onPositionPress;
  bool isDefault = true;

  MovableItemWidget({
    required Key key,
    required this.width,
    required this.height,
    required this.type,
    required this.imageUrl,
    required this.onPress,
    required this.onPositionPress
  }): super(key: key);

  @override
  _MovableItemWidgetState createState() => _MovableItemWidgetState(type, width, height);
}

class _MovableItemWidgetState extends State<MovableItemWidget> {
  Offset hatOffset = Offset(0, 0);
  LocalItemService? service;
  Item? item;
  late double width, height;

  _MovableItemWidgetState(String _type, double w, double h) {
    service = localItemService[_type];
    width = w;
    width = h;

    switch (_type)
    {
      case HAT:
        hatOffset = Offset(150, 75);
        break;
      case SHIRT:
        hatOffset = Offset(110, 130);
        break;
      case PANTS:
        hatOffset = Offset(100, 260);
        break;

      case SHOES:
        hatOffset = Offset(150, 400);
        break;
      case BACKPACK:
        hatOffset = Offset(250, 200);
        break;
    }

    service!.getStream().listen((_item) {
      if (mounted && _item != null) {
        widget.imageUrl = _item.imageUrl;
        print(widget.imageUrl);
        setState(() {
          item = _item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var image = (item == null)
        ? Image.asset(widget.imageUrl, width: widget.width, height: widget.height,)
        : Image.network(item!.imageUrl, width: widget.width, height: widget.height,);

    if (item != null)
    {
      widget.isDefault = false;
    }
    else
    {
      widget.isDefault = true;
    }

    return Positioned(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
              onTapDown: (details) {
                widget.onPositionPress(widget);
              },
              onPanUpdate: (details) {
                setState(() {
                  hatOffset = Offset(hatOffset.dx + details.delta.dx, hatOffset.dy + details.delta.dy);
                });
              },
              child: Icon(Icons.highlight_remove_outlined, size: 25,)
          ),
          GestureDetector(
              onTapDown: (details) {
                widget.onPress(widget.type);
              },
              child: image
          ),
        ],
      ),
      left: hatOffset.dx,
      top: hatOffset.dy,
    );
  }
}
