import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PNService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void initialize() {
    // _fcm.
  }

  Future<String?> getToken() {
    return _fcm.getToken();
  }
}

final g_pnService = PNService();