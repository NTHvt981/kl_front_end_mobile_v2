import 'package:do_an_ui/models/detail.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderDetailWidget extends StatelessWidget {
  final Detail detail;

  OrderDetailWidget({
    required this.detail,
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
          Row(children: [
            Expanded(child: _img(), flex: 1,),
            Expanded(child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextWidget(text: detail.item!.name, size: 18.0, bold: true,),
                TextWidget(text: detail.item!.brand, size: 10.0, fontStyle: FontStyle.italic,),
                TextWidget(text: formatMoney(detail.item!.price), size: 12.0,),
                Row(
                  children: [
                    _edtAmount(),
                    Padding(padding: EdgeInsets.only(left: 8.0)),
                    detail.size != null? _edtSize(detail.size!): Container()
                  ],
                ),
              ],),
            ), flex: 3,),
          ],),
        ],
      ),
    );
  }

  Widget _edtAmount() {
    return Row(
      children: [
        Text('Amount: ${detail.amount.toString()}'),
      ],
    );
  }

  Widget _edtSize(ESize size) {
    return Row(
      children: [
        Text('Size: ${detail.size!.name}'),
      ],
    );
  }

  Widget _img() {
    return detail.item!.imageUrl.isNotEmpty
        ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: detail.item!.imageUrl)
        : Image.asset('images/placeholders/news-1');
  }
}
