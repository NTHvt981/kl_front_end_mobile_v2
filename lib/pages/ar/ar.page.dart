

import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/ar.model.data.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/services/clothes/body_stat.data.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:do_an_ui/shared/ar/image_painter.dart';
import 'package:do_an_ui/shared/clothes/specific_type.enum.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;

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

  final dkey = '[DEBUG AR]';

  late Size _imageSize;
  final Map<EType, ArData> _arDatas = {
    EType.Hat: ArData(type: EType.Hat),
    EType.Shirt: ArData(type: EType.Shirt),
    EType.Pants: ArData(type: EType.Pants),
    EType.Shoes: ArData(type: EType.Shoes),
    EType.Backpack: ArData(type: EType.Backpack),
  };

  //------------------OVERRIDE METHODS----------------------//
  @override
  void initState() {
    super.initState();
    //Initialize clothes item widget
    g_localItemsData.forEach((type , data) async {
      Item? item = data.getCurrentItem();
      if (item != null) {
        _extractArDataFromItem(type, item);
      }
    });
    //Initialize cammera
    _initializeCamera();
  }

  _extractArDataFromItem(EType type, Item item) async {
    final http.Response rawImage = await http.get(Uri.parse(item.imageUrl)).catchError((err) {
      log(dkey + 'get rawImage fail ' + err.toString());
    });
    final ui.Image image = await decodeImageFromList(rawImage.bodyBytes).catchError((err) {
      log(dkey + 'decodeImageFromList fail ' + err.toString());
    });

    final itemSize = g_localItemsData[type]!.getCurrentSize();
    final bodySize = g_bodyStat.toEsize();
    final scale = itemSize!= null? itemSize.isSPSize()? 1 + (itemSize.index - bodySize.index) * 0.15: 1.0: 1.0;
    // log('$dkey itemSize is ${itemSize.name} | bodySize is ${bodySize.name}');
    setState(() {
      _arDatas[type]!.item = item;
      _arDatas[type]!.image = image;
      _arDatas[type]!.scale = scale;
    });
    log('$dkey _extractArDataFromItem (type $type) set scale ${scale.toString()} of item ${item.name}');
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
    _imageSize = _cameraService.getImageSize();
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
      final leftKnee = marks[PoseLandmarkType.leftKnee];
      final rightKnee = marks[PoseLandmarkType.rightKnee];
      final leftEar = marks[PoseLandmarkType.leftEar];
      final rightEar = marks[PoseLandmarkType.rightEar];
      final rightEye = marks[PoseLandmarkType.rightEye];
      final leftWrist = marks[PoseLandmarkType.leftWrist];
      final rightWrist = marks[PoseLandmarkType.rightWrist];
      final leftPinky = marks[PoseLandmarkType.leftPinky];
      final rightPinky = marks[PoseLandmarkType.rightPinky];
      final leftIndex = marks[PoseLandmarkType.leftIndex];
      final rightIndex = marks[PoseLandmarkType.rightIndex];

      if (leftShoulder != null && rightShoulder != null && leftHip != null) {
        _setArShirt(leftShoulder: leftShoulder, rightShoulder: rightShoulder, leftHip: leftHip);
      }

      if (leftAnkle != null && rightAnkle != null && leftShoulder != null
          && rightShoulder != null && leftHip != null && leftKnee != null) {
        final pantsItem = g_localItemsData[EType.Pants]!.getCurrentItem();
        if (pantsItem != null) {
          if (pantsItem.specificType == ESpecificType.ShortSkirt || pantsItem.specificType == ESpecificType.Shorts) {
            _setArPants(
                leftShoulder: leftShoulder,
                rightShoulder: rightShoulder,
                leftHip: leftHip,
                leftAnkle: leftKnee
            );
          } else {
            _setArPants(
                leftShoulder: leftShoulder,
                rightShoulder: rightShoulder,
                leftHip: leftHip,
                leftAnkle: leftAnkle
            );
          }
        }
      }

      if (leftEar != null && rightEar != null && rightEye != null) {
        _setArHat(leftEar: leftEar, rightEar: rightEar, rightEye: rightEye,
            leftShoulder: leftEar, rightShoulder: rightEar);
      }

      if (leftWrist != null && leftPinky != null && leftIndex != null
        && leftShoulder != null && rightShoulder != null && leftHip != null && rightHip != null
      ) {
        _setArBackpack(leftWrist: leftWrist, leftPinky: leftPinky, leftIndex: leftIndex,
            rightShoulder: rightShoulder, leftShoulder: leftShoulder, leftHip: leftHip, rightHip: rightHip);
      }

      if (rightWrist != null && rightPinky != null && rightIndex != null
          && leftShoulder != null && rightShoulder != null && leftHip != null
      ) {
        _setArShoes(rightWrist: rightWrist, rightPinky: rightPinky, rightIndex: rightIndex,
            rightShoulder: rightShoulder, leftShoulder: leftShoulder);
      }
    }

    _cameraMutex = true;
  }



  _setArHat({
    required PoseLandmark leftEar,
    required PoseLandmark rightEar,
    required PoseLandmark rightEye,
    required PoseLandmark leftShoulder,
    required PoseLandmark rightShoulder,
}) {
    if (leftShoulder.x > rightShoulder.x) {
      setState(() {
        _arDatas[EType.Hat]!.canShow = true;
      });
    } else {
      setState(() {
        _arDatas[EType.Hat]!.canShow = false;
      });
    }
    final disEarToEye = (rightEar.y - rightEye.y) * 2;
    setState(() {
      _arDatas[EType.Hat]!.area = Rect.fromLTRB(
        math.min(leftEar.x, rightEar.x),
        rightEye.y - disEarToEye * 3,
        math.max(leftEar.x, rightEar.x),
        rightEye.y - disEarToEye
      );
    });
  }

  _setArShirt({
    required PoseLandmark leftShoulder,
    required PoseLandmark rightShoulder,
    required PoseLandmark leftHip,
  }) {
    if (leftShoulder.x > rightShoulder.x) {
      setState(() {
        _arDatas[EType.Shirt]!.canShow = true;
      });
    } else {
      setState(() {
        _arDatas[EType.Shirt]!.canShow = false;
      });
    }
    setState(() {
      _arDatas[EType.Shirt]!.area = Rect.fromLTRB(
        math.min(leftShoulder.x, rightShoulder.x),
        math.min(leftShoulder.y, leftHip.y),
        math.max(leftShoulder.x, rightShoulder.x),
        math.max(leftShoulder.y, leftHip.y),
      );
    });
  }

  _setArPants({
    required PoseLandmark leftShoulder,
    required PoseLandmark rightShoulder,
    required PoseLandmark leftHip,
    required PoseLandmark leftAnkle,
  }) {
    if (leftShoulder.x > rightShoulder.x) {
      setState(() {
        _arDatas[EType.Pants]!.canShow = true;
      });
    } else {
      setState(() {
        _arDatas[EType.Pants]!.canShow = false;
      });
    }
    setState(() {
      _arDatas[EType.Pants]!.area = Rect.fromLTRB(
        math.min(leftShoulder.x, rightShoulder.x),
        math.min(leftHip.y, leftAnkle.y),
        math.max(leftShoulder.x, rightShoulder.x),
        math.max(leftAnkle.y, leftHip.y),
      );
    });
  }

  _setArShoes({
    required PoseLandmark rightWrist,
    required PoseLandmark rightPinky,
    required PoseLandmark rightIndex,
    required PoseLandmark rightShoulder,
    required PoseLandmark leftShoulder,
  }) {
    final midX = (rightWrist.x + rightPinky.x + rightIndex.x) / 3;
    final midY = (rightWrist.y + rightPinky.y + rightIndex.y) / 3;
    final width = (leftShoulder.x - rightShoulder.x).abs() / 2;
    final height = width / 2;
    setState(() {
      _arDatas[EType.Shoes]!.area = Rect.fromLTRB(
        midX - width/2,
        midY - height/2,
        midX + width/2,
        midY + height/2,
      );
    });
  }

  _setArBackpack({
    required PoseLandmark leftWrist,
    required PoseLandmark leftPinky,
    required PoseLandmark leftIndex,
    required PoseLandmark rightShoulder,
    required PoseLandmark leftShoulder,
    required PoseLandmark leftHip,
    required PoseLandmark rightHip,
  }) {
    if (leftShoulder.x > rightShoulder.x) {
      // setState(() {
      //   _arDatas[BACKPACK]!.canShow = false;
      // });
      final midX = (leftWrist.x + leftPinky.x + leftIndex.x) / 3;
      final midY = (leftWrist.y + leftPinky.y + leftIndex.y) / 3;
      final width = (leftShoulder.x - rightShoulder.x).abs() * 0.8;
      final height = (leftShoulder.y - leftHip.y).abs() * 0.6;
      setState(() {
        _arDatas[EType.Backpack]!.area = Rect.fromLTRB(
          midX - width/2,
          midY - height * 1/3,
          midX + width /2,
          midY + height * 2/3,
        );
      });
    } else {
      // setState(() {
      //   _arDatas[BACKPACK]!.canShow = true;
      // });
      final midX = (leftShoulder.x + rightShoulder.x) / 2;
      final midY = (leftShoulder.y + leftHip.y) / 2.1;
      final width = (leftShoulder.x - rightShoulder.x).abs() * 0.8;
      final height = (leftShoulder.y - leftHip.y).abs() * 0.6;

      setState(() {
        _arDatas[EType.Backpack]!.area = Rect.fromLTRB(
          midX - width/2,
          midY - height/2,
          midX + width/2,
          midY + height/2,
        );
      });
    }
  }

  InputImage _cameraToInputImage(CameraImage image) {
    final WriteBuffer _allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      _allBytes.putUint8List(plane.bytes);
    }
    final bytes = _allBytes.done().buffer.asUint8List();

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());

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
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
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
    );
  }

  Stack _arContent() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraService.cameraController),
        _paintWidget(EType.Hat),
        _paintWidget(EType.Shirt),
        _paintWidget(EType.Pants),
        _paintWidget(EType.Shoes),
        _paintWidget(EType.Backpack),
      ],
    );
  }

  Widget _paintWidget(EType type) {
    return _arDatas[type]!.isValid()? CustomPaint(
      painter: ImagePainter(
        imageSize: _imageSize,
        bound: _arDatas[type]!.area,
        image: _arDatas[type]!.image,
        item: _arDatas[type]!.item,
        externalScale: _arDatas[type]!.scale
      ),
    ): Container();
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
