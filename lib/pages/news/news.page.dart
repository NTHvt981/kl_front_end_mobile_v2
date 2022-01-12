import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatelessWidget {
  final String title;
  final String url;

  NewsPage({
    Key? key,
    required this.title,
    required this.url
}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            title: TextWidget(
              text: Shorten(title, 20),
              size: 16.0,
              color: BLACK,
            ),
            canGoBack: true,
            router: context.router,
          ),
          PercentageSizeWidget(
            percentageHeight: 0.9,
            child: WebView(initialUrl: url,)
          ),
        ],
      ),
    );
  }
}
