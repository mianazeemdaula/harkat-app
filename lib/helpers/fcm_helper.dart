import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harkat_app/main-notificatinos.dart';
import 'package:rxdart/rxdart.dart';

class FCMHelper {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("onBackground: $message");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> configLocalNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  static Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}
}
