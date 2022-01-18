import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

import 'selectable.item.widget.dart';

class SelectableItemsDrawer extends StatelessWidget {
  final List<Item> items;
  final EType type;
  final Function(Item) onAddItem;
  final Function(Item item) onRemoveItem;
  final Function(Item item, ESize size) onChangeSize;

  SelectableItemsDrawer({
    required this.items,
    required this.type,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onChangeSize,
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
                  text: type.name,
                  size: 32,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return SelectableItemWidget(
                    item: items[position],
                    onAddItem: onAddItem,
                    onRemoveItem: onRemoveItem,
                    onChangeSize: onChangeSize,
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
}
