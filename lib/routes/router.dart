import 'package:auto_route/auto_route.dart';
import 'package:do_an_ui/pages/ar/ar_page.dart';
import 'package:do_an_ui/pages/clothes/clothes_list_page.dart';
import 'package:do_an_ui/pages/clothes/clothes_detail_page.dart';
import 'package:do_an_ui/pages/customer/setting_page.dart';
import 'package:do_an_ui/pages/dashboard_page.dart';
import 'package:do_an_ui/pages/login_page.dart';
import 'package:do_an_ui/pages/messages/create_message_page.dart';
import 'package:do_an_ui/pages/messages/message_detail_page.dart';
import 'package:do_an_ui/pages/messages/message_list_page.dart';
import 'package:do_an_ui/pages/news/news_detail_page.dart';
import 'package:do_an_ui/pages/news/news_list_page.dart';
import 'package:do_an_ui/pages/order/create_order_page.dart';
import 'package:do_an_ui/pages/order/order_detail_page.dart';
import 'package:do_an_ui/pages/order/order_list_page.dart';
import 'package:do_an_ui/pages/register_page.dart';

@MaterialAutoRouter(
    routes: [
      AutoRoute(page: LoginPage, initial: true),
      AutoRoute(page: RegisterPage),
      AutoRoute(page: DashboardPage),
      AutoRoute(page: NewsListPage),
      AutoRoute(page: NewsDetailPage),
      AutoRoute(page: ClothesDetailPage),
      AutoRoute(page: ClothesListPage),
      AutoRoute(page: CreateOrderPage),
      AutoRoute(page: OrderDetailPage),
      AutoRoute(page: OrderListPage),
      AutoRoute(page: CreateMessagePage),
      AutoRoute(page: SettingPage),
      AutoRoute(page: MessageDetailPage),
      AutoRoute(page: MessageListPage),
      AutoRoute(page: ArPage)
])
class $AppRouter  {
}