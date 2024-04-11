import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  // User ID
  int? _userId;
  int? get userId => _userId;

  Future<void> updateUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    _userId = userId;
    log('AP User ID: $userId');
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _userId = null;
    log('AP User ID: $_userId');
    notifyListeners();
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    log('AP User ID: $_userId');
    notifyListeners();
  }

}