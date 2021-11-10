import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/item.dart';

class ItemService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'PhuKienThoiTrang';

  Stream<List<Item>> readAllLive() {
    return firestore.collection(root).snapshots(includeMetadataChanges: false).map((snapshot) {
      List<Item> items = [];

      snapshot.docs.forEach((doc) {
        items.add(Item.fromMap(doc.data()));
      });

      return items;
    });
  }

  Future<List<Item>> readAllOnce() {
    return firestore.collection(root).get().then((snapshot) {
      List<Item> items = [];

      snapshot.docs.forEach((docSnap) {
        items.add(Item.fromMap(docSnap.data()));
      });

      return items;
    });
  }

  Future<List<Item>> readAllOnceByType(String type) {
    return firestore.collection(root).where('Loai', isEqualTo: type).get().then((snapshot) {
      List<Item> items = [];

      snapshot.docs.forEach((docSnap) {
        items.add(Item.fromMap(docSnap.data()));
      });

      return items;
    });
  }

  Future<Item> readOnce(String id) {
    return firestore.collection(root).doc(id).get().then((snapshot) {
      return Item.fromMap(snapshot.data()!);
    });
  }
}

final itemService = ItemService();
