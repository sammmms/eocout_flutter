import 'package:shared_preferences/shared_preferences.dart';

class Store {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  static Future<String> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    prefs.remove("token");
    return token;
  }

  static clearAuthenticationStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('resendOTPTime');
  }

  static Future<void> saveFCMToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcmToken", token);
  }

  static Future<String> getFCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("fcmToken") ?? "";
  }

  static Future<void> saveResendOTPTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now().add(const Duration(seconds: 60));
    prefs.setString("resendOTPTime", time.toIso8601String());
  }

  static Future<DateTime?> getResendOTPTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? time = prefs.getString("resendOTPTime");
    if (time == null) return null;
    return DateTime.parse(time);
  }

  static Future<void> removeResendOTPTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("resendOTPTime");
  }

  static Future<void> saveLastRead(String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lastRead/$chatId", DateTime.now().toIso8601String());
  }

  static Future<String?> getLastRead(String chatId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastRead/$chatId");
  }

  static Future<void> saveLastSeenNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lastSeenNotification", DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastSeenNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? time = prefs.getString("lastSeenNotification");
    if (time == null) return null;
    return DateTime.parse(time);
  }
}
