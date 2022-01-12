import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SettingDrawerWidget extends StatefulWidget {
  @override
  _SettingDrawerWidgetState createState() => _SettingDrawerWidgetState();
}

class _SettingDrawerWidgetState extends State<SettingDrawerWidget> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final _customerService = new CustomerService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Customer _user;
  final dkey = '[DEBUG SETTING DRAWER]';

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    _user = g_userData.itemBehavior.value;

    g_userData.getStream().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _logOut() {
    _auth.signOut().then((value) {
      context.router.popUntilRouteWithName(AuthPageRoute.name);
    });
  }

  void _quit() {
    context.router.pop();
    context.router.pop();
  }

  void _goToProfile() {
    context.router.push(ProfilePageRoute());
  }

  void _goToCart() {
    context.router.push(CartPageRoute(userId: _user.id));
  }

  void _goToOrderHistory() {
    context.router.push(OrderListPageRoute(userId: _user.id));
  }

  void _goToSaveFace2() {
    context.router.push(
        SaveFace2PageRoute(cameraDescription: g_frontCameraDescription)
    );
  }

  void _goToPaymentMethod() {
    context.router.push(PaymentInfoPageRoute(userId: _user.id));
  }

  void _goToWardrobe() {
    context.router.push(CollectionListPageRoute(userId: _user.id));
  }

  void _goToHelp() {
    context.router.push(HelpPageRoute(userId: _user.id));
  }

  void _goToAbout() {
    context.router.push(AboutPageRoute());
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
      child: Drawer(
        child: Container(
          padding: EdgeInsets.zero,
          color: MEDIUM_BLUE,
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Center(
                    child: _whiteTxt('WELCOME BACK', FONT_SIZE_3),
                  ),
                  Container(alignment: Alignment.centerRight,
                    child: GestureDetector(child: Icon(IconCancel, color: WHITE,), onTap: _close,),
                  )
                ],
              )
            ),
            _userInfo(),
            _btnGoToCart(),
            _btnWardrobe(),
            _btnPaymentMethods(),
            _btnOrderHistory(),
            _btnFaceRegister(),
            Divider(),
            _btnHelp(),
            _btnSignOut(),
            _btnQuit(),
          ],)
        ),
      ),
    );
  }

  ListTile _btnGoToCart() {
    return ListTile(
              leading: Icon(Icons.shopping_bag_outlined, color: WHITE,),
              title: _whiteTxt('My Cart', FONT_SIZE_2),
              onTap: _goToCart
          );
  }

  ListTile _btnWardrobe() {
    return ListTile(
        leading: Icon(FontAwesome5.heart, color: WHITE,),
        title: _whiteTxt('Payment methods', FONT_SIZE_2),
        onTap: _goToPaymentMethod
    );
  }

  ListTile _btnPaymentMethods() {
    return ListTile(
        leading: Icon(Icons.credit_card, color: WHITE,),
        title: _whiteTxt('My Wardrobe', FONT_SIZE_2),
        onTap: _goToWardrobe
    );
  }

  ListTile _btnOrderHistory() {
    return ListTile(
        leading: Icon(Icons.doorbell, color: WHITE,),
        title: _whiteTxt('Orders history', FONT_SIZE_2),
        onTap: _goToOrderHistory
    );
  }

  ListTile _btnFaceRegister() {
    return ListTile(
        leading: Icon(Icons.face, color: WHITE,),
        title: _whiteTxt('Register face recognition', FONT_SIZE_2),
        onTap: _goToSaveFace2
    );
  }

  ListTile _btnHelp() {
    return ListTile(
        leading: Icon(FontAwesome5.question_circle, color: WHITE,),
        title: _whiteTxt('Help', FONT_SIZE_2),
        onTap: _goToHelp
    );
  }

  ListTile _btnSignOut() {
    return ListTile(
              leading: Icon(Icons.logout, color: WHITE,),
              title: _whiteTxt('Log Out', FONT_SIZE_2),
              onTap: _logOut
          );
  }

  ListTile _btnQuit() {
    return ListTile(
        leading: Icon(Icons.keyboard_return_outlined, color: WHITE,),
        title: _whiteTxt('Exit', FONT_SIZE_2),
        onTap: _quit
    );
  }

  GestureDetector _userInfo() {
    return GestureDetector(
      onTap: _goToProfile,
      child: ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              leading: SizedBox(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/clothes-icon.png'),
                ),
              ),
              title: _whiteTxt(
                  _user.name,
                  FONT_SIZE_2
              ),
              subtitle: _whiteTxt(
                  _user.phoneNumber,
                  FONT_SIZE_1
              ),
            ),
    );
  }

  Text _whiteTxt(String text, double size) {
    return Text(
      text,
      style: TextStyle(
        color: WHITE,
        fontSize: size,
      ),
    );
  }

  _close() {
    Navigator.of(context).pop();
  }
}
