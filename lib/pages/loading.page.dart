import 'package:do_an_ui/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    context.router.push(AuthPageRoute());
  }
}
