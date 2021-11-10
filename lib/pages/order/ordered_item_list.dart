import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:flutter/material.dart';

class OrderedItemList extends StatelessWidget {
  final List<Item> data;

  OrderedItemList({
    required this.data
  }): super();

  void onSelectItem(int pos) {

  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, pos) => ListTile(
          onTap: () {onSelectItem(pos);},
          leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: (data[pos].imageUrl != null)? Image.network(data[pos].imageUrl): Text('')
          ),
          title: Text(data[pos].name),
          trailing: Text(formatMoney(data[pos].price)),
        ),
        separatorBuilder: (context, pos) => Divider() ,
        itemCount: data.length);
  }
}