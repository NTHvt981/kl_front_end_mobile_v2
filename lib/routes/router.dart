import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/pages/about.page.dart';
import 'package:do_an_ui/pages/ar/ar.page.dart';
import 'package:do_an_ui/pages/ar/ar2.page.dart';
import 'package:do_an_ui/pages/auth.page.dart';
import 'package:do_an_ui/pages/auth/update_pass.page.dart';
import 'package:do_an_ui/pages/chat/create_chat.page.dart';
import 'package:do_an_ui/pages/clothes/collection_list.page.dart';
import 'package:do_an_ui/pages/clothes/clothes_detail.page.dart';
import 'package:do_an_ui/pages/face_recognition/save_face2.page.dart';
import 'package:do_an_ui/pages/help.page.dart';
import 'package:do_an_ui/pages/make_order/cart.page.dart';
import 'package:do_an_ui/pages/make_order/delivery.info.dart';
import 'package:do_an_ui/pages/make_order/discount.info.dart';
import 'package:do_an_ui/pages/make_order/order_fail.page.dart';
import 'package:do_an_ui/pages/make_order/order_success.page.dart';
import 'package:do_an_ui/pages/make_order/payment.info.dart';
import 'package:do_an_ui/pages/profile/profile.page.dart';
import 'package:do_an_ui/pages/dashboard.page.dart';
import 'package:do_an_ui/pages/face_recognition/load_face.page.dart';
import 'package:do_an_ui/pages/face_recognition/save_face.page.dart';
import 'package:do_an_ui/pages/loading.page.dart';
import 'package:do_an_ui/pages/test/loading.test.page.dart';
import '../pages/auth/sign_in.page.dart';
import 'package:do_an_ui/pages/chat/create_chat.page.dart';
import 'package:do_an_ui/pages/chat/message_list.page.dart';
import 'package:do_an_ui/pages/chat/chat_list.page.dart';
import 'package:do_an_ui/pages/news/news.page.dart';
import 'package:do_an_ui/pages/news/news_list.page.dart';
import 'package:do_an_ui/pages/order/create_order.page.dart';
import 'package:do_an_ui/pages/order/order_detail.page.dart';
import 'package:do_an_ui/pages/order/order_list.page.dart';
import '../pages/auth/sign_up.page.dart';
import 'package:flutter/material.dart';

Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
            position: animation.drive(tween),
            child: child,
      );
}

@MaterialAutoRouter(
    routes: [
      //CustomRoute(page: LoadingPage, initial: true, transitionsBuilder: slideUpTransition),
      CustomRoute(page: AuthPage, initial: true, transitionsBuilder: slideUpTransition),
      CustomRoute(page: SignInPage, transitionsBuilder: slideUpTransition),
      CustomRoute(page: SignUpPage, transitionsBuilder: slideUpTransition),
      AutoRoute(page: DashboardPage),
      AutoRoute(page: NewsPage),
      AutoRoute(page: CollectionListPage),
      AutoRoute(page: CreateOrderPage),
      AutoRoute(page: OrderFailPage),
      AutoRoute(page: OrderSuccessPage),
      AutoRoute(page: OrderDetailPage),
      AutoRoute(page: OrderListPage),
      AutoRoute(page: CreateChatPage),
      AutoRoute(page: ProfilePage),
      AutoRoute(page: MessageListPage),
      AutoRoute(page: ArPage),
      AutoRoute(page: Ar2Page),
      AutoRoute(page: SaveFacePage),
      AutoRoute(page: SaveFace2Page),
      AutoRoute(page: LoadFacePage),

      CustomRoute(page: NewsListPage),
      CustomRoute(page: ClothesDetailPage),
      CustomRoute(page: ChatListPage),

      AutoRoute(page: CartPage),
      AutoRoute(page: DeliveryInfoPage),
      AutoRoute(page: PaymentInfoPage),
      AutoRoute(page: DiscountInfoPage),

      AutoRoute(page: HelpPage),
      AutoRoute(page: AboutPage),
      AutoRoute(page: UpdatePassPage),

      //testing
      AutoRoute(page: LoadingTestPage),
])
class $AppRouter  {
}