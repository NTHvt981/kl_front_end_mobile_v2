import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ImageService {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final _dkey = '[IMAGE SERVICE]';

  Future<String> uploadFile(File file, String dir) async {
    var task = _storage.ref(dir).putFile(file);
    String url = "";

    await task.then((TaskSnapshot taskSnap) async {
      url = await taskSnap.ref.getDownloadURL().catchError((err) {
        log(_dkey + 'Get download url error: ${err.toString()}');
      });
      log(_dkey + 'upload file success, url: $url');
    }).catchError((err) {
      log(_dkey + "_saveCollection upload file to storage error: ${err.toString()}");
    });

    return url;
  }

  Future<String> uploadFileData(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(data);

    String imageUrl = await uploadFile(file, fileName);

    return imageUrl;
  }

  Future<Uint8List?> takeScreenShot(ScreenshotController controller) async {
    Uint8List? result;

    await controller.capture().then((imageData) {
      result = imageData;
      log(_dkey + '_takeScreenShot success');
    }).catchError((err) {
      log(_dkey + '_takeScreenShot fail ${err.toString()}');
    });

    return result;
  }
}

final g_imageService = new ImageService();