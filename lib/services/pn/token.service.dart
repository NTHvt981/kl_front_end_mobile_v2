import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/token.model.dart';

class TokenService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root1 = 'KhachHang';
  String root2 = 'Tokens';
  String _dkey = "[TokenService]";

  // Future<Customer?> readOnce(String id) {
  //   return firestore.collection(root).doc(id).get().then((snapshot) {
  //     if (!snapshot.exists) return null;
  //     return Customer.fromMap(snapshot.data()!);
  //   });
  // }
  //
  // Stream<Customer?> readLive(String id) {
  //   return firestore.collection(root).doc(id).snapshots().map((snapshot) {
  //     if (!snapshot.exists) {
  //       log(_dkey + "readLive return null");
  //       return null;
  //     }
  //     return Customer.fromMap(snapshot.data()!);
  //   });
  // }

  Future<void> create(String uid, Token token) async {
    firestore.collection(root1).doc(uid).collection(root2).doc(token.token)
        .set(token.toMap());
  }
}

final g_tokenService = TokenService();