import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Item item;

  ItemWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:5,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: VERY_LIGHT_GRAY,
      child: Stack(
        children: [
          _btnCancel(),
          Row(children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: _img(),
            ), flex: 1,),
            Expanded(child: Column(children: [
              _name(),
              _brand(),
              _price(),
            ],), flex: 3,),
          ],),
        ],
      ),
    );
  }

  Container _btnCancel() {
    return Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 4.0, top: 4.0),
          child: IconButton(icon: Icon(IconCancel, color: MEDIUM_GRAY,), onPressed: () {},));
  }

  Container _name() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: TextWidget(
        text: item.name,
        size: 16.0,
        bold: true,
        color: MEDIUM_BLUE,
      ),
    );
  }
  Container _brand() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: TextWidget(
        text: item.brand,
        size: 12.0,
        color: MEDIUM_GRAY,
      ),
    );
  }
  Container _price() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: TextWidget(
        text: formatMoney(item.price),
        size: 18.0,
        bold: true,
      ),
    );
  }

  Widget _img() {
    return item.imageUrl.isNotEmpty
        ? Image.network(item.imageUrl)
        : Image.asset('images/placeholders/news-1');
  }
}
