
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectableItemWidget extends StatelessWidget {
  final Item item;
  final Function(Item item) onAddItem;
  final Function(Item item) onRemoveItem;
  final Function(Item item, ESize size) onChangeSize;
  late final bool _hasSelected;
  late final ESize? _size;

  SelectableItemWidget({
    required this.item,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onChangeSize,
}) {
    final data = g_localItemsData[item.type]!;
    _hasSelected = data.hasItem(item);
    _size = data.getSizes()[item.id];
  }

  _onAddOrRemove() {
    final data = g_localItemsData[item.type]!;
    if (data.hasItem(item)) {
      onRemoveItem(item);
    } else {
      onAddItem(item);
    }
  }

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
      color: WHITE,
      elevation:5,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: _hasSelected ? BorderSide(color: Colors.green, width: 3)
                          : BorderSide(color: Colors.white70, width: 1),
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
    );
  }

  Expanded _body() {
    return Expanded(flex: 3, child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                GestureDetector(
                  onTap: _onAddOrRemove,
                  child: TextWidget(text: item.name, size: 18.0, bold: true,)
                ),
                TextWidget(text: item.brand, size: 10.0, fontStyle: FontStyle.italic,),
                TextWidget(text: formatMoney(item.price), size: 12.0,),
                _size != null? _edtSize(): Container()
              ],),
            ));
  }

  Widget _edtSize() {
    return Row(
      children: [
        Text('Size: '),
        NumberPicker(
          minValue: _getMin(_size!),
          maxValue: _getMax(_size!),
          axis: Axis.vertical,
          value: _size!.index,
          onChanged: (value) {
            onChangeSize(item, value.toEsize());
          },
          textMapper: (value) {
            return _size!.name;
          },
          itemCount: 1,
          itemHeight: 32.0,
          itemWidth: 36.0,
        ),
      ],
    );
  }

  Expanded _img() {
    return Expanded(
              child: GestureDetector(
                onTap: _onAddOrRemove,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.imageUrl
                ),
              ),
            );
  }
}
