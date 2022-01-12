import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';

class OrderFailPage extends StatefulWidget {
  final Object error;

  OrderFailPage({
    required this.error
});

  @override
  State<OrderFailPage> createState() => _OrderFailPageState();
}

class _OrderFailPageState extends State<OrderFailPage> {
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

  _goBack() {
    context.router.pop();
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
              child: Image.asset('images/order/fail.png'),
              width: size.width / 4,
              height: size.width / 4,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextWidget(
                text: 'Oh Snap! Order failed',
                size: 32.0,
                bold: true,
                color: BLACK,
              ),
            ),
            PercentageSizeWidget(
              percentageHeight: 0.3,
              percentageWidth: 0.8,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: TextWidget(
                  text: widget.error.toString(),
                  size: 12.0,
                  bold: true,
                  color: MEDIUM_GRAY,
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 5),
            //   child: TextWidget(
            //     text: 'Looks like something went wrong',
            //     size: 12.0,
            //     bold: true,
            //     color: MEDIUM_GRAY,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 10),
            //   child: TextWidget(
            //     text: 'while processing your request',
            //     size: 12.0,
            //     bold: true,
            //     color: MEDIUM_GRAY,
            //   ),
            // ),
            Padding(
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
                    text: 'PLEASE TRY AGAIN',
                    size: 12.0,
                    color: WHITE,
                    bold: true,
                  ),
                ),
              )
            ),
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
}
