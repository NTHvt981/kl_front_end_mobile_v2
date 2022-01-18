import '../shared/clothes/size.enum.dart';

import 'item.model.dart';

class LocalDetail {
  final Item item;
  late int amount;
  late ESize? size;

  LocalDetail({
    required this.item,
    required this.size,
    this.amount = 1,
  });
}