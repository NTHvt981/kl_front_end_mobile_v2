import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/clothes_collection.dart';
import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/cupertino.dart';

class ClothesCollectionService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'QuanAo';

  Future<List<ClothesCollection>> readAllOnce(String uid) {
    return firestore.collection(root).where(USER_ID, isEqualTo: uid).get().then((snapshot) {
      List<ClothesCollection> collections = [];

      snapshot.docs.forEach((docSnap) {
        collections.add(ClothesCollection.fromMap(docSnap.data()));
      });

      return collections;
    });
  }

  Stream<List<ClothesCollection>> readAllLive(String uid) {
    return firestore.collection(root).where(USER_ID, isEqualTo: uid)
        .snapshots(includeMetadataChanges: false)
        .map((snapshot) {
      List<ClothesCollection> collections = [];

      snapshot.docs.forEach((docSnap) {
        collections.add(ClothesCollection.fromMap(docSnap.data()));
      });

      return collections;
    });
  }

  Future<void> create(String uid, @optionalTypeArgs String imageUrl) async {
    ClothesCollection collection = new ClothesCollection();

    collection.userId = uid;
    collection.id = firestore.collection(root).doc().id;
    collection.imageUrl = imageUrl;
    collection.name = '';

    localItemService.forEach((type, ser) {
      Item? item = ser.itemBehavior.value;

      if (item != null)
        {
          collection.setItemId(type, item);
          collection.name += item.name + '\n';
        }
    });

    firestore.collection(root).doc(collection.id)
        .set(collection.toMap())
        .then((value) => log("Add Collection success"))
        .catchError((err) => log("Error adding Collection"));
  }

  Future<void> delete(String id) {
    return firestore.collection(root).doc(id).delete();
  }
}

final clothesCollectionService = new ClothesCollectionService();