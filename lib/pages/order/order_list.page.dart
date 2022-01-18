import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/order/order.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import '../../services/orders/order.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
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

    g_orderService.readAllLive(widget.userId).listen((orders) {
      orders.sort((a, b) => a.createdTime.compareTo(b.createdTime));
      setState(() {
        _orders = orders.reversed.toList();
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
      backgroundColor: WHITE,
      body: Column(
        children: [
          _header(context),
          PercentageSizeWidget(
            percentageHeight: 0.9,
            child: _orderList(),
          ),
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
      child: Container(
        color: WHITE,
        child: ListView.builder(
          itemBuilder: (context, position) {
            return OrderWidget(order: _orders[position], onSelect: _onSelect,);
          },
          itemCount: _orders.length,
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
