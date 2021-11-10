import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/customer.dart';

class CustomerService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'KhachHang';

  Future<Customer?> readOnce(String id) {
    return firestore.collection(root).doc(id).get().then((snapshot) {
      if (!snapshot.exists) return null;
      return Customer.fromMap(snapshot.data()!);
    });
  }

  Stream<Customer?> readLive(String id) {
    return firestore.collection(root).doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return Customer.fromMap(snapshot.data()!);
    });
  }

  Future<void> create(Customer cus) async {
    firestore.collection(root).doc(cus.id)
        .set(cus.toMap())
        .then((value) => log("Add Customer success"))
        .catchError(() => log("Error adding Customer"));
  }

  Future<void> update(Customer cus) async {
    firestore.collection(root).doc(cus.id)
        .set(cus.toMap());
  }
}

final customerService = new CustomerService();