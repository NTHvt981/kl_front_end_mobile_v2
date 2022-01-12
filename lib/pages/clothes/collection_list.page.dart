import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/shared/bottom_nav.widget.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/header.widget.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:do_an_ui/shared/setting.drawer.dart';
import 'package:do_an_ui/models/clothes_collection.model.dart';
import 'package:do_an_ui/models/item.model.dart';
import 'package:do_an_ui/pages/clothes/collection.widget.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/clothes_collection.service.dart';
import 'package:do_an_ui/services/item.service.dart';
import 'package:do_an_ui/services/local_item.service.dart';
import 'package:do_an_ui/shared/text.widget.dart';
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
  List<ClothesCollection> _collections = [];

  //------------------OVERRIDE  METHODS----------------------//
  @override
  void initState() {
    super.initState();

    clothesCollectionService.readAllLive(widget.userId)
        .listen((value) {
          if (mounted)
            setState(() {
              _collections = value;
            });
    });
  }

  //------------------PRIVATE METHODS---------------------//
  _onSelectCollection(ClothesCollection collection) {
    if (collection.hatId.isNotEmpty)
      g_itemService.readOnce(collection.hatId).then((value) => g_localItemsService[HAT]!.set(value));

    if (collection.shirtId.isNotEmpty)
      g_itemService.readOnce(collection.shirtId).then((value) => g_localItemsService[SHIRT]!.set(value));

    if (collection.pantsId.isNotEmpty)
      g_itemService.readOnce(collection.pantsId).then((value) => g_localItemsService[PANTS]!.set(value));

    if (collection.shoesId.isNotEmpty)
      g_itemService.readOnce(collection.shoesId).then((value) => g_localItemsService[SHOES]!.set(value));

    if (collection.backpackId.isNotEmpty)
      g_itemService.readOnce(collection.backpackId).then((value) => g_localItemsService[BACKPACK]!.set(value));

    context.router.pop();
  }

  _onDeleteCollection(ClothesCollection collection) {
    clothesCollectionService.delete(collection.id);
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
