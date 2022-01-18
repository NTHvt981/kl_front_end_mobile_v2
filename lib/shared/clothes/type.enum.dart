import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';

enum EType {
  Hat,
  Shirt,
  Pants,
  Shoes,
  Backpack
}

final mapETypeToName = {
  EType.Hat : 'Hat',
  EType.Shirt : 'Shirt',
  EType.Pants : 'Pants',
  EType.Shoes : 'Shoes',
  EType.Backpack : 'Backpack',
};

final mapNameToEType = {
  'Hat' : EType.Hat,
  'Shirt' : EType.Shirt,
  'Pants' : EType.Pants,
  'Shoes' : EType.Shoes,
  'Backpack' : EType.Backpack,
};

final Map<EType, List<ESpecificType>> mapETypeToSpecificTypes = {
  EType.Hat : [
    ESpecificType.Caps,
    // ESpecificType.Beanies,
    ESpecificType.Fedoras,
    // ESpecificType.Berets
  ],
  EType.Shirt : [ESpecificType.Shirt, ESpecificType.T_Shirt, ESpecificType.Jacket],
  EType.Pants : [
    ESpecificType.Jeans,
    ESpecificType.Shorts,
    ESpecificType.Skirt,
    //ESpecificType.Gym_Pants,
    //ESpecificType.Kaki
  ],
  EType.Shoes : [
    ESpecificType.Shoes,
    // ESpecificType.Slipper
  ],
  EType.Backpack : [ESpecificType.Backpack]
};

extension StringETypeExtension on String {
  EType toEType() {
    return mapNameToEType[this]!;
  }
}

extension ETypeExtension on EType {
  String get name {
    return mapETypeToName[this]!;
  }

  List<ESpecificType> get specificTypes {
    return mapETypeToSpecificTypes[this]!;
  }
}
