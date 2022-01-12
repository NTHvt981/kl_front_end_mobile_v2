import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import '../../shared/label.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdatePassPage extends StatefulWidget {
  @override
  _UpdatePassPageState createState() => _UpdatePassPageState();
}

class _UpdatePassPageState extends State<UpdatePassPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final _auth = FirebaseAuth.instance;
  final _oldPassCon = TextEditingController();
  final _newPassCon = TextEditingController();
  final _confirmNewPassCon = TextEditingController();

  _updatePassword() {
    late User user;

    if (_auth.currentUser == null) {
      context.router.pop();
      return;
    }
    else {
      user = _auth.currentUser!;
    }

    String oldPass = _oldPassCon.text;
    String pass = _newPassCon.text.trim();
    String conPass = _confirmNewPassCon.text.trim();

    if (pass.isEmpty) {
      Fluttertoast.showToast(msg: 'New password is empty');
      return;
    }

    if (pass.compareTo(conPass) == true) {
      Fluttertoast.showToast(msg: 'Confirm password is not the same as new password');
      return;
    }

    var credential = EmailAuthProvider.credential(email: user.email!, password: oldPass);
    user.reauthenticateWithCredential(credential).then((value) {
      user.updatePassword(pass).then((value) async {
        Fluttertoast.showToast(msg: 'Update password success');
        await Future.delayed(Duration(milliseconds: 1000));
        context.router.pop();
      }).catchError((err) {
        Fluttertoast.showToast(msg: 'Update password fail, error: ${err.toString()}');
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'Old password is wrong');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(
            children: [
              _header(),
              _dataSection(),
              _btnCreate(size)
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavWidget(index: 2,),
    );
  }

  PercentageSizeWidget _dataSection() {
    return PercentageSizeWidget(
      percentageWidth: BIG_PERCENTAGE_OFFSET,
      percentageHeight: 0.8,
      child: Column(children: [
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        LabelWidget1(text: 'Old password'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtOldPass(),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        LabelWidget1(text: 'New password'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtNewPass(),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        LabelWidget1(text: 'Confirm new password'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtConfirmNewPass(),
      ],),
    );
  }

  RoundedEditWidget _edtOldPass() {
    return RoundedEditWidget(
      controller: _oldPassCon,
      cursorColor: MEDIUM_GRAY,
      borderColor: MEDIUM_GRAY,
      inputType: TextInputType.text,
      roundness: 15,
    );
  }

  RoundedEditWidget _edtNewPass() {
    return RoundedEditWidget(
      controller: _newPassCon,
      cursorColor: MEDIUM_GRAY,
      borderColor: MEDIUM_GRAY,
      inputType: TextInputType.text,
      roundness: 15,
    );
  }

  RoundedEditWidget _edtConfirmNewPass() {
    return RoundedEditWidget(
      controller: _confirmNewPassCon,
      cursorColor: MEDIUM_GRAY,
      borderColor: MEDIUM_GRAY,
      inputType: TextInputType.text,
      roundness: 15,
    );
  }

  Widget _header() {
    return HeaderWidget(
      canGoBack: true,
      router: context.router,
      title: TextWidget(
        text: 'Update password.',
        size: 16.0,
        bold: true,
        color: BLACK,
      ),
    );
  }

  Widget _btnCreate(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedButtonWidget(
          onTap: _updatePassword,
          roundness: 90,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          child: TextWidget(
            text: 'CONFIRM CHANGE',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }
}
