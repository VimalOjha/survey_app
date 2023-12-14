import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_app/src/features/common/users/data/models/user.dart';

class SharedPreferencesService {
  // Private constructor to prevent external instantiation
  SharedPreferencesService._privateConstructor();

  // Singleton instance
  static final SharedPreferencesService _instance =
  SharedPreferencesService._privateConstructor();

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferences? _preferences;

  // Initialize shared preferences
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Get a value from shared preferences
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Set a value in shared preferences
  Future<bool> setString(String key, String value) {
    return _preferences?.setString(key, value) ?? Future.value(false);
  }

  Future<void> saveLoggedInUser(String user) async{
    try {
      await _preferences?.setString('userModel', user);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  String? getLoggedInUser(){
    return _preferences?.getString("userModel");
  }

  Future<bool>? clearPreference(){
    return _preferences?.clear();
  }


// Additional methods for other data types can be added as needed
}