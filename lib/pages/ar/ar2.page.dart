

import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/models/vector.type.dart';
import 'package:do_an_ui/pages/ar/ar_item.widget.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/ar/image_painter.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:do_an_ui/pages/clothes/movable_item.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_save/image_save.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;

class Ar2Page extends StatefulWidget {

  @override
  _Ar2PageState createState() => _Ar2PageState();
}

class _Ar2PageState extends State<Ar2Page> with WidgetsBindingObserver {
  //------------------PRIVATE ATTRIBUTES------------------//
  ScreenshotController _screenshotController = ScreenshotController();
  late Future<void> _initializeCameraFuture;

  final CameraService _cameraService = CameraService();
  bool _isCameraServiceInitialized = false;

  final _poseDetector = GoogleMlKit.vision.poseDetector();

  final dkey = '[DEBUG AR]';

  late Size imageSize;

  late Item shirtItem;
  ui.Image? shirtImage;
  Rect? shirtArea;

  late Item pantsItem;
  ui.Image? pantsImage;
  Rect? pantsArea;

  late Item hatItem;
  ui.Image? hatImage;
  Rect? hatArea;

  late Item backPackItem;
  ui.Image? backPackImage;
  Rect? backPackArea;

  late Item shoesItem;
  ui.Image? shoesImage;
  Rect? shoesArea;

  //------------------OVERRIDE METHODS----------------------//
  @override
  void initState() {
    super.initState();
    //Initialize clothes item widget
    g_localItemsService..forEach((type , service) async {
      Item? item = service.itemBehavior.value;
      if (item != null) {
        log("[DEBUG AR] Item type ${type}");
        final http.Response rawImage = await http.get(Uri.parse(item.imageUrl)).catchError((err) {
          log(dkey + 'get rawImage fail ' + err.toString());
        });
        final ui.Image result = await decodeImageFromList(rawImage.bodyBytes).catchError((err) {
          log(dkey + 'decodeImageFromList fail ' + err.toString());
        });
        switch (type) {
          case SHIRT:
            setState(() {
              shirtImage = result;
              shirtItem = item;
            });
            log("[DEBUG AR] Receive Shirt");
            break;

          case HAT:
            setState(() {
              hatImage = result;
              hatItem = item;
            });
            log("[DEBUG AR] Receive Shirt");
            break;

          case PANTS:
            setState(() {
              pantsImage = result;
              pantsItem = item;
            });
            log("[DEBUG AR] Receive Shirt");
            break;

          case BACKPACK:
            setState(() {
              backPackImage = result;
              backPackItem = item;
            });
            log("[DEBUG AR] Receive Shirt");
            break;

          case SHOES:
            setState(() {
              shoesImage = result;
              shoesItem = item;
            });
            log("[DEBUG AR] Receive Shirt");
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

  bool _cameraMutex = true;

  void _streamTrackingPose() {
    imageSize = _cameraService.getImageSize();
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
      final marks = poses[0].landmarks;
      final leftShoulder = marks[PoseLandmarkType.leftShoulder];
      final rightShoulder = marks[PoseLandmarkType.rightShoulder];
      final leftHip = marks[PoseLandmarkType.leftHip];
      final rightHip = marks[PoseLandmarkType.rightHip];
      final leftAnkle = marks[PoseLandmarkType.leftAnkle];
      final rightAnkle = marks[PoseLandmarkType.rightAnkle];
      final leftEar = marks[PoseLandmarkType.leftEar];
      final rightEar = marks[PoseLandmarkType.rightEar];
      final rightEye = marks[PoseLandmarkType.rightEye];
      final leftWrist = marks[PoseLandmarkType.leftWrist];
      final rightWrist = marks[PoseLandmarkType.rightWrist];
      final leftPinky = marks[PoseLandmarkType.leftPinky];
      final rightPinky = marks[PoseLandmarkType.rightPinky];
      final leftIndex = marks[PoseLandmarkType.leftIndex];
      final rightIndex = marks[PoseLandmarkType.rightIndex];

      if (leftShoulder != null && rightShoulder != null && leftHip != null && rightHip != null) {
        setState(() {
          shirtArea = Rect.fromLTRB(
            math.min(leftShoulder.x, rightShoulder.x),
            math.min(leftShoulder.y, leftHip.y),
            math.max(leftShoulder.x, rightShoulder.x),
            math.max(leftShoulder.y, leftHip.y),
          );
        });
        log(dkey + 'shirtArea is not null');
        log(dkey + 'shirtArea (${shirtArea!.left}, ${shirtArea!.top}, ${shirtArea!.right}, ${shirtArea!.bottom})');
      }

      if (leftAnkle != null && rightAnkle != null && leftShoulder != null && rightShoulder != null && leftHip != null) {
        setState(() {
          pantsArea = Rect.fromLTRB(
            math.min(leftShoulder.x, rightShoulder.x),
            math.min(leftHip.y, leftAnkle.y),
            math.max(leftShoulder.x, rightShoulder.x),
            math.max(leftAnkle.y, leftHip.y),
          );
        });
        log(dkey + 'pantsArea is not null');
        log(dkey + 'pantsArea (${shirtArea!.left}, ${shirtArea!.top}, ${shirtArea!.right}, ${shirtArea!.bottom})');
      }

      if (leftEar != null && rightEar != null && rightEye != null) {
        final disEarToEye = (rightEar.y - rightEye.y) * 2;
        setState(() {
          hatArea = Rect.fromLTRB(
            math.min(leftEar.x, rightEar.x),
            rightEye.y - disEarToEye * 3,
            math.max(leftEar.x, rightEar.x),
            rightEye.y - disEarToEye
          );
        });
      }

      if (leftWrist != null && leftPinky != null && leftIndex != null
        && leftShoulder != null && rightShoulder != null && leftHip != null
      ) {
        final midX = (leftWrist.x + leftPinky.x + leftIndex.x) / 3;
        final midY = (leftWrist.y + leftPinky.y + leftIndex.y) / 3;
        final width = (leftShoulder.x - rightShoulder.x).abs() * 0.8;
        final height = (leftShoulder.y - leftHip.y).abs() * 0.6;
        setState(() {
          backPackArea = Rect.fromLTRB(
            midX - width/2,
            midY - height * 1/3,
            midX + width /2,
            midY + height * 2/3,
          );
        });
      }

      if (rightWrist != null && rightPinky != null && rightIndex != null
          && leftShoulder != null && rightShoulder != null && leftHip != null
      ) {
        final midX = (rightWrist.x + rightPinky.x + rightIndex.x) / 3;
        final midY = (rightWrist.y + rightPinky.y + rightIndex.y) / 3;
        final width = (leftShoulder.x - rightShoulder.x).abs() / 2;
        final height = width / 2;
        setState(() {
          shoesArea = Rect.fromLTRB(
            midX - width/2,
            midY - height/2,
            midX + width/2,
            midY + height/2,
          );
        });
      }
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

  Future<void> _saveScreenshot() async {  //event
    String randomId = Timestamp.now().nanoseconds.toString();

    String? path = await NativeScreenshot.takeScreenshot().catchError((err) {
      print('Save screenshot fail ${err.toString()}');
    }).then((path) {
      print('Native screenshot in then path: $path');
    });
    print('Native screenshot path: $path');
    if (path == null) {
      Fluttertoast.showToast(msg: 'Save screenshot fail');
    } else {
      Fluttertoast.showToast(msg: 'Save screenshot success, path $path');
    }

    // _screenshotController.capture().then((file) async {
    //   bool? success = await ImageSave.saveImage(file, "$randomId.png", albumName: "demo");
    //   if (success == null) {
    //     log("[ERROR] Save not success");
    //   }
    //   else if (success) {
    //     Fluttertoast.showToast(msg: 'Save screenshot to library');
    //   }
    // });
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    if (!_isCameraServiceInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: FutureBuilder(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _arContent();
                }
                else return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _header(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveScreenshot,
      ),
    );
  }

  Stack _arContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraService.cameraController),
        (shirtArea != null && shirtImage != null)? CustomPaint(
          painter: ImagePainter(
            imageSize: imageSize,
            bound: shirtArea!,
            image: shirtImage!,
            item: shirtItem
          ),
        ): Container(),

        (pantsArea != null && pantsImage != null)? CustomPaint(
          painter: ImagePainter(
              imageSize: imageSize,
              bound: pantsArea!,
              image: pantsImage!,
              item: pantsItem
          ),
        ): Container(),

        (hatArea != null && hatImage != null)? CustomPaint(
        painter: ImagePainter(
            imageSize: imageSize,
            bound: hatArea!,
            image: hatImage!,
            item: hatItem
          ),
        ): Container(),

        (backPackArea != null && backPackImage != null)? CustomPaint(
          painter: ImagePainter(
              imageSize: imageSize,
              bound: backPackArea!,
              image: backPackImage!,
              item: backPackItem
          ),
        ): Container(),

        (shoesArea != null && shoesImage != null)? CustomPaint(
          painter: ImagePainter(
              imageSize: imageSize,
              bound: shoesArea!,
              image: shoesImage!,
              item: shoesItem
          ),
        ): Container()
      ],
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
      canGoBack: true,
    );
  }

  String _toLog(PoseLandmark mark) {
    final x = mark.x;
    final y = mark.y;
    return '($x, $y)';
  }
}
