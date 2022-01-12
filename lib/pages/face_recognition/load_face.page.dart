
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:do_an_ui/models/local_user.model.dart';
import 'package:do_an_ui/pages/face_recognition/face_reg_camera.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/services/face_recognition/facenet.service.dart';
import 'package:do_an_ui/services/face_recognition/ml_kit.service.dart';
import 'package:do_an_ui/services/user.data.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/face_recognition/camera_header.dart';
import 'package:do_an_ui/shared/floating_camera.widget.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'accounts.dialog.dart';

class LoadFacePage extends StatefulWidget {
  final CameraDescription cameraDescription;

const LoadFacePage({
  Key? key,
  required this.cameraDescription
}) : super(key: key);

  @override
  LoadFacePageState createState() => LoadFacePageState();
}

class LoadFacePageState extends State<LoadFacePage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  late String imagePath;
  Face? faceDetected;
  late Size imageSize;

  bool _detectingFacesMutex = false;
  bool _isPictureTaken = false;

  late Future _initializeControllerFuture;
  bool isCameraInitialized = false;

  // switchs when the user press the camera
  bool _saving = false;

  //---------------service injection----------------------//
  final MLKitService _mlKitService = MLKitService();
  final CameraService _cameraService = CameraService();
  final FaceNetService _faceNetService = FaceNetService();

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
      isCameraInitialized = true;
    });

    _streamDetectFace();
  }

  /// draws rectangles when detects faces
  _streamDetectFace() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_detectingFacesMutex) return;
      _detectingFacesMutex = true;

      await _tryDetectFace(image);

      _detectingFacesMutex = false;
    });
  }

  _tryDetectFace(dynamic image) async {
    try {
      await _detectFace(image);
    } catch (e) {
      print(e);
    }
  }

  _detectFace(dynamic image) async {
    List<Face> faces = await _mlKitService.getFacesFromImage(image);

    if (faces.length > 0) {
      setState(() {
        faceDetected = faces[0];
      });

      // if (_saving) {
      _faceNetService.setCurrentPrediction(image, faceDetected!);
      setState(() {
        _saving = false;
      });
      // }
    } else {
      setState(() {
        faceDetected = null;
      });
    }
  }

  /// handles the button pressed event
  _onDetectFace() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );
    } else {
      _saving = true;

      //we use delay so that _faceNetService.setCurrentPrediction get called (in dif thread)
      EasyLoading.show(status: 'loading credentials...');
      await Future.delayed(Duration(milliseconds: 3000));
      EasyLoading.dismiss();
      // await _cameraService.cameraController.stopImageStream();
      // LocalUser? user = _getUser();
      // if (user != null) {
      //   _login(user.email, user.password);
      // }
      final users = _getUsers(1);
      if (users.isNotEmpty) {
        showDialog(context: context, builder: (context) {
          return AccountsDialog(
            users: users,
            onSelectUser: _loginUser,
          );
        });
      } else {
        Fluttertoast.showToast(msg: "User not found",);
      }
    }
  }

  _returnToPreviousPage() {
    context.router.pop();
  }

  _loginUser(LocalUser user) {
    _login(user.email, user.password);
  }
  
  _login(email, password) {
    var auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((cred) {
      Fluttertoast.showToast(msg: "Sign in success",);
      _tryGoToApp(cred.user!);
    }).catchError((err) {
      var ex = err as FirebaseAuthException;
      Fluttertoast.showToast(msg: "Error sign in ${err.message}",);
    });
  }

  void _tryGoToApp(User user) async {
    await user.reload();
    g_userData = UserData(uid: user.uid);
    if (user.emailVerified) {
      // await Fluttertoast.showToast(msg: 'Sign in success');
      await EasyLoading.showSuccess('Sign in success', duration: Duration(seconds: 1));
      g_userData = UserData(uid: user.uid);
      _goToApp();
    } else {
      await Fluttertoast.showToast(msg: 'Your email has not yet verified!');
      _reSendVerifyEmail(user);
    }
  }

  void _reSendVerifyEmail(User user) {
    user.sendEmailVerification().catchError((err) {
      Fluttertoast.showToast(msg: 'Send verify email fail ${err.toString()}');
    }).then((value) {
      Fluttertoast.showToast(msg: 'We have sent you a verify email, please check it');
      context.router.pop();
    });
  }

  void _goToApp() {
    context.router.push(NewsListPageRoute());
  }

  _resetFaceDetection() {    //Not use currently
    setState(() {
      isCameraInitialized = false;
      _isPictureTaken = false;
    });
    this._initializeCamera();
  }

  LocalUser? _getUser() {
    log('[LoadFace] call _getUser');
    String? emailAndPass = _faceNetService.predictUser();
    if (emailAndPass != null)
      {
        var user = LocalUser.Parse(emailAndPass);
        return user;
      }
    return null;
  }

  List<LocalUser> _getUsers(double threshold) {
    log('[LoadFace] call _getUsers');
    List<LocalUser> result = List.empty(growable: true);
    List<String> emailAndPassList = _faceNetService.predictUsers(threshold);
    emailAndPassList.forEach((emailAndPass) {
      var user = LocalUser.Parse(emailAndPass);
      result.add(user);
    });

    return result;
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
          ],
        ),
      floatingActionButton: FloatingCameraWidget(
        onPress: _onDetectFace,
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
      canGoBack: true,
      router: context.router,
    );
  }
}