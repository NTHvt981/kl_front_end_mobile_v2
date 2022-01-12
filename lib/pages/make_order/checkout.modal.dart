import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/pages/make_order/delivery.info.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/orders/discount.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutModal extends StatefulWidget {
  final int totalCost;
  final Function(Order?) onPlaceOrder;
  final String userId;

  CheckoutModal({
    required this.totalCost,
    required this.onPlaceOrder,
    required this.userId
});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  final _sfSize = 16.0;

  final _bfSize = 20.0;

  final _hPadding = 20.0;

  final _vPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Column(children: [
        Expanded(flex: 4, child: _options(context),),
        Expanded(flex: 1, child: _btnPlaceOrder(),)
      ],),
    );
  }

  Container _btnPlaceOrder() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        child: RoundedButtonWidget(
          onTap: () {
            widget.onPlaceOrder(null);
          },
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'CONFIRM CHECKOUT',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      );
  }

  Container _options(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20.0),
      child: ListView(children: [
        _titleTile(context),
        Divider(),
        _deliveryTile(context),
        Divider(),
        _paymentTile(),
        Divider(),
        _totalCostTile(),
        Divider(),
        _discountTile(),
        Divider(),
        _finalCostTile(),
        Divider(),
        _txtAgreement()
      ],),
    );
  }

  Container _txtAgreement() {
    return Container(
        padding: EdgeInsets.all(_vPadding),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextWidget(
              text: 'By placing an order you agree to our',
              size: 12,
              color: MEDIUM_GRAY,
            ),
            TextWidget(
              text: 'Term and Agreement',
              size: 12,
              color: MEDIUM_GRAY,
            ),
          ],
        ),
      );
  }

  Widget _titleTile(BuildContext context) {
    return _tile(
      TextWidget(
        text: 'Checkout',
        size: _bfSize,
        bold: true,
      ),
      GestureDetector(
        child: Icon(IconCancel, color: MEDIUM_GRAY,),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _deliveryTile(BuildContext context) {
    return _tile(
      TextWidget(
        text: 'Delivery',
        size: _sfSize,
        bold: true,
      ),
      GestureDetector(
        child: TextWidget(
          text: 'Select Method >',
          size: _sfSize,
          color: DARK_BLUE,
          bold: true,
        ),
        onTap: _goToDelivery,
      ),
    );
  }

  Widget _paymentTile() {
    return _tile(
      TextWidget(
        text: 'Payment',
        size: _sfSize,
        bold: true,
      ),
      GestureDetector(
        child: TextWidget(
          text: 'Choose payment >',
          size: _sfSize,
          color: DARK_BLUE,
          bold: true,
        ),
        onTap: _goToPayment,
      ),
    );
  }

  Widget _discountTile() {
    return _tile(
      TextWidget(
        text: 'Your discount',
        size: _sfSize,
        bold: true,
      ),
      GestureDetector(
        child: TextWidget(
          text: '${formatMoney(DiscountData().usedTickets * 10000)} >',
          size: _sfSize,
          color: DARK_BLUE,
          bold: true,
        ),
        onTap: _goToDiscount,
      ),
    );
  }

  Widget _totalCostTile() {
    return _tile(
      TextWidget(
        text: 'Total cost',
        size: _sfSize,
        bold: true,
      ),
      GestureDetector(
        child: TextWidget(
          text: '${formatMoney(widget.totalCost != null? widget.totalCost: 0).toString()}',
          size: _sfSize,
          color: BLACK,
          bold: true,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _finalCostTile() {
    return _tile(
      TextWidget(
        text: 'After discount',
        size: _sfSize,
        bold: true,
      ),
      GestureDetector(
        child: TextWidget(
          text: '${formatMoney(widget.totalCost - DiscountData().usedTickets * 10000)}',
          size: _sfSize,
          color: Colors.red,
          bold: true,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _tile(Widget left, Widget right) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding, vertical: _vPadding),
      child: Stack(children: [
        Container(alignment: Alignment.centerLeft, child: left,),
        Container(alignment: Alignment.centerRight, child: right,)
      ],),
    );
  }

  void _goToDelivery() {
    context.router.push(DeliveryInfoPageRoute(userId: widget.userId));
  }

  void _goToPayment() {
    context.router.push(PaymentInfoPageRoute(userId: widget.userId));
  }

  void _goToDiscount() {
    context.router.push(DiscountInfoPageRoute(userId: widget.userId));
  }
}
