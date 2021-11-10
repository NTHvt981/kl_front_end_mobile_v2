import 'dart:developer';

import 'package:auto_route/auto_route.dart' as route;
import 'package:do_an_ui/models/news.dart';
import 'package:do_an_ui/pages/news/news_components.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/news_service.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:flutter/material.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<News> data = [];

  @override
  void initState() {
    super.initState();

    newsService.readAllOnce()
        .then((value) {
       log('Read news list success');
       log('length is ${value.length}');

       setState(() {
         data = value;
       });
    }).catchError((err) {
      log('Catch error in getting news $err');
    });
  }

  void onSelectNews(News news) {
    context.router.push(NewsDetailPageRoute(title: news.title, url: news.url));
   // route.ExtendedNavigator.root.push(Routes.newsDetailPage,
   //     arguments: NewsDetailPageArguments(title: news.title, url: news.url)
   // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách tin tức'),
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, position) {
            return NewsListTile(data: data[position], onSelect: onSelectNews,);
          },
          itemCount: data.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      )
    );
  }
}
