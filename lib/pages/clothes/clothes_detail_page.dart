import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/main.dart';
import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/pages/clothes/select_item_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/clothes_collection_service.dart';
import 'package:do_an_ui/services/item_service.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:do_an_ui/shared/clothes_bottom_navigation.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'movable_item_widget.dart';

class ClothesDetailPage extends StatefulWidget {
  final String userId;

  ClothesDetailPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _ClothesDetailPageState createState() => _ClothesDetailPageState();
}

class _ClothesDetailPageState extends State<ClothesDetailPage> {
  Offset hatOffset = Offset(150, 75);
  bool showItemPanel = false;

  List<MovableItemWidget> itemList = [];
  List<Item> allItems = [];
  List<Item> displayedItems = [];

  ScreenshotController screenshotController = ScreenshotController();

  FirebaseStorage storage = FirebaseStorage.instance;

  final List<String> bgUrls = [

  ];

  @override
  void initState() {
    super.initState();
    itemService.readAllLive().listen((items) {
      setState(() {
        allItems = items;
      });
    });

    setDefaultItemList();
  }

  void onItemPress(String _type) {

    List<Item> _displayedItems = [];
    allItems.forEach((item) {
      if (item.type == _type)
        _displayedItems.add(item);
    });

    SelectItemDialogHelper.show(context, _displayedItems, _type);
  }

  void onItemMovePress(MovableItemWidget caller) {
    setState(() {
      itemList.remove(caller);
      itemList.add(caller);
    });
  }

  void reNewAllItems() {
    localItemService.forEach((key, value) {
      value.clear();
    });
  }

  void saveCollection() {
    String randomId = Timestamp.now().nanoseconds.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    screenshotController.capture().then((file) {
      storage.ref('QuanAo/$randomId.png').putFile(File.fromRawPath(file!)).then((snapshot) async {
        String imageUrl = await snapshot.ref.getDownloadURL().then((value) => value);

        log('upload file success, url: $imageUrl');

        clothesCollectionService.create(uid, imageUrl);
      });
    });
  }

  void goToArPage() {
    List<MovableItemWidget> itemsForAr = [];
    itemList.forEach((item) {
        if (localItemService[item.type]!.itemBehavior.value != null)
        {
          item.imageUrl = localItemService[item.type]!.itemBehavior.value!.imageUrl;
          itemsForAr.add(item);
        }
    });

    debugPrint(itemsForAr.length.toString());
    context.router.push(ArPageRoute(itemList: itemsForAr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobe!'),
        actions: [
          IconButton(icon: Icon(Icons.autorenew), onPressed: reNewAllItems),
          IconButton(icon: Icon(Icons.save), onPressed: saveCollection),
          IconButton(icon: Icon(Icons.camera_alt_outlined), onPressed: goToArPage),
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              ...itemList,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: () {},
      ),
      bottomNavigationBar: ClothesBottomNavigation(index: CLOTHES_DETAIL_PAGE,),
    );
  }

  void setDefaultItemList() {
    itemList.add(MovableItemWidget(
      key: GlobalKey(),
      type: HAT,
      width: 50,
      height: 50,
      onPress: onItemPress,
      onPositionPress: onItemMovePress,
      imageUrl: 'images/icon_clothes_hat.png',
    ));

    itemList.add(MovableItemWidget(
      key: GlobalKey(),
      type: SHIRT,
      width: 125,
      height: 125,
      onPress: onItemPress,
      onPositionPress: onItemMovePress,
      imageUrl: 'images/icon_clothes_shirt.png',
    ));

    itemList.add(MovableItemWidget(
      key: GlobalKey(),
      type: PANTS,
      width: 150,
      height: 150,
      onPress: onItemPress,
      onPositionPress: onItemMovePress,
      imageUrl: 'images/icon_clothes_pants.png',
    ));
    itemList.add(MovableItemWidget(
      key: GlobalKey(),
      type: SHOES,
      width: 50,
      height: 50,
      onPress: onItemPress,
      onPositionPress: onItemMovePress,
      imageUrl: 'images/icon_clothes_shoes.png',
    ));
    itemList.add(MovableItemWidget(
      key: GlobalKey(),
      type: BACKPACK,
      width: 75,
      height: 75,
      onPress: onItemPress,
      onPositionPress: onItemMovePress,
      imageUrl: 'images/icon_clothes_backpack.png',
    )); //Backpack
  }
}
