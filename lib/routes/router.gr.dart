// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;

import '../models/message.dart' as _i19;
import '../models/order.dart' as _i18;
import '../pages/ar/ar_page.dart' as _i15;
import '../pages/clothes/clothes_detail_page.dart' as _i6;
import '../pages/clothes/clothes_list_page.dart' as _i7;
import '../pages/clothes/movable_item_widget.dart' as _i20;
import '../pages/customer/setting_page.dart' as _i12;
import '../pages/dashboard_page.dart' as _i3;
import '../pages/login_page.dart' as _i1;
import '../pages/messages/create_message_page.dart' as _i11;
import '../pages/messages/message_detail_page.dart' as _i13;
import '../pages/messages/message_list_page.dart' as _i14;
import '../pages/news/news_detail_page.dart' as _i5;
import '../pages/news/news_list_page.dart' as _i4;
import '../pages/order/create_order_page.dart' as _i8;
import '../pages/order/order_detail_page.dart' as _i9;
import '../pages/order/order_list_page.dart' as _i10;
import '../pages/register_page.dart' as _i2;

class AppRouter extends _i16.RootStackRouter {
  AppRouter([_i17.GlobalKey<_i17.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.LoginPage());
    },
    RegisterPageRoute.name: (routeData) {
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.RegisterPage());
    },
    DashboardPageRoute.name: (routeData) {
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.DashboardPage());
    },
    NewsListPageRoute.name: (routeData) {
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.NewsListPage());
    },
    NewsDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<NewsDetailPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.NewsDetailPage(
              key: args.key, title: args.title, url: args.url));
    },
    ClothesDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<ClothesDetailPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.ClothesDetailPage(key: args.key, userId: args.userId));
    },
    ClothesListPageRoute.name: (routeData) {
      final args = routeData.argsAs<ClothesListPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.ClothesListPage(key: args.key, userId: args.userId));
    },
    CreateOrderPageRoute.name: (routeData) {
      final args = routeData.argsAs<CreateOrderPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.CreateOrderPage(key: args.key, userId: args.userId));
    },
    OrderDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.OrderDetailPage(key: args.key, order: args.order));
    },
    OrderListPageRoute.name: (routeData) {
      final args = routeData.argsAs<OrderListPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.OrderListPage(key: args.key, userId: args.userId));
    },
    CreateMessagePageRoute.name: (routeData) {
      final args = routeData.argsAs<CreateMessagePageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.CreateMessagePage(key: args.key, userId: args.userId));
    },
    SettingPageRoute.name: (routeData) {
      final args = routeData.argsAs<SettingPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.SettingPage(key: args.key, userId: args.userId));
    },
    MessageDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageDetailPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i13.MessageDetailPage(
              userId: args.userId, message: args.message));
    },
    MessageListPageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageListPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.MessageListPage(userId: args.userId));
    },
    ArPageRoute.name: (routeData) {
      final args = routeData.argsAs<ArPageRouteArgs>();
      return _i16.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.ArPage(key: args.key, itemList: args.itemList));
    }
  };

  @override
  List<_i16.RouteConfig> get routes => [
        _i16.RouteConfig(LoginPageRoute.name, path: '/'),
        _i16.RouteConfig(RegisterPageRoute.name, path: '/register-page'),
        _i16.RouteConfig(DashboardPageRoute.name, path: '/dashboard-page'),
        _i16.RouteConfig(NewsListPageRoute.name, path: '/news-list-page'),
        _i16.RouteConfig(NewsDetailPageRoute.name, path: '/news-detail-page'),
        _i16.RouteConfig(ClothesDetailPageRoute.name,
            path: '/clothes-detail-page'),
        _i16.RouteConfig(ClothesListPageRoute.name, path: '/clothes-list-page'),
        _i16.RouteConfig(CreateOrderPageRoute.name, path: '/create-order-page'),
        _i16.RouteConfig(OrderDetailPageRoute.name, path: '/order-detail-page'),
        _i16.RouteConfig(OrderListPageRoute.name, path: '/order-list-page'),
        _i16.RouteConfig(CreateMessagePageRoute.name,
            path: '/create-message-page'),
        _i16.RouteConfig(SettingPageRoute.name, path: '/setting-page'),
        _i16.RouteConfig(MessageDetailPageRoute.name,
            path: '/message-detail-page'),
        _i16.RouteConfig(MessageListPageRoute.name, path: '/message-list-page'),
        _i16.RouteConfig(ArPageRoute.name, path: '/ar-page')
      ];
}

/// generated route for [_i1.LoginPage]
class LoginPageRoute extends _i16.PageRouteInfo<void> {
  const LoginPageRoute() : super(name, path: '/');

  static const String name = 'LoginPageRoute';
}

/// generated route for [_i2.RegisterPage]
class RegisterPageRoute extends _i16.PageRouteInfo<void> {
  const RegisterPageRoute() : super(name, path: '/register-page');

  static const String name = 'RegisterPageRoute';
}

/// generated route for [_i3.DashboardPage]
class DashboardPageRoute extends _i16.PageRouteInfo<void> {
  const DashboardPageRoute() : super(name, path: '/dashboard-page');

  static const String name = 'DashboardPageRoute';
}

/// generated route for [_i4.NewsListPage]
class NewsListPageRoute extends _i16.PageRouteInfo<void> {
  const NewsListPageRoute() : super(name, path: '/news-list-page');

  static const String name = 'NewsListPageRoute';
}

/// generated route for [_i5.NewsDetailPage]
class NewsDetailPageRoute extends _i16.PageRouteInfo<NewsDetailPageRouteArgs> {
  NewsDetailPageRoute(
      {_i17.Key? key, required String title, required String url})
      : super(name,
            path: '/news-detail-page',
            args: NewsDetailPageRouteArgs(key: key, title: title, url: url));

  static const String name = 'NewsDetailPageRoute';
}

class NewsDetailPageRouteArgs {
  const NewsDetailPageRouteArgs(
      {this.key, required this.title, required this.url});

  final _i17.Key? key;

  final String title;

  final String url;
}

/// generated route for [_i6.ClothesDetailPage]
class ClothesDetailPageRoute
    extends _i16.PageRouteInfo<ClothesDetailPageRouteArgs> {
  ClothesDetailPageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/clothes-detail-page',
            args: ClothesDetailPageRouteArgs(key: key, userId: userId));

  static const String name = 'ClothesDetailPageRoute';
}

class ClothesDetailPageRouteArgs {
  const ClothesDetailPageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i7.ClothesListPage]
class ClothesListPageRoute
    extends _i16.PageRouteInfo<ClothesListPageRouteArgs> {
  ClothesListPageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/clothes-list-page',
            args: ClothesListPageRouteArgs(key: key, userId: userId));

  static const String name = 'ClothesListPageRoute';
}

class ClothesListPageRouteArgs {
  const ClothesListPageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i8.CreateOrderPage]
class CreateOrderPageRoute
    extends _i16.PageRouteInfo<CreateOrderPageRouteArgs> {
  CreateOrderPageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/create-order-page',
            args: CreateOrderPageRouteArgs(key: key, userId: userId));

  static const String name = 'CreateOrderPageRoute';
}

class CreateOrderPageRouteArgs {
  const CreateOrderPageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i9.OrderDetailPage]
class OrderDetailPageRoute
    extends _i16.PageRouteInfo<OrderDetailPageRouteArgs> {
  OrderDetailPageRoute({_i17.Key? key, required _i18.Order order})
      : super(name,
            path: '/order-detail-page',
            args: OrderDetailPageRouteArgs(key: key, order: order));

  static const String name = 'OrderDetailPageRoute';
}

class OrderDetailPageRouteArgs {
  const OrderDetailPageRouteArgs({this.key, required this.order});

  final _i17.Key? key;

  final _i18.Order order;
}

/// generated route for [_i10.OrderListPage]
class OrderListPageRoute extends _i16.PageRouteInfo<OrderListPageRouteArgs> {
  OrderListPageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/order-list-page',
            args: OrderListPageRouteArgs(key: key, userId: userId));

  static const String name = 'OrderListPageRoute';
}

class OrderListPageRouteArgs {
  const OrderListPageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i11.CreateMessagePage]
class CreateMessagePageRoute
    extends _i16.PageRouteInfo<CreateMessagePageRouteArgs> {
  CreateMessagePageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/create-message-page',
            args: CreateMessagePageRouteArgs(key: key, userId: userId));

  static const String name = 'CreateMessagePageRoute';
}

class CreateMessagePageRouteArgs {
  const CreateMessagePageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i12.SettingPage]
class SettingPageRoute extends _i16.PageRouteInfo<SettingPageRouteArgs> {
  SettingPageRoute({_i17.Key? key, required String userId})
      : super(name,
            path: '/setting-page',
            args: SettingPageRouteArgs(key: key, userId: userId));

  static const String name = 'SettingPageRoute';
}

class SettingPageRouteArgs {
  const SettingPageRouteArgs({this.key, required this.userId});

  final _i17.Key? key;

  final String userId;
}

/// generated route for [_i13.MessageDetailPage]
class MessageDetailPageRoute
    extends _i16.PageRouteInfo<MessageDetailPageRouteArgs> {
  MessageDetailPageRoute(
      {required String userId, required _i19.Message message})
      : super(name,
            path: '/message-detail-page',
            args: MessageDetailPageRouteArgs(userId: userId, message: message));

  static const String name = 'MessageDetailPageRoute';
}

class MessageDetailPageRouteArgs {
  const MessageDetailPageRouteArgs(
      {required this.userId, required this.message});

  final String userId;

  final _i19.Message message;
}

/// generated route for [_i14.MessageListPage]
class MessageListPageRoute
    extends _i16.PageRouteInfo<MessageListPageRouteArgs> {
  MessageListPageRoute({required String userId})
      : super(name,
            path: '/message-list-page',
            args: MessageListPageRouteArgs(userId: userId));

  static const String name = 'MessageListPageRoute';
}

class MessageListPageRouteArgs {
  const MessageListPageRouteArgs({required this.userId});

  final String userId;
}

/// generated route for [_i15.ArPage]
class ArPageRoute extends _i16.PageRouteInfo<ArPageRouteArgs> {
  ArPageRoute({_i17.Key? key, required List<_i20.MovableItemWidget> itemList})
      : super(name,
            path: '/ar-page',
            args: ArPageRouteArgs(key: key, itemList: itemList));

  static const String name = 'ArPageRoute';
}

class ArPageRouteArgs {
  const ArPageRouteArgs({this.key, required this.itemList});

  final _i17.Key? key;

  final List<_i20.MovableItemWidget> itemList;
}
