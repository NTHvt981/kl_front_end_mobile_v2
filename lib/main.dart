
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/services/face_recognition/face.database.dart';
import 'package:do_an_ui/services/face_recognition/facenet.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future _getCameraDesciption() async
{
  g_cameraDescriptions = await availableCameras();

  /// takes the front camera
  try {
    g_frontCameraDescription = g_cameraDescriptions.firstWhere(
          (CameraDescription camera) =>
      camera.lensDirection == CameraLensDirection.front,
    );
  } catch(exept) {
    log('[DEBUG MAIN] USE FAKE CAMERA FRONT');
    g_frontCameraDescription = CameraDescription(
        name: "Fake", lensDirection: CameraLensDirection.front, sensorOrientation: 0);
  }

  /// takes the front camera
  try {
    g_backCameraDescription = g_cameraDescriptions.firstWhere(
          (CameraDescription camera) =>
      camera.lensDirection == CameraLensDirection.back,
    );
  } catch (exception) {
    log('[DEBUG MAIN] USE FAKE CAMERA BACK');
    g_backCameraDescription = CameraDescription(
        name: "Fake", lensDirection: CameraLensDirection.back, sensorOrientation: 0);
  }
}

void _initEasyLoading() {
  EasyLoading.instance
      ..textColor = DARK_BLUE
      ..indicatorColor = DARK_BLUE
      ..progressColor = DARK_BLUE
      ..progressColor = DARK_BLUE;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _getCameraDesciption();

  // start the services
  await FaceNetService().loadModel();
  await FaceDatabase().load();

  await Firebase.initializeApp();

  _initEasyLoading();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'WeClothes',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: EasyLoading.init(),
    );
  }

  static const _kFontFam = 'MyFont';
  static const _kFontPkg = null;

  static const IconData ic_save = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_folder_open = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_renew = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_shopping_cart = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_cog = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
