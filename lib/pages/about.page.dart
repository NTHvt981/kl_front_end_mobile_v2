import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: WHITE,
      body: Column(children: [
        _header()
      ],),
    );
  }

  HeaderWidget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: "About.",
        size: 20.0,
        bold: true,
      ),
      canGoBack: true,
      router: context.router,
    );
  }
}
