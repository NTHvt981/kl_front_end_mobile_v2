import 'dart:math';

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
const TICKETS_USED = 'PhieuSuDung';
const IMAGE_URL = 'HinhAnh';

const ORDER_STATE_INIT = 'Taking order';
const ORDER_STATE_DELIVERY = 'Delivery';
const ORDER_STATE_SUCCESS = 'Finish';
const ORDER_STATE_CANCELED = 'Cancel';

class Order {
  late String id;
  late String userId;
  late String userName;
  late String phoneNumber;
  late String address;
  late Timestamp createdTime;
  late String state;
  int total = 0;
  int discount = 0;
  int ticketsUsed = 0;
  String imageUrl = '';

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
    DISCOUNT: discount,
    TICKETS_USED: ticketsUsed,
    IMAGE_URL: imageUrl
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
        imageUrl = map[IMAGE_URL],
        discount = map[DISCOUNT],
        ticketsUsed = map[TICKETS_USED];

  int finalTotal() {
    return max(total - discount, 0);
  }

  //each ticket use discount for 5.000 VNĐ
  void applyDiscount(int tickets) {
    ticketsUsed = tickets;
    discount = tickets * 5000;
  }
}