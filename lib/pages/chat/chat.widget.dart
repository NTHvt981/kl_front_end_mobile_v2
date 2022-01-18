import 'dart:developer';

import 'package:do_an_ui/models/chat.model.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final Chat chat;
  final Function(Chat) onTap;
  final double roundness = 20;

  ChatWidget({required this.chat, required this.onTap}) {
    log('[DEBUG CHATWIDGET CONSTRUCTOR] ${this.chat.title}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: GestureDetector(
        onTap: () {onTap(chat);},
        child: SizedBox(
          height: 128,
          child: Stack(children: [
            _back(),
            _front(),
          ],),
        ),
      ),
    );
  }

  Container _front() {
    return Container(margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(roundness)),
                color: DARK_BLUE
            ),
            child: Center(
              child: WhiteBoldTextWidget(text: chat.title, size: 16,),
            ),
          );
  }

  Container _back() {
    return Container(margin: EdgeInsets.only(left: 8.0, top: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(roundness)),
                color: BLACK
            ),
          );
  }
}
