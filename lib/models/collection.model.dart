
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';

const _ID = 'Ma';
const USER_ID = 'MaKhachHang';
const _IMAGE_URL = 'HinhAnh';
const _SHIRT_IDS = 'MaAo';
const _PANTS_IDS = 'MaQuan';
const _HAT_IDS = 'MaNon';
const _SHOES_IDS = 'MaGiay';
const _BACKPACK_IDS = 'MaBalo';
const _NAME = 'TenToanBoPKTT';

//Collection of clothes item
class Collection {
  late String id;
  late String userId;
  late String imageUrl;
  late List<String> shirtIds;
  late List<String> pantsIds;
  late List<String> hatIds;
  late List<String> shoesIds;
  late List<String> backpackIds;
  late String name;

  Collection();

  Map<String, dynamic> toMap() => {
    _ID: id,
    _SHOES_IDS: shoesIds,
    _HAT_IDS: hatIds,
    _SHIRT_IDS: shirtIds,
    _PANTS_IDS: pantsIds,
    _BACKPACK_IDS: backpackIds,
    _IMAGE_URL: imageUrl,
    USER_ID: userId,
    _NAME: name
  };

  Collection.fromMap(Map<String, dynamic> map):
        assert(map[_ID] != null),
        id = map[_ID],

        hatIds = (map[_HAT_IDS] as List<dynamic>).cast(),
        shirtIds = (map[_SHIRT_IDS] as List<dynamic>).cast(),
        pantsIds = (map[_PANTS_IDS] as List<dynamic>).cast(),
        shoesIds = (map[_SHOES_IDS] as List<dynamic>).cast(),
        backpackIds = (map[_BACKPACK_IDS] as List<dynamic>).cast(),

        imageUrl = map[_IMAGE_URL],
        userId = map[USER_ID],
        name = map[_NAME];

  void setItemsId(EType _type, List<String> ids) {
    switch (_type)
    {
      case EType.Hat:
        hatIds = ids;
        break;
      case EType.Shirt:
        shirtIds = ids;
        break;
      case EType.Pants:
        pantsIds = ids;
        break;
      case EType.Shoes:
        shoesIds = ids;
        break;
      case EType.Backpack:
        backpackIds = ids;
        break;
    }
  }

  void addItemId(EType _type, String id) {
    switch (_type)
    {
      case EType.Hat:
        hatIds.add(id);
        break;
      case EType.Shirt:
        shirtIds.add(id);
        break;
      case EType.Pants:
        pantsIds.add(id);
        break;
      case EType.Shoes:
        shoesIds.add(id);
        break;
      case EType.Backpack:
        backpackIds.add(id);
        break;
    }
  }
}