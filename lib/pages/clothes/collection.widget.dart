import 'package:do_an_ui/models/clothes_collection.model.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:flutter/material.dart';

class CollectionWidget extends StatelessWidget {
  final ClothesCollection data;
  final Function(ClothesCollection a) onSelect;
  final Function(ClothesCollection a) onDelete;

  CollectionWidget({
    Key? key,
    required this.data,
    required this.onSelect,
    required this.onDelete
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {onSelect(data);},
      leading: (data.imageUrl.isNotEmpty)? Image.network(
          data.imageUrl,
        width: 64, height: 64,
      ): Text(''),
      title: TextWidget(text: data.name, size: 16.0, color: MEDIUM_BLUE,),
      trailing: IconButton(
        icon: Icon(IconCancel),
        onPressed: () {onDelete(data);},
      ),
      tileColor: VERY_LIGHT_GRAY,
    );
  }
}
