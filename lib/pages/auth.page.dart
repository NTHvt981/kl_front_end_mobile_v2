import 'dart:developer';

import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/common.dart';
import '../shared/widgets/image_background.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //------------------PRIVATE METHODS---------------------//
  void _goToSignIn() {
    context.router.push(SignInPageRoute());
  }

  void _goToLoadFace() {
    context.router.push(LoadFacePageRoute(cameraDescription: g_frontCameraDescription));
  }

  void _goToSignUp() {
    context.router.push(SignUpPageRoute());
  }

  void _exit() {
    SystemNavigator.pop();
  }

  //------------------OVERRIDE  METHODS----------------------//
  @override
  Widget build(BuildContext context) {
    final newSize = MediaQuery
        .of(context)
        .size;
    if (g_screenSize.width != newSize.width) {
      g_screenSize = newSize;

      log('[AUTH] set g_screenSize ${g_screenSize.toString()}');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        _bg1(),
        _bg2(),
        Container(
          child: Center(
            child: Column(children: [
              PercentageSizeWidget(percentageHeight: 0.1),
              _title(),
              PercentageSizeWidget(percentageHeight: 0.12),
              TextWidget(
                text: "Create your fashion",
                size: 16,
                bold: true,
              ),
              TextWidget(
                text: "in your own way",
                size: 16,
                bold: true,
              ),
              PercentageSizeWidget(percentageHeight: 0.04),
              TextWidget(
                text: "Each men and women has their own style,",
                size: 12,
                bold: true,
              ),
              TextWidget(
                text: "Weclothes help you to create your unique style.",
                size: 12,
                bold: true,
              ),
              PercentageSizeWidget(percentageHeight: 0.05),
              _btnLogin(),
              PercentageSizeWidget(percentageHeight: 0.015),
              GestureDetector( //for loading test
                onTap: () {
                  context.router.push(LoadingTestPageRoute());
                },
                child: TextWidget(
                  text: "OR",
                  size: 16,
                  bold: true,
                ),
              ),
              PercentageSizeWidget(percentageHeight: 0.015),
              _btnFaceRecognition(),
              PercentageSizeWidget(percentageHeight: 0.05),
              _btnRegister(),
              PercentageSizeWidget(percentageHeight: 0.025),
              GestureDetector(
                onTap: _exit,
                child: TextWidget(
                  text: "EXIT",
                  size: 12,
                  bold: true,
                  color: DARK_BLUE,
                ),
              ),
            ],),
          ),
        )
      ]),
    );
  }

  //------------------UI WIDGETS--------------------------//
  PercentageSizeWidget _btnRegister() {
    return PercentageSizeWidget(
              percentageWidth: 0.6,
              percentageHeight: 0.075,
              child: RoundedButtonWidget(
                onTap: _goToSignUp,
                borderColor: DARK_BLUE,
                backgroundColor: DARK_BLUE,
                child: TextWidget(
                  text: "REGISTER",
                  size: 12,
                  color: Colors.white,
                  bold: true,
                ),
              ),
            );
  }

  PercentageSizeWidget _btnFaceRecognition() {
    return PercentageSizeWidget(
              percentageWidth: 0.6,
              percentageHeight: 0.075,
              child: RoundedButtonWidget(
                onTap: _goToLoadFace,
                borderColor: Colors.black,
                backgroundColor: Colors.white.withOpacity(0),
                child: TextWidget(
                  text: "FACE RECOGNITION",
                  size: 12,
                  bold: true,
                ),
              ),
            );
  }

  PercentageSizeWidget _btnLogin() {
    return PercentageSizeWidget(
              percentageWidth: 0.6,
              percentageHeight: 0.075,
              child: RoundedButtonWidget(
                onTap: _goToSignIn,
                borderColor: Colors.black,
                backgroundColor: Colors.white.withOpacity(0),
                child: TextWidget(
                  text: "LOGIN",
                  size: 12,
                  bold: true,
                ),
              ),
            );
  }

  TextWidget _title() {
    return TextWidget(
              text: "WeClothes.",
              size: 32,
              bold: true,
            );
  }

  ImageBackgroundWidget _bg2() {
    return ImageBackgroundWidget(
        path: "images/sign-in/bg2.png",
        fitMode: BoxFit.fill,
      );
  }

  ImageBackgroundOpacityWidget _bg1() {
    return ImageBackgroundOpacityWidget(
        path: "images/sign-in/bg1.png",
        opacity: 0.1,
        fitMode: BoxFit.fitWidth,
      );
  }
}
