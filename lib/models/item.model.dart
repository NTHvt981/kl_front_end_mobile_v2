// const HAT = 'Hat';
// const SHIRT = 'Shirt';
// const PANTS = 'Pants';
// const SHOES = 'Shoes';
// const BACKPACK = 'Backpack';

import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';

const ID = 'Ma';
const NAME = 'Ten';
const TYPE = 'Loai';
const SPECIFIC_TYPE = 'PhanLoai';
const IMAGE_URL = 'Hinh';
const DESCRIPTION = 'MoTa';
const NUMBER = 'SoLuong';
const PRICE = 'Gia';
const BRAND = 'Hang';
const COLOR = 'Mau';

//ar
const LEFT_OFFSET = 'OffsetTrai';
const RIGHT_OFFSET = 'OffsetPhai';
const TOP_OFFSET = 'OffsetTren';
const BOTTOM_OFFSET = 'OffsetDuoi';

//item of clothes
class Item {
  late String id;
  late String name;
  late EType type;
  late ESpecificType specificType;
  late String imageUrl;
  late String description;
  late int number;
  late int price;
  late String brand;
  late String color;

  //ar
  late double leftOffset;
  late double rightOffset;
  late double topOffset;
  late double bottomOffset;

  Item();

  Map<String, dynamic> toMap() => {
    ID: id,
    NAME: name,
    TYPE: type.name,
    SPECIFIC_TYPE: specificType.name,
    IMAGE_URL: imageUrl,
    DESCRIPTION: description,
    NUMBER: number,
    PRICE: price,
    BRAND: brand,
    COLOR: color,

    //ar
    LEFT_OFFSET: leftOffset,
    RIGHT_OFFSET: rightOffset,
    TOP_OFFSET: topOffset,
    BOTTOM_OFFSET: bottomOffset,
  };

  Item.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        name = map[NAME],
        type = (map[TYPE] as String).toEType(),
        specificType = (map[SPECIFIC_TYPE] as String).toESpecificType(),
        imageUrl = map[IMAGE_URL],
        description = map[DESCRIPTION],
        number = map[NUMBER],
        price = map[PRICE],
        brand = map[BRAND],
        color = map[COLOR],

        //ar
        leftOffset = (map[LEFT_OFFSET] as num).toDouble(),
        rightOffset = (map[RIGHT_OFFSET] as num).toDouble(),
        topOffset = (map[TOP_OFFSET] as num).toDouble(),
        bottomOffset = (map[BOTTOM_OFFSET] as num).toDouble();

  bool isSP() {
    return type == EType.Shirt || type == EType.Pants;
  }

  bool isSH() {
    return type == EType.Shoes;
  }
}