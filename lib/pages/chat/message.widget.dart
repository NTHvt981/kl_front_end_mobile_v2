import 'package:bubble/bubble.dart';
import 'package:do_an_ui/models/message.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  late final Alignment _alignment;

  MessageWidget({required this.message}) {
    _alignment = message.createdByAdmin? Alignment.topLeft: Alignment.topRight;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        message.content.isNotEmpty? Bubble(
          style: message.createdByAdmin? _otherStyle(): _myStyle(),
          child: Text(message.content),
        ): Container(),
        Container(

          padding: EdgeInsets.all(8.0),
          child: _image(message.imageUrl, size), alignment: _alignment,
        ),
      ],
    );
  }

  Widget _image(String url, Size size) {
    if (url.isEmpty) {
      return Container();
    }
    // return Image.network(url, width: size.width * 2/3,);
    return InteractiveViewer(child: Image.network(url, width: size.width * 2/3,));
  }

  BubbleStyle _otherStyle() {
    return BubbleStyle(
      nip: BubbleNip.leftTop,
      nipWidth: 12,
      nipHeight: 12,
      color: Colors.white,
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: _alignment,
    );
  }

  BubbleStyle _myStyle() {
    return BubbleStyle(
      nip: BubbleNip.rightTop,
      nipWidth: 12,
      nipHeight: 12,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 3,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: _alignment,
    );
  }
}
