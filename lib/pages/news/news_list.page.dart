// ignore_for_file: unused_import

import 'dart:developer';

import 'package:auto_route/auto_route.dart' as route;
import 'package:do_an_ui/models/news.model.dart';
import 'package:do_an_ui/pages/news/news.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/news.service.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  List<News> _newsList = [];

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    newsService.readAllOnce()
        .then((value) {
       log('Read news list success');
       log('length is ${value.length}');

       setState(() {
         _newsList = value;
       });
    }).catchError((err) {
      log('Catch error in getting news $err');
    });
  }

  //------------------PRIVATE METHODS---------------------//
  void _onSelectNews(News news) {
    context.router.push(NewsPageRoute(title: news.title, url: news.url));
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Column(children: [
          HeaderWidget(
            title: TextWidget(
              text: "WeClothes.",
              size: 24.0,
              bold: true,
            ),
          ),
          _newsListWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(index: 0,),
      endDrawer: SettingDrawer(),
    );
  }

  PercentageSizeWidget _newsListWidget() {
    return PercentageSizeWidget(
          percentageHeight: 0.8,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemBuilder: (context, position) {
                return NewsWidget(news: _newsList[position], onSelect: _onSelectNews,);
              },
              itemCount: _newsList.length,
            ),
          ),
        );
  }
}
