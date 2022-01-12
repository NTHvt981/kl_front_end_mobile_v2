import 'dart:developer';

import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MovableItemWidget extends StatefulWidget {
  final String type;
  final Function(String _type) onPress;
  final Function(MovableItemWidget _this) onPositionPress;

  MovableItemWidget({
    Key? key,
    required this.type,
    required this.onPress,
    required this.onPositionPress
  }): super(key: key);

  @override
  _MovableItemWidgetState createState() => _MovableItemWidgetState(
      type: type,
  );
}

class _MovableItemWidgetState extends State<MovableItemWidget> {
  Offset _offset = Offset(0, 0);
  late LocalItemService _service;
  Item? item;
  late String _imageUrl;
  Size _size = Size.zero;
  String type;
  bool _isVisible = true;

  _MovableItemWidgetState({
      required this.type
      }) {
    Size screenSize = g_screenSize;
    _service = g_localItemsService[type]!;
    switch (type)
    {
      case HAT:
        _size = Size(g_screenSize.width/5, g_screenSize.width/5);
        _offset = Offset(
            (g_screenSize.width - _size.width) / 2,
            (g_screenSize.height - _size.height) / 2 - screenSize.height/3,
            );
        _imageUrl = 'images/placeholders/hat.png';
        break;

      case SHIRT:
        _size = Size(g_screenSize.width/2, g_screenSize.width/2);
        _offset = Offset(
          (g_screenSize.width - _size.width) / 2,
          (g_screenSize.height - _size.height) / 2  - screenSize.height/5.8,
        );
        _imageUrl = 'images/placeholders/shirt.png';
        break;

      case PANTS:
        _size = Size(g_screenSize.width/2, g_screenSize.width/2);
        _offset = Offset(
          (g_screenSize.width - _size.width) / 2,
          (g_screenSize.height - _size.height) / 2 + screenSize.height/18,
        );
        _imageUrl = 'images/placeholders/pants.png';
        break;

      case SHOES:
        _size = Size(g_screenSize.width/5, g_screenSize.width/5);
        _offset = Offset(
          (g_screenSize.width - _size.width) / 2,
          (g_screenSize.height - _size.height) / 2 + screenSize.height/4,
        );
        _imageUrl = 'images/placeholders/shoes.png';
        break;

      case BACKPACK:
        _size = Size(g_screenSize.width/4, g_screenSize.width/4);
        _offset = Offset(
          (g_screenSize.width - _size.width) / 2 + screenSize.width/4,
          (g_screenSize.height - _size.height) / 2,
        );
        _imageUrl = 'images/placeholders/backpack.png';
        break;
    }

    _service.getStream().listen((_item) {
      if (mounted) {
        if (_item != null) {
          setState(() {
            _imageUrl = _item.imageUrl;
          });
          print("[DEBUG MOVABLE WIDGET] listen" + _imageUrl);
        }

        item = _item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var image = (item == null)
        ? Image.asset(_imageUrl, width: _size.width, height: _size.height,)
        : Image.network(item!.imageUrl, width: _size.width, height: _size.height,);

    return Positioned(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTapDown: _onVisibilityToggle,
                  child: Icon(FontAwesome.eye, size: 25,)
              ),
              GestureDetector(
                  onTapDown: (details) {
                    widget.onPositionPress(widget);
                  },
                  onPanUpdate: (details) {
                    _move(details);
                  },
                  child: Icon(FontAwesome.hand_grab_o, size: 25,)
              ),
            ],
          ),
          _isVisible? _visibleItem(image): _invisibleItem()
        ],
      ),
      left: _offset.dx,
      top: _offset.dy,
    );
  }

  void _onVisibilityToggle(details) {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
      });
    } else {
      setState(() {
        _isVisible = true;
      });
    }
  }

  Widget _visibleItem(Image image) {
    return GestureDetector(
      onTapDown: (details) {
        widget.onPress(widget.type);
      },
      child: image
    );
  }

  Widget _invisibleItem() {
    return Container();
  }

  void _move(DragUpdateDetails details) {
    return setState(() {
              _offset = Offset(_offset.dx + details.delta.dx, _offset.dy + details.delta.dy);
            });
  }
}
