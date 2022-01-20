import 'dart:developer' as dev;
import 'dart:io';

import 'package:do_an_ui/models/chat.model.dart';
import 'package:do_an_ui/models/message.model.dart';
import 'package:do_an_ui/pages/chat/langs.dialog.dart';
import 'package:do_an_ui/pages/chat/message.widget.dart';
import 'package:do_an_ui/services/image.service.dart';
import 'package:do_an_ui/services/languages/language_detection.service.dart';
import 'package:do_an_ui/services/languages/translation.service.dart';
import 'package:do_an_ui/services/message.service.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_edit.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:auto_route/auto_route.dart' as route;
import 'package:image_picker/image_picker.dart';

class MessageListPage extends StatefulWidget {
  final Chat chat;

  MessageListPage({
    required this.chat
}): super();

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  List<Message> _messages = [];
  TextEditingController _replyCon = new TextEditingController();
  final _translateService = TranslationService();
  final _langDetectService = LanguageDetectionService();
  final _messageService = MessageService();
  final _userData = g_userData;
  final _auth = FirebaseAuth.instance;
  final dkey = '[MessageListPage]';
  final _imgPicker = ImagePicker();
  final _imgService = g_imageService;
  bool _showImgPanel = false;
  File? _file;
  final List<Lang> _langs = List.of({
    Lang(id: TranslateLanguage.ENGLISH, name: 'English'),
    Lang(id: TranslateLanguage.VIETNAMESE, name: 'Vietnamese'),
    Lang(id: TranslateLanguage.GERMAN, name: 'German'),
    Lang(id: TranslateLanguage.FRENCH, name: 'French'),
    Lang(id: TranslateLanguage.SPANISH, name: 'Spanish'),
  });
  late Lang _targetLang;
  late BuildContext dialogContext;

  _MessageListPageState() {
    _targetLang = _langs.first;
  }

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    _messageService.readAllLive(widget.chat.id).listen((value) {
      _messages.clear();
      _messages.addAll(value);
      setState(() {
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _submitChat() async {
    var text = _replyCon.value.text.trim();
    if (text.isEmpty && _file == null) {
      dev.log('$dkey reply content and image is empty');
      return;
    }
    Message reply = new Message();

    //Set reply image if file exist
    if (_file != null) {
      EasyLoading.show(status: 'Upload image...');
      reply.imageUrl = await _imgService.uploadFile(_file!, 'Chat');
      EasyLoading.dismiss();
    }

    reply.messageId = widget.chat.id;
    reply.content = text;
    reply.creatorId = _userData.uid;
    reply.creatorName = _auth.currentUser!.email!;

    _messageService.create(reply).then((value) {
      _resetImage();
      _replyCon.text = '';
    });
  }

  void _translate() async {
    var text = _replyCon.text.trim();
    if (text.isEmpty) {
      Fluttertoast.showToast(msg: "reply is empty");
      return;
    }

    EasyLoading.show(status: 'Loading data for translation...');
    final String sourceLang = await _langDetectService.Detect(text);

    await _translateService.Translate(
        text: text,
        sourceLang: sourceLang,
        targetLang: _targetLang.id
    ).then((translateText) {
      Fluttertoast.showToast(msg: "Translate text is $translateText");
      setState(() {
        _replyCon.text = translateText;
      });
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Translate error: $error");
      dev.log('$dkey Translate error: ${error.toString()}');
    });

    EasyLoading.dismiss();
  }

  void _openLangsDialog() {
    showDialog(context: context, builder: (context) {
      dialogContext = context;
      return LangsDialog(
        langs: _langs,
        initialLang: _targetLang,
        onSelectLang: _onSelectLang,
      );
    });
  }

  void _toggleImgPanel() {
    if (_showImgPanel) {
      setState(() {
        _showImgPanel = false;
      });
    } else {
      setState(() {
        _showImgPanel = true;
      });
    }
  }

  void _getImageFromGallery() async {
    final XFile? image = await _imgPicker.pickImage(source: ImageSource.gallery);
    _setImage(image);
  }

  void _getImageFromCamera() async {
    final XFile? image = await _imgPicker.pickImage(source: ImageSource.camera);
    _setImage(image);
  }

  void _setImage(XFile? image) {
    if (image != null) {
      dev.log('$dkey Create image success');
      setState(() {
        _file = File(image.path);
      });
    }
  }

  void _resetImage() async {
    setState(() {
      _file = null;
    });
  }

  void _onSelectLang(Lang lang) {
    setState(() {
      _targetLang = lang;
    });
    dev.log('$dkey _onSelectLang lang: ${_targetLang.id}');
    Navigator.pop(dialogContext);
  }

  //------------------UI WIDGETS--------------------------//
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
          child: Column(
            children: [
              _header(),
              _chatContents(),
              _inputSection(),
              (_file != null) || (_showImgPanel)? _imgPanel(): Container()
            ],
          ),
        ),
      ),
    );
  }

  PercentageSizeWidget _chatContents() {
    return PercentageSizeWidget(
            percentageHeight: (_file != null) || (_showImgPanel)? 0.7: 0.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              // child: MessageListWidget(data: _messages,),
              child: ListView.builder(itemBuilder: (context, pos) {
                return MessageWidget(message: _messages[pos]);
              },
              itemCount: _messages.length,
            )
          ));
  }

  Widget _inputSection() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.image_outlined), onPressed: _toggleImgPanel),
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
            GestureDetector(
              child: Icon(Icons.translate),
              onTap: _translate,
              onLongPress: _openLangsDialog,
            )
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: widget.chat.title,
        size: 16.0,
        color: BLACK,
      ),
      canGoBack: true,
      router: context.router,
    );
  }

  Widget _imgPanel() {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: _getImageFromCamera, icon: Icon(Icons.camera)),
                IconButton(onPressed: _getImageFromGallery, icon: Icon(Icons.folder_open)),
              ],
            ),
            (_file != null)? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.file(_file!),
                IconButton(onPressed: _resetImage, icon: Icon(Icons.highlight_remove_sharp)),
              ],
            ): Container(),
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
