import 'dart:async';

import 'package:do_an_ui/validators/create_order.validator.dart';

class CreateOrderBloc {
  final _nameController = new StreamController();
  final _phoneController = new StreamController();
  final _addressController = new StreamController();

  Stream get NameStream => _nameController.stream;
  Stream get PhoneStream => _phoneController.stream;
  Stream get AddressStream => _addressController.stream;

  bool IsValidInfo(String name, String phone, String address) {
    if (!CreateOrderValidator.isValidName(name)) {
      _nameController.sink.addError('Name is not valid');
      return false;
    }
    _nameController.sink.add('OK');

    if (!CreateOrderValidator.isValidPhone(phone)) {
      _phoneController.sink.addError('Phone number is not valid');
      return false;
    }
    _phoneController.sink.add('OK');

    if (!CreateOrderValidator.isValidAddress(address)) {
      _addressController.sink.addError('Address is not valid');
      return false;
    }
    _addressController.sink.add('OK');

    return true;
  }

  void dispose() {
    _nameController.close();
    _phoneController.close();
    _addressController.close();
  }
}