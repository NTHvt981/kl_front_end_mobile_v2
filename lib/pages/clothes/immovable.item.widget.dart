
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/clothes/body_stat.data.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/common.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ImmovableItemWidget extends StatelessWidget {
  final EType type;
  final Function(EType type) onOpenDrawer;
  final Function(EType type) onSwitchIndex;
  late final LocalItemData data;
  late final Offset _offset;
  late final String _imageUrl;
  late final Size _size;
  final dkey = '[ImmovableItemWidget]';

  ImmovableItemWidget({
    required this.type,
    required this.onOpenDrawer,
    required this.onSwitchIndex,
  }) {
    data = g_localItemsData[type]!;
    final screenSize = g_screenSize;
    // double scale = data.getCurrentSize() != null? data.getCurrentSize()!.scale: 1;
    final itemSize = g_localItemsData[type]!.getCurrentSize();
    final bodySize = g_bodyStat.toEsize();
    double scale = itemSize != null?
      itemSize.isSPSize()? 1 + (itemSize.index - bodySize.index) * 0.15: 1.0: 1.0;
    switch (type)
    {
      case EType.Hat:
        _adjustForHat(screenSize, scale);
        break;
      case EType.Shirt:
        _adjustForShirt(screenSize, scale);
        break;
      case EType.Pants:
        _adjustForPants(screenSize, scale);
        break;
      case EType.Shoes:
        _adjustForShoes(screenSize, scale);
        break;
      case EType.Backpack:
        _adjustForBackpack(screenSize, scale);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = data.getCurrentItem();
    var image = (currentItem == null)
        ? Image.asset(_imageUrl, width: _size.width, height: _size.height,)
        : Image.network(currentItem.imageUrl, width: _size.width, height: _size.height,);

    return Positioned(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    onOpenDrawer(type);
                  },
                  child: Icon(FontAwesome.plus_circle, size: 25,)
              ),
            ],
          ),
          _item(image)
        ],
      ),
      left: _offset.dx,
      top: _offset.dy,
    );
  }

  Widget _item(Image image) {
    return GestureDetector(
        onTap: () {
          onSwitchIndex(type);
        },
        child: image
    );
  }

  void _adjustForHat(Size screenSize, double scale) {
    _size = Size(g_screenSize.width/5, g_screenSize.width/5) * scale;
    _offset = Offset(
      (g_screenSize.width - _size.width) / 2,
      (g_screenSize.height - _size.height) / 2 - screenSize.height/3,
    );
    _imageUrl = 'images/placeholders/hat.png';
  }

  void _adjustForShirt(Size screenSize, double scale) {
    _size = Size(g_screenSize.width/2, g_screenSize.width/2) * scale;
    _offset = Offset(
      (g_screenSize.width - _size.width) / 2,
      (g_screenSize.height - _size.height) / 2  - screenSize.height/6,
    );
    _imageUrl = 'images/placeholders/shirt.png';
  }

  void _adjustForPants(Size screenSize, double scale) {
    _size = Size(g_screenSize.width/3, g_screenSize.width/2) * scale;
    _offset = Offset(
      (g_screenSize.width - _size.width) / 2,
      (g_screenSize.height - _size.height) / 2 + screenSize.height/12,
    );
    _imageUrl = 'images/placeholders/pants.png';
  }

  void _adjustForShoes(Size screenSize, double scale) {
    _size = Size(g_screenSize.width/5, g_screenSize.width/5) * scale;
    _offset = Offset(
      (g_screenSize.width - _size.width) / 2,
      (g_screenSize.height - _size.height) / 2 + screenSize.height/3.6,
    );
    _imageUrl = 'images/placeholders/shoes.png';
  }

  void _adjustForBackpack(Size screenSize, double scale) {
    _size = Size(g_screenSize.width/4, g_screenSize.width/4) * scale;
    _offset = Offset(
      (g_screenSize.width - _size.width) / 2 + screenSize.width/3.5,
      (g_screenSize.height - _size.height) / 2 + screenSize.height/12,
    );
    _imageUrl = 'images/placeholders/backpack.png';
  }
}
