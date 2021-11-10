import 'dart:ffi';

import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constraints.dart';

class SelectItemDialog extends StatelessWidget {
  final List<Item> data;
  final String type;

  SelectItemDialog({
    Key? key,
    required this.data,
    required this.type,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      // backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.separated(
                itemBuilder: (context, position) {
                  return DialogItemTile(data: data[position],
                      chooseItem: (item) {
                        localItemService[type]!.set(item);
                        Navigator.of(context).pop();
                      });
                },
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  // localItemService[type]!.set();
                  Navigator.of(context).pop();
                },
                child: Text('RESET'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).buttonColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DialogItemTile extends StatelessWidget {
  final Item data;
  final Function(Item item) chooseItem;

  DialogItemTile({
    Key? key,
    required this.data,
    required this.chooseItem,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.name),
      subtitle: Text(formatMoney(data.price)),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        ),
        child: Image.network(data.imageUrl),
      ),
      onTap: () {
        chooseItem(data);
      },);
  }
}

class SelectItemDialogHelper {
  static show(
      context, List<Item> data, String type) => showDialog(context: context, builder: (context) {
    return SelectItemDialog(data: data, type: type);
  });
}