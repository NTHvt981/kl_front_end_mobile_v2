import 'package:bubble/bubble.dart';
import 'package:do_an_ui/models/message.model.dart';
import 'package:flutter/material.dart';

class MessageListWidget extends StatelessWidget {
  final List<Message> data;

  MessageListWidget({
	Key? key,
    required this.data,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, pos) {
      return Bubble(
        style: data[pos].createdByAdmin? _otherBStyle(): myBStyle(),
        child: Text(data[pos].content),
      );
    },
      itemCount: data.length,
    );
  }

  BubbleStyle myBStyle() {
    return BubbleStyle(
      nip: BubbleNip.rightTop,
      nipWidth: 12,
      nipHeight: 12,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
  }

  BubbleStyle _otherBStyle() {
    return BubbleStyle(
      nip: BubbleNip.leftTop,
      nipWidth: 12,
      nipHeight: 12,
      color: Colors.white,
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
  }
}
