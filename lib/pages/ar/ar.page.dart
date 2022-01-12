

import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/models/vector.type.dart';
import 'package:do_an_ui/pages/ar/ar_item.widget.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:do_an_ui/pages/clothes/movable_item.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:screenshot/screenshot.dart';

class ArPage extends StatefulWidget {
  @override
  _ArPageState createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> with WidgetsBindingObserver {
  //------------------PRIVATE ATTRIBUTES------------------//
  ScreenshotController _screenshotController = ScreenshotController();
  late Future<void> _initializeCameraFuture;

  final CameraService _cameraService = CameraService();
  bool _isCameraServiceInitialized = false;

  final _poseDetector = GoogleMlKit.vision.poseDetector();
  ArItem _shirt = ArItem();
  ArItem _pants = ArItem();
  ArItem _hat = ArItem();
  ArItem _shoes = ArItem();
  ArItem _backpack = ArItem();

  //------------------OVERRIDE METHODS----------------------//
  @override
  void initState() {
    super.initState();
    //Initialize clothes item widget
    g_localItemsService..forEach((type , service) {
      Item? item = service.itemBehavior.value;
      if (item != null) {
        log("[DEBUG AR] Item type${type}");
        switch (type) {
          case SHIRT:
            log("[DEBUG AR] Receive Shirt");
            _shirt.imageUrl = item.imageUrl;
            break;
          case PANTS:
            log("[DEBUG AR] Receive Pants");
            _pants.imageUrl = item.imageUrl;
            break;
          case HAT:
            log("[DEBUG AR] Receive Hat");
            _hat.imageUrl = item.imageUrl;
            break;
          case SHOES:
            log("[DEBUG AR] Receive Shoes");
            break;
          case BACKPACK:
            log("[DEBUG AR] Receive Backpack");
            break;
        }
      }
    });
    //Initialize cammera
    _initializeCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  //------------------PRIVATE METHODS---------------------//

  /// starts the camera & start framing faces
  _initializeCamera() async {
    _initializeCameraFuture = _cameraService.startService(g_frontCameraDescription);
    await _initializeCameraFuture;

    setState(() {
      _isCameraServiceInitialized = true;
    });

    _streamTrackingPose();
  }

  // DateTime _cameraTimer = DateTime.now();
  // int _cameraWaitTime = 200;
  bool _cameraMutex = true;

  void _streamTrackingPose() {
    _cameraService.cameraController.startImageStream((CameraImage image) async {
      if (_cameraMutex)
      {
        _imageStream(image);
      }
    });
  }

  void _imageStream(CameraImage image) async {
    while (!_cameraMutex);
    _cameraMutex = false;

    InputImage inputImage = _cameraToInputImage(image);

    final List<Pose> poses = await _poseDetector.processImage(inputImage);

    if (poses.isNotEmpty)
    {
      Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      log("[DEBUG AR] Image size(${imageSize.width}, ${imageSize.height})");
      log("[DEBUG AR] Screen size(${_screenSize.width}, ${_screenSize.height})");
      //_setShirtPosition(poses[0], imageSize, _screenSize);

      _setAllArItemPosition(poses[0], imageSize, _screenSize);
    }

    _cameraMutex = true;
  }

  late Size _screenSize;
  late Size _imageSize;

  InputImage _cameraToInputImage(CameraImage image) {
    final WriteBuffer _allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      _allBytes.putUint8List(plane.bytes);
    }
    final bytes = _allBytes.done().buffer.asUint8List();

    _imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationMethods.fromRawValue(_cameraService.cameraRotation.rawValue) ??
            InputImageRotation.Rotation_0deg;

    final InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: _imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  void _setAllArItemPosition(Pose pose, Size imageSize, Size ScreenSize) {
    if (_shirt.imageUrl != null)
    {
      _shirt = _setArItemPosition(pose, imageSize, ScreenSize, _shirt.imageUrl!, ArItemType.shirt);
    }

    if (_pants.imageUrl != null)
    {
      _pants = _setArItemPosition(pose, imageSize, ScreenSize, _pants.imageUrl!, ArItemType.pants);
    }

    if (_hat.imageUrl != null)
    {
      _hat = _setArItemPosition(pose, imageSize, ScreenSize, _hat.imageUrl!, ArItemType.hat);
    }

    setState(() {

    });
  }
  ArItem _setArItemPosition(Pose pose, Size imageSize, Size ScreenSize, String url, ArItemType type) {
    ArItem result = ArItem();
    result.imageUrl = url;

    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
    final leftEar = pose.landmarks[PoseLandmarkType.leftEar];
    final rightEar = pose.landmarks[PoseLandmarkType.rightEar];
    final nose = pose.landmarks[PoseLandmarkType.nose];
    final leftEye = pose.landmarks[PoseLandmarkType.leftEye];
    final leftPinky = pose.landmarks[PoseLandmarkType.leftPinky];
    final leftIndex = pose.landmarks[PoseLandmarkType.leftIndex];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];

    switch (type)
    {
    case ArItemType.shirt:
      if (leftShoulder == null || rightShoulder == null ||
          leftHip       == null || rightHip == null)
      {
        log("[DEBUG AR] Shirt CAN NOT PROCESS");
        return result;
      }

      log("[DEBUG AR] rightShoulder likely hood ${rightShoulder.likelihood}");
      log("[DEBUG AR] rightShoulder z index ${rightShoulder.z}");

      log("[DEBUG AR] leftShoulder(${leftShoulder.x}, ${leftShoulder.y})");
      log("[DEBUG AR] rightShoulder(${rightShoulder.x}, ${rightShoulder.y})");
      log("[DEBUG AR] leftHip(${leftHip.x}, ${leftHip.y})");
      log("[DEBUG AR] rightHip(${rightHip.x}, ${rightHip.y})");

      final middleX = (rightShoulder.x + leftShoulder.x) / 2;
      final middleY = (rightShoulder.y + rightHip.y) / 2;

      result.size = Size((rightShoulder.x - leftShoulder.x).abs(), (rightShoulder.y - rightHip.y).abs());
      result.position.x = rightShoulder.x / 3;
      result.position.y = rightShoulder.y / 3;
      break;
    case ArItemType.pants:
      if (leftAnkle   == null || rightAnkle == null ||
          leftHip     == null || rightHip   == null)
      {
        log("[DEBUG AR] Pants CAN NOT PROCESS");
        return result;
      }

      log("[DEBUG AR] leftAnkle(${leftAnkle.x}, ${leftAnkle.y})");
      log("[DEBUG AR] rightAnkle(${rightAnkle.x}, ${rightAnkle.y})");
      log("[DEBUG AR] leftHip(${leftHip.x}, ${leftHip.y})");
      log("[DEBUG AR] rightHip(${rightHip.x}, ${rightHip.y})");

      final middleX = (leftHip.x + rightHip.x) / 2;
      final middleY = leftAnkle.y > rightAnkle.y ? (leftAnkle.y + rightHip.y) / 2
                                                : (rightAnkle.y + rightHip.y) / 2;
      final ankleWidth = (leftAnkle.x - rightAnkle.x).abs();
      final hipWidth = (leftHip.x - rightHip.x).abs();
      final width = math.max(ankleWidth, hipWidth);
      final height = math.max(rightAnkle.y, leftAnkle.y) - rightHip.y;

      result.size = Size(width*2, height*2);
      result.position.x = rightHip.x / 3 - result.size.width/4;
      result.position.y = middleY / 3 - result.size.height/4;
      break;
    case ArItemType.hat:
      if (leftEye   == null || nose == null ||
          leftEar     == null || rightEar   == null)
      {
        log("[DEBUG AR] Hat CAN NOT PROCESS");
        return result;
      }

      log("[DEBUG AR] leftEye(${leftEye.x}, ${leftEye.y})");
      log("[DEBUG AR] nose(${nose.x}, ${nose.y})");
      log("[DEBUG AR] leftEar(${leftEar.x}, ${leftEar.y})");
      log("[DEBUG AR] rightEar(${rightEar.x}, ${rightEar.y})");

      final distNoseToEye = (nose.y - leftEye.y).abs();
      final middleX = (leftEar.x + rightEar.x) / 2;
      final middleY = leftEye.y - distNoseToEye;
      final width = (leftEar.x - rightEar.x).abs() * 2;
      final height = distNoseToEye * 2 * 2;
      result.size = Size(width, height);
      result.position.x = middleX / 3 + result.size.width/4;
      result.position.y = middleY / 3;// - result.size.height/4;
      break;
    case ArItemType.shoes:
      throw("Shoes not implement");
      break;
    case ArItemType.backpack:
      if (leftPinky   == null || leftWrist == null || leftIndex  == null)
      {
        return result;
      }
      if (leftShoulder == null || rightShoulder == null || rightHip == null)
      {
        return result;
      }
      break;
    }

    return result;
  }

  Future<void> _saveScreenshot() async {  //event
    String randomId = Timestamp.now().nanoseconds.toString();

    var path = await NativeScreenshot.takeScreenshot();
    print(path);

    _screenshotController.capture().then((file) async {
      bool? success = await ImageSave.saveImage(file, "$randomId.png", albumName: "demo");
      if (!success!)
      {
        log("[ERROR] Save not success");
      }
    });
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    if (!_isCameraServiceInitialized) {
      return Container();
    }
    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          // _header(),
          FutureBuilder(
            future: _initializeCameraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    CameraPreview(_cameraService.cameraController),
                    _pants.imageUrl != null? ArItemWidget(_pants.position, _pants.size, _pants.imageUrl!): Container(),
                    _shirt.imageUrl != null? ArItemWidget(_shirt.position, _shirt.size, _shirt.imageUrl!): Container(),
                    _hat.imageUrl != null? ArItemWidget(_hat.position, _hat.size, _hat.imageUrl!): Container(),
                  ],
                );
              }
              else return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return HeaderWidget(
      backgroundColor: Colors.white.withOpacity(0),
      title: TextWidget(
        text: 'WeClothes.',
        size: 24.0,
        bold: true,
        color: DARK_BLUE,
      ),
      textColor: DARK_BLUE,
      // canGoBack: true,
      router: context.router,
    );
  }
}
