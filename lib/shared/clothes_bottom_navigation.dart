import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const SAVED_COLLECTION_PAGE = 0;
const CLOTHES_DETAIL_PAGE = 1;
const CREATE_ORDER_PAGE = 2;
const AR_PAGE = 3;

class ClothesBottomNavigation extends StatefulWidget {
  final int index;

  ClothesBottomNavigation({
    Key? key,
    required this.index
}): super(key: key);

  @override
  _ClothesBottomNavigationState createState() => _ClothesBottomNavigationState();
}

class _ClothesBottomNavigationState extends State<ClothesBottomNavigation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((user) {
      if (user == null)
      {
        context.router.replace(LoginPageRoute());
        // ExtendedNavigator.root.replace(Routes.loginPage);
      }
      else
        setState(() {
          userId = user.uid;
        });
    });
  }

  void onSelect(int index) {
    if (userId == null) {
      context.router.replace(LoginPageRoute());
      // ExtendedNavigator.root.replace(Routes.loginPage);
      log("user id IS null");
    }
    else {
      log("user id NOT null");
    }

    switch (index) {
      case SAVED_COLLECTION_PAGE:
        context.router.replace(ClothesListPageRoute(userId: userId));
        // ExtendedNavigator.root.replace(Routes.clothesListPage,
        //     arguments: ClothesListPageArguments(userId: userId));
        break;
      case CLOTHES_DETAIL_PAGE:
        context.router.replace(ClothesDetailPageRoute(userId: userId));
        // ExtendedNavigator.root.replace(Routes.clothesDetailPage,
        //     arguments: ClothesDetailPageArguments(userId: userId));
        break;
      case CREATE_ORDER_PAGE:
        context.router.replace(CreateOrderPageRoute(userId: userId));
        // ExtendedNavigator.root.replace(Routes.createOrderPage,
        //     arguments: CreateOrderPageArguments(userId: userId));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.folder_open),
        label: 'Saved',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Main Collection',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_shopping_cart),
        label: 'Order',
      ),
    ],
      currentIndex: widget.index,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      onTap: onSelect,
    );
  }
}
