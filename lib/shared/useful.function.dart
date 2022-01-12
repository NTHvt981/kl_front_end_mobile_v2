import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String TimeAgo(Timestamp passTime) {
  final timeInterval = Timestamp.now().toDate().difference(passTime.toDate());
  String timeCreateAgo = "";
  if (timeInterval.inDays > 1) timeCreateAgo += timeInterval.inDays.toString() + " days";
  else if (timeInterval.inHours > 1) timeCreateAgo += timeInterval.inHours.toString() + " hours";
  else if (timeInterval.inMinutes > 1) timeCreateAgo += timeInterval.inMinutes.toString() + " minutes";
  else timeCreateAgo += timeInterval.inSeconds.toString() + " seconds";
  timeCreateAgo += " ago";

  return timeCreateAgo;
}

String Shorten(String text, int len) {
  String newText = '';

  if (text.length > len) {
    newText += text.substring(0, len);
    newText += '...';
  }
  else {
    newText += text;
  }

  return newText;
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatCardNumber(String number) {
  String value = '';

  for (int i = 0; i < number.length; i++) {
    value += number[i];
    if ((i + 1) % 4 == 0 && (i != number.length - 1)) {
      value += '-';
    }
  }

  return value;
}

String formatID(String longId) {
  String value = '';

  value += longId.substring(0, 8);
  value = value.toUpperCase();

  return value;
}