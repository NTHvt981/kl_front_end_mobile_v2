import 'package:bubble/bubble.dart';
import 'package:do_an_ui/models/message_segment.dart';
import 'package:flutter/material.dart';

class MessageSegmentListView extends StatelessWidget {
  final List<MessageSegment> data;

  MessageSegmentListView({
	Key? key,
    required this.data,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return ListView.builder(itemBuilder: (context, pos) {
      return Bubble(
        style: data[pos].createdByAdmin? styleSomebody: styleMe,
        child: Text(data[pos].content),
      );
    },
      itemCount: data.length,
    );
  }
}
