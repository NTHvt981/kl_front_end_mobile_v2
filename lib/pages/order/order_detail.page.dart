import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/detail.model.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/pages/order/ordered_item_list.widget.dart';
import 'package:do_an_ui/services/clothes/item.service.dart';
import 'package:do_an_ui/services/orders/order_detail.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/order_status.enum.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../services/orders/order.service.dart';
import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'order_detail.widget.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  // const OrderDetailPageRoute({required this.order});
  OrderDetailPage({
    Key? key,
    required this.order
}):super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState(
    status: order.status
  );
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<Detail> _details = [];
  EOrderStatus status;

  _OrderDetailPageState({
    required this.status
});

  @override
  void initState() {
    super.initState();

    g_orderService.readLive(widget.order.id).listen((order) {
      setState(() {
        status = order.status;
      });
    });

    g_orderDetailService.readAllOnce(widget.order.id)
      .then((details) => {
        details.forEach((detail) async {
          final item = await g_itemService.readOnce(detail.itemId);

          setState(() {
            detail.item = item;
            _details.add(detail);
          });
        })
    });
  }

  _confirmCancel() async {
    if (await confirm(
      context,
      title: Text('CONFIRM CANCEL'),
      content: Text('Are you sure?'),
      textOK: Text('Yes'),
      textCancel: Text('No'),
    )) {
      _cancelOrder();
    }
  }

  _cancelOrder() async {
    EasyLoading.show(status: 'Cancel order...');

    await g_orderService.cancel(widget.order.id).whenComplete(() {
      setState(() {
        status = EOrderStatus.Cancel;
      });
    });

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Column(children: [
        _header(context),
        _detailsList(),
        _infoList(),
        status == EOrderStatus.Cancel? _txtCancel(): status == EOrderStatus.Finish? _txtFinish(): _btnCancel(),
      ],)
    );
  }

  HeaderWidget _header(BuildContext context) {
    return HeaderWidget(
      title: TextWidget(
        text: "Order: ${formatID(widget.order.id)}.",
        size: 16.0,
        bold: true,
        color: DARK_BLUE,
      ),
      canGoBack: true,
      router: context.router,
      textColor: DARK_BLUE,
    );
  }

  PercentageSizeWidget _detailsList() {
    return PercentageSizeWidget(
      percentageHeight: 0.5,
      child: Container(
        color: WHITE,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemBuilder: (context, position) {
            return OrderDetailWidget(
              detail: _details[position],
            );
          },
          itemCount: _details.length,
        ),
      ),
    );
  }

  PercentageSizeWidget _infoList() {
    return PercentageSizeWidget(
      percentageHeight: 0.3,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(children: [
          _txtTitle(title: 'DELIVERY'),
          _txtInfo(label: 'Name:', value: widget.order.userName),
          _txtInfo(label: 'Phone number:', value: widget.order.phoneNumber),
          _txtInfo(label: 'Address:', value: widget.order.address),
          _txtTitle(title: 'DISCOUNT'),
          _txtInfo(label: 'Tickets used:', value: widget.order.ticketsUsed.toString()),
          _txtInfo(label: 'Total:',
              value: formatMoney(widget.order.total),
              highLight: true
          ),
          _txtInfo(label: 'Discount:',
              value: formatMoney(widget.order.discount),
              highLight: true
          ),
          Divider(),
          _txtInfo(label: 'After discount:',
            value: formatMoney(widget.order.total - widget.order.discount),
            highLight: true
          ),
          _txtTitle(title: 'OTHER'),
          _txtInfo(label: 'Created at:', value: formatDate(widget.order.createdTime.toDate())),
          _txtInfo(label: 'Recent update:', value: formatDate(widget.order.updatedTime.toDate())),
          _txtInfo(label: 'Status:',
              value: status.name,
              highLight: true
          ),
        ],),
      ),
    );
  }

  Center _txtTitle({required String title}) {
    return Center(
      child: TextWidget(
              text: title,
              size: FONT_SIZE_2,
              bold: true,
              color: DARK_BLUE,
            ),
    );
  }

  Widget _txtInfo({required String label, required String value, bool highLight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: label,
          size: FONT_SIZE_2,
          bold: true,
        ),
      TextWidget(
        text: value,
        size: FONT_SIZE_2,
        color: highLight? Colors.red: BLACK,
      ),
    ],);
  }

  PercentageSizeWidget _btnCancel() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.all(15.0),
        child: RoundedButtonWidget(
          onTap: _confirmCancel,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'CANCEL ORDER',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  PercentageSizeWidget _txtCancel() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: TextWidget(
            text: 'THIS ORDER IS CANCELED',
            size: FONT_SIZE_1,
            color: DARK_BLUE,
          ),
        ),
      ),
    );
  }

  PercentageSizeWidget _txtFinish() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: TextWidget(
            text: 'ORDER DELIVERED',
            size: FONT_SIZE_1,
            color: DARK_BLUE,
          ),
        ),
      ),
    );
  }
}
