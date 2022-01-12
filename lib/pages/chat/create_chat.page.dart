import 'dart:developer';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/models/chat.model.dart';
import 'package:do_an_ui/models/message.model.dart';
import 'package:do_an_ui/services/message.service.dart';
import 'package:do_an_ui/services/chat.service.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import '../../shared/label.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateChatPage extends StatefulWidget {
  final String userId;

  CreateChatPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  TextEditingController _titleCon = new TextEditingController();
  TextEditingController _contentCon = new TextEditingController();
  final dkey = '[DEBUG CreateMessagePage]';

  //------------------PRIVATE METHODS---------------------//
  void _createMessage() {
    String title = _titleCon.text;
    String content = _contentCon.text;

    Chat chat = new Chat();

    chat.creatorId = widget.userId;
    chat.title = title;
    chat.creatorName = 'USER';

    g_chatMessage.create(chat);

    Message message = new Message();
    message.messageId = chat.id;
    message.creatorId = widget.userId;
    message.content = content;
    message.creatorName = 'USER';

    messageSegmentService.create(message).then((value) {
      log(dkey + ' Create message success');
      context.router.pop();
    });
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SettingDrawerWidget(),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(
            children: [
              _header(),
              _textSection(),
              _btnCreate(size)
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavWidget(index: 2,),
      endDrawer: SettingDrawerWidget(),
    );
  }

  PercentageSizeWidget _textSection() {
    return PercentageSizeWidget(
      percentageWidth: BIG_PERCENTAGE_OFFSET,
      percentageHeight: 0.8,
      child: Column(children: [
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        LabelWidget1(text: 'What is your problem'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtTitle(),
        PercentageSizeWidget(percentageHeight: MEDIUM_PERCENTAGE_GAP,),
        LabelWidget1(text: 'Can you describe it'),
        PercentageSizeWidget(percentageHeight: SMALL_PERCENTAGE_GAP,),
        _edtContent(),
      ],),
    );
  }

  RoundedEditWidget _edtTitle() {
    return RoundedEditWidget(
      controller: _titleCon,
      cursorColor: MEDIUM_GRAY,
      borderColor: MEDIUM_GRAY,
      inputType: TextInputType.text,
      roundness: 15,
    );
  }

  RoundedEditWidget _edtContent() {
    return RoundedEditWidget(
      controller: _contentCon,
      cursorColor: MEDIUM_GRAY,
      borderColor: MEDIUM_GRAY,
      inputType: TextInputType.multiline,
      roundness: 15,
      minLines: 4,
      maxLines: 4,
    );
  }

  PercentageSizeWidget _header() {
    return PercentageSizeWidget(percentageHeight: 0.1,
      child: Stack(children: [
        Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 16.0),
          child: IconButton(icon: Icon(IconGoBack), onPressed: _goBack,),
        ),
        Container(alignment: Alignment.center,
            child: TextWidget(
              text: 'Your problem.',
              size: 24.0,
              bold: true,
              color: BLACK,
            )
        ),
      ],),);
  }

  void _goBack() {
    context.router.pop();
  }

  Widget _btnCreate(Size size) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedButtonWidget(
          onTap: _createMessage,
          roundness: 90,
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          child: TextWidget(
            text: 'CREATE',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }
}
