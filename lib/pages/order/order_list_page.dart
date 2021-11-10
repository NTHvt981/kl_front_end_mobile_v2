import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/order.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/order_service.dart';
import 'package:do_an_ui/shared/drawer.dart';
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
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();

    orderService.readAllLive(widget.userId).listen((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('What have you ordered?'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.separated(
            itemBuilder: (context, pos) {
              var time = orders[pos].createdTime.toDate();
              var day = time.day;
              var month = time.month;
              var year = time.year;
            return ListTile(
              title: Text(orders[pos].id.toString()),
              subtitle: Text(orders[pos].state.toLowerCase()),
              trailing: Text(
                  "Thành giá: " + orders[pos].total.toString() + "VNĐ\n"
                      + "Ngày đặt: $day/$month/$year"
              ),
              onTap: () => onSelect(orders[pos]),
            );},
            separatorBuilder: (context, pos) => Divider(),
            itemCount: orders.length
        ),
      ),
    );
  }

  void onSelect(Order order) {
    context.router.push(OrderDetailPageRoute(order: order));
    // ExtendedNavigator.root.push(
    //     OrderDetailRoute.name, arguments: OrderDetailPageArguments(order: order));
  }
}
