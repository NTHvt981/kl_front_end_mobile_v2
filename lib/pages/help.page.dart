import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelpPage extends StatefulWidget {
  final String userId;

  HelpPage({
    required this.userId
});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _auth = FirebaseAuth.instance;
  bool _showPhoneNumber = false;
  bool _showEmail = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WHITE,
      body: Column(children: [
        _header(),
        _body()
      ],),
    );
  }

  PercentageSizeWidget _body() {
    return PercentageSizeWidget(
      percentageHeight: 0.9,
      child: ListView(children: [
        _contactSection(),
        Divider(),
        _settingSection()
      ],),
      );
  }

  Container _contactSection() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _textWidget('Contact us'),
            _tileWidget(Icons.phone, 'Phone', () {
              if (_showPhoneNumber) _showPhoneNumber = false;
              else _showPhoneNumber = true;
              setState(() {});
            }),
            _showPhoneNumber == false? Container(): _textWidget('Call us at 0342039364.'),
            _tileWidget(Icons.email, 'Email', () {
              if (_showEmail) _showEmail = false;
              else _showEmail = true;
              setState(() {});
            }),
            _showEmail == false? Container(): _textWidget('Our email is NTHvt981@gmail.com'),
            _tileWidget(Icons.info_outlined, 'Send Feedback', _sendFeedback),
          ],
        ),
      );
  }

  Container _settingSection() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _textWidget('Popular'),
          _tileWidget(Icons.account_box, 'Forgot password? Reset it', _resetPass),
          _tileWidget(Icons.account_box, 'Change your password', _updatePass),
          _tileWidget(Icons.account_box, 'Edit your profile', _editProfile),
        ],
      ),
    );
  }

  Widget _tileWidget(IconData icon, String title, Function() onPress) {
    return InkWell(
      onTap: onPress,
      child: Row(children: [
                _iconWidget(icon),
                _textWidget(title)
              ],),
    );
  }
  
  Widget _textWidget(String text) {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.topLeft,
      child: TextWidget(
        text: text,
        size: 16.0,
      ),
    );
  }

  Widget _iconWidget(IconData iconData) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(16.0),
      child: Icon(iconData, color: DARK_BLUE,),
    );
  }

  HeaderWidget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: "Help.",
        size: 20.0,
        bold: true,
        color: WHITE,
      ),
      canGoBack: true,
      router: context.router,
      textColor: WHITE,
      backgroundColor: DARK_BLUE,
    );
  }

  _sendFeedback() {
    context.router.popAndPush(CreateChatPageRoute(userId: widget.userId));
  }

  _editProfile() {
    context.router.push(ProfilePageRoute());
  }

  _updatePass() {
    context.router.push(UpdatePassPageRoute());
  }

  _resetPass() {
    late User user;

    if (_auth.currentUser == null) {
      context.router.pop();
      return;
    }
    else {
      user = _auth.currentUser!;
    }

    _auth.sendPasswordResetEmail(email: user.email!).then((value) {
      Fluttertoast.showToast(msg: 'We have sent you a reset password email, check it out');
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'Reset password fail, error: ${err.toString()}');
    });
  }
}
