import 'package:do_an_ui/models/clothes_collection.model.dart';
import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/icons.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatelessWidget {
  final Order data;
  final Function(Order) onSelect;

  OrderWidget({
    Key? key,
    required this.data,
    required this.onSelect,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {onSelect(data);},
      leading: (data.imageUrl.isNotEmpty)? Image.network(
          data.imageUrl,
        width: 64, height: 64,
      ): Text(''),
      title: TextWidget(text: formatID(data.id), size: 16.0, color: MEDIUM_BLUE,),
      subtitle: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: TextWidget(text: formatMoney(data.finalTotal()), size: 12.0, color: BLACK,),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextWidget(
              text: 'Update ' + TimeAgo(data.createdTime),
              size: 12.0, color: BLACK,)
          ),
        ],
      ),
      tileColor: VERY_LIGHT_GRAY,
    );
  }
}
