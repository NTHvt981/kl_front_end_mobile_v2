import 'dart:async';

import 'package:do_an_ui/models/item.dart';
import 'package:rxdart/rxdart.dart';

class LocalItemService {
  late BehaviorSubject<Item?> itemBehavior;

  LocalItemService() {
    itemBehavior = BehaviorSubject.seeded(null);
  }

  Stream<Item?> getStream() {
    return itemBehavior.stream;
  }

  Future<Item> set(Item val) async {
    itemBehavior.add(val);

    return val;
  }

  Future<void> clear() async {
    itemBehavior.add(null);
  }

  void dispose() {
    itemBehavior.close();
  }
}

final Map<String, LocalItemService> localItemService = {
  HAT: LocalItemService(),
  SHIRT: LocalItemService(),
  PANTS: LocalItemService(),
  SHOES: LocalItemService(),
  BACKPACK: LocalItemService(),
};