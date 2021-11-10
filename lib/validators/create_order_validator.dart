import 'package:regexed_validator/regexed_validator.dart';

class CreateOrderValidator {
  static bool isValidName(String name) {
    if (name == null || name.trim() == '')
      return false;

    // if (!validator.name(name))
    //   return false;

    return true;
  }

  static bool isValidAddress(String address) {
    if (address == null || address.trim() == '')
      return false;

    return true;
  }

  static bool isValidPhone(String number) {
    if (number == null || number.trim() == '')
      return false;

    if (!validator.phone(number))
      return false;

    return true;
  }
}