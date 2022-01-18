import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

class OrderSuccessPage extends StatefulWidget {
  final String userId;

  OrderSuccessPage({
    required this.userId
});

  @override
  _OrderSuccessPageState createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {

  _goBack() {
    context.router.pop();
  }

  _goToOrderList() {
    context.router.popAndPush(OrderListPageRoute(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(children: [
        HeaderWidget(
          canGoBack: true,
          router: context.router,
        ),
        _contents(size)
      ],
      ),
    );
  }

  PercentageSizeWidget _contents(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.9,
      child: Container(
        color: WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('images/order/success.png'),
              width: size.width / 4,
              height: size.width / 4,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 2.0),
              child: TextWidget(
                text: 'Congrats! Your Order has',
                size: 28.0,
                bold: true,
                color: BLACK,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: TextWidget(
                text: 'been placed',
                size: 28.0,
                bold: true,
                color: BLACK,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: TextWidget(
                text: 'Your items has been placed and is on',
                size: 12.0,
                bold: true,
                color: MEDIUM_GRAY,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: TextWidget(
                text: 'it’s way to being processed',
                size: 12.0,
                bold: true,
                color: MEDIUM_GRAY,
              ),
            ),
            _btnTrackOrders(),
            _btnContinueShopping(),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: TextWidget(
                text: '<- Back to home',
                size: 12.0,
                bold: true,
              ),
            ),
          ],),
      ),
    );
  }

  Padding _btnContinueShopping() {
    return Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: PercentageSizeWidget(
                percentageWidth: 0.8,
                percentageHeight: 0.08,
                child: RoundedButtonWidget(
                  onTap: _goBack,
                  borderColor: DARK_BLUE,
                  roundness: 90,
                  backgroundColor: DARK_BLUE,
                  child: TextWidget(
                    text: 'CONTINUE SHOPPING',
                    size: 12.0,
                    color: WHITE,
                    bold: true,
                  ),
                ),
              )
          );
  }

  Padding _btnTrackOrders() {
    return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: PercentageSizeWidget(
                percentageWidth: 0.8,
                percentageHeight: 0.08,
                child: RoundedButtonWidget(
                  onTap: _goToOrderList,
                  borderColor: DARK_BLUE,
                  roundness: 90,
                  backgroundColor: DARK_BLUE,
                  child: TextWidget(
                    text: 'TRACK ORDER',
                    size: 12.0,
                    color: WHITE,
                    bold: true,
                  ),
                ),
              )
          );
  }
}
