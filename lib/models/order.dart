import 'package:cloud_firestore/cloud_firestore.dart';

const ID = 'Ma';
const USER_ID = 'MaKhachHang';

const USER_NAME = 'TenKhachHang';
const PHONE_NUMBER = 'SoDienThoai';
const ADDRESS = 'DiaChi';

const CREATED_TIME = 'ThoiGianDatHang';
const STATE = 'TinhTrang';
const TOTAL = 'TongCong';
const DISCOUNT = 'KhuyenMai';

const ORDER_STATE_INIT = 'Đặt hàng thành công';
const ORDER_STATE_TAKING_IN = 'Đã tiếp nhận đơn hàng';
const ORDER_STATE_SUCCESS = 'Giao hàng thành công';
const ORDER_STATE_CANCELED = 'Đã huỷ';

class Order {
  late String id;
  late String userId;
  late String userName;
  late String phoneNumber;
  late String address;
  late Timestamp createdTime;
  late String state;
  late int total;
  late int discount;

  Order();

  Map<String, dynamic> toMap() => {
    ID: id,
    USER_ID: userId,

    USER_NAME: userName,
    PHONE_NUMBER: phoneNumber,
    ADDRESS: address,

    CREATED_TIME: createdTime,
    STATE: state,
    TOTAL: total,
    DISCOUNT: discount
  };

  Order.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        userId = map[USER_ID],

        userName = map[USER_NAME],
        phoneNumber = map[PHONE_NUMBER],
        address = map[ADDRESS],

        createdTime = map[CREATED_TIME] as Timestamp,
        state = map[STATE],
        total = map[TOTAL],
        discount = 0;
}