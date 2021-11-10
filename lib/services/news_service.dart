import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/news.dart';

class NewsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String root = 'TinTuc';

  Future<List<News>> readAllOnce() {
    return firestore.collection(root).get().then((snapshot) {
      List<News> newsList = [];

      snapshot.docs.forEach((docSnap) {
        newsList.add(News.fromMap(docSnap.data()));
      });

      return newsList;
    });
  }

  Future<News> readOnce(String id) {
    return firestore.collection(root).doc(id).get().then((snapshot) {
      return News.fromMap(snapshot.data()!);
    });
  }
  
  Future<void> create(News news) async {
    firestore.collection(root).doc(news.id)
        .set(news.toMap())
        .then((value) => log("Add News success"))
        .catchError(() => log("Error adding News"));
  }

  Future<void> update(News news) async {
    firestore.collection(root).doc(news.id)
        .update(news.toMap())
        .then((value) => log("update News success"))
        .catchError(() => log("Error update News"));
  }

  Future<void> delete(String id) async {
    firestore.collection(root).doc(id).delete()
        .then((value) => log('Delete News success'));
  }
}

final newsService = new NewsService();