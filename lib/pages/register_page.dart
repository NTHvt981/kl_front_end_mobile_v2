import 'dart:developer';

import 'package:auto_route/auto_route.dart' as route;
import 'package:do_an_ui/routes/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var auth = FirebaseAuth.instance;
  TextEditingController emailCon = new TextEditingController();
  TextEditingController passCon = new TextEditingController();
  TextEditingController confirmPassCon = new TextEditingController();

  void register() {
    String email = emailCon.value.text;
    String password = passCon.value.text;
    String confirmPass = confirmPassCon.value.text;

    if (confirmPass != password) {
      Toast.show("Password is not the same as confirm password", context);
      return;
    }

    auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      context.router.pop();
      // route.ExtendedNavigator.root.pop();
    }).catchError((err) {
      var ex = err as FirebaseAuthException;
      var msg = ex.message;
      Toast.show("Error create account $msg", context);
    });
  }

  void goToSignIn() {
    context.router.pop();
    // route.ExtendedNavigator.root.pop();
  }

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((event) {
      if (auth.currentUser != null)
        context.router.replace(ClothesDetailPageRoute(userId: event!.uid));
        // route.ExtendedNavigator.root.replace(Routes.clothesDetailPage,
        //     arguments: ClothesDetailPageArguments(userId: event.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTER'),
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
              TextField(
                controller: confirmPassCon,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: register,
                  child: Text('Create Account'),
                  color: Theme.of(context).buttonColor,
                  textColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: goToSignIn,
                  child: Text('go to login page'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).buttonColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
