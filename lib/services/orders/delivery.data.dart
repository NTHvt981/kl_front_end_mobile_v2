import 'package:do_an_ui/models/customer.model.dart';

class DeliveryData {
  // singleton boilerplate
  static final DeliveryData _instance = DeliveryData._internal();

  factory DeliveryData() {
    return _instance;
  }

  // singleton boilerplate
  DeliveryData._internal() {
    name = "";
    phoneNumber = "";
    address = "";
  }

  //------------------PRIVATE ATTRIBUTES------------------//
  late String name;
  late String phoneNumber;
  late String address;

  void setFromUser(Customer user) {
    name = user.name;
    phoneNumber = user.phoneNumber;
    address = user.address;
  }
}