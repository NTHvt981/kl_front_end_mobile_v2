import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/message_segment.dart';

class MessageSegmentService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'TinNhan';
  String nextRoot = 'ChiTietTinNhan';

  Future<List<MessageSegment>> readAllOnce(String mesId) {
    return firestore.collection(root).doc(mesId).collection(nextRoot)
        .orderBy(CREATED_TIME, descending: true).get().then((snapshot) {
      List<MessageSegment> messageSegmentList = [];

      snapshot.docs.forEach((docSnap) {
        MessageSegment mes = MessageSegment.fromMap(docSnap.data());

        messageSegmentList.add(mes);
      });

      return messageSegmentList;
    });
  }

  Stream<List<MessageSegment>> readAllLive(String mesId) {
    return firestore.collection(root).doc(mesId).collection(nextRoot)
        .orderBy(CREATED_TIME).snapshots().map((snapshot) {
      List<MessageSegment> messageSegmentList = [];

      snapshot.docs.forEach((docSnap) {
        MessageSegment mes = MessageSegment.fromMap(docSnap.data());

        messageSegmentList.add(mes);
      });

      return messageSegmentList;
    });
  }

  Future<void> create(MessageSegment messageSegment) async {
    firestore.collection(root).doc(messageSegment.messageId).collection(nextRoot).doc(messageSegment.id)
        .set(messageSegment.toMap());
  }
}

final messageSegmentService = new MessageSegmentService();