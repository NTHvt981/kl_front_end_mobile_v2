import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/main.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/clothes/select_item.dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/services/image.service.dart';
import 'package:do_an_ui/shared/common.dart';
import 'package:flutter/services.dart';
import '../make_order/cart.page.dart';
import 'package:do_an_ui/pages/order/create_order.page.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/clothes_collection.service.dart';
import 'package:do_an_ui/services/item.service.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/floating_camera.widget.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'items.drawer.dart';
import 'package:do_an_ui/shared/percentage_pos.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/rounded_button.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/text.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'movable_item.widget.dart';

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
  //------------------PRIVATE ATTRIBUTES------------------//
  Map<String, MovableItemWidget> _itemWidgets = {};
  List<Item> _allItems = [];
  List<Item> _displayedItems = [];
  String _displayedType = '';
  final _screenshotController = ScreenshotController();
  final _imageService = g_imageService;
  final DEBUG_KEY = "[DEBUG CLOTHES DETAIL]";

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();
    g_itemService.readAllLive().listen((items) {
      log(DEBUG_KEY + 'Read all items length ${items.length}');
      setState(() {
        _allItems = items;
      });
    });

    _setDefaultItemWidgets();
  }

  //------------------PRIVATE METHODS---------------------//
  void _onItemPress(String type) {
    _displayedItems.clear();
    _allItems.forEach((item) {
      if (item.type == type)
        _displayedItems.add(item);
    });

    setState(() {
      _displayedType = type;
    });

    // SelectItemDialogHelper.show(context, _displayedItems, _type);
    _scaffoldKey.currentState!.openDrawer();
  }

  void _onItemMovePress(MovableItemWidget caller) {
    setState(() {
    });
  }

  _goToOrder() async {
    context.router.push(CartPageRoute(userId: widget.userId));
  }

  void _goToCollections() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    context.router.push(CollectionListPageRoute(userId: uid));
  }

  void _onSaveCollection() async {
    String randomId = Timestamp.now().nanoseconds.toString();

    var imageData = await _imageService.takeScreenShot(_screenshotController);
    if (imageData == null) return;

    var imageUrl = await _imageService.uploadScreenShot(imageData, randomId);

    var result = await _saveCollection(widget.userId, imageUrl);
    if (result) {
      _goToCollections();
    }
  }

  Future<bool> _saveCollection(String uid, String imageUrl) async {
    var result = false;

    await clothesCollectionService.create(uid, imageUrl).then(
        (value) {
          log(DEBUG_KEY + "Save collection to firebase success");
          result = true;
        },
        onError: (err) {
          log(DEBUG_KEY + "Save collection to firebase error: ${err.toString()}");
          result = true;
        }
        );
    return result;
  }

  void _goToArPage() {
    // context.router.push(ArPageRoute());
    context.router.push(Ar2PageRoute());
  }

  void _onRefresh() {
    g_localItemsService..forEach((type , service) {
      service.clear();
    });
    setState(() {});
  }

  //------------------UI WIDGETS--------------------------//
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final newSize = MediaQuery
        .of(context)
        .size;
    if (g_screenSize.width != newSize.width) {
      g_screenSize = newSize;

      log('[CLOTHES DETAIL] set g_screenSize ${g_screenSize.toString()}');
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SettingDrawerWidget(),
      drawer: ItemsDrawerWidget(items: _displayedItems, type: _displayedType,),
      body: Container(
        color: WHITE,
        child: PercentageSizeWidget(
          percentageHeight: 0.9,
          child: Stack(children: [
            _header(),
            Screenshot(
              controller: _screenshotController,
              child: Stack(
                children: [
                  ..._itemWidgets.values,
                  _btnGoToOrder(),
                  _btnSave(),
                  _btnGoToCollections(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(16.0),
              child: _btnRefresh(),),
          ],),
        ),
      ),
      floatingActionButton: _btnGoToAr(),
      bottomNavigationBar: BottomNavWidget(index: CLOTHES_PAGE_ID,),
    );
  }

  Widget _btnRefresh() {
    return ClipOval(
      child: Material(
        color: MEDIUM_BLUE, // Button color
        child: InkWell(
          splashColor: DARK_BLUE, // Splash color
          onTap: _onRefresh,
          child: SizedBox(
              width: 56, height: 56,
              child: Icon(Icons.refresh, color: WHITE,)
          ),
        ),
      ),
    );
  }

  PercentagePosWidget _btnGoToOrder() {
    return PercentagePosWidget(
                percentageBottom: 0.02,
                percentageLeft: 0.05,
                child: PercentageSizeWidget(
                  percentageWidth: 0.2,
                  percentageHeight: 0.08,
                  child: RoundedButtonWidget(
                    backgroundColor: DARK_BLUE,
                    borderColor: DARK_BLUE,
                    onTap: _goToOrder,
                    child: Icon(Icons.shopping_bag_outlined, color: WHITE,),
                  ),
                )
              );
  }

  PercentagePosWidget _btnSave() {
    return PercentagePosWidget(
        percentageBottom: 0.12,
        percentageLeft: 0.05,
        child: PercentageSizeWidget(
          percentageWidth: 0.2,
          percentageHeight: 0.08,
          child: RoundedButtonWidget(
            backgroundColor: DARK_BLUE,
            borderColor: DARK_BLUE,
            onTap: _onSaveCollection,
            child: Icon(Icons.save, color: WHITE,),
          ),
        )
    );
  }

  PercentagePosWidget _btnGoToCollections() {
    return PercentagePosWidget(
        percentageBottom: 0.22,
        percentageLeft: 0.05,
        child: PercentageSizeWidget(
          percentageWidth: 0.2,
          percentageHeight: 0.08,
          child: RoundedButtonWidget(
            backgroundColor: DARK_BLUE,
            borderColor: DARK_BLUE,
            onTap: _goToCollections,
            child: Icon(Icons.folder_open, color: WHITE,),
          ),
        )
    );
  }

  Widget _btnGoToAr() {
    return FloatingCameraWidget(
      onPress: _goToArPage,
    );
  }

  Widget _header() {
    return HeaderWidget(
      title: TextWidget(
        text: 'WeClothes.',
        size: 24.0,
        bold: true,
        color: BLACK,
      ),
    );
  }

  //------------------PRIVATE METHODS---------------------//
  void _setDefaultItemWidgets() {
    _itemWidgets[HAT] = MovableItemWidget(
      key: GlobalKey(),
      type: HAT,
      onPress: _onItemPress,
      onPositionPress: _onItemMovePress,
    );

    _itemWidgets[SHIRT] = MovableItemWidget(
      key: GlobalKey(),
      type: SHIRT,
      onPress: _onItemPress,
      onPositionPress: _onItemMovePress,
    );

    _itemWidgets[PANTS] = MovableItemWidget(
      key: GlobalKey(),
      type: PANTS,
      onPress: _onItemPress,
      onPositionPress: _onItemMovePress,
    );

    _itemWidgets[SHOES] = MovableItemWidget(
      key: GlobalKey(),
      type: SHOES,
      onPress: _onItemPress,
      onPositionPress: _onItemMovePress,
    );

    _itemWidgets[BACKPACK] = MovableItemWidget(
      key: GlobalKey(),
      type: BACKPACK,
      onPress: _onItemPress,
      onPositionPress: _onItemMovePress,
    );
  }
}
