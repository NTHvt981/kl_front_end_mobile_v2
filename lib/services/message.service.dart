
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/message.model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'TinNhan';
  String nextRoot = 'ChiTietTinNhan';

  Future<List<Message>> readAllOnce(String mesId) {
    return firestore.collection(root).doc(mesId).collection(nextRoot)
        .orderBy(CREATED_TIME, descending: true).get().then((snapshot) {
      List<Message> messageSegmentList = [];

      snapshot.docs.forEach((docSnap) {
        Message mes = Message.fromMap(docSnap.data());

        messageSegmentList.add(mes);
      });

      return messageSegmentList;
    });
  }

  Stream<List<Message>> readAllLive(String mesId) {
    return firestore.collection(root).doc(mesId).collection(nextRoot)
        .orderBy(CREATED_TIME).snapshots().map((snapshot) {
      List<Message> messageSegmentList = [];

      snapshot.docs.forEach((docSnap) {
        Message mes = Message.fromMap(docSnap.data());

        messageSegmentList.add(mes);
      });

      return messageSegmentList;
    });
  }

  Future<void> create(Message messageSegment) async {
    firestore.collection(root).doc(messageSegment.messageId).collection(nextRoot).doc(messageSegment.id)
        .set(messageSegment.toMap());
  }
}

final messageSegmentService = new MessageService();