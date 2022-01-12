import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'item.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';

class ItemsDrawerWidget extends StatelessWidget {
  final List<Item> items;
  final String type;

  ItemsDrawerWidget({
    required this.items,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: MEDIUM_BLUE,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: WhiteBoldTextWidget(
                  text: type,
                  size: 32,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return ItemWidget(
                    item: items[position],
                    onSelect: (Item item) {_onSelectItem(item, context);},
                  );
                },
                itemCount: items.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSelectItem(Item item, BuildContext context) {
    String type = item.type;
    g_localItemsService[type]!.set(item);
    Navigator.of(context).pop();
  }
}
