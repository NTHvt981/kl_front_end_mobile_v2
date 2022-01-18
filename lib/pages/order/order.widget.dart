import 'package:do_an_ui/models/order.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/order_status.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  final Function(Order) onSelect;

  OrderWidget({
    Key? key,
    required this.order,
    required this.onSelect,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {onSelect(order);},
      leading: order.imageUrl.isNotEmpty?
        FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: order.imageUrl, width: 64, height: 64)
        : Image.asset('images/placeholders/news-1'),
      title: TextWidget(text: formatID(order.id), size: 16.0, color: MEDIUM_BLUE,),
      subtitle: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextWidget(text: formatMoney(order.finalTotal()), size: 12.0, color: BLACK,),
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: TextWidget(
                    text: 'STATUS: ' + order.status.name,
                    size: 12.0, color: Colors.red,)
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextWidget(
              text: 'Update ' + TimeAgo(order.updatedTime),
              size: 12.0, color: BLACK,)
          ),
        ],
      ),
      tileColor: VERY_LIGHT_GRAY,
    );
  }
}
