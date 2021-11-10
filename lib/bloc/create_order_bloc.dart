import 'dart:async';

import 'package:do_an_ui/validators/create_order_validator.dart';

class CreateOrderBloc {
  StreamController nameController = new StreamController();
  StreamController phoneController = new StreamController();
  StreamController addressController = new StreamController();

  Stream get nameStream => nameController.stream;
  Stream get phoneStream => phoneController.stream;
  Stream get addressStream => addressController.stream;

  bool isValidInfo(String name, String phone, String address) {
    if (!CreateOrderValidator.isValidName(name)) {
      nameController.sink.addError('Name is not valid');
      return false;
    }
    nameController.sink.add('OK');

    if (!CreateOrderValidator.isValidPhone(phone)) {
      phoneController.sink.addError('Phone number is not valid');
      return false;
    }
    phoneController.sink.add('OK');

    if (!CreateOrderValidator.isValidAddress(address)) {
      addressController.sink.addError('Address is not valid');
      return false;
    }
    addressController.sink.add('OK');

    return true;
  }

  void dispose() {
    nameController.close();
    phoneController.close();
    addressController.close();
  }
}