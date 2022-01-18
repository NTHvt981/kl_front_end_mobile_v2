const _STATE_INIT = 'Taking order';
const _STATE_DELIVERY = 'Delivery';
const _STATE_FINISH = 'Finish';
const _STATE_CANCELED = 'Cancel';

enum EOrderStatus {
  Init,
  Delivery,
  Finish,
  Cancel
}

final mapEOStatusToId = {
  EOrderStatus.Init : _STATE_INIT,
  EOrderStatus.Delivery : _STATE_DELIVERY,
  EOrderStatus.Finish : _STATE_FINISH,
  EOrderStatus.Cancel : _STATE_CANCELED,
};

final mapEOStatusToName = {
  EOrderStatus.Init : 'preparing',
  EOrderStatus.Delivery : 'in delivery',
  EOrderStatus.Finish : 'finished',
  EOrderStatus.Cancel : 'canceled',
};

final mapStringToEOStatus = {
  _STATE_INIT: EOrderStatus.Init,
  _STATE_DELIVERY: EOrderStatus.Delivery,
  _STATE_FINISH: EOrderStatus.Finish,
  _STATE_CANCELED: EOrderStatus.Cancel,
};

extension StringOStatusExtension on String {
  EOrderStatus toOStatus() {
    final result = mapStringToEOStatus[this];
    if (result == null) {
      throw('[StringOStatusExtension] ERROR toOStatus');
    } else {
      return result;
    }
  }
}

extension EOrderStatusExtension on EOrderStatus {
  String get name {
    final result = mapEOStatusToName[this];
    if (result == null) {
      throw('[EOrderStatusExtension] ERROR get name');
    } else {
      return result;
    }
  }

  String get id {
    final result = mapEOStatusToId[this];
    if (result == null) {
      throw('[EOrderStatusExtension] ERROR get name');
    } else {
      return result;
    }
  }
}