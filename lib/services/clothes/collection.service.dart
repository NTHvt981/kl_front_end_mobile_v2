import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/collection.model.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:do_an_ui/shared/useful.function.dart';
import '../user.data.dart';
import 'local_item.data.dart';


class CollectionService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _root = 'QuanAo';
  final dkey = '[Collection2Service]';

  Future<List<Collection>> readAllOnce(String uid) {
    return _firestore.collection(_root).where(USER_ID, isEqualTo: uid).get().then((snapshot) {
      List<Collection> collections = [];

      snapshot.docs.forEach((docSnap) {
        collections.add(Collection.fromMap(docSnap.data()));
      });

      return collections;
    });
  }

  Stream<List<Collection>> readAllLive(String uid) {
    return _firestore.collection(_root).where(USER_ID, isEqualTo: uid)
        .snapshots(includeMetadataChanges: false)
        .map((snapshot) {
      List<Collection> collections = [];

      snapshot.docs.forEach((docSnap) {
        collections.add(Collection.fromMap(docSnap.data()));
      });

      return collections;
    });
  }

  Future<bool> create(String uid, String imageUrl) async {
    Collection collection = new Collection();
    bool result = false;

    var user = g_userData.currentUser();
    user.savedCollections += 1;

    collection.userId = uid;
    collection.id = _firestore.collection(_root).doc().id;
    collection.imageUrl = imageUrl;
    collection.name = 'WARDROBE ' + user.savedCollections.toString();
    
    g_localItemsData.forEach((type, data) {
      final items = data.getItems();

      collection.setItemsId(type, items.keys.toList());
    });

    await _firestore.collection(_root).doc(collection.id)
        .set(collection.toMap()).then((value) {
      log('$dkey Save success');
      result = true;
    }).catchError((err) {
      log('$dkey Save fail error ${err.toString()}');
    });

    g_customerService.update(user);

    return result;
  }

  Future<void> delete(String id) {
    return _firestore.collection(_root).doc(id).delete();
  }
}

final g_collection2Service = new CollectionService();