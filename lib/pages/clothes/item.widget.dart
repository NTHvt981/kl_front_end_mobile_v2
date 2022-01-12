import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../shared/colors.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final Function(Item) onSelect;

  ItemWidget({
    required this.item,
    required this.onSelect
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {onSelect(item);},
      child: Card(
        color: WHITE,
        elevation:5,
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _img(),
              _body()
            ],
          ),
        ),
      ),
    );
  }

  Expanded _body() {
    return Expanded(flex: 3, child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                TextWidget(text: item.name, size: 18.0, bold: true,),
                TextWidget(text: item.brand, size: 10.0, fontStyle: FontStyle.italic,),
                TextWidget(text: formatMoney(item.price), size: 12.0,),
              ],),
            ));
  }

  Expanded _img() {
    return Expanded(
              // child: Image(image: NetworkImage(item.imageUrl))
              child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: item.imageUrl),
            );
  }
}
