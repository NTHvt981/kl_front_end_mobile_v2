import 'dart:async';

import 'package:do_an_ui/models/customer.model.dart';
import 'package:do_an_ui/services/customer.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserData {
  late final BehaviorSubject<Customer> itemBehavior;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isInitialized = false;
  final String uid;
  final _customerService = CustomerService();

  UserData({
    required this.uid
}) {
    _initialize();
  }

  Future _initialize() async {
    final Customer? user = await _customerService.readOnce(this.uid);

    if (user == null) {
      throw('Customer with id ${this.uid} does not exit in database');
    } else {
      itemBehavior = BehaviorSubject.seeded(user);
    }

    _customerService.readLive(uid).listen((user) {
      if (user != null) {
        _set(user);
      }
    });

    _isInitialized = true;
  }

  Stream<Customer> getStream() {
    if (!_isInitialized) {
      throw('User has not been initialized!');
    }
    return itemBehavior.stream;
  }

  void _set(Customer val) async {
    if (!_isInitialized) {
      throw('User has not been initialized!');
    }

    itemBehavior.add(val);
  }

  Customer currentUser() {
    if (!_isInitialized) {
      throw('User has not been initialized!');
    }

    return itemBehavior.value;
  }

  void dispose() {
    if (!_isInitialized) {
      throw('User has not been initialized!');
    }

    itemBehavior.close();
  }
}

late UserData g_userData;