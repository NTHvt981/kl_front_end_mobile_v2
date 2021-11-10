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
  }

  void convertPointToTicket(int p) {
    point -= p;
    ticket += (p / 100) as int;
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
        name = map[NAME],
        phoneNumber = map[PHONE_NUMBER],
        address = map[ADDRESS],
        imageUrl = map[IMAGE],
        point = map[POINT],
        ticket = map[TICKET];
}