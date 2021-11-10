

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/pages/clothes/ar_movable_item_widget.dart';
import 'package:do_an_ui/pages/clothes/movable_item_widget.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ui/main.dart';
import 'package:screenshot/screenshot.dart';

class ArPage extends StatefulWidget {
  late List<MovableItemWidget> itemList;

  ArPage({
    Key? key,
    required this.itemList
  }): super(key: key);

  @override
  _ArPageState createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> with WidgetsBindingObserver {
  ScreenshotController screenshotController = ScreenshotController();
  List<ArMovableItemWidget> arItemList = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    widget.itemList.forEach((item) {
      arItemList.add(ArMovableItemWidget(item: item, onPositionPress: onItemMovePress));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller.description);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    await controller.dispose();

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        children: [
          CameraPreview(controller),
          Scaffold(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            appBar: AppBar(
              title: Text('Your Wardrobe!'),
              actions: [
                IconButton(icon: Icon(Icons.camera_alt_outlined), onPressed: saveScreenshot),
              ],
            ),
            drawer: MyDrawer(),
            body: Stack(
              children: [
                ...arItemList,
              ],
            ),
          )
        ],
      ),
    );
  }

  void onItemMovePress(ArMovableItemWidget caller) {
    setState(() {
      arItemList.remove(caller);
      arItemList.add(caller);
    });
  }

  Future<void> saveScreenshot() async {
    String randomId = Timestamp.now().nanoseconds.toString();

    //var path = await NativeScreenshot.takeScreenshot();
    //print(path);

    // screenshotController.capture().then((file) async {
    //   // storage.ref('QuanAo/$randomId.png').putFile(File.fromRawPath(file!)).then((snapshot) async {
    //   //   String imageUrl = await snapshot.ref.getDownloadURL().then((value) => value);
    //
    //     // log('upload file success, url: $imageUrl');
    //
    //     //clothesCollectionService.create(uid, imageUrl);
    //   // });
    //   bool? success = await ImageSave.saveImage(file, "$randomId.png", albumName: "demo");
    //   if (!success!)
    //     {
    //       log("Save not success");
    //     }
    // });
  }
}
