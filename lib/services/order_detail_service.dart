import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/order_detail.dart';

class OrderDetailService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'DonHang';
  String nextRoot = 'ChiTietDonHang';

  String getId() {
    return firestore.collection(root).doc().id;
  }

  Future<List<OrderDetail>> readAllOnce(String orderId) {
    return firestore.collection(root).doc(orderId)
        .collection(nextRoot).get().then((snapshot) {
      List<OrderDetail> details = [];

      snapshot.docs.forEach((docSnap) {
        details.add(OrderDetail.fromMap(docSnap.data()));
      });

      return details;
    });
  }

  Future<void> create(OrderDetail detail) {
    return firestore.collection(root).doc(detail.orderId)
        .collection(nextRoot).doc(detail.id).set(detail.toMap());
  }
}

final orderDetailService = new OrderDetailService();