
import 'package:auto_route/auto_route.dart' as route;
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import '../../shared/widgets/label.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final _firebaseAuth = FirebaseAuth.instance;
  final _emailCon = new TextEditingController();
  final _passCon = new TextEditingController();
  final _confirmPassCon = new TextEditingController();
  final _customerService = CustomerService();

  //------------------PRIVATE METHODS---------------------//
  void _signUp(_context) {
    var email = _emailCon.value.text;
    var password = _passCon.value.text;
    var confirmPass = _confirmPassCon.value.text;

    if (confirmPass != password) {
      Fluttertoast.showToast(msg: "Password is not the same as confirm password");
      return;
    }

    _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((cred) async {
      //Create customer in database
      var customer = Customer(id: cred.user!.uid, email: email);
      await _customerService.create(customer);

      _sendVerifyEmail(cred.user!);

      _showFROfferDialog(_context, email, password);
    }).catchError((err) {
      var ex = err as FirebaseAuthException;
      Fluttertoast.showToast(msg: "Error create account ${ex.message}");
    });
  }

  Future<void> _showFROfferDialog(_context, String email, String password) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Face recognition'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to use this function?.'),
                Text('It allow you to login without the need for password.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                context.router.pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _goToSaveFacePage(email, password);
              },
            ),
          ],
        );
      },
    );
  }

  void _goToSaveFacePage(String email, String password) {
    context.router.push(SaveFacePageRoute(
        cameraDescription: g_frontCameraDescription,
        email: email, password: password)
    );
  }

  void _goToBack() {
    context.router.pop();
  }

  void _sendVerifyEmail(User user) {
    user.sendEmailVerification().catchError((err) {
      Fluttertoast.showToast(msg: 'Send verify email fail ${err.toString()}');
    }).then((value) {
      Fluttertoast.showToast(msg: 'We have sent you a verify email, please check it');
    });
  }

  //------------------OVERRIDE METHODS----------------------//
  @override
  void initState() {
    super.initState();
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(children: [
            _upperSection(),
            _lowerSection(context)
          ],),
        ),
      ),
    );
  }

  FractionallySizedBox _lowerSection(_context) {
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
        LabelWidget1(text: 'Confirm Password'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtConfirmPassword(),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        _btnSignUp(_context),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP/2,),
        Text("By joining I agree to receive emails from Weclothes.")
      ],),
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

  RoundedEditWidget _edtConfirmPassword() {
    return RoundedEditWidget(
      controller: _confirmPassCon,
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

  PercentageSizeWidget _btnSignUp(_context) {
    return PercentageSizeWidget(
      percentageWidth: BIG_PERCENTAGE_OFFSET,
      percentageHeight: MEDIUM_PERCENTAGE_HEIGHT,
      child: RoundedButtonWidget(
        onTap: () {_signUp(_context);},
        borderColor: DARK_BLUE,
        backgroundColor: DARK_BLUE,
        roundness: 90,
        child: TextWidget(
          text: "REGISTER",
          size: FONT_SIZE_1,
          bold: true,
          color: WHITE,
        ),
      ),
    );
  }

  PercentageSizeWidget _upperSection() {
    return PercentageSizeWidget(
      percentageHeight: 0.35,
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
                text: "Get’s started with Weclothes.",
                size: FONT_SIZE_2,
                bold: true,
                color: Colors.white,
              ),
              PercentageSizeWidget(percentageHeight: 0.02,),
              TextWidget(
                text: "Already have an account? Log in.",
                size: FONT_SIZE_1,
                color: Colors.white,
              ),
              PercentageSizeWidget(percentageHeight: 0.05,),
              TextWidget(
                text: "REGISTER",
                size: FONT_SIZE_2,
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
              onTap: _goToBack,
              child: Icon(IconGoBack, color: Colors.white,),
            );
  }
}
