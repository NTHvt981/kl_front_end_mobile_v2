import 'package:do_an_ui/services/face_recognition/camera.service.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class MLKitService {
  // singleton boilerplate
  static final MLKitService _cameraServiceService = MLKitService._internal();

  factory MLKitService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  MLKitService._internal();

  // service injection
  late CameraService _cameraService;

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => this._faceDetector;

  void initialize(CameraService i_cameraService) {
    this._faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );

    this._cameraService = i_cameraService;
  }

  Future<List<Face>> getFacesFromImage(CameraImage image) async {
    /// preprocess the image  🧑🏻‍🔧
    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation: _cameraService.cameraRotation,
      inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw)!,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    /// Transform the image input for the _faceDetector 🎯
    InputImage _firebaseVisionImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      inputImageData: _firebaseImageMetadata,
    );

    /// proces the image and makes inference 🤖
    List<Face> faces =
        await this._faceDetector.processImage(_firebaseVisionImage);
    return faces;
  }
}

late MLKitService g_mlKitService = MLKitService();
