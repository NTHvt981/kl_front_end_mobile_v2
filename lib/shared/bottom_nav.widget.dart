import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:do_an_ui/shared/colors.dart';
import 'package:do_an_ui/shared/percentage_size.widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const NEWS_PAGE_ID = 0;
const CLOTHES_PAGE_ID = 1;
const CHAT_PAGE_ID = 2;
const INFO_PAGE_ID = 3;

class BottomNavWidget extends StatefulWidget {
  final int index;

  BottomNavWidget({
    Key? key,
    required this.index
}): super(key: key);

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userId;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((user) {
      if (user == null)
      {
        context.router.popAndPush(SignInPageRoute());
      }
      else
        setState(() {
          userId = user.uid;
        });
    });
  }

  void onSelect(int index) {
    if (userId.isEmpty) {
      context.router.popUntilRouteWithName(SignInPageRoute.name);
      log("user id IS null");
    }
    else {
      log("user id NOT null");
    }

    switch (index) {
      case NEWS_PAGE_ID:
        context.router.popAndPush(NewsListPageRoute());
        break;
      case CLOTHES_PAGE_ID:
        context.router.popAndPush(ClothesDetailPageRoute(userId: userId));
        break;
      case CHAT_PAGE_ID:
        context.router.popAndPush(ChatListPageRoute(userId: userId));
        break;
      case INFO_PAGE_ID:
        // context.router.popAndPush(ProfilePageRoute(userId: userId));
        Scaffold.of(context).openEndDrawer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PercentageSizeWidget(
      percentageHeight: 0.1,
      child: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Info',
        ),
      ],
        currentIndex: widget.index,
        selectedItemColor: WHITE,
        unselectedItemColor: WHITE.withOpacity(0.8),
        backgroundColor: DARK_BLUE,
        onTap: onSelect,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
      ),
    );
  }
}
