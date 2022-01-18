import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';

class Lang {
  final String id;
  final String name;

  Lang({
    required this.id,
    required this.name
});
}

class LangsDialog extends StatefulWidget {
  final List<Lang> langs;
  final Lang initialLang;
  final Function(Lang) onSelectLang;

  LangsDialog({
   required this.langs,
   required this.initialLang,
   required this.onSelectLang,
});

  @override
  State<LangsDialog> createState() => _LangsDialogState(
      selectedLang: initialLang
  );
}

class _LangsDialogState extends State<LangsDialog> {
  Lang selectedLang;

  _LangsDialogState({
    required this.selectedLang
});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      child: PercentageSizeWidget(
        percentageWidth: 0.8,
        percentageHeight: 0.5,
        child: Column(children: [
          // Expanded(flex: 1, child: Te,)
          Expanded(flex: 5, child: _users(),),
          Expanded(flex: 1, child: _btn(),)
        ],),
      ),
    );
  }

  Widget _btn() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: RoundedButtonWidget(
          backgroundColor: DARK_BLUE,
          borderColor: DARK_BLUE,
          roundness: 90,
          onTap: () {
            widget.onSelectLang(this.selectedLang);
          },
          child: TextWidget(
            text: 'Translate to',
            size: FONT_SIZE_1,
            color: WHITE,
          ),
        ),
      ),
    );
  }

  ListView _users() {
    return ListView.builder(
        itemBuilder: (context, position) {
          return _userTile(widget.langs[position]);
        },
        itemCount: widget.langs.length,
      );
  }

  RadioListTile _userTile(Lang lang) {
    return RadioListTile(
      title: Text(lang.name),
      value: lang,
      groupValue: selectedLang,
      onChanged: _onSelectLang
    );
  }

  void _onSelectLang(lang) {
      if (lang == null) {

      } else {
        setState(() {
          this.selectedLang = lang;
        });
      }
    }
}
