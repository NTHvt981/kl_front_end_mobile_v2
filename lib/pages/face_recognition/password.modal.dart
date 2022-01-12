import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/pages/make_order/delivery.info.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/orders/discount.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/label.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordModal extends StatefulWidget {
  final String email;
  final Function(String) onInputPassword;

  const PasswordModal({
    required this.email,
    required this.onInputPassword
  });

  @override
  State<PasswordModal> createState() => _PasswordModalState();
}

class _PasswordModalState extends State<PasswordModal> {
  final _emailCon = new TextEditingController();
  final _passCon = new TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _emailCon.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return PercentageSizeWidget(
      percentageHeight: 0.4,
      child: Container(
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: [
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Email'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtEmail(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Password'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtPassword(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
            ],),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: _btnEnterPassword(),)
        ],),
      ),
    );
  }

  RoundedEditWidget _edtPassword() {
    return RoundedEditWidget(
      controller: _passCon,
      cursorColor: DARK_BLUE,
      borderColor: DARK_BLUE,
      prefixIcon: Icons.lock,
      roundness: 15,
      hideText: true,
    );
  }

  RoundedEditWidget _edtEmail() {
    return RoundedEditWidget(
      controller: _emailCon,
      cursorColor: DARK_BLUE,
      borderColor: DARK_BLUE,
      prefixIcon: Icons.lock,
      roundness: 15,
      readOnly: true,
    );
  }

  Widget _btnEnterPassword() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedButtonWidget(
          onTap: _confirmPassword,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'ENTER PASSWORD',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  _confirmPassword() {
    String password = _passCon.text;
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: 'Password is null');
      return;
    }

    late User user;

    if (_auth.currentUser == null) {
      context.router.pop();
      return;
    }
    else {
      user = _auth.currentUser!;
    }

    var credential = EmailAuthProvider.credential(email: user.email!, password: password);
    user.reauthenticateWithCredential(credential).then((value) {
      widget.onInputPassword(password);
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'Password is wrong');
    });
  }
}
