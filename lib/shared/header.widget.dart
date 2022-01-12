import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final StackRouter? router;
  final bool canGoBack;
  final TextWidget? title;
  final Widget? suffix;
  final Color backgroundColor;
  final Color textColor;

  HeaderWidget({
    this.router,
    this.canGoBack = false,
    this.title,
    this.suffix,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
});

  Widget build(BuildContext context) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Container(
        color: backgroundColor,
        child: Stack(children: [
          _btnGoBack(),
          _title(),
          _suffix(),
    ],),
      ),);
  }

  Container _suffix() {
    return Container(alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 16.0),
        child: suffix,
      );
  }

  Container _title() {
    return Container(alignment: Alignment.center,
          child: title,
      );
  }

  Container _btnGoBack() {
    return canGoBack
        ? Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(IconGoBack, color: textColor,),
            onPressed: _goBack,
            color: textColor,),
          )
        : Container();
  }

  void _goBack() {
    if (!canGoBack) throw('CAN NOT GO BACK');
    router?.pop();
  }
}
