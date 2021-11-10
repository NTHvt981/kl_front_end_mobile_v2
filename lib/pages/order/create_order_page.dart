import 'dart:developer' as logger;
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/bloc/create_order_bloc.dart';
import 'package:do_an_ui/models/customer.dart';
import 'package:do_an_ui/models/order.dart';
import 'package:do_an_ui/models/order_detail.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/pages/order/ordered_item_list.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/customer_service.dart';
import 'package:do_an_ui/services/order_detail_service.dart';
import 'package:do_an_ui/services/order_service.dart';
import 'package:do_an_ui/shared/clothes_bottom_navigation.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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

    localItemService.forEach((key, s) {
      Item? item = s.itemBehavior.value;

      if (item != null)
        {
          orderedItems.add(item);
          totalCost += item.price;
        }
    });

    customerService.readOnce(widget.userId).then((cus) {
      nameController.text = cus!.name;
      phoneController.text = cus.phoneNumber;
      addressController.text = cus.address;
      ticket = cus.ticket;
      customer = cus;
    });

    if (orderedItems.isEmpty) {
      // Toast.show('There are no item to purchase', context,
      //     duration: Toast.LENGTH_SHORT,
      //     gravity: Toast.BOTTOM);

      // ExtendedNavigator.root.replace(Routes.clothesDetailPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total cost: ' + formatMoney(totalCost - (useTicket? 100000: 0))),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(child: OrderedItemList(data: orderedItems), flex: 1,),
          Divider(color: Colors.blue, thickness: 2,),
          Expanded(flex: 1, child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
            child: ListView(children: [
              StreamBuilder(
                stream: bloc.nameStream,
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
                stream: bloc.phoneStream,
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
                stream: bloc.addressStream,
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
      bottomNavigationBar: ClothesBottomNavigation(index: CREATE_ORDER_PAGE,),
    );
  }

  void setDiscount(Customer customer, Order order) {
    order.discount = 100000;
    order.total = max(order.total - order.discount, 0);

    customer.ticket = max(customer.ticket - 1, 0);
  }

  void executeOrder(Order order, List<Item> items) {
    orderService.create(order).then((value) => {
      Toast.show('Order successfully!', context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM)
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
      Toast.show("Sorry, you don't have discount tickets", context);
      return;
    }

    logger.log("C");
    if (bloc.isValidInfo(nameController.text, phoneController.text, addressController.text))
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
        customerService.update(customer);

        executeOrder(order, orderedItems);
      }
  }
}


