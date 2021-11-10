
import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/material.dart';

class ItemToChooseListWidget extends StatelessWidget {
  final List<Item> data;

  ItemToChooseListWidget({
    Key? key,
    required this.data
  }): super(key: key);

  chooseItem(int pos) {
    String type = data[pos].type;
    localItemService[type]!.set(data[pos]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 300,
      child: ListView.separated(
        itemBuilder: (context, position) {
          return Column(
              children: [ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  child: Image.network(data[position].imageUrl),
                ),
                onTap: () {
                  chooseItem(position);
                },),
                Text( formatMoney(data[position].price))
              ]
          );
        },
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}