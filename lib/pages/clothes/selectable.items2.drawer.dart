import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/clothes/specific_type.sub.drawer.dart';
import 'package:do_an_ui/pages/clothes/type.sub.drawer.dart';
import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

import 'selectable.item.widget.dart';

class SelectableItems2Drawer extends StatefulWidget {
  final List<Item> items;
  final EType type;
  final Function(Item) onAddItem;
  final Function(Item item) onRemoveItem;
  final Function(Item item, ESize size) onChangeSize;

  SelectableItems2Drawer({
    required this.items,
    required this.type,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onChangeSize,
  });

  @override
  State<SelectableItems2Drawer> createState() => _SelectableItems2DrawerState();
}

class _SelectableItems2DrawerState extends State<SelectableItems2Drawer> {
  bool _hasSelectSpecType = false;
  late ESpecificType _selectedSpecType;
  List<Item> _items = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _hasSelectSpecType? SpecificTypeSubDrawer(
        items: _items,
        specificType: _selectedSpecType,
        onAddItem: widget.onAddItem,
        onRemoveItem: widget.onRemoveItem,
        onChangeSize: widget.onChangeSize,
        onGoBack: _onGoBack
      ) : TypeSubDrawer(
        type: widget.type,
        onChooseSpecificType: _onChooseSpecificType
      ),
    );
  }

  _onGoBack() {
    setState(() {
      _hasSelectSpecType = false;
    });
  }

  _onChooseSpecificType(ESpecificType specificType) {
    _filterItems(specificType);
    setState(() {
      _hasSelectSpecType = true;
      _selectedSpecType = specificType;
    });
  }

  _filterItems(ESpecificType specificType) {
    _items.clear();
    widget.items.forEach((item) {
      if (item.specificType == specificType) _items.add(item);
    });
  }
}
