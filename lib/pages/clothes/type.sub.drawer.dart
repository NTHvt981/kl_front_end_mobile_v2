import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/clothes/specific_type.widget.dart';
import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

import 'selectable.item.widget.dart';

class TypeSubDrawer extends StatelessWidget {
  final EType type;
  final Function(ESpecificType) onChooseSpecificType;
  late final List<ESpecificType> _specificTypes;

  TypeSubDrawer({
    required this.type,
    required this.onChooseSpecificType
  }) {
    _specificTypes = type.specificTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MEDIUM_BLUE,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: WhiteBoldTextWidget(
                text: type.name,
                size: 32,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return SpecificTypeWidget(
                  specificType: _specificTypes[position],
                  onSelectSpecificType: onChooseSpecificType,
                );
              },
              itemCount: _specificTypes.length,
            ),
          )
        ],
      ),
    );
  }
}
