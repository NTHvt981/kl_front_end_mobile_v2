import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

import 'selectable.item.widget.dart';

class SpecificTypeSubDrawer extends StatelessWidget {
  final List<Item> items;
  final ESpecificType specificType;
  final Function(Item) onAddItem;
  final Function(Item item) onRemoveItem;
  final Function(Item item, ESize size) onChangeSize;
  final Function() onGoBack;

  SpecificTypeSubDrawer({
    required this.items,
    required this.specificType,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onChangeSize,
    required this.onGoBack
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MEDIUM_BLUE,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(onPressed: onGoBack, icon: Icon(Icons.chevron_left, color: WHITE,)),
                ),
                Center(
                  child: WhiteBoldTextWidget(
                    text: specificType.name,
                    size: 32,
                  ),
                ),
              ],
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
    );
  }
}
