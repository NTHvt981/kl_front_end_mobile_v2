
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/constraints.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transparent_image/transparent_image.dart';

class SpecificTypeWidget extends StatelessWidget {
  final ESpecificType specificType;
  final Function(ESpecificType specificType) onSelectSpecificType;

  SpecificTypeWidget({
    required this.specificType,
    required this.onSelectSpecificType,
  }) {
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: WHITE,
      elevation:5,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
      child: GestureDetector(
          onTap: () {
            onSelectSpecificType(specificType);
          },
          child: Center(child: TextWidget(text: specificType.name, size: 24.0, bold: true,))
      ),
    ));
  }

  Expanded _img() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onSelectSpecificType(specificType);
        },
        child: Image.asset(specificType.assetPath)
      ),
    );
  }
}
