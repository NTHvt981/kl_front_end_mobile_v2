import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/order.dart';

class OrderService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'DonHang';

  String getId() {
    return firestore.collection(root).doc().id;
  }

  Future<List<Order>> readAllOnce(String uid) {
    return firestore.collection(root).where(USER_ID, isEqualTo: uid).get().then((snapshot) {
      List<Order> orders = [];

      snapshot.docs.forEach((docSnap) {
        orders.add(Order.fromMap(docSnap.data()));
      });

      return orders;
    });
  }

  Stream<List<Order>> readAllLive(String uid) {
    return firestore.collection(root).where(USER_ID, isEqualTo: uid).snapshots().map((snapshot) {
      List<Order> orders = [];

      snapshot.docs.forEach((docSnap) {
        orders.add(Order.fromMap(docSnap.data()));
      });

      return orders;
    });
  }

  Future<void> create(Order order) async {
    return firestore.collection(root).doc(order.id).set(order.toMap());
  }
  
  Future<void> cancel(String id) async {
    return firestore.collection(root).doc(id).update({
      STATE: ORDER_STATE_CANCELED
    });
  }
}

final orderService = new OrderService();