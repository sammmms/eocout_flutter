import 'package:eocout_flutter/firebase_options.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseMessaging {
  static const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize Firebase Messaging
  static Future<void> initialize() async {
    // Initialize Firebase

    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    // Request notification permission
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (kDebugMode) {
      print("Notification settings: $settings");
    }

    String? fcmToken = await messaging.getToken();

    if (kDebugMode) {
      print("FCM Token: $fcmToken");
    }

    if (fcmToken != null) {
      await Store.saveFCMToken(fcmToken);
    }

    // Initialize local notification
    await _initializeLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        String? title = notification.title;
        String? body = notification.body;

        if (title != null && body != null) {
          showNotification(title, body);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessageOpenedApp: $message");
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Initialize local notification
  static Future<void> _initializeLocalNotification() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
      'app_icon',
    );

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    return flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> showNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }
}
