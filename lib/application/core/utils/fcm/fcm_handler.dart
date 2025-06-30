import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/cache/cache_manager.dart';
import 'notification_handler.dart';

class FCMHandler {
  static final FCMHandler _instance = FCMHandler._internal();

  factory FCMHandler() {
    return _instance;
  }

  FCMHandler._internal();

  Future<void> initializeFCM() async {
    final NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      FirebaseMessaging.onMessage.listen(_onMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
      FirebaseMessaging.instance.getInitialMessage().then(
        (message) {
          if (message != null) handleMessage(message);
        },
      );
    }
  }

  Future<void> _onMessage(RemoteMessage message) async {
    await handleMessage(message, displayNotification: true);
  }

  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    await handleMessage(message);
  }
}

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await CacheManager.instance.init();
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
  await handleMessage(message);
}

Future<void> handleMessage(RemoteMessage message, {bool displayNotification = false}) async {
  if (message.notification == null || displayNotification) {
    await LocalNotificationHandler.displayNotification(message);
  }
  if (message.data.isEmpty) return;

  debugPrint("Handling a message: ${message.data}");
}
