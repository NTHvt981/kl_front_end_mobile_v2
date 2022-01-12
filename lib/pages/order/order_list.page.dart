import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/order/order.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import '../../services/orders/order.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatefulWidget {
  final String userId;

  OrderListPage({
    Key? key,
    required this.userId
}): super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  List<Order> _orders = [];

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    orderService.readAllLive(widget.userId).listen((value) {
      setState(() {
        _orders = value;
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _onSelect(Order order) {
    context.router.push(OrderDetailPageRoute(order: order));
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(context),
          _orderList(),
        ],
      ),
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

  PercentageSizeWidget _orderList() {
    return PercentageSizeWidget(
      percentageHeight: 0.9,
      child: Container(
        color: WHITE,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemBuilder: (context, position) {
            return OrderWidget(data: _orders[position], onSelect: _onSelect,);
          },
          itemCount: _orders.length,
        ),
      ),
    );
  }
}
