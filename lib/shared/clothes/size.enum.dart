import 'dart:developer';

import 'package:do_an_ui/services/clothes/body_stat.data.dart';
import 'package:do_an_ui/shared/order_status.enum.dart';

enum ESize {
  S,
  M,
  L,
  XL,
  I37,
  I38,
  I39,
  I40,
  I41,
  I42,
}
///SP means Shirt & Pants
final SP_SIZE_MIN = 0;
final SP_SIZE_MAX = 3;
///SH means Shoes
final SH_SIZE_MIN = 4;
final SH_SIZE_MAX = 9;

final mapIntToESize = {
  0: ESize.S,
  1: ESize.M,
  2: ESize.L,
  3: ESize.XL,
  4: ESize.I37,
  5: ESize.I38,
  6: ESize.I39,
  7: ESize.I40,
  8: ESize.I41,
  9: ESize.I42,
};

final mapESizeToInt = {
  ESize.S : 0,
  ESize.M : 1,
  ESize.L : 2,
  ESize.XL : 3,
  ESize.I37 : 4,
  ESize.I38 : 5,
  ESize.I39 : 6,
  ESize.I40 : 7,
  ESize.I41 : 8,
  ESize.I42 : 9,
};

final mapESizeToName = {
  ESize.S : 'S',
  ESize.M : 'M',
  ESize.L : 'L',
  ESize.XL : 'XL',
  ESize.I37 : '37',
  ESize.I38 : '38',
  ESize.I39 : '39',
  ESize.I40 : '40',
  ESize.I41 : '41',
  ESize.I42 : '42',
};

final Map<String, ESize> mapNameToESize = {
  'S' : ESize.S,
  'M' : ESize.M,
  'L' : ESize.L,
  'XL' : ESize.XL,
  '37' : ESize.I37,
  '38' : ESize.I38,
  '39' : ESize.I39,
  '40' : ESize.I40,
  '41' : ESize.I41,
  '42' : ESize.I42,
};

final mapESizeToScale = {
  ESize.S : 0.95,
  ESize.M : 1.0,
  ESize.L : 1.05,
  ESize.XL : 1.1,
  ESize.I37 : 0.96,
  ESize.I38 : 0.98,
  ESize.I39 : 1.0,
  ESize.I40 : 1.02,
  ESize.I41 : 1.04,
  ESize.I42 : 1.06,
};

final mapESizeToHeight = { //in cm
  ESize.S : 157,
  ESize.M : 163,
  ESize.L : 170,
  ESize.XL : 175,
};

final mapESizeToWeight = { //in kg
  ESize.S : 53,
  ESize.M : 60,
  ESize.L : 65,
  ESize.XL : 75,
};

extension IntESizeExtension on int {
  ESize toEsize() {
    final result = mapIntToESize[this];
    if (result == null) {
      throw('[IntESizeExtension] ERROR toEsize');
    } else {
      return result;
    }
  }
}

extension StringESizeExtension on String {
  ESize toEsize() {
    final result = mapNameToESize[this];
    if (result == null) {
      throw('[StringESizeExtension] ERROR toEsize');
    } else {
      return result;
    }
  }
}

extension BodyStatExtension on BodyStat {
  ESize toEsize() {
    int sum = this.sum;
    ESize result = SP_SIZE_MIN.toEsize();
    int nearest = (result.bodyStat.sum - sum).abs();
    for (int i = SP_SIZE_MIN; i <= SP_SIZE_MAX; i++) {
      log('[ESize] Sum is ${i.toEsize().bodyStat.sum} from size ${i.toEsize().name}');
      int temp = (i.toEsize().bodyStat.sum - sum).abs();
      if (temp < nearest) {
        nearest = temp;
        result = i.toEsize();
      }
    }

    log('[ESize] Body stat sum is ${sum.toString()}');
    log('[ESize] Nearest sum is ${result.bodyStat.sum} from size ${result.name}');
    return result;
  }
}

extension ESizeExtension on ESize {
  bool isSPSize() {
    return this.index >= SP_SIZE_MIN && this.index <= SP_SIZE_MAX;
  }

  bool isSHSize() {
    return this.index >= SH_SIZE_MIN && this.index <= SH_SIZE_MAX;
  }

  String get name {
    return mapESizeToName[this]!;
  }

  double get scale {
    return mapESizeToScale[this]!;
  }

  int get index {
    return mapESizeToInt[this]!;
  }

  int get height {
    return mapESizeToHeight[this]!;
  }

  int get weight {
    return mapESizeToWeight[this]!;
  }

  BodyStat get bodyStat {
    var result = BodyStat();
    result.weight = this.weight;
    result.height = this.height;
    return result;
  }

  double compare(int height, int weight) {
    final heightFactor = 1;
    final weightFactor = 1;
    return (
      (this.height / height) * heightFactor + (this.weight / weight) * weightFactor
    ) / (heightFactor + weightFactor);
  }
}