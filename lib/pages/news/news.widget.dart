
import 'package:do_an_ui/models/news.model.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsWidget extends StatelessWidget {
  final News news;
  final Function(News a) onSelect;

  NewsWidget({
    required this.news,
    required this.onSelect
}): super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onSelect(news);},
      child: Card(
        elevation:5,
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _header(TimeAgo(news.createdTime)),
              _img(),
              _content()
            ],
          ),
        ),
      ),
    );
  }

  Padding _content() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextWidget(
              text: news.title,
              size: 12,
              bold: true,
            ),
          );
  }

  Padding _img() {
    return Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16.0),
            child: _imgNews(),
          );
  }

  ListTile _header(String timeCreateAgo) {
    return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/clothes-icon.png'),
            ),
            title: Text("WeClothes"),
            subtitle: Text(
              timeCreateAgo,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          );
  }

  Widget _imgNews() {
    return news.imageUrl.isNotEmpty
        // ? Image.network(news.imageUrl)
        ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: news.imageUrl)
        : Image.asset('images/placeholders/news-1');
  }
}