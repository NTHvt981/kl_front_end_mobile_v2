import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/orders/discount.data.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import '../../shared/label.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:numberpicker/numberpicker.dart';

class DiscountInfoPage extends StatefulWidget {
  final String userId;

  DiscountInfoPage({
    required this.userId
  });

  @override
  _DiscountInfoPageState createState() => _DiscountInfoPageState();
}

class _DiscountInfoPageState extends State<DiscountInfoPage> {
  final TextEditingController _pointsCon = new TextEditingController();
  final TextEditingController _ticketsCon = new TextEditingController();
  final _userService = CustomerService();
  late Customer _user;
  int _pointsToTickets = 0;

  @override
  void initState() {
    super.initState();
    _pointsCon.text = '0';
    _ticketsCon.text = '0';

    _user = g_userData.currentUser();
    g_userData.itemBehavior.listen((user) {
      _user = user;
      log('[DISCOUNT] g_userData _user.point.toString() ${_user.point.toString()}');
      setState(() {
        _pointsCon.text = _user.point.toString();
        _ticketsCon.text = _user.ticket.toString();
      });
    });
  }

  _convertPointsToTickets() {
    _user.convertPointToTicket(_pointsToTickets);

    setState(() {
      _pointsToTickets = 0;
    });

    _userService.update(_user).catchError((err) {
      log('[DISCOUNT INFO] ${err.toString()}');
    });
  }

  _confirmDiscount() {
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final size = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(children: [
            _header(),
            _info(size),
            _btnConfirm(size)
          ],
          ),
        ),
      ),
    );
  }

  HeaderWidget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: "Your discount.",
        size: 20.0,
        bold: true,
      ),
      canGoBack: true,
      router: context.router,
    );
  }

  Widget _info(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.8,
      child: Container(
        color: WHITE,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.width * 0.05),
        child: ListView(
          children: [
            _rowPointsAndTickets(),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            Divider(),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            Container(
              alignment: Alignment.center,
              child: TextWidget(
                text: 'Transfer points to tickets',
                size: FONT_SIZE_2,
                bold: true,
              ),
            ),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _rowPointsToTickets(size),
            Container(
              alignment: Alignment.center,
              child: TextWidget(
                text: '${_pointsToTickets ~/ 1000},000 points = ${_pointsToTickets ~/ 1000} ticket',
                size: FONT_SIZE_1,
                bold: false,
                color: MEDIUM_GRAY,
              ),
            ),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            Divider(),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            Container(
              alignment: Alignment.center,
              child: TextWidget(
                text: 'Apply ticket for discount',
                size: FONT_SIZE_2,
                bold: true,
              ),
            ),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtApplyTickets(),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            Container(
              alignment: Alignment.center,
              child: TextWidget(
                text: '${DiscountData().usedTickets} ticket discount for ${formatMoney(DiscountData().usedTickets * 5000)}',
                size: FONT_SIZE_1,
                bold: false,
                color: MEDIUM_GRAY,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _rowPointsAndTickets() {
    return Row(children: [
            Expanded(
              child: Column(children: [
                LabelWidget1(text: 'Your points'),
                PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
                _edtPoints(),
              ],),
            ),
            PercentageSizeWidget(percentageWidth: 0.05,percentageHeight: SMALL_PERCENTAGE_GAP),
            Expanded(
              child: Column(children: [
                LabelWidget1(text: 'Your tickets'),
                PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
                _edtTickets(),
              ],),
            )
          ],);
  }

  Widget _rowPointsToTickets(Size size) {
    return SizedBox(
      width: size.width / 2,
      child: Row(children: [
        Expanded(
          child: _edtPointsToTickets(),
        ),
        PercentageSizeWidget(percentageWidth: 0.05,percentageHeight: SMALL_PERCENTAGE_GAP),
        _btnPointsToTickets(),
      ],),
    );
  }

  RoundedButtonWidget _btnPointsToTickets() {
    return RoundedButtonWidget(
        onTap: _convertPointsToTickets,
        backgroundColor: DARK_BLUE,
        borderColor: DARK_BLUE,
        roundness: 90,
        child: Icon(FontAwesome5Solid.ticket_alt)
      );
  }

  RoundedEditWidget _edtPoints() {
    return RoundedEditWidget(
      controller: _pointsCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.number,
      readOnly: true,
    );
  }

  RoundedEditWidget _edtTickets() {
    return RoundedEditWidget(
      controller: _ticketsCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.number,
      readOnly: true,
    );
  }

  Widget _edtPointsToTickets() {
    return NumberPicker(
      minValue: 0,
      maxValue: int.parse(_pointsCon.text),
      value: _pointsToTickets,
      step: 1000,
      onChanged: (int value) {
        setState(() {
          _pointsToTickets = value;
        });
      },
      textMapper: (String valueInt) {
        final tickets = int.parse(valueInt)/1000;
        return valueInt + ' points';
      },
    );
  }

  Widget _edtApplyTickets() {
    return NumberPicker(
      minValue: 0,
      maxValue: int.parse(_ticketsCon.text),
      value: DiscountData().usedTickets <= int.parse(_ticketsCon.text)? DiscountData().usedTickets: 0,
      axis: Axis.horizontal,
      onChanged: (int value) {
        setState(() {
          DiscountData().usedTickets = value;
        });
      },
    );
  }

  Widget _btnConfirm(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: RoundedButtonWidget(
          onTap: _confirmDiscount,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'CONFIRM YOUR DISCOUNT',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }
}
