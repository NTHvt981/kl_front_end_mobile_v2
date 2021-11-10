import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/models/order.dart';
import 'package:do_an_ui/pages/order/ordered_item_list.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/item_service.dart';
import 'package:do_an_ui/services/order_detail_service.dart';
import 'package:do_an_ui/services/order_service.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  // const OrderDetailPageRoute({required this.order});
  OrderDetailPage({
    Key? key,
    required this.order
}):super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<Item> orderedItems = [];
  bool isCanceled = false;

  @override
  void initState() {
    super.initState();

    isCanceled = widget.order.state == ORDER_STATE_CANCELED;

    orderDetailService.readAllOnce(widget.order.id)
      .then((details) => {
        details.forEach((detail) {
          itemService.readOnce(detail.itemId).then((item) {
            setState(() {
              orderedItems.add(item);
            });
          });
        })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order.id),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Expanded(child: OrderedItemList(data: orderedItems), flex: 1,),
          Divider(color: Colors.blue, thickness: 2,),
          Expanded(flex: 1, child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: ListView(children: [
              TextFormField(
                enabled: false,
                controller: TextEditingController(text: widget.order.userName),
                style: TextStyle(
                  color: Colors.black87
                ),
              decoration: new InputDecoration(
                labelText: 'Name',
              ),),
              TextFormField(
                enabled: false,
                controller: TextEditingController(text: widget.order.phoneNumber),
                style: TextStyle(
                    color: Colors.black87
                ),
                decoration: new InputDecoration(
                  labelText: 'Phone number',
                ),),
              TextFormField(
                enabled: false,
                controller: TextEditingController(text: widget.order.address),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                style: TextStyle(
                    color: Colors.black87
                ),
                decoration: new InputDecoration(
                  labelText: 'Address',
                ),),
            ],),
          ),),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: isCanceled? null : cancelOrder,
              child: Text('CANCEL ORDER'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).buttonColor,
            ),
          )
        ],),
      ),
    );
  }

  cancelOrder() {
    orderService.cancel(widget.order.id).whenComplete(() {
      setState(() {
        isCanceled = false;
      });
    });
  }
}
