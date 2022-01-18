const _CAPS = 'Caps';
const _BEANIES = 'Beanies';
const _FEDORAS = 'Fedoras';
const _BERETS = 'Berets';
const _SHIRT = 'Shirt';
const _T_SHIRT = 'T-Shirt';
const _JACKET = 'Jacket';
const _JEANS = 'Jeans';
const _SHORTS = 'Shorts';
const _SKIRT = 'Skirt';
const _GYM_PANTS = 'Gym Pants';
const _KAKI = 'Kaki';
const _BACKPACK = 'Backpack';
const _SHOES = 'Shoes';
const _SLIPPER = 'Slipper';

enum ESpecificType {
  Caps,
  Beanies,
  Fedoras,
  Berets,
  Shirt,
  T_Shirt,
  Jacket,
  Jeans,
  Shorts,
  Skirt,
  Gym_Pants,
  Kaki,
  Backpack,
  Shoes,
  Slipper,
}

final mapESpecificTypeToName = {
  ESpecificType.Caps : _CAPS,
  ESpecificType.Beanies : _BEANIES,
  ESpecificType.Fedoras : _FEDORAS,
  ESpecificType.Berets : _BERETS,
  ESpecificType.Shirt : _SHIRT,
  ESpecificType.T_Shirt : _T_SHIRT,
  ESpecificType.Jacket : _JACKET,
  ESpecificType.Jeans : _JEANS,
  ESpecificType.Shorts : _SHORTS,
  ESpecificType.Skirt : _SKIRT,
  ESpecificType.Gym_Pants : _GYM_PANTS,
  ESpecificType.Kaki : _KAKI,
  ESpecificType.Backpack : _BACKPACK,
  ESpecificType.Shoes : _SHOES,
  ESpecificType.Slipper : _SLIPPER,
};

final mapESpecificTypeToPath = {
  ESpecificType.Caps : 'images/placeholders/spec caps.png',
  ESpecificType.Beanies : 'images/placeholders/hat.png',
  ESpecificType.Fedoras : 'images/placeholders/spec pandoras.png',
  ESpecificType.Berets : 'images/placeholders/hat.png',
  ESpecificType.Shirt : 'images/placeholders/spec shirt.png',
  ESpecificType.T_Shirt : 'images/placeholders/spec t shirt.png',
  ESpecificType.Jacket : 'images/placeholders/spec jacket.png',
  ESpecificType.Jeans : 'images/placeholders/spec jeans.png',
  ESpecificType.Shorts : 'images/placeholders/spec shorts.png',
  ESpecificType.Skirt : 'images/placeholders/spec skirt.png',
  ESpecificType.Gym_Pants : 'images/placeholders/pants.png',
  ESpecificType.Kaki : 'images/placeholders/pants.png',
  ESpecificType.Backpack : 'images/placeholders/spec backpack.png',
  ESpecificType.Shoes : 'images/placeholders/spec shoes.png',
  ESpecificType.Slipper : 'images/placeholders/shoes.png',
};

final mapNameToESpecificType = {
  _CAPS : ESpecificType.Caps,
  _BEANIES : ESpecificType.Beanies,
  _FEDORAS : ESpecificType.Fedoras,
  _BERETS : ESpecificType.Berets,
  _SHIRT : ESpecificType.Shirt,
  _T_SHIRT : ESpecificType.T_Shirt,
  _JACKET : ESpecificType.Jacket,
  _JEANS : ESpecificType.Jeans,
  _SHORTS : ESpecificType.Shorts,
  _SKIRT : ESpecificType.Skirt,
  _GYM_PANTS : ESpecificType.Gym_Pants,
  _KAKI : ESpecificType.Kaki,
  _BACKPACK : ESpecificType.Backpack,
  _SHOES : ESpecificType.Shoes,
  _SLIPPER : ESpecificType.Slipper,
};

extension StringESpecificTypeExtension on String {
  ESpecificType toESpecificType() {
    return mapNameToESpecificType[this]!;
  }
}

extension ESpecificTypeExtension on ESpecificType {
  String get name {
    return mapESpecificTypeToName[this]!;
  }

  String get assetPath {
    return mapESpecificTypeToPath[this]!;
  }
}
