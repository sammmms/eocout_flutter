import 'dart:convert';

import 'package:eocout_flutter/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  static Future<void> saveUser(UserData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedUser = jsonEncode(user.toJson());
    prefs.setString("user", encodedUser);
  }

  static Future<UserData?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedUser = prefs.getString("user");
    if (encodedUser == null) return null;
    Map<String, dynamic> userMap = jsonDecode(encodedUser);
    return UserData.fromJson(userMap);
  }

  static Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }

  static clearStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> saveFCMToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcmToken", token);
  }
}
