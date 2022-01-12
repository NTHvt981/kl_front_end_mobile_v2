
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:do_an_ui/models/local_user.model.dart';
import 'package:do_an_ui/pages/face_recognition/face_reg_camera.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/services/face_recognition/face.database.dart';
import 'package:do_an_ui/services/face_recognition/facenet.service.dart';
import 'package:do_an_ui/services/face_recognition/ml_kit.service.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/face_recognition/camera_header.dart';
import 'package:do_an_ui/shared/floating_camera.widget.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class SaveFacePage extends StatefulWidget {
  final CameraDescription cameraDescription;
  final String email;
  final String password;

  const SaveFacePage({
    Key? key,
    required this.cameraDescription,
    required this.email,
    required this.password
  }) : super(key: key);

  @override
  SaveFacePageState createState() => SaveFacePageState();
}

class SaveFacePageState extends State<SaveFacePage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  late String imagePath;
  Face? faceDetected;
  late Size imageSize;

  bool _detectingFaces = false;
  bool _isPictureTaken = false;

  late Future _initializeControllerFuture;
  bool _isCameraServiceInitialized = false;

  // switchs when the user press the camera
  bool _saving = false;

  //---------------service injection----------------------//
  final MLKitService _mlKitService = MLKitService();
  final CameraService _cameraService = CameraService();
  final FaceNetService _faceNetService = FaceNetService();
  final _dataBaseService = FaceDatabase();

  //------------------OVERRIDE----------------------------//
  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
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
    _initializeControllerFuture = _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;
    _mlKitService.initialize(_cameraService);

    setState(() {
      _isCameraServiceInitialized = true;
    });

    _streamDetectFace();
  }

  /// draws rectangles when detects faces
  _streamDetectFace() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((CameraImage image) async {
      if (_detectingFaces) return;
      else _detectingFaces = true;

      await _tryDetectFace(image);

      _detectingFaces = false;
    });
  }

  _tryDetectFace(CameraImage image) async {
    try {
      await _detectFace(image);
    } catch (e) {
      log("[ERROR] ${e.toString()}");
    }
  }

  _detectFace(CameraImage image) async {
    List<Face> faces = await _mlKitService.getFacesFromImage(image);

    log("[DEBUG] call _detectFace");
    if (faces.length > 0) {
      log("[DEBUG] faces.length > 0");
      setState(() {
        faceDetected = faces[0];
        _detectingFaces = true;
      });

      // if (_saving && faceDetected != null) {
        _faceNetService.setCurrentPrediction(image, faceDetected!);
        setState(() {
          _saving = false;
        });
      // }
    } else {
      setState(() {
        faceDetected = null;
        _detectingFaces = false;
      });
    }
  }

  /// handles the button pressed event
  _onTakePicture() async {
    if (faceDetected == null) {
      Fluttertoast.showToast(msg: "No face detected!");
    } else {
      _saving = true;

      //we use delay so that _faceNetService.setCurrentPrediction get called (in dif thread)
      await _cameraService.cameraController.stopImageStream();
      await _saveCredentialToLocalDB(widget.email, widget.password);
      Fluttertoast.showToast(msg: "Save credential success!");
      await Future.delayed(Duration(milliseconds: 200));
      context.router.pop();
    }
  }

  _returnToPreviousPage() {
    context.router.pop();
  }

  _resetFaceDetection() {    //Not use currently
    setState(() {
      _isCameraServiceInitialized = false;
      _isPictureTaken = false;
    });
    this._initializeCamera();
  }

  _saveCredentialToLocalDB(String email, String password) async {
    /// gets predicted data from facenet service (user face detected)
    var predictedData = _faceNetService.predictedFaceData;

    var dataBaseService = FaceDatabase();
    if (predictedData == null)
      {
        throw("[ERROR] _saveCredentialToLocalDB predictedData is null");
      }
    /// creates a new user in the 'database'
    await dataBaseService.save(
        email,
        password,
        predictedData);

    /// resets the face stored in the face net service
    this._faceNetService.setPredictedData(null);
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_isPictureTaken) {
                  return Container(
                    width: width,
                    height: height,
                    child: Transform(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.file(File(imagePath)),
                        ),
                        transform: Matrix4.rotationY(mirror)),
                  );
                } else {
                  return FaceRegCameraWidget(
                      cameraController: _cameraService.cameraController,
                      faceDetected: faceDetected,
                      imageSize: imageSize
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          _header(),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(16.0),
            child: _btnTakePicture(),),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(16.0),
            child: _btnEraseAllFaces(),)
        ]),
      // floatingActionButton: FloatingCameraWidget(
      //   onPress: _onTakePicture,
      // ),
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
      canGoBack: true,
      router: context.router,
    );
  }


  Widget _btnTakePicture() {
    return ClipOval(
      child: Material(
        color: MEDIUM_BLUE, // Button color
        child: InkWell(
          splashColor: DARK_BLUE, // Splash color
          onTap: _onTakePicture,
          child: SizedBox(
              width: 56, height: 56,
              child: Icon(Icons.camera_alt_outlined, color: WHITE,)
          ),
        ),
      ),
    );
  }

  Widget _btnEraseAllFaces() {
    return ClipOval(
      child: Material(
        color: MEDIUM_BLUE, // Button color
        child: InkWell(
          splashColor: DARK_BLUE, // Splash color
          onTap: () {
            _dataBaseService.clearAll();
            Fluttertoast.showToast(msg: 'Remove all registered face');
          },
          child: SizedBox(
              width: 56, height: 56,
              child: Icon(Icons.refresh, color: WHITE)
          ),
        ),
      ),
    );
  }
}