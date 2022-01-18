import 'dart:developer';

import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/clothes/body_stat.data.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import '../../shared/clothes/size.enum.dart';

class LocalItemData {
  Map<String, Item> _items = {};
  Map<String, ESize> _sizes = {};
  String? _currentId;
  static final dkey = '[LocalItemData]';

  Map<String, Item> getItems() {
    return _items;
  }

  Map<String, ESize> getSizes() {
    return _sizes;
  }
  ESize? getSize(String id) {
    return _sizes[id];
  }

  String? getCurrentId() {
    return _currentId;
  }

  ESize? getCurrentSize() {
    return _currentId == null? null: _sizes[_currentId];
  }

  Item? getCurrentItem() {
    return _currentId == null? null: _items[_currentId];
  }

  void setCurrentId(String? id) {
    _currentId = id;
  }

  void setSizeAll(ESize size) {
    _sizes.keys.forEach((key) {
      _sizes[key] = size;
    });
  }

  void setCurrentItem(Item item) {
    if (!hasItem(item)) {
      addItem(item);
    }
    _currentId = item.id;
  }

  void setSize(Item item, ESize size) {
    setSizeId(item.id, size);
  }

  void setSizeId(String id, ESize size) {
    if (_sizes.containsKey(id)) {
      _sizes[id] = size;
    } else {
      log('$dkey ERROR _sizes don t contain id $id');
    }
  }

  void addItem(Item item) {
    _items[item.id] = item;
    if (item.isSP()) {
      _sizes[item.id] = g_bodyStat.toEsize();
    } else if (item.isSH()) {
      _sizes[item.id] = SH_SIZE_MIN.toEsize();
    }
  }

  void removeAllItems() {
    _items.clear();
    _currentId = null;
  }

  void removeItem(Item item) {
    removeItemId(item.id);
  }

  void removeItemId(String id) {
    _items.remove(id);
    _onRemoveItemId(id);
  }

  void _onRemoveItemId(String id) {
    _sizes.remove(id);

    if (_currentId == id) {
      if (_items.isNotEmpty) {
        _currentId = _items.keys.first;
      } else {
        _currentId = null;
      }
    }
  }

  bool hasId(String id) {
    return _items.containsKey(id);
  }

  bool hasItem(Item item) {
    return _items.containsKey(item.id);
  }

  bool hasSize(String id) {
    return _sizes.containsKey(id);
  }
}

final Map<EType, LocalItemData> g_localItemsData = {
  EType.Hat: LocalItemData(),
  EType.Shirt: LocalItemData(),
  EType.Pants: LocalItemData(),
  EType.Shoes: LocalItemData(),
  EType.Backpack: LocalItemData(),
};