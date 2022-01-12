import 'package:do_an_ui/models/customer.model.dart';

class DiscountData {
  // singleton boilerplate
  static final DiscountData _instance = DiscountData._internal();

  factory DiscountData() {
    return _instance;
  }

  // singleton boilerplate
  DiscountData._internal() {

  }

  //------------------PRIVATE ATTRIBUTES------------------//
  int points = 0;
  int allTickets = 0;
  int usedTickets = 0;

  void setFromUser(final Customer user) {
    points = user.point;
    allTickets = user.ticket;
  }

  Customer applyDiscount(Customer user) {
    user.point = points;
    user.ticket = allTickets - usedTickets;

    return user;
  }
}