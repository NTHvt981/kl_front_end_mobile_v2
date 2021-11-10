import 'package:do_an_ui/models/item.dart';

const ID = 'Ma';
const USER_ID = 'MaKhachHang';
const IMAGE_URL = 'HinhAnh';
const SHIRT_ID = 'MaAo';
const PANTS_ID = 'MaQuan';
const HAT_ID = 'MaNon';
const SHOES_ID = 'MaGiay';
const BACKPACK_ID = 'MaBalo';
const NAME = 'TenToanBoPKTT';

class ClothesCollection {
  late String id;
  late String userId;
  late String imageUrl;
  late String shirtId;
  late String pantsId;
  late String hatId;
  late String shoesId;
  late String backpackId;
  late String name;

  ClothesCollection();

  Map<String, dynamic> toMap() => {
    ID: id,

    SHOES_ID: shoesId,
    HAT_ID: hatId,
    SHIRT_ID: shirtId,
    PANTS_ID: pantsId,
    BACKPACK_ID: backpackId,

    IMAGE_URL: imageUrl,
    USER_ID: userId,
    NAME: name
  };

  ClothesCollection.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],

        hatId = map[HAT_ID],
        shirtId = map[SHIRT_ID],
        pantsId = map[PANTS_ID],
        shoesId = map[SHOES_ID],
        backpackId = map[BACKPACK_ID],

        imageUrl = map[IMAGE_URL],
        userId = map[USER_ID],
        name = map[NAME];

  void setItemId(String _type, Item item) {
    switch (_type)
    {
      case HAT:
        hatId = item.id;
        break;
      case SHIRT:
        shirtId = item.id;
        break;
      case PANTS:
        pantsId = item.id;
        break;
      case SHOES:
        shoesId = item.id;
        break;
      case BACKPACK:
        backpackId = item.id;
        break;
    }
  }
}