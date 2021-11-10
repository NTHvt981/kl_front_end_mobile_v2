import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:do_an_ui/routes/router.gr.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var auth = FirebaseAuth.instance;
  TextEditingController emailCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();

  void signIn() {
    auth.signInWithEmailAndPassword(
        email: emailCon.value.text,
        password: passCon.value.text
    ).then((value) {
      log("Sign in success");
      context.router.push(ClothesDetailPageRoute(userId: value.user!.uid));
      // route.ExtendedNavigator.root.push(routes.clothesDetailPage,
      //     arguments: ClothesDetailPageArguments(userId: value.user.uid));
    }).catchError((err) {
      var ex = err as FirebaseAuthException;
      var msg = ex.message;
      Toast.show("Error sign in $msg", context);
    });
  }

  void goToSignUp() {
    context.router.push(RegisterPageRoute());
    // route.ExtendedNavigator.root.push(Routes.registerPage);
  }


  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((event) {
      if (auth.currentUser != null)
        context.router.replace(ClothesDetailPageRoute(userId: event!.uid));
        // route.ExtendedNavigator.root.replace(routes .clothesDetailPage,
        //   arguments: ClothesDetailRouteArgs(userId: event!.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN IN'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: emailCon,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passCon,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: signIn,
                  child: Text('Login'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).buttonColor,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: goToSignUp,
                  child: Text('go to sign up page'),
                  color: Theme.of(context).buttonColor,
                  textColor: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
