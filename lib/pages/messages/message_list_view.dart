import 'package:do_an_ui/models/message.dart';
import 'package:flutter/material.dart';

class MessageListView extends StatelessWidget {
  final List<Message> data;
  final Function(Message message) onSelect;

  MessageListView({
    Key? key,
    required this.data,
    required this.onSelect
}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, pos) {
          var time = data[pos].createdTime.toDate();
          var day = time.day;
          var month = time.month;
          var year = time.year;

          var state = "Tình trạng: ";
          if (data[pos].isOver)
            state += "ĐÃ ĐÓNG";
          else
            state += "ĐANG MỞ";

          return ListTile(
            title: Text(data[pos].title),
            subtitle: Text(state),
            trailing: Text("$day/$month/$year"),
            onTap: () {onSelect(data[pos]);},
          );
        },
        separatorBuilder: (context, pos) => Divider(),
        itemCount: data.length
    );
  }
}
