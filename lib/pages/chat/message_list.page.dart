import 'package:do_an_ui/models/chat.model.dart';
import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/models/message.model.dart';
import 'package:do_an_ui/pages/chat//message_list.widget.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/services/languages/language_detection.service.dart';
import 'package:do_an_ui/services/languages/translation.service.dart';
import 'package:do_an_ui/services/message.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:auto_route/auto_route.dart' as route;

class MessageListPage extends StatefulWidget {
  final String userId;
  final Chat chat;

  MessageListPage({
    required this.userId,
    required this.chat
}): super();

  @override
  _MessageListPageState createState() => _MessageListPageState(chat: chat, userId: userId);
}

class _MessageListPageState extends State<MessageListPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  final Chat chat;
  final String userId;
  Customer? _user;
  List<Message> _messages = [];
  TextEditingController _replyCon = new TextEditingController();
  final _translateService = TranslationService();
  final _langDetectService = LanguageDetectionService();
  final _messageService = MessageService();
  final _userService = CustomerService();

  _MessageListPageState({
    required this.chat,
    required this.userId,
  });

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    _messageService.readAllLive(chat.id).listen((value) {
      _messages.clear();
      _messages.addAll(value);
      setState(() {
      });
    });

    _userService.readOnce(userId).then((user) {
      if (user == null) {
        throw('[THROW MESSAGE LIST] USER MUST NOT NULL');
      }

      _user = user;
      setState(() {
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _submitChat() {
    var text = _replyCon.value.text;
    if (text.trim().isEmpty) {
      return;
    }

    Message reply = new Message();

    reply.messageId = chat.id;
    reply.content = text;
    reply.creatorId = userId;

    _messageService.create(reply).then((value) {
      _replyCon.text = '';
    });
  }

  final translateLanguageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  void _translate() {
    var text = _replyCon.text;

    _langDetectService.Detect(text).then((String langCode) async {
      Fluttertoast.showToast(msg: "Language code is $langCode");
      _translateService.Translate(text, langCode).then((translateText) {
        Fluttertoast.showToast(msg: "Translate text is $translateText");
        setState(() {
          _replyCon.text = translateText;
        });
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Translate error: $error");
      });
    });
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Column(
        children: [
          _header(),
          Expanded(
            flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: MessageListWidget(data: _messages,),
              )),
          _inputSection(),
        ],
      ),
    );
  }

  Widget _inputSection() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _avatar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 6.0, top: 6.0),
                child: RoundedEditWidget(
                  controller: _replyCon,
                  roundness: 90,
                ),
              ),
              flex: 1,
            ),
            IconButton(icon: Icon(Icons.chat), onPressed: _submitChat),
            IconButton(icon: Icon(Icons.translate), onPressed: _translate,)
          ],
        ),
      ),
    );
  }

  CircleAvatar _avatar() {
    final dResult = CircleAvatar(backgroundImage: AssetImage('images/pic_user.png'));

    if (_user == null)
      return dResult;

    if (_user!.imageUrl.isEmpty)
      return dResult;

    return CircleAvatar(backgroundImage: NetworkImage(_user!.imageUrl));
  }

  Widget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: chat.title,
        size: 16.0,
        color: BLACK,
      ),
      canGoBack: true,
      router: context.router,
    );
  }
}
