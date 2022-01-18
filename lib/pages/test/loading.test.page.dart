import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:do_an_ui/shared/colors.dart';
import '../../shared/widgets/header.widget.dart';
import 'package:do_an_ui/shared/widgets/percentage_size.widget.dart';
import 'package:do_an_ui/shared/widgets/rounded_button.widget.dart';
import 'package:do_an_ui/shared/widgets/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingTestPage extends StatefulWidget {
  @override
  _LoadingTestPageState createState() => _LoadingTestPageState();
}

class _LoadingTestPageState extends State<LoadingTestPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: WHITE,
      body: Stack(
        children: [
          HeaderWidget(
            textColor: DARK_BLUE,
            canGoBack: true,
            router: context.router,
            title: TextWidget(text: 'LOADING TEST', size: 16.0, color: DARK_BLUE,),
          ),
          Center(
            child: PercentageSizeWidget(
              percentageWidth: 0.8,
              percentageHeight: 0.1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: RoundedButtonWidget(
                  onTap: _onTap,
                  borderColor: DARK_BLUE,
                  backgroundColor: WHITE,
                  child: TextWidget(
                    color: DARK_BLUE,
                    text: 'WAIT FOR 3 SECONDS',
                    size: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTap() async {
    EasyLoading.show(status: 'Loading...');
    await Future.delayed(Duration(seconds: 2));
    await EasyLoading.dismiss();
    EasyLoading.showSuccess('Done');
  }
}
