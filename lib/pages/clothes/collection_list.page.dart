import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/models/collection.model.dart';
import 'package:do_an_ui/pages/clothes/collection.widget.dart';
import 'package:do_an_ui/services/clothes/collection.service.dart';
import 'package:do_an_ui/services/clothes/item.service.dart';
import 'package:do_an_ui/services/clothes/local_item.data.dart';
import 'package:do_an_ui/shared/clothes/type.enum.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';

class CollectionListPage extends StatefulWidget {
  final String userId;

  CollectionListPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _CollectionListPageState createState() => _CollectionListPageState();
}

class _CollectionListPageState extends State<CollectionListPage> {
  //------------------PRIVATE ATTRIBUTES------------------//
  List<Collection> _collections = [];
  final dkey = '[CollectionList2Page]';

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();
    log('$dkey call initState');

    g_collection2Service.readAllLive(widget.userId)
        .listen((value) {
          if (mounted)
            setState(() {
              _collections = value;
            });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  _onSelectCollection(Collection collection) async {
    EasyLoading.show(status: 'Loading...');

    final hatData = g_localItemsData[EType.Hat]!;
    hatData.removeAllItems();
    await Future.forEach(collection.hatIds, (String id) async {
      final Item item = await g_itemService.readOnce(id);
      hatData.addItem(item);
      hatData.setCurrentItem(item);
      log('$dkey call _onSelectCollection hatIds $id');
    });

    final shirtData = g_localItemsData[EType.Shirt]!;
    shirtData.removeAllItems();
    await Future.forEach(collection.shirtIds, (String id) async {
      final Item item = await g_itemService.readOnce(id);
      shirtData.addItem(item);
      shirtData.setCurrentItem(item);
      log('$dkey call _onSelectCollection shirtIds $id');
    });

    final pantsData = g_localItemsData[EType.Pants]!;
    pantsData.removeAllItems();
    await Future.forEach(collection.pantsIds, (String id) async {
      final Item item = await g_itemService.readOnce(id);
      pantsData.addItem(item);
      pantsData.setCurrentItem(item);
      log('$dkey call _onSelectCollection pantsIds $id');
    });

    final shoesData = g_localItemsData[EType.Shoes]!;
    shoesData.removeAllItems();
    await Future.forEach(collection.shoesIds, (String id) async {
      final Item item = await g_itemService.readOnce(id);
      shoesData.addItem(item);
      shoesData.setCurrentItem(item);
      log('$dkey call _onSelectCollection shoesIds $id');
    });

    final backpackData = g_localItemsData[EType.Backpack]!;
    backpackData.removeAllItems();
    await Future.forEach(collection.backpackIds, (String id) async {
      final Item item = await g_itemService.readOnce(id);
      backpackData.addItem(item);
      backpackData.setCurrentItem(item);
      log('$dkey call _onSelectCollection backpackIds $id');
    });

    await EasyLoading.dismiss();
    context.router.pop();
  }

  _onDeleteCollection(Collection collection) async {
    EasyLoading.show(status: 'Deleting...');
    await g_collection2Service.delete(collection.id);
    EasyLoading.dismiss();
  }

  //------------------UI WIDGETS--------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            _header(context),
            _collectionList(),
          ],
        ),
    );
  }

  PercentageSizeWidget _collectionList() {
    return PercentageSizeWidget(
            percentageHeight: 0.9,
            child: Container(
              color: WHITE,
              padding: EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, position) {
                  return CollectionWidget(
                    data: _collections[position],
                    onSelect: _onSelectCollection,
                    onDelete: _onDeleteCollection,
                  );
                },
                itemCount: _collections.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            ),
          );
  }

  HeaderWidget _header(BuildContext context) {
    return HeaderWidget(
            title: TextWidget(
              text: "My Wardrobe.",
              size: 16.0,
              bold: true,
            ),
            canGoBack: true,
            router: context.router,
          );
  }
}
