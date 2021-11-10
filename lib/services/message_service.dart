import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/message.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'TinNhan';

  Future<List<Message>> readAllOnce(String userId) {
    return firestore.collection(root).orderBy(CREATED_TIME, descending: true).get().then((snapshot) {
      List<Message> messageList = [];

      snapshot.docs.forEach((docSnap) {
        Message mes = Message.fromMap(docSnap.data());

        if (mes.createdByAdmin || mes.creatorId == userId)
          messageList.add(mes);
      });

      return messageList;
    });
  }

  Stream<List<Message>> readAllLive(String userId) {
    return firestore.collection(root).orderBy(CREATED_TIME, descending: true).snapshots().map((snapshot) {
      List<Message> messageList = [];

      snapshot.docs.forEach((docSnap) {
        Message mes = Message.fromMap(docSnap.data());

        if (mes.createdByAdmin || mes.creatorId == userId)
          messageList.add(mes);
      });

      return messageList;
    });
  }

  Future<Message> readOnce(String id) {
    return firestore.collection(root).doc(id).get().then((snapshot) {
      return Message.fromMap(snapshot.data()!);
    });
  }

  Future<void> create(Message message) async {
    firestore.collection(root).doc(message.id)
        .set(message.toMap())
        .then((value) => log("Add Message success"))
        .catchError(() => log("Error adding Message"));
  }

  Future<void> update(Message message) async {
    firestore.collection(root).doc(message.id)
        .update(message.toMap())
        .then((value) => log("update Message success"))
        .catchError(() => log("Error update Message"));
  }

  Future<void> delete(String id) async {
    firestore.collection(root).doc(id).delete()
        .then((value) => log('Delete Message success'));
  }
}

final messageService = new MessageService();