import 'dart:developer' as logger;
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/bloc/create_order_bloc.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/models/order_detail.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/pages/order/ordered_item_list.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/orders/order_detail.service.dart';
import 'package:do_an_ui/services/orders/order.service.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateOrderPage extends StatefulWidget {
  final String userId;

  CreateOrderPage({
    Key? key,
    required this.userId
}): super(key: key);

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  List<Item> orderedItems = [];
  int totalCost = 0;
  int ticket = 0;
  bool useTicket = false;
  late Customer customer;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  CreateOrderBloc bloc = CreateOrderBloc();

  @override
  void initState() {
    super.initState();

    g_localItemsService.forEach((key, s) {
      Item? item = s.itemBehavior.value;

      if (item != null)
        {
          orderedItems.add(item);
          totalCost += item.price;
        }
    });

    g_customerService.readOnce(widget.userId).then((cus) {
      nameController.text = cus!.name;
      phoneController.text = cus.phoneNumber;
      addressController.text = cus.address;
      ticket = cus.ticket;
      customer = cus;
    });

    if (orderedItems.isEmpty) {
      Fluttertoast.showToast(msg: "There are no item to purchase");

      context.router.replace(ClothesDetailPageRoute(userId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(child: OrderedItemList(data: orderedItems), flex: 1,),
          Divider(color: Colors.blue, thickness: 2,),
          Expanded(flex: 1, child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: ListView(children: [
              StreamBuilder(
                stream: bloc.NameStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'What is your name?',
                      errorText: snapshot.hasError? snapshot.error.toString(): null
                    ),
                  );
                }
              ),
              StreamBuilder(
                stream: bloc.PhoneStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'What is your phone number?',
                      errorText: snapshot.hasError? snapshot.error.toString(): null
                    ),
                  );
                }
              ),
              StreamBuilder(
                stream: bloc.AddressStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: addressController,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Where should we send you?',
                      errorText: snapshot.hasError? snapshot.error.toString(): null
                    ),
                  );
                }
              ),
              Row(
                children: [
                  Text("Use discount ticket?"),
                  Checkbox(
                    value: this.useTicket, onChanged: (value) {
                      setState(() {
                        useTicket = value!;
                      });
                  },
                    activeColor: Colors.blue,  ),
                  Text(useTicket? "Discount by ${formatMoney(100000)}": "No discount"),
                ],
              )
              ],),
          ),),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: createOrder,
              child: Text('ORDER'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Theme.of(context).backgroundColor;
                      return Theme.of(context).primaryColor;
                    },
              ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Theme.of(context).primaryColor;
                    return Theme.of(context).backgroundColor;
                  },
            ),
          ))
        ,),]
      ),),
    );
  }

  void setDiscount(Customer customer, Order order) {
    order.discount = 100000;
    order.total = max(order.total - order.discount, 0);

    customer.ticket = max(customer.ticket - 1, 0);
  }

  void executeOrder(Order order, List<Item> items) {
    orderService.create(order).then((value) {
      Fluttertoast.showToast(msg: 'Order successfully!');
    });

    items.forEach((item) {
      OrderDetail orderDetail = new OrderDetail();
      orderDetail.id = orderService.getId();
      orderDetail.orderId = order.id;
      orderDetail.itemId = item.id;

      orderDetail.imageUrl = item.imageUrl;
      orderDetail.name = item.name;
      orderDetail.price = item.price;

      orderDetailService.create(orderDetail);
    });
  }

  void createOrder() {
    Order order = new Order();

    logger.log("A");

    if (ticket == 0 && useTicket)
    {
      logger.log("B");
      Fluttertoast.showToast(msg: "Sorry, you don't have discount tickets");
      return;
    }

    logger.log("C");
    if (bloc.IsValidInfo(nameController.text, phoneController.text, addressController.text))
      {
        logger.log("D");
        order.id = orderService.getId();
        order.userId = widget.userId;

        order.userName = nameController.text;
        order.phoneNumber = phoneController.text;
        order.address = addressController.text;

        order.createdTime = Timestamp.now();
        order.state = ORDER_STATE_INIT;
        order.total = totalCost;

        if (useTicket)
          setDiscount(customer, order);

        customer.point += (order.total / 10000).floor();
        g_customerService.update(customer);

        executeOrder(order, orderedItems);
      }
  }
}


