


import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String dir) async {
    var task = storage.ref(dir).putFile(file);
    String url = "";

    await task.then((TaskSnapshot taskSnap) async {
      url = await taskSnap.ref.getDownloadURL();
    });

    return url;
  }
}

final imageService = new ImageService();