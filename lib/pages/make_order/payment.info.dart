import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/services/orders/payment.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import '../../shared/widgets/label.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentInfoPage extends StatefulWidget {
  final String userId;

  PaymentInfoPage({
    required this.userId
  });

  @override
  _PaymentInfoPageState createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  final TextEditingController _cardNameCon = TextEditingController();
  final TextEditingController _cardNumberCon = TextEditingController();
  final TextEditingController _expireDateCon = TextEditingController();
  final TextEditingController _cvcCon = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getDefaultCardName();
    _getDefaultCardNumber();
    _getDefaultExpireDate();
    _getDefaultCVC();
  }

  //------------------PRIVATE METHODS---------------------//
  bool _getDefaultCardName() {
    if (PaymentData().cardName.isEmpty) {
      return false;
    } else {
      setState(() {
        _cardNameCon.text = PaymentData().cardName;
      });
      return true;
    }
  }

  bool _getDefaultCardNumber() {
    if (PaymentData().cardNumber.isEmpty) {
      return false;
    } else {
      setState(() {
        _cardNumberCon.text = PaymentData().cardNumber;
      });
      return true;
    }
  }

  bool _getDefaultExpireDate() {
    if (PaymentData().expireDate.isEmpty) {
      return false;
    } else {
      DateTime time = DateTime.parse(PaymentData().expireDate);
      setState(() {
        _expireDateCon.text = formatDate(time);
      });
      return true;
    }
  }

  bool _getDefaultCVC() {
    if (PaymentData().cvc.isEmpty) {
      return false;
    } else {
      setState(() {
        _cvcCon.text = PaymentData().cvc;
      });
      return true;
    }
  }

  _onSetExpireDate() async {
    var date =  await showDatePicker(
      context: context,
      initialDate:DateTime.now(),
      firstDate:DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      _expireDateCon.text = formatDate(date);
      PaymentData().expireDate = date.toString();
      setState(() {});
    }
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
            _imgCard(size),
            _info(size),
            _btnUseCard()
          ],
          ),
        ),
      ),
    );
  }

  Widget _imgCard(Size size) {
    final width = size.width * 0.9;
    final height = width * 2/3;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Image.asset(
              'images/credit.png',
            ),
            _txtCardNumber(),
            _txtCardName(),
            _txtExpireDate(),
          ],
        ),
      ),
    );
  }

  Container _txtCardNumber() {
    return Container(
            alignment: Alignment.center,
            child: TextWidget(
              text: formatCardNumber(_cardNumberCon.text),
              size: 28.0,
              color: WHITE,
              bold: true,
            ),
          );
  }

  Container _txtCardName() {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(8.0),
      child: TextWidget(
        text: 'Nguyễn Trung Hiếu',// _cardNameCon.text,
        size: 16.0,
        color: WHITE,
        bold: true,
      ),
    );
  }

  Container _txtExpireDate() {
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 16.0, bottom: 8.0),
      child: TextWidget(
        text: _expireDateCon.text,
        size: 16.0,
        color: WHITE,
        bold: true,
      ),
    );
  }

  HeaderWidget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: "Credit / Debit card.",
        size: 18.0,
        bold: true,
      ),
      canGoBack: true,
      router: context.router,
    );
  }

  Widget _info(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.5,
      child: Container(
        color: WHITE,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 8.0),
        child: ListView(
          children: [
            LabelWidget1(text: 'Name on card'),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtCardName(),
            PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            LabelWidget1(text: 'Card number'),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtCardNumber(),
            PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            Row(children: [
              Expanded(
                child: Column(children: [
                  LabelWidget1(text: 'Expire Date'),
                  PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
                  _edtExpireDate(),
                ],),
              ),
              PercentageSizeWidget(percentageWidth: 0.05,percentageHeight: SMALL_PERCENTAGE_GAP),
              Expanded(
                child: Column(children: [
                  LabelWidget1(text: 'CVC'),
                  PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
                  _edtCVC(),
                ],),
              )
            ],)
          ],
        ),
      ),
    );
  }

  RoundedEditWidget _edtCardName() {
    return RoundedEditWidget(
      controller: _cardNameCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.text,
      onValueChange: _onCardNameChange,
    );
  }

  RoundedEditWidget _edtCardNumber() {
    return RoundedEditWidget(
      controller: _cardNumberCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.phone,
      onValueChange: _onCardNumberChange,
    );
  }

  RoundedEditWidget _edtExpireDate() {
    return RoundedEditWidget(
      controller: _expireDateCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.datetime,
      readOnly: true,
      onTap: _onSetExpireDate,
    );
  }

  RoundedEditWidget _edtCVC() {
    return RoundedEditWidget(
      controller: _cvcCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      roundness: 15,
      inputType: TextInputType.datetime,
      onValueChange: _onCVCChange,
    );
  }

  Widget _btnUseCard() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: RoundedButtonWidget(
          onTap: _useCard,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'USE THIS CARD',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  _onCardNameChange(String v) {
    PaymentData().cardName = v;
    setState(() {});
  }

  _onCardNumberChange(String v) {
    PaymentData().cardNumber = v;
    setState(() {});
  }

  _onCVCChange(String v) {
    PaymentData().cvc = v;
  }

  _useCard() {
    context.router.pop();
  }
}
