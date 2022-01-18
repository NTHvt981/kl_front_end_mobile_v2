import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/shared/order_status.enum.dart';
import 'package:flutter/cupertino.dart';

const ID = 'Ma';
const USER_ID = 'MaKhachHang';

const USER_NAME = 'TenKhachHang';
const PHONE_NUMBER = 'SoDienThoai';
const ADDRESS = 'DiaChi';

const CREATED_TIME = 'ThoiGianDatHang';
const UPDATED_TIME = 'ThoiGianCapNhat';
const STATE = 'TinhTrang';
const TOTAL = 'TongCong';
const DISCOUNT = 'KhuyenMai';
const TICKETS_USED = 'PhieuSuDung';
const IMAGE_URL = 'HinhAnh';

class Order {
  String id;
  String userId;
  String userName;
  String phoneNumber;
  String address;
  Timestamp createdTime;
  Timestamp updatedTime;
  EOrderStatus status;
  int total = 0;
  int discount = 0;
  int ticketsUsed = 0;
  String imageUrl = '';

  Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.createdTime,
    required this.updatedTime,
    required this.status,
});

  Map<String, dynamic> toMap() => {
    ID: id,
    USER_ID: userId,

    USER_NAME: userName,
    PHONE_NUMBER: phoneNumber,
    ADDRESS: address,

    CREATED_TIME: createdTime,
    UPDATED_TIME: updatedTime,
    STATE: status.id,
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
        updatedTime = map[UPDATED_TIME] as Timestamp,
        status = (map[STATE] as String).toOStatus(),
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
    discount = tickets * 10000;
  }
}