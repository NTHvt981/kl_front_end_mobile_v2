import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/pages/clothes/selectable.items2.drawer.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import '../../services/clothes/body_stat.data.dart';
import 'package:do_an_ui/services/clothes/collection.service.dart';
import 'package:do_an_ui/services/clothes/item.service.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/services/image.service.dart';
import 'package:do_an_ui/shared/common.dart';
import '../../shared/clothes/size.enum.dart';
import 'package:flutter/services.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/floating_camera.widget.dart';
import '../../shared/widgets/header.widget.dart';
import '../../shared/widgets/percentage_pos.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:screenshot/screenshot.dart';
import 'immovable.item.widget.dart';
import 'selectable.items.drawer.dart';

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
  List<Item> _allItems = [];
  List<Item> _displayedItems = [];
  EType _displayedType = EType.Hat;
  final _screenshotController = ScreenshotController();
  final _imageService = g_imageService;
  final dkey = "[ClothesDetail2Page]";

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();
    log(dkey + 'call initState');
    g_itemService.readAllLive().listen((items) {
      log(dkey + 'Read all items length ${items.length}');
      setState(() {
        _allItems = items;
      });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  _goToOrder() async {
    context.router.push(CartPageRoute(userId: widget.userId));
  }

  void _goToCollections() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await context.router.push(CollectionListPageRoute(userId: uid));
    setState(() { });
  }

  void _onSaveCollection() async {
    String randomId = Timestamp.now().nanoseconds.toString();

    var imageData = await _imageService.takeScreenShot(_screenshotController);
    if (imageData == null) return;

    var imageUrl = await _imageService.uploadFileData(imageData, randomId);

    var result = await _saveCollection(widget.userId, imageUrl);
    if (result) {
      _goToCollections();
    }
  }

  Future<bool> _saveCollection(String uid, String imageUrl) async {
    EasyLoading.show(status: 'Saving...');
    var result = await g_collection2Service.create(uid, imageUrl);
    await EasyLoading.dismiss();
    if (result) {
      await EasyLoading.showSuccess('Save success', duration: Duration(seconds: 1));
    } else {
      await EasyLoading.showError('Save fail', duration: Duration(seconds: 1));
    }
    return result;
  }

  void _goToArPage() {
    // context.router.push(ArPageRoute());
    context.router.push(ArPageRoute());
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
      endDrawer: SettingDrawer(),

      drawer: SelectableItems2Drawer(
        items: _displayedItems,
        type: _displayedType,
        onAddItem: _onAddItem,
        onRemoveItem: _onRemoveItem,
        onChangeSize: _onChangeSize,
      ),

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
                  _item(EType.Hat),
                  _item(EType.Shirt),
                  _item(EType.Pants),
                  _item(EType.Shoes),
                  _item(EType.Backpack),
                  _btnGoToOrder(),
                  _btnSave(),
                  _btnGoToCollections(),
                  _rowHeightWeight()
                ],
              ),
            ),
          ],),
        ),
      ),
      floatingActionButton: _btnGoToAr(),
      bottomNavigationBar: BottomNavWidget(index: CLOTHES_PAGE_ID,),
    );
  }

  Widget _item(EType type) {
    // return ImmovableItemWidget(
    //               type: type,
    //               onOpenDrawer: _onOpenDrawer,
    //               onSwitchIndex: _onSwitchIndex,
    //             );
    return ImmovableItemWidget(
      type: type,
      onOpenDrawer: _onOpenDrawer,
      onSwitchIndex: _onSwitchIndex,
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
  void _onOpenDrawer(EType type) {
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

  void _onSwitchIndex(EType type) {
    log('[DEBUG CLOTHES DETAIL] call _onSwitchIndex type $type');
    // final items = _mapAllItems[type]!;
    // var currentId = _mapShownIndex[type];
    final data = g_localItemsData[type]!;
    final items = data.getItems();
    var currentId = data.getCurrentId();

    if (items.isNotEmpty) {
      final list = items.keys.toList();
      if (currentId != null) {
        var index = list.indexOf(currentId);
        index++;
        if (index >= list.length) index = 0;
        setState(() {
          data.setCurrentId(list[index]);
        });
      } else {
        setState(() {
          data.setCurrentId(list.first);
        });
      }
    }
  }

  _onAddItem(Item item) {
    log('[DEBUG CLOTHES DETAIL] Choose item ${item.id}');
    final data = g_localItemsData[item.type]!;
    setState(() {
      data.addItem(item);
      data.setCurrentItem(item);
    });
  }

  _onRemoveItem(Item item) {
    log('[DEBUG CLOTHES DETAIL] Choose item ${item.id}');
    final data = g_localItemsData[item.type]!;
    setState(() {
      data.removeItem(item);
    });
  }

  _onChangeSize(Item item, ESize size) {
    log('[DEBUG CLOTHES DETAIL] Change size item ${item.id} size ${size.name}');
    final data = g_localItemsData[item.type]!;
    setState(() {
      data.setSize(item, size);
    });
  }

  Widget _rowHeightWeight() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 72.0),
      child: Column(
        children: [
          _edtHeight(),
          _edtWeight(),
        ],
      ),
    );
  }
  Widget _edtHeight() {
    return Row(
      children: [
        Text('Height: '),
        NumberPicker(
          minValue: 0,
          maxValue: 250,
          axis: Axis.vertical,
          value: g_bodyStat.height,
          onChanged: _onChangeHeight,
          textMapper: (value) {
            return (g_bodyStat.height / 100.0).toString();
          },
          itemCount: 1,
          itemHeight: 32.0,
          itemWidth: 64.0,
        ),
        Text(' m'),
      ],
    );
  }

  Widget _edtWeight() {
    return Row(
      children: [
        Text('Weight: '),
        NumberPicker(
          minValue: 0,
          maxValue: 150,
          axis: Axis.horizontal,
          value: g_bodyStat.weight,
          onChanged: _onChangeWeight,
          itemCount: 1,
          itemHeight: 32.0,
          itemWidth: 50.0,
        ),
        Text(' kg'),
      ],
    );
  }

  void _onChangeWeight(value) {
    _setSizeAll();
    setState(() {
      g_bodyStat.weight = value;
    });
  }

  void _onChangeHeight(value) {
    _setSizeAll();
    setState(() {
      g_bodyStat.height = value;
    });
  }

  void _setSizeAll() {
    final size = g_bodyStat.toEsize();
    g_localItemsData.forEach((key, data) {
      data.setSizeAll(size);
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
