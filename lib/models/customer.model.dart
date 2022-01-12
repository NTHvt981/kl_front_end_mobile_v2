import 'package:do_an_ui/models/order.model.dart';

const ID = 'Ma';
const NAME = 'HoTen';
const PHONE_NUMBER = 'SoDienThoai';
const ADDRESS = 'DiaChi';
const IMAGE = 'HinhAnh';
const POINT = 'SoDiemTichLuy';
const TICKET = 'SoPhieuKhuyenMai';

class Customer {
  late String id;
  late String name;
  late String phoneNumber;
  late String address;
  late String imageUrl;
  late int point;
  late int ticket;

  Customer(String _id) {
    id = _id;
    point = 0;
    ticket = 0;
    name = "";
    phoneNumber = "";
    address = "";
    imageUrl = "";
  }

  Map<String, dynamic> toMap() => {
    ID: id,
    NAME: name,
    PHONE_NUMBER: phoneNumber,
    ADDRESS: address,
    IMAGE: imageUrl,
    POINT: point,
    TICKET: ticket
  };

  Customer.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
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
    ticket -= tickets;
  }
}