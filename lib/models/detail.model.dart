
import 'package:do_an_ui/models/item.model.dart';
import '../shared/clothes/size.enum.dart';

const ID = 'Ma';
const ORDER_ID = 'MaDonHang';
const ITEM_ID = 'MaPhuKien';

const NAME = 'Ten';
const IMAGE_URL = 'Hinh';
const PRICE = 'Gia';
const AMOUNT = 'SoLuong';
const ESIZE = 'KichThuoc';

class Detail {
  String id;
  String orderId;
  String itemId;
  String imageUrl;
  String name;
  int price;
  int amount;
  // detail total = price x amount
  ESize? size;
  Item? item;

  Detail({
    required this.id,
    required this.orderId,
    required this.itemId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.amount,
    this.size,
});

  Map<String, dynamic> toMap() => {
    ID: id,
    ORDER_ID: orderId,
    ITEM_ID: itemId,
    IMAGE_URL: imageUrl,
    NAME: name,
    PRICE: price,
    AMOUNT: amount,
    ESIZE: size?.name,
  };

  Detail.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        orderId = map[ORDER_ID],
        itemId = map[ITEM_ID],
        imageUrl = map[IMAGE_URL],
        name = map[NAME],
        price = map[PRICE],
        amount = map[AMOUNT],
        size = map[ESIZE]!= null? (map[ESIZE] as String).toEsize(): null
  ;
}