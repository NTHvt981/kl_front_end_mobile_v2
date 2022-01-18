import 'dart:ui';
import 'package:do_an_ui/shared/clothes/type.enum.dart';

import 'item.model.dart';

class ArData {
  final EType type;
  Item? _item;
  Rect? _area;
  Image? _image;
  double scale = 1;
  bool canShow = true;

  Item get item => _item!;

  set item(Item item) {
    _item = item;
  }

  Image get image => _image!;

  set image(Image image) {
    _image = image;
  }

  Rect get area => _area!;

  set area(Rect area) {
    _area = area;
  }

  ArData({required this.type}) {

  }

  bool isValid() {
    return _item != null && _image != null && _area != null && canShow;
  }
}