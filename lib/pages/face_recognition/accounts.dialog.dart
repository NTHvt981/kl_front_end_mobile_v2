import 'package:do_an_ui/models/local_user.model.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:do_an_ui/shared/values.dart';
import 'package:flutter/material.dart';

class AccountsDialog extends StatefulWidget {
  final List<LocalUser> users;
  final Function(LocalUser) onSelectUser;

  AccountsDialog({
   required this.users,
   required this.onSelectUser,
});

  @override
  State<AccountsDialog> createState() => _AccountsDialogState(
    selectedUser: users[0]
  );
}

class _AccountsDialogState extends State<AccountsDialog> {
  LocalUser selectedUser;

  _AccountsDialogState({
    required this.selectedUser
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
            widget.onSelectUser(this.selectedUser);
          },
          child: TextWidget(
            text: 'USE THIS ACCOUNT',
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
          return _userTile(widget.users[position]);
        },
        itemCount: widget.users.length,
      );
  }

  RadioListTile _userTile(LocalUser user) {
    return RadioListTile(
      title: Text(user.email),
      value: user,
      groupValue: selectedUser,
      onChanged: _onSelectUser
    );
  }

  void _onSelectUser(user) {
      if (user == null) {

      } else {
        setState(() {
          this.selectedUser = user;
        });
      }
    }
}
