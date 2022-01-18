import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/orders/delivery.data.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/widgets/label.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeliveryInfoPage extends StatefulWidget {
  final String userId;

  DeliveryInfoPage({
    required this.userId
});

  @override
  _DeliveryInfoPageState createState() => _DeliveryInfoPageState();
}

class _DeliveryInfoPageState extends State<DeliveryInfoPage> {
  final _nameCon = new TextEditingController();
  final _phoneCon = new TextEditingController();
  final _addrCon = new TextEditingController();
  late final Customer _user;
  final dkey = '[DEBUG DELIVERY PAGE]';
  bool _isUpdateProfile = false;

  @override
  void initState() {
    super.initState();

    _user = g_userData.currentUser();
    setState(() {
      if (_user.name.isNotEmpty) {
        _nameCon.text = _user.name;
        DeliveryData().name = _user.name;
      }
      if (_user.phoneNumber.isNotEmpty) {
        _phoneCon.text = _user.phoneNumber;
        DeliveryData().phoneNumber = _user.phoneNumber;
      }
      if (_user.address.isNotEmpty) {
        _addrCon.text = _user.address;
        DeliveryData().address = _user.address;
      }
    });
  }


  //------------------PRIVATE METHODS---------------------//
  _updateProfile() async {
    _user.name = _nameCon.text;
    _user.phoneNumber = _phoneCon.text;
    _user.address = _addrCon.text;

    await g_customerService.update(_user).then((value) {
      Fluttertoast.showToast(msg: "Update information successfully!");
    }).catchError((err) {
      Fluttertoast.showToast(msg: "Update information fail ${err.toString()}");
    });
  }

  _confirmDelivery() async {
    DeliveryData().address = _addrCon.text;
    DeliveryData().phoneNumber = _phoneCon.text;
    DeliveryData().name = _nameCon.text;

    //if user also update profile
    if (_isUpdateProfile) {
      await _updateProfile();
    }

    context.router.pop();
  }

  _onNameChange(String name) {
    DeliveryData().name = name;
  }

  _onPhoneNumberChange(String number) {
    DeliveryData().phoneNumber = number;
  }

  _onAddressChange(String addr) {
    DeliveryData().address = addr;
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
          ],),
        ),
      ),
    );
  }

  HeaderWidget _header() {
    return HeaderWidget(
        title: TextWidget(
          text: "Delivery.",
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
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            LabelWidget1(text: 'Your Name'),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtName(),
            PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            LabelWidget1(text: 'Phone number'),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtPhoneNumber(),
            PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            LabelWidget1(text: 'Home Address'),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _edtAddress(),
            PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            _cbUpdateProfile()
          ],
        ),
      ),
    );
  }

  RoundedEditWidget _edtName() {
    return RoundedEditWidget(
      controller: _nameCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      prefixIcon: Icons.person,
      roundness: 15,
      inputType: TextInputType.emailAddress,
      onValueChange: _onNameChange,
    );
  }

  RoundedEditWidget _edtPhoneNumber() {
    return RoundedEditWidget(
      controller: _phoneCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      prefixIcon: Icons.phone,
      roundness: 15,
      inputType: TextInputType.phone,
      onValueChange: _onPhoneNumberChange,
    );
  }

  RoundedEditWidget _edtAddress() {
    return RoundedEditWidget(
      controller: _addrCon,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      prefixIcon: Icons.home,
      roundness: 15,
      inputType: TextInputType.multiline,
      minLines: 5,
      maxLines: 8,
      onValueChange: _onAddressChange,
    );
  }

  Widget _btnConfirm(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: RoundedButtonWidget(
          onTap: _confirmDelivery,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'CONFIRM YOUR DELIVERY',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  Widget _cbUpdateProfile() {
    return Row(children: [
      Checkbox(
        value: _isUpdateProfile,
        onChanged: (value) {
          setState(() {
          _isUpdateProfile = value!;
          });
        },
        activeColor: DARK_BLUE,
      ),
      Expanded(child: LabelWidget1(text: 'Set as default ?',))
    ],);
  }
}
