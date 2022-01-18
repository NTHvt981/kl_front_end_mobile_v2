import 'package:do_an_ui/models/collection.model.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CollectionWidget extends StatelessWidget {
  final Collection data;
  final Function(Collection a) onSelect;
  final Function(Collection a) onDelete;

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
      leading: _img(),
      title: TextWidget(text: data.name, size: 16.0, color: MEDIUM_BLUE,),
      trailing: IconButton(
        icon: Icon(IconCancel),
        onPressed: () {onDelete(data);},
      ),
      tileColor: VERY_LIGHT_GRAY,
    );
  }

  Widget _img() {
    return data.imageUrl.isNotEmpty
      ? FadeInImage.memoryNetwork(
        placeholder: kTransparentImage, image: data.imageUrl,
        width: 64, height: 64,
      )
      : Image.asset('images/placeholders/news-1');
  }
}
