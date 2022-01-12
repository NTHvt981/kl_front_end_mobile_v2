import 'package:camera/camera.dart';
import 'package:do_an_ui/shared/face_recognition/face_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceRegCameraWidget extends StatelessWidget {
  final CameraController cameraController;
  final Face? faceDetected;
  final Size imageSize;

  FaceRegCameraWidget({
    Key? key,
    required this.cameraController,
    required this.faceDetected,
    required this.imageSize
    }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Transform.scale(
      scale: 1.0,
      child: AspectRatio(
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Container(
              width: width,
              height: width * cameraController.value.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(cameraController),
                  faceDetected != null? CustomPaint(
                    painter: FacePainter(
                        face: faceDetected!,
                        imageSize: imageSize),
                  ): Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
