
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'UngDungThoiTrangMobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // builder: AppRouter(
      //     router: MyRouter(),
      //     // pass anything navigation related to ExtendedNav instead of MaterialApp
      //     initialRoute: Routes.loginPage
      // ),
    );
  }

  static const _kFontFam = 'MyFont';
  static const _kFontPkg = null;

  static const IconData ic_save = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_folder_open = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_renew = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_shopping_cart = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ic_cog = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
