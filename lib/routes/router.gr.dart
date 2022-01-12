// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i31;
import 'package:camera/camera.dart' as _i36;
import 'package:flutter/material.dart' as _i32;

import '../models/chat.model.dart' as _i35;
import '../models/order.model.dart' as _i34;
import '../pages/about.page.dart' as _i28;
import '../pages/ar/ar.page.dart' as _i15;
import '../pages/ar/ar2.page.dart' as _i16;
import '../pages/auth.page.dart' as _i1;
import '../pages/auth/sign_in.page.dart' as _i2;
import '../pages/auth/sign_up.page.dart' as _i3;
import '../pages/auth/update_pass.page.dart' as _i29;
import '../pages/chat/chat_list.page.dart' as _i22;
import '../pages/chat/create_chat.page.dart' as _i12;
import '../pages/chat/message_list.page.dart' as _i14;
import '../pages/clothes/clothes_detail.page.dart' as _i21;
import '../pages/clothes/collection_list.page.dart' as _i6;
import '../pages/dashboard.page.dart' as _i4;
import '../pages/face_recognition/load_face.page.dart' as _i19;
import '../pages/face_recognition/save_face.page.dart' as _i17;
import '../pages/face_recognition/save_face2.page.dart' as _i18;
import '../pages/help.page.dart' as _i27;
import '../pages/make_order/cart.page.dart' as _i23;
import '../pages/make_order/delivery.info.dart' as _i24;
import '../pages/make_order/discount.info.dart' as _i26;
import '../pages/make_order/order_fail.page.dart' as _i8;
import '../pages/make_order/order_success.page.dart' as _i9;
import '../pages/make_order/payment.info.dart' as _i25;
import '../pages/news/news.page.dart' as _i5;
import '../pages/news/news_list.page.dart' as _i20;
import '../pages/order/create_order.page.dart' as _i7;
import '../pages/order/order_detail.page.dart' as _i10;
import '../pages/order/order_list.page.dart' as _i11;
import '../pages/profile/profile.page.dart' as _i13;
import '../pages/test/loading.test.page.dart' as _i30;
import 'router.dart' as _i33;

class AppRouter extends _i31.RootStackRouter {
  AppRouter([_i32.GlobalKey<_i32.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i31.PageFactory> pagesMap = {
    AuthPageRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i1.AuthPage(),
          transitionsBuilder: _i33.slideUpTransition,
          opaque: true,
          barrierDismissible: false);
    },
    SignInPageRoute.name: (routeData) {
      final args = routeData.argsAs<SignInPageRouteArgs>(
          orElse: () => const SignInPageRouteArgs());
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.SignInPage(key: args.key),
          transitionsBuilder: _i33.slideUpTransition,
          opaque: true,
          barrierDismissible: false);
    },
    SignUpPageRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.SignUpPage(),
          transitionsBuilder: _i33.slideUpTransition,
          opaque: true,
          barrierDismissible: false);
    },
    DashboardPageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.DashboardPage());
    },
    NewsPageRoute.name: (routeData) {
      final args = routeData.argsAs<NewsPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.NewsPage(key: args.key, title: args.title, url: args.url));
    },
    CollectionListPageRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionListPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.CollectionListPage(key: args.key, userId: args.userId));
    },
    CreateOrderPageRoute.name: (routeData) {
      final args = routeData.argsAs<CreateOrderPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.CreateOrderPage(key: args.key, userId: args.userId));
    },
    OrderFailPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderFailPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.OrderFailPage(error: args.error));
    },
    OrderSuccessPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderSuccessPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.OrderSuccessPage(userId: args.userId));
    },
    OrderDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.OrderDetailPage(key: args.key, order: args.order));
    },
    OrderListPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderListPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.OrderListPage(key: args.key, userId: args.userId));
    },
    CreateChatPageRoute.name: (routeData) {
      final args = routeData.argsAs<CreateChatPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.CreateChatPage(key: args.key, userId: args.userId));
    },
    ProfilePageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i13.ProfilePage());
    },
    MessageListPageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageListPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.MessageListPage(userId: args.userId, chat: args.chat));
    },
    ArPageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i15.ArPage());
    },
    Ar2PageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i16.Ar2Page());
    },
    SaveFacePageRoute.name: (routeData) {
      final args = routeData.argsAs<SaveFacePageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i17.SaveFacePage(
              key: args.key,
              cameraDescription: args.cameraDescription,
              email: args.email,
              password: args.password));
    },
    SaveFace2PageRoute.name: (routeData) {
      final args = routeData.argsAs<SaveFace2PageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i18.SaveFace2Page(cameraDescription: args.cameraDescription));
    },
    LoadFacePageRoute.name: (routeData) {
      final args = routeData.argsAs<LoadFacePageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i19.LoadFacePage(
              key: args.key, cameraDescription: args.cameraDescription));
    },
    NewsListPageRoute.name: (routeData) {
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i20.NewsListPage(),
          opaque: true,
          barrierDismissible: false);
    },
    ClothesDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<ClothesDetailPageRouteArgs>();
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i21.ClothesDetailPage(key: args.key, userId: args.userId),
          opaque: true,
          barrierDismissible: false);
    },
    ChatListPageRoute.name: (routeData) {
      final args = routeData.argsAs<ChatListPageRouteArgs>();
      return _i31.CustomPage<dynamic>(
          routeData: routeData,
          child: _i22.ChatListPage(userId: args.userId),
          opaque: true,
          barrierDismissible: false);
    },
    CartPageRoute.name: (routeData) {
      final args = routeData.argsAs<CartPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i23.CartPage(key: args.key, userId: args.userId));
    },
    DeliveryInfoPageRoute.name: (routeData) {
      final args = routeData.argsAs<DeliveryInfoPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i24.DeliveryInfoPage(userId: args.userId));
    },
    PaymentInfoPageRoute.name: (routeData) {
      final args = routeData.argsAs<PaymentInfoPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i25.PaymentInfoPage(userId: args.userId));
    },
    DiscountInfoPageRoute.name: (routeData) {
      final args = routeData.argsAs<DiscountInfoPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i26.DiscountInfoPage(userId: args.userId));
    },
    HelpPageRoute.name: (routeData) {
      final args = routeData.argsAs<HelpPageRouteArgs>();
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i27.HelpPage(userId: args.userId));
    },
    AboutPageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i28.AboutPage());
    },
    UpdatePassPageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i29.UpdatePassPage());
    },
    LoadingTestPageRoute.name: (routeData) {
      return _i31.MaterialPageX<dynamic>(
          routeData: routeData, child: _i30.LoadingTestPage());
    }
  };

  @override
  List<_i31.RouteConfig> get routes => [
        _i31.RouteConfig(AuthPageRoute.name, path: '/'),
        _i31.RouteConfig(SignInPageRoute.name, path: '/sign-in-page'),
        _i31.RouteConfig(SignUpPageRoute.name, path: '/sign-up-page'),
        _i31.RouteConfig(DashboardPageRoute.name, path: '/dashboard-page'),
        _i31.RouteConfig(NewsPageRoute.name, path: '/news-page'),
        _i31.RouteConfig(CollectionListPageRoute.name,
            path: '/collection-list-page'),
        _i31.RouteConfig(CreateOrderPageRoute.name, path: '/create-order-page'),
        _i31.RouteConfig(OrderFailPageRoute.name, path: '/order-fail-page'),
        _i31.RouteConfig(OrderSuccessPageRoute.name,
            path: '/order-success-page'),
        _i31.RouteConfig(OrderDetailPageRoute.name, path: '/order-detail-page'),
        _i31.RouteConfig(OrderListPageRoute.name, path: '/order-list-page'),
        _i31.RouteConfig(CreateChatPageRoute.name, path: '/create-chat-page'),
        _i31.RouteConfig(ProfilePageRoute.name, path: '/profile-page'),
        _i31.RouteConfig(MessageListPageRoute.name, path: '/message-list-page'),
        _i31.RouteConfig(ArPageRoute.name, path: '/ar-page'),
        _i31.RouteConfig(Ar2PageRoute.name, path: '/ar2-page'),
        _i31.RouteConfig(SaveFacePageRoute.name, path: '/save-face-page'),
        _i31.RouteConfig(SaveFace2PageRoute.name, path: '/save-face2-page'),
        _i31.RouteConfig(LoadFacePageRoute.name, path: '/load-face-page'),
        _i31.RouteConfig(NewsListPageRoute.name, path: '/news-list-page'),
        _i31.RouteConfig(ClothesDetailPageRoute.name,
            path: '/clothes-detail-page'),
        _i31.RouteConfig(ChatListPageRoute.name, path: '/chat-list-page'),
        _i31.RouteConfig(CartPageRoute.name, path: '/cart-page'),
        _i31.RouteConfig(DeliveryInfoPageRoute.name,
            path: '/delivery-info-page'),
        _i31.RouteConfig(PaymentInfoPageRoute.name, path: '/payment-info-page'),
        _i31.RouteConfig(DiscountInfoPageRoute.name,
            path: '/discount-info-page'),
        _i31.RouteConfig(HelpPageRoute.name, path: '/help-page'),
        _i31.RouteConfig(AboutPageRoute.name, path: '/about-page'),
        _i31.RouteConfig(UpdatePassPageRoute.name, path: '/update-pass-page'),
        _i31.RouteConfig(LoadingTestPageRoute.name, path: '/loading-test-page')
      ];
}

/// generated route for [_i1.AuthPage]
class AuthPageRoute extends _i31.PageRouteInfo<void> {
  const AuthPageRoute() : super(name, path: '/');

  static const String name = 'AuthPageRoute';
}

/// generated route for [_i2.SignInPage]
class SignInPageRoute extends _i31.PageRouteInfo<SignInPageRouteArgs> {
  SignInPageRoute({_i32.Key? key})
      : super(name, path: '/sign-in-page', args: SignInPageRouteArgs(key: key));

  static const String name = 'SignInPageRoute';
}

class SignInPageRouteArgs {
  const SignInPageRouteArgs({this.key});

  final _i32.Key? key;
}

/// generated route for [_i3.SignUpPage]
class SignUpPageRoute extends _i31.PageRouteInfo<void> {
  const SignUpPageRoute() : super(name, path: '/sign-up-page');

  static const String name = 'SignUpPageRoute';
}

/// generated route for [_i4.DashboardPage]
class DashboardPageRoute extends _i31.PageRouteInfo<void> {
  const DashboardPageRoute() : super(name, path: '/dashboard-page');

  static const String name = 'DashboardPageRoute';
}

/// generated route for [_i5.NewsPage]
class NewsPageRoute extends _i31.PageRouteInfo<NewsPageRouteArgs> {
  NewsPageRoute({_i32.Key? key, required String title, required String url})
      : super(name,
            path: '/news-page',
            args: NewsPageRouteArgs(key: key, title: title, url: url));

  static const String name = 'NewsPageRoute';
}

class NewsPageRouteArgs {
  const NewsPageRouteArgs({this.key, required this.title, required this.url});

  final _i32.Key? key;

  final String title;

  final String url;
}

/// generated route for [_i6.CollectionListPage]
class CollectionListPageRoute
    extends _i31.PageRouteInfo<CollectionListPageRouteArgs> {
  CollectionListPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/collection-list-page',
            args: CollectionListPageRouteArgs(key: key, userId: userId));

  static const String name = 'CollectionListPageRoute';
}

class CollectionListPageRouteArgs {
  const CollectionListPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i7.CreateOrderPage]
class CreateOrderPageRoute
    extends _i31.PageRouteInfo<CreateOrderPageRouteArgs> {
  CreateOrderPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/create-order-page',
            args: CreateOrderPageRouteArgs(key: key, userId: userId));

  static const String name = 'CreateOrderPageRoute';
}

class CreateOrderPageRouteArgs {
  const CreateOrderPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i8.OrderFailPage]
class OrderFailPageRoute extends _i31.PageRouteInfo<OrderFailPageRouteArgs> {
  OrderFailPageRoute({required Object error})
      : super(name,
            path: '/order-fail-page',
            args: OrderFailPageRouteArgs(error: error));

  static const String name = 'OrderFailPageRoute';
}

class OrderFailPageRouteArgs {
  const OrderFailPageRouteArgs({required this.error});

  final Object error;
}

/// generated route for [_i9.OrderSuccessPage]
class OrderSuccessPageRoute
    extends _i31.PageRouteInfo<OrderSuccessPageRouteArgs> {
  OrderSuccessPageRoute({required String userId})
      : super(name,
            path: '/order-success-page',
            args: OrderSuccessPageRouteArgs(userId: userId));

  static const String name = 'OrderSuccessPageRoute';
}

class OrderSuccessPageRouteArgs {
  const OrderSuccessPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i10.OrderDetailPage]
class OrderDetailPageRoute
    extends _i31.PageRouteInfo<OrderDetailPageRouteArgs> {
  OrderDetailPageRoute({_i32.Key? key, required _i34.Order order})
      : super(name,
            path: '/order-detail-page',
            args: OrderDetailPageRouteArgs(key: key, order: order));

  static const String name = 'OrderDetailPageRoute';
}

class OrderDetailPageRouteArgs {
  const OrderDetailPageRouteArgs({this.key, required this.order});

  final _i32.Key? key;

  final _i34.Order order;
}

/// generated route for [_i11.OrderListPage]
class OrderListPageRoute extends _i31.PageRouteInfo<OrderListPageRouteArgs> {
  OrderListPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/order-list-page',
            args: OrderListPageRouteArgs(key: key, userId: userId));

  static const String name = 'OrderListPageRoute';
}

class OrderListPageRouteArgs {
  const OrderListPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i12.CreateChatPage]
class CreateChatPageRoute extends _i31.PageRouteInfo<CreateChatPageRouteArgs> {
  CreateChatPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/create-chat-page',
            args: CreateChatPageRouteArgs(key: key, userId: userId));

  static const String name = 'CreateChatPageRoute';
}

class CreateChatPageRouteArgs {
  const CreateChatPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i13.ProfilePage]
class ProfilePageRoute extends _i31.PageRouteInfo<void> {
  const ProfilePageRoute() : super(name, path: '/profile-page');

  static const String name = 'ProfilePageRoute';
}

/// generated route for [_i14.MessageListPage]
class MessageListPageRoute
    extends _i31.PageRouteInfo<MessageListPageRouteArgs> {
  MessageListPageRoute({required String userId, required _i35.Chat chat})
      : super(name,
            path: '/message-list-page',
            args: MessageListPageRouteArgs(userId: userId, chat: chat));

  static const String name = 'MessageListPageRoute';
}

class MessageListPageRouteArgs {
  const MessageListPageRouteArgs({required this.userId, required this.chat});

  final String userId;

  final _i35.Chat chat;
}

/// generated route for [_i15.ArPage]
class ArPageRoute extends _i31.PageRouteInfo<void> {
  const ArPageRoute() : super(name, path: '/ar-page');

  static const String name = 'ArPageRoute';
}

/// generated route for [_i16.Ar2Page]
class Ar2PageRoute extends _i31.PageRouteInfo<void> {
  const Ar2PageRoute() : super(name, path: '/ar2-page');

  static const String name = 'Ar2PageRoute';
}

/// generated route for [_i17.SaveFacePage]
class SaveFacePageRoute extends _i31.PageRouteInfo<SaveFacePageRouteArgs> {
  SaveFacePageRoute(
      {_i32.Key? key,
      required _i36.CameraDescription cameraDescription,
      required String email,
      required String password})
      : super(name,
            path: '/save-face-page',
            args: SaveFacePageRouteArgs(
                key: key,
                cameraDescription: cameraDescription,
                email: email,
                password: password));

  static const String name = 'SaveFacePageRoute';
}

class SaveFacePageRouteArgs {
  const SaveFacePageRouteArgs(
      {this.key,
      required this.cameraDescription,
      required this.email,
      required this.password});

  final _i32.Key? key;

  final _i36.CameraDescription cameraDescription;

  final String email;

  final String password;
}

/// generated route for [_i18.SaveFace2Page]
class SaveFace2PageRoute extends _i31.PageRouteInfo<SaveFace2PageRouteArgs> {
  SaveFace2PageRoute({required _i36.CameraDescription cameraDescription})
      : super(name,
            path: '/save-face2-page',
            args: SaveFace2PageRouteArgs(cameraDescription: cameraDescription));

  static const String name = 'SaveFace2PageRoute';
}

class SaveFace2PageRouteArgs {
  const SaveFace2PageRouteArgs({required this.cameraDescription});

  final _i36.CameraDescription cameraDescription;
}

/// generated route for [_i19.LoadFacePage]
class LoadFacePageRoute extends _i31.PageRouteInfo<LoadFacePageRouteArgs> {
  LoadFacePageRoute(
      {_i32.Key? key, required _i36.CameraDescription cameraDescription})
      : super(name,
            path: '/load-face-page',
            args: LoadFacePageRouteArgs(
                key: key, cameraDescription: cameraDescription));

  static const String name = 'LoadFacePageRoute';
}

class LoadFacePageRouteArgs {
  const LoadFacePageRouteArgs({this.key, required this.cameraDescription});

  final _i32.Key? key;

  final _i36.CameraDescription cameraDescription;
}

/// generated route for [_i20.NewsListPage]
class NewsListPageRoute extends _i31.PageRouteInfo<void> {
  const NewsListPageRoute() : super(name, path: '/news-list-page');

  static const String name = 'NewsListPageRoute';
}

/// generated route for [_i21.ClothesDetailPage]
class ClothesDetailPageRoute
    extends _i31.PageRouteInfo<ClothesDetailPageRouteArgs> {
  ClothesDetailPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/clothes-detail-page',
            args: ClothesDetailPageRouteArgs(key: key, userId: userId));

  static const String name = 'ClothesDetailPageRoute';
}

class ClothesDetailPageRouteArgs {
  const ClothesDetailPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i22.ChatListPage]
class ChatListPageRoute extends _i31.PageRouteInfo<ChatListPageRouteArgs> {
  ChatListPageRoute({required String userId})
      : super(name,
            path: '/chat-list-page',
            args: ChatListPageRouteArgs(userId: userId));

  static const String name = 'ChatListPageRoute';
}

class ChatListPageRouteArgs {
  const ChatListPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i23.CartPage]
class CartPageRoute extends _i31.PageRouteInfo<CartPageRouteArgs> {
  CartPageRoute({_i32.Key? key, required String userId})
      : super(name,
            path: '/cart-page',
            args: CartPageRouteArgs(key: key, userId: userId));

  static const String name = 'CartPageRoute';
}

class CartPageRouteArgs {
  const CartPageRouteArgs({this.key, required this.userId});

  final _i32.Key? key;

  final String userId;
}

/// generated route for [_i24.DeliveryInfoPage]
class DeliveryInfoPageRoute
    extends _i31.PageRouteInfo<DeliveryInfoPageRouteArgs> {
  DeliveryInfoPageRoute({required String userId})
      : super(name,
            path: '/delivery-info-page',
            args: DeliveryInfoPageRouteArgs(userId: userId));

  static const String name = 'DeliveryInfoPageRoute';
}

class DeliveryInfoPageRouteArgs {
  const DeliveryInfoPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i25.PaymentInfoPage]
class PaymentInfoPageRoute
    extends _i31.PageRouteInfo<PaymentInfoPageRouteArgs> {
  PaymentInfoPageRoute({required String userId})
      : super(name,
            path: '/payment-info-page',
            args: PaymentInfoPageRouteArgs(userId: userId));

  static const String name = 'PaymentInfoPageRoute';
}

class PaymentInfoPageRouteArgs {
  const PaymentInfoPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i26.DiscountInfoPage]
class DiscountInfoPageRoute
    extends _i31.PageRouteInfo<DiscountInfoPageRouteArgs> {
  DiscountInfoPageRoute({required String userId})
      : super(name,
            path: '/discount-info-page',
            args: DiscountInfoPageRouteArgs(userId: userId));

  static const String name = 'DiscountInfoPageRoute';
}

class DiscountInfoPageRouteArgs {
  const DiscountInfoPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i27.HelpPage]
class HelpPageRoute extends _i31.PageRouteInfo<HelpPageRouteArgs> {
  HelpPageRoute({required String userId})
      : super(name,
            path: '/help-page', args: HelpPageRouteArgs(userId: userId));

  static const String name = 'HelpPageRoute';
}

class HelpPageRouteArgs {
  const HelpPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i28.AboutPage]
class AboutPageRoute extends _i31.PageRouteInfo<void> {
  const AboutPageRoute() : super(name, path: '/about-page');

  static const String name = 'AboutPageRoute';
}

/// generated route for [_i29.UpdatePassPage]
class UpdatePassPageRoute extends _i31.PageRouteInfo<void> {
  const UpdatePassPageRoute() : super(name, path: '/update-pass-page');

  static const String name = 'UpdatePassPageRoute';
}

/// generated route for [_i30.LoadingTestPage]
class LoadingTestPageRoute extends _i31.PageRouteInfo<void> {
  const LoadingTestPageRoute() : super(name, path: '/loading-test-page');

  static const String name = 'LoadingTestPageRoute';
}
