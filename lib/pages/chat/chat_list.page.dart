import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/chat.model.dart';
import 'package:do_an_ui/pages/chat/chat.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/chat.service.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ChatListPage extends StatefulWidget {
  final String userId;

  ChatListPage({
    required this.userId
}): super();

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Chat> _chats = [];
  final dkey = '[DEBUG CHAT LIST PAGE]';

  @override
  void initState() {
    super.initState();
    log(dkey + 'call initState');

    g_chatMessage.readAllLive(widget.userId).listen((data) {
      log(dkey + 'number of message: ${data.length}');
      log(dkey + 'Message id: ${data[0].id}');
      setState(() {
        _chats = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: SettingDrawerWidget(),
      body: Container(
        color: WHITE,
        child: Column(
          children: [
            _header(),
            _chatList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(index: 2,),
      endDrawer: SettingDrawerWidget(),
    );
  }

  PercentageSizeWidget _chatList() {
    return PercentageSizeWidget(
          percentageHeight: 0.8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(itemBuilder: (context, position) {
              return ChatWidget(chat: _chats[position], onTap: _onSelectChat,);
            },itemCount: _chats.length,
            )
          ),
        );
  }

  Widget _header() {
    return HeaderWidget(
      title: TextWidget(
                text: 'Your problem.',
                size: 24.0,
                bold: true,
                color: BLACK,
              ),
      suffix: IconButton(icon: Icon(IconCreate), onPressed: _goToCreateChat,),
    );
  }

  _onSelectChat(Chat chat) {
    context.router.push(MessageListPageRoute(userId: widget.userId, chat: chat));
  }

  _goToCreateChat() {
    context.router.push(CreateChatPageRoute(userId: widget.userId));
  }
}
