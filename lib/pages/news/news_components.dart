import 'dart:developer';

import 'package:do_an_ui/models/news.dart';
import 'package:flutter/material.dart';

class NewsListTile extends StatelessWidget {
  final News data;
  final Function(News a) onSelect;

  NewsListTile({
    required this.data,
    required this.onSelect
}): super();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {onSelect(data);},
      leading: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 44,
            minHeight: 44,
            maxWidth: 64,
            maxHeight: 64,
          ),
          child: (data.imageUrl != null)? Image.network(data.imageUrl): Text('')
      ),
      title: Text(data.title),
    );
  }
}