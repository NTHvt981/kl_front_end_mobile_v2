import 'dart:developer';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/models/order_detail.model.dart';
import 'package:do_an_ui/pages/make_order/checkout.modal.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/orders/delivery.data.dart';
import 'package:do_an_ui/services/orders/discount.data.dart';
import 'package:do_an_ui/services/orders/order.service.dart';
import 'package:do_an_ui/services/orders/order_detail.service.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:screenshot/screenshot.dart';
import 'item.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPage extends StatefulWidget {
  final String userId;

  CartPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  List<Item> _items = [];
  int _totalCost = 0;
  final _userService = CustomerService();
  late Customer _user;
  final _screenshotController = ScreenshotController();

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    g_localItemsService.forEach((key, s) {
      Item? item = s.itemBehavior.value;

      if (item != null)
      {
        _items.add(item);
        _totalCost += item.price;
        log('[DEBUG CART] update total cost ${_totalCost.toString()}');
      }
    });

    if (_items.isEmpty) {
      Fluttertoast.showToast(msg: "There are no item to purchase");

      context.router.pop();
    }

    _user = g_userData.currentUser();
    g_userData.getStream().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  _showCheckoutModal(BuildContext context) {
    showRoundedModalBottomSheet(context: context, builder: (context) {
      log('[DEBUG CART] total cost ${_totalCost.toString()}');
      return CheckoutModal(
        totalCost: _totalCost,
        onPlaceOrder: _onPlaceOrder,
        userId: widget.userId,
      );
    },
      radius: 30.0,
      color: Colors.white,
    );
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _header(context),
        _itemsList(),
        _btnCheckout(context)
      ],),
    );
  }

  HeaderWidget _header(BuildContext context) {
    return HeaderWidget(
        title: TextWidget(
          text: "My Cart.",
          size: 20.0,
          bold: true,
        ),
        canGoBack: true,
        router: context.router,
      );
  }

  PercentageSizeWidget _itemsList() {
    return PercentageSizeWidget(
        percentageHeight: 0.8,
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            color: WHITE,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemBuilder: (context, position) {
                return ItemWidget(item: _items[position]);
              },
              itemCount: _items.length,
            ),
          ),
        ),
      );
  }

  PercentageSizeWidget _btnCheckout(BuildContext context) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.all(15.0),
        child: RoundedButtonWidget(
          onTap: () {_showCheckoutModal(context);},
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'GO TO CHECKOUT',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  _onPlaceOrder(Order? order) async {
    //check requirement information
    if (!_checkNameCondition()) return;
    if (!_checkPhoneNumberCondition()) return;
    if (!_checkAddressCondition()) return;

    final order = _createOrder();
    _applyDiscount(order, DiscountData().usedTickets);
    _user.accumulate(order);
    _user.useTickets(DiscountData().usedTickets);
    await _userService.update(_user);
    _updateOrderAndOrderDetails(order, _items);
  }

  Order _createOrder() {
    Order order = new Order();

    order.id = orderService.getId();
    order.userId = widget.userId;

    order.userName = DeliveryData().name;
    order.phoneNumber = DeliveryData().phoneNumber;
    order.address = DeliveryData().address;
    order.imageUrl = '''https://firebasestorage.googleapis.com/v0/b/doan1-6aa37.appspot.com/o/HinhCoSan%2FCard%20(1).png?alt=media&token=5d92a8f9-686b-4e15-bb03-6602470ce999''';

    order.createdTime = Timestamp.now();
    order.state = ORDER_STATE_INIT;
    order.total = _totalCost;
    order.discount = 0; // temp

    return order;
  }

  void _applyDiscount(Order order, int tickets) {
    order.applyDiscount(tickets);
  }

  Future<void> _updateOrderAndOrderDetails(Order order, List<Item> items) async {
    items.forEach((item) async {
      OrderDetail orderDetail = new OrderDetail();
      orderDetail.id = orderService.getId();
      orderDetail.orderId = order.id;
      orderDetail.itemId = item.id;

      orderDetail.imageUrl = item.imageUrl;
      orderDetail.name = item.name;
      orderDetail.price = item.price;

      await orderDetailService.create(orderDetail);
    });

    orderService.create(order).then((value) {
      Fluttertoast.showToast(msg: 'Order successfully!');
      context.router.pop();
      context.router.popAndPush(OrderSuccessPageRoute(userId: widget.userId));
    }).catchError((err) {
      context.router.popAndPush(OrderFailPageRoute(error: err));
    });
  }

  bool _checkNameCondition() {
    if (DeliveryData().name.isEmpty) {
      Fluttertoast.showToast(msg: "Please type name in Delivery Method");
      return false;
    }

    return true;
  }

  bool _checkPhoneNumberCondition() {
    if (DeliveryData().phoneNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Please type phone number in Delivery Method");
      return false;
    }

    return true;
  }

  bool _checkAddressCondition() {
    if (DeliveryData().address.isEmpty) {
      Fluttertoast.showToast(msg: "Please type adress in Delivery Method");
      return false;
    }

    return true;
  }
}
