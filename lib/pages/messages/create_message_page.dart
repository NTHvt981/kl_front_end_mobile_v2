import 'package:do_an_ui/models/message.dart';
import 'package:do_an_ui/models/message_segment.dart';
import 'package:do_an_ui/services/message_segment_service.dart';
import 'package:do_an_ui/services/message_service.dart';
import 'package:flutter/material.dart';

class CreateMessagePage extends StatefulWidget {
  final String userId;

  CreateMessagePage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _CreateMessagePageState createState() => _CreateMessagePageState();
}

class _CreateMessagePageState extends State<CreateMessagePage> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What is your problem'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'problem summary'
            ),
          ),
          Divider(),
          TextField(
            controller: contentController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 7,
            decoration: InputDecoration(
                labelText: 'please describe your problem in detail'
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: createMessage,
              child: Text('Send to Admin'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).buttonColor,
            )
          )
        ],),
      ),
    );
  }

  void createMessage() {
    String title = titleController.text;
    String content = contentController.text;

    Message message = new Message();

    message.creatorId = widget.userId;
    message.title = title;
    message.creatorName = 'USER';

    messageService.create(message);

    MessageSegment firstSegment = new MessageSegment();
    firstSegment.messageId = message.id;
    firstSegment.creatorId = widget.userId;
    firstSegment.content = content;
    firstSegment.creatorName = 'USER';

    messageSegmentService.create(firstSegment);
  }
}
