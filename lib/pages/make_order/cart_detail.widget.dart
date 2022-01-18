import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/models/local_detail.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/icons.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transparent_image/transparent_image.dart';

class CartDetailWidget extends StatelessWidget {
  final LocalDetail detail;
  final Function(LocalDetail) onRemove;
  final Function(int) onChangeAmount;
  final Function(ESize) onChangeSize;

  CartDetailWidget({
    required this.detail,
    required this.onRemove,
    required this.onChangeAmount,
    required this.onChangeSize,
  });

  int _getMin(ESize size) {
    if (size.isSHSize()) {
      return SH_SIZE_MIN;
    } else if (size.isSPSize()) {
      return SP_SIZE_MIN;
    }
    throw('ERROR at SelectableItemWidget::_getMin');
  }

  int _getMax(ESize size) {
    if (size.isSHSize()) {
      return SH_SIZE_MAX;
    } else if (size.isSPSize()) {
      return SP_SIZE_MAX;
    }
    throw('ERROR at SelectableItemWidget::_getMax');
  }

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
            Expanded(child: _img(), flex: 1,),
            Expanded(child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextWidget(text: detail.item.name, size: 18.0, bold: true,),
                TextWidget(text: detail.item.brand, size: 10.0, fontStyle: FontStyle.italic,),
                TextWidget(text: formatMoney(detail.item.price), size: 12.0,),
                Row(
                  children: [
                    _edtAmount(),
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
        Text('Amount: '),
        NumberPicker(
          minValue: 1,
          maxValue: 100,
          axis: Axis.horizontal,
          value: detail.amount,
          onChanged: onChangeAmount,
          itemCount: 1,
          itemHeight: 32.0,
          itemWidth: 32.0,
        ),
      ],
    );
  }

  Widget _edtSize(ESize size) {
    return Row(
      children: [
        Text('Size: '),
        NumberPicker(
          minValue: _getMin(size),
          maxValue: _getMax(size),
          axis: Axis.horizontal,
          value: size.index,
          onChanged: (value) {
            onChangeSize(value.toEsize());
          },
          textMapper: (value) {
            return size.name;
          },
          itemCount: 1,
          itemHeight: 32.0,
          itemWidth: 36.0,
        ),
      ],
    );
  }

  Container _btnCancel() {
    return Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 4.0, top: 4.0),
          child: IconButton(
            icon: Icon(IconCancel, color: MEDIUM_GRAY,),
              onPressed: () {
                onRemove(detail);
              },
          )
    );
  }

  Widget _img() {
    return detail.item.imageUrl.isNotEmpty
        ? FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: detail.item.imageUrl)
        : Image.asset('images/placeholders/news-1');
  }
}
