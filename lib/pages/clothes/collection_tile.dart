import 'package:do_an_ui/models/clothes_collection.dart';
import 'package:flutter/material.dart';

class CollectionListTile extends StatelessWidget {
  final ClothesCollection data;
  final Function(ClothesCollection a) onSelect;
  final Function(ClothesCollection a) onDelete;

  CollectionListTile({
    Key? key,
    required this.data,
    required this.onSelect,
    required this.onDelete
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {onSelect(data);},
      leading: (data.imageUrl != null)? Image.network(
          data.imageUrl,
        width: 64, height: 64,
      ): Text(''),
      title: Text(data.name),
      trailing: IconButton(
        icon: Icon(Icons.highlight_remove_outlined),
        onPressed: () {onDelete(data);},
      ),
    );
  }
}
