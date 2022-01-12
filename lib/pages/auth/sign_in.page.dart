import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/common.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../shared/label.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInPage extends StatefulWidget {

  SignInPage({
    Key? key,
  }): super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<User?> _authListener;
  final _emailCon = new TextEditingController();
  final _passCon = new TextEditingController();

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    _authListener = _auth.authStateChanges().listen((user) async {
      if (user != null) {
        _tryGoToApp(user);
      }
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _signIn() async {
    EasyLoading.show(status: 'Sign in');

    await _auth.signInWithEmailAndPassword(
      email: _emailCon.value.text,
      password: _passCon.value.text,
    ).then((value) {
    }).catchError((err) {
      var ex = err as FirebaseAuthException;
      Fluttertoast.showToast(msg: "Error sign in ${ex.message}");
    });

    await EasyLoading.dismiss();
    await EasyLoading.showSuccess('Sign in success', duration: Duration(milliseconds: 500));
    EasyLoading.dismiss();
  }

  void _goToSignUp() async {
    await _authListener.cancel();
    context.router.push(SignUpPageRoute());
  }

  void _goBackToAuth() {
    context.router.pop();
  }

  void _tryGoToApp(User user) async {
    await user.reload();
    g_userData = UserData(uid: user.uid);
    if (user.emailVerified) {
      // await Fluttertoast.showToast(msg: 'Sign in success');
      g_userData = UserData(uid: user.uid);
      _goToApp();
    } else {
      // await Fluttertoast.showToast(msg: 'Your email has not yet verified!');
      await EasyLoading.showInfo('Your email has not yet verified!', duration: Duration(seconds: 1));
      _reSendVerifyEmail(user);
    }
  }

  void _goToApp() {
    context.router.push(NewsListPageRoute());
  }

  void _reSendVerifyEmail(User user) {
    user.sendEmailVerification().catchError((err) {
      Fluttertoast.showToast(msg: 'Send verify email fail ${err.toString()}');
    }).then((value) {
      Fluttertoast.showToast(msg: 'We have sent you a verify email, please check it');
      context.router.pop();
    });
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    final newSize = MediaQuery
        .of(context)
        .size;
    if (g_screenSize.width != newSize.width) {
      g_screenSize = newSize;

      log('[SIGN IN] set g_screenSize ${g_screenSize.toString()}');
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Column(children: [
              _upperSection(),
              _lowerSection()
            ],),
          ),
        ),
    );
  }

  FractionallySizedBox _lowerSection() {
    return FractionallySizedBox(
      widthFactor: BIG_PERCENTAGE_OFFSET,
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
        _btnSignIn(),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP/2,),
        _lbbtnGoToSignUp()
      ],),
    );
  }

  RichText _lbbtnGoToSignUp() {
    return RichText(
      text: TextSpan(
        text: 'Not registered yet? ',
        style: TextStyle(fontSize: 12, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: 'Create an Account',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _goToSignUp();
                },
              style: TextStyle(
                color: Colors.blue,
              )),
        ],
      ),
    );
  }

  PercentageSizeWidget _btnSignIn() {
    return PercentageSizeWidget(
      percentageWidth: BIG_PERCENTAGE_OFFSET,
      percentageHeight: MEDIUM_PERCENTAGE_HEIGHT,
      child: RoundedButtonWidget(
        onTap: _signIn,
        borderColor: DARK_BLUE,
        backgroundColor: DARK_BLUE,
        child: TextWidget(
          text: "LOG IN",
          size: 12,
          bold: true,
          color: WHITE,
        ),
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
            prefixIcon: Icons.email,
            roundness: 15,
          );
  }
  PercentageSizeWidget _upperSection() {
    return PercentageSizeWidget(
          percentageHeight: 0.5,
          child: Container(color: DARK_BLUE,
            child: FractionallySizedBox(
              widthFactor: BIG_PERCENTAGE_OFFSET,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PercentageSizeWidget(percentageHeight: 0.06,),
                  _btnGoBack(),
                  PercentageSizeWidget(percentageHeight: 0.04,),
                  TextWidget(
                    text: "Welcome back!",
                    size: 16,
                    bold: true,
                    color: Colors.white,
                  ),
                  PercentageSizeWidget(percentageHeight: 0.05,),
                  TextWidget(
                    text: "Yay! You're back! Thanks for shopping with us.",
                    size: 12,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: "We have excited deals and promotions going on",
                    size: 12,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: "grab your pick now!",
                    size: 12,
                    color: Colors.white,
                  ),
                  PercentageSizeWidget(percentageHeight: 0.1,),
                  TextWidget(
                    text: "LOGIN",
                    size: 16,
                    bold: true,
                    color: Colors.white,
                  ),
              ],),
            ),
          ),
        );
  }

  InkWell _btnGoBack() {
    return InkWell(
                  onTap: _goBackToAuth,
                  child: Icon(IconGoBack, color: Colors.white,),
                );
  }
}
