import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/chat.model.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'TinNhan';
  final dkey = '[DEBUG ChatService]';

  Future<List<Chat>> readAllOnce(String userId) {
    return firestore.collection(root).orderBy(CREATED_TIME, descending: true).get().then((snapshot) {
      List<Chat> messageList = [];

      snapshot.docs.forEach((docSnap) {
        Chat mes = Chat.fromMap(docSnap.data());

        if (mes.createdByAdmin || mes.creatorId == userId)
          messageList.add(mes);
      });

      return messageList;
    });
  }

  Stream<List<Chat>> readAllLive(String userId) {
    return firestore.collection(root).orderBy(CREATED_TIME, descending: true).snapshots().map((snapshot) {
      List<Chat> messageList = [];

      snapshot.docs.forEach((docSnap) {
        Chat mes = Chat.fromMap(docSnap.data());

        if (mes.createdByAdmin || mes.creatorId == userId)
          messageList.add(mes);
      });

      return messageList;
    });
  }

  Future<Chat> readOnce(String id) {
    return firestore.collection(root).doc(id).get().then((snapshot) {
      return Chat.fromMap(snapshot.data()!);
    });
  }

  Future<void> create(Chat message) async {
    firestore.collection(root).doc(message.id)
        .set(message.toMap())
        .then((value) => log(dkey + "Add Message success"))
        .catchError((err) => log(dkey + "Error adding Message ${err.toString()}"));
  }

  Future<void> update(Chat message) async {
    firestore.collection(root).doc(message.id)
        .update(message.toMap())
        .then((value) => log(dkey + "update Message success"))
        .catchError((err) => log(dkey + "Error update Message ${err.toString()}"));
  }

  Future<void> delete(String id) async {
    firestore.collection(root).doc(id).delete()
        .then((value) => log(dkey + 'Delete Message success'))
        .catchError((err) => log(dkey + "Error Delete Message ${err.toString()}"));
  }
}

final g_chatMessage = new ChatService();