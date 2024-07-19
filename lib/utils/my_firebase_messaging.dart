import 'dart:convert';

import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/chat_page/chat_detail_page.dart';
import 'package:eocout_flutter/features/dashboard_page.dart';
import 'package:eocout_flutter/firebase_options.dart';
import 'package:eocout_flutter/utils/notification_type_util.dart';
import 'package:eocout_flutter/utils/print_error.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class MyFirebaseMessaging {
  static const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final NotificationBloc notificationBloc;

  MyFirebaseMessaging({required this.notificationBloc});

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    // Initialize Firebase

    try {
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
    } catch (err) {
      printError(err, method: "initializing FCM token");
    }

    // Initialize local notification
    await _initializeLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }

      RemoteNotification? notification = message.notification;
      if (kDebugMode) {
        print("Data : ${message.data}");
      }

      if (notification != null) {
        String? title = notification.title;
        String? body = notification.body;

        if (kDebugMode) {
          print(notification.toMap());
          print(notification.toString());
        }

        if (title != null &&
            body != null &&
            notificationBloc.currentChatId.valueOrNull !=
                message.data["ref_id"]) {
          if (kDebugMode) {
            print("Showing notification");
          }
          showNotification(title, body, message.data);
        }
      }
    });
    try {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print("onMessageOpenedApp: $message");
        }
        notificationBloc.fetchNotifications();
      });
    } catch (e) {
      printError(e, method: "onMessageOpenedApp");
    }

    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      printError(e, method: "onBackgroundMessage");
    }
  }

  /// Initialize local notification
  Future<void> _initializeLocalNotification() async {
    try {
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

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: handleNotificationClick,
      );
    } catch (err) {
      printError(err, method: "initializing local notification");
    }
  }

  Future<void> showNotification(
      String title, String body, Map<String, dynamic>? data) async {
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
      payload: jsonEncode(data),
    );
  }

  Future<void> handleNotificationClick(NotificationResponse details) async {
    Map<String, dynamic> data = jsonDecode(details.payload ?? "{}");

    if (kDebugMode) {
      print("Notification data: $data");
    }

    NotificationType? type =
        NotificationTypeUtil.fromString(data["notification_type"]);

    if (type == NotificationType.chat) {
      String? chatId = data["ref_id"];
      navigatorNavigateTo(
        ChatDetailPage(
          conversationId: chatId,
        ),
        transition: TransitionType.slideInFromBottom,
      );
    } else if (type == NotificationType.userBooking) {
      navigatorNavigateTo(const DashboardPage(),
          transition: TransitionType.slideInFromBottom, clearStack: true);
    }
  }
}
