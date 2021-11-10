import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/shared/clothes_bottom_navigation.dart';
import 'package:do_an_ui/shared/drawer.dart';
import 'package:do_an_ui/models/clothes_collection.dart';
import 'package:do_an_ui/models/item.dart';
import 'package:do_an_ui/pages/clothes/collection_tile.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/services/clothes_collection_service.dart';
import 'package:do_an_ui/services/item_service.dart';
import 'package:do_an_ui/services/local_item_service.dart';
import 'package:flutter/material.dart';

class ClothesListPage extends StatefulWidget {
  final String userId;

  ClothesListPage({
    Key? key,
    required this.userId
  }): super(key: key);

  @override
  _ClothesListPageState createState() => _ClothesListPageState();
}

class _ClothesListPageState extends State<ClothesListPage> {

  List<ClothesCollection> data = [];

  @override
  void initState() {
    super.initState();

    clothesCollectionService.readAllLive(widget.userId)
        .listen((value) {
          if (mounted)
            setState(() {
              data = value;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your outfits'),
        ),
        drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
            itemBuilder: (context, position) {
              return CollectionListTile(
                data: data[position],
                onSelect: onSelectCollection,
                onDelete: onDeleteCollection,
              );
            },
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
          ),
        ),
      bottomNavigationBar: ClothesBottomNavigation(index: SAVED_COLLECTION_PAGE,),
    );
  }

  onSelectCollection(ClothesCollection collection) {
    if (collection.hatId != null)
      itemService.readOnce(collection.hatId).then((value) => localItemService[HAT]!.set(value));

    if (collection.shirtId != null)
      itemService.readOnce(collection.shirtId).then((value) => localItemService[SHIRT]!.set(value));

    if (collection.pantsId != null)
      itemService.readOnce(collection.pantsId).then((value) => localItemService[PANTS]!.set(value));

    if (collection.shoesId != null)
      itemService.readOnce(collection.shoesId).then((value) => localItemService[SHOES]!.set(value));

    if (collection.backpackId != null)
      itemService.readOnce(collection.backpackId).then((value) => localItemService[BACKPACK]!.set(value));

    context.router.popAndPush(ClothesDetailPageRoute(userId: widget.userId));
    // ExtendedNavigator.root.popAndPush(
    //   Routes.clothesDetailPage,
    //   arguments: ClothesDetailPageArguments(userId: widget.userId)
    // );
  }

  onDeleteCollection(ClothesCollection collection) {
    clothesCollectionService.delete(collection.id);
  }
}
