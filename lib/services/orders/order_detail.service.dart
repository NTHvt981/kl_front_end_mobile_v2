import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/detail.model.dart';

class OrderDetailService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final root = 'DonHang';
  final nextRoot = 'ChiTietDonHang';
  final dkey = '[OrderDetailService]';

  String getId() {
    return firestore.collection(root).doc().id;
  }

  Future<List<Detail>> readAllOnce(String orderId) {
    return firestore.collection(root).doc(orderId)
        .collection(nextRoot).get().then((snapshot) {
      List<Detail> details = [];

      snapshot.docs.forEach((docSnap) {
        details.add(Detail.fromMap(docSnap.data()));
      });

      return details;
    });
  }

  // Future<void> create(OrderDetail detail) {
  //   return firestore.collection(root).doc(detail.orderId)
  //       .collection(nextRoot).doc(detail.id).set(detail.toMap());
  // }
  Future<void> create(Detail detail) {
    return firestore.collection(root).doc(detail.orderId)
        .collection(nextRoot).doc(detail.id).set(detail.toMap()).catchError((err) {
      log('$dkey add detail fail, error ${err.toString()}');
    });
  }
}

final g_orderDetailService = OrderDetailService();