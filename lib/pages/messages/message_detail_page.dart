import 'package:do_an_ui/models/message.dart';
import 'package:do_an_ui/models/message_segment.dart';
import 'package:do_an_ui/pages/messages/message_segment_list_view.dart';
import 'package:do_an_ui/services/message_segment_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDetailPage extends StatefulWidget {
  final String userId;
  final Message message;

  MessageDetailPage({
    required this.userId,
    required this.message
}): super();

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState(message: message);
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final Message message;
  List<MessageSegment> segments = [];
  TextEditingController replyCon = new TextEditingController();

  _MessageDetailPageState({
    required this.message,
  });

  void submitText() {
    var text = replyCon.value.text;

    MessageSegment reply = new MessageSegment();

    reply.messageId = message.id;
    reply.content = text;
    reply.creatorId = widget.userId;

    messageSegmentService.create(reply).then((value) => {

    });
  }

  @override
  void initState() {
    super.initState();

    messageSegmentService.readAllLive(message.id).listen((value) {
      setState(() {
        segments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.title),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
                child: MessageSegmentListView(data: segments,)),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyCon,
                    cursorColor: Colors.greenAccent,
                    decoration: InputDecoration(
                        hintText: "Reply here",
                        border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(16.0)
                        )
                    ),
                  ),flex: 1,
                ),
                IconButton(icon: Icon(CupertinoIcons.add_circled), onPressed: submitText)
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}
