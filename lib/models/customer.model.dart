import 'dart:developer';

import 'package:do_an_ui/models/order.model.dart';

const ID = 'Ma';
const NAME = 'HoTen';
const EMAIL = 'Email';
const PHONE_NUMBER = 'SoDienThoai';
const ADDRESS = 'DiaChi';
const COLLECTION_SAVED = 'BoQuanAoLuu';
const IMAGE = 'HinhAnh';
const POINT = 'SoDiemTichLuy';
const TICKET = 'SoPhieuKhuyenMai';

class Customer {
  late String id;
  late String name;
  late String email;
  late int savedCollections;
  late String phoneNumber;
  late String address;
  late String imageUrl;
  late int point;
  late int ticket;

  Customer({required this.id, required this.email}) {
    point = 0;
    ticket = 0;
    savedCollections = 0;
    name = "";
    phoneNumber = "";
    address = "";
    imageUrl = "";
  }

  Map<String, dynamic> toMap() => {
    ID: id,
    NAME: name,
    COLLECTION_SAVED: savedCollections,
    EMAIL: email,
    PHONE_NUMBER: phoneNumber,
    ADDRESS: address,
    IMAGE: imageUrl,
    POINT: point,
    TICKET: ticket
  };

  Customer.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        email = map[EMAIL],
        savedCollections = map[COLLECTION_SAVED] != null? map[COLLECTION_SAVED]: 0,
        name = map[NAME] != null? map[NAME]: '',
        phoneNumber = map[PHONE_NUMBER] != null? map[PHONE_NUMBER]: '',
        address = map[ADDRESS] != null? map[ADDRESS]: '',
        imageUrl = map[IMAGE] != null? map[IMAGE]: '',
        point = map[POINT] != null? map[POINT]: 0,
        ticket = map[TICKET] != null? map[TICKET]: 0;


  void convertPointToTicket(int p) {
    assert(point > p);
    point -= p;
    ticket += p ~/ 1000;
  }

  // for each 100VND purchase, accumulate 1 point
  void accumulate(Order order) {
    int finalPrice = order.finalTotal();
    point += finalPrice ~/ 100;
  }

  void useTickets(int tickets) {
    log('[CustomerModel] current tickets ${ticket.toString()} ticket used ${tickets.toString()}');
    ticket -= tickets;
  }
}