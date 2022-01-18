
import 'dart:io';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/image.service.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import '../../shared/widgets/image_background.widget.dart';
import 'package:flutter/services.dart';
import '../../shared/widgets/label.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart' as route;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final _nameCon = new TextEditingController();
  final _phoneCon = new TextEditingController();
  final _dobCon = new TextEditingController();
  final _addrCon = new TextEditingController();
  final _emailCon = new TextEditingController();

  final _pointCon = new TextEditingController();
  final _ticketCon = new TextEditingController();
  final _picker = ImagePicker();

  late Customer _user;
  String? _userAvatarUrl;
  int _maxConvertPoint = 1000;
  int _convertPoint = 0;

  Future changeAvatar() async {
    String random = (new DateTime.now()).toIso8601String();

    File pickedFile = await _picker.pickImage(source: ImageSource.camera) as File;
    g_imageService.uploadFile(pickedFile, "Customer/${_user.id}/$random").then((url) {
      setState(() {
        _userAvatarUrl = url;
        _user.imageUrl = url;
      });
    });
  }

  void onAvatarTap() {
    Fluttertoast.showToast(msg: "Double tap avatar to change it");
  }

  void convert() {
    _user.point -= _convertPoint;
    _user.ticket += (_convertPoint / 100).floor();

    setState(() {
      _ticketCon.text = _user.ticket.toString();
      _pointCon.text = _user.point.toString();
    });
  }

  void _updateProfile() {
    _user.name = _nameCon.text;
    _user.phoneNumber = _phoneCon.text;
    _user.address = _addrCon.text;

    g_customerService.update(_user).then((value) => {
      Fluttertoast.showToast(msg: "Update information successfully!")
    });
  }

  @override
  void initState() {
    super.initState();

    _user = g_userData.itemBehavior.value;
    _nameCon.text = _user.name;
    _phoneCon.text = _user.phoneNumber;
    _addrCon.text = _user.address;
    _emailCon.text = _user.email;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: WHITE,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(children: [
            // _imgSection(context),
            _header(context),
            _textSection(context),
            _btnUpdateProfile(context),
            ],),
        ),
      )
    );
  }

  PercentageSizeWidget _imgSection(BuildContext context) {
    return PercentageSizeWidget(percentageHeight: 0.4,
        child: Stack(
          children: [
            ImageBackgroundWidget(
              path: "images/placeholders/profile-avatar.png",
              fitMode: BoxFit.fitWidth,
            ),
            _header(context),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 32, bottom: 32),
              child: TextWidget(text: 'PROFILE', size: 16, color: WHITE, bold: true,),
            )
          ],
        ),
      );
  }

  HeaderWidget _header(BuildContext context) {
    return HeaderWidget(
            backgroundColor: DARK_BLUE,
            canGoBack: true,
            router: context.router,
            textColor: WHITE,
            title: TextWidget(
              text: 'Profile',
              size: 18.0,
              color: WHITE,
            ),
          );
  }

  Widget _btnUpdateProfile(BuildContext context) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RoundedButtonWidget(
          onTap: _updateProfile,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          child: TextWidget(
            text: 'UPDATE PROFILE',
            size: FONT_SIZE_2,
            color: WHITE,
          ),
        ),
      )
    );
  }

  Widget _textSection(BuildContext context) {
    return PercentageSizeWidget(
      percentageHeight: 0.8,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
            children: [
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Your Name'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtName(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Email Address'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtEmail(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Date of birth'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtDob(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Phone number'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtPhoneNumber(),
              PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
              LabelWidget1(text: 'Home Address'),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
              _edtAddress(),
              PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
            ],
          ),
    ),);
  }

  RoundedEditWidget _edtName() {
    return _edt(
      controller: _nameCon,
      inputType: TextInputType.emailAddress,
      prefixIcon: Icons.person,
    );
  }

  RoundedEditWidget _edtEmail() {
    return _edt(
      controller: _emailCon,
      inputType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      readOnly: true
    );
  }

  RoundedEditWidget _edtDob() {
    return _edt(
      controller: _dobCon,
      inputType: TextInputType.datetime,
      prefixIcon: Icons.calendar_today,
    );
  }

  RoundedEditWidget _edtPhoneNumber() {
    return _edt(
      controller: _phoneCon,
      inputType: TextInputType.phone,
      prefixIcon: Icons.phone,
    );
  }

  RoundedEditWidget _edtAddress() {
    return _edt(
      controller: _addrCon,
      inputType: TextInputType.text,
      prefixIcon: Icons.home,
    );
  }

  RoundedEditWidget _edt( {
      required TextEditingController controller,
      required TextInputType inputType,
      required IconData prefixIcon,
      bool readOnly = false
      }) {
    return RoundedEditWidget(
      controller: controller,
      cursorColor: DARK_BLUE,
      borderColor: MEDIUM_GRAY,
      borderSelectedColor: DARK_BLUE,
      prefixIcon: prefixIcon,
      roundness: 15,
      inputType: inputType,
      readOnly: readOnly,
    );
  }
}
