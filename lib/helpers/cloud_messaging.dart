import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:harkat_app/model/new_order_notification.dart';
import 'package:harkat_app/screens/customer/track_order/track_order_screen.dart';
import 'package:harkat_app/screens/suggestion/suggestion_chat_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/new_order_dialog.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class CloudMessaging {
  BuildContext _context;
  FirebaseMessaging _firebaseMessaging;

  static final CloudMessaging instance = CloudMessaging.internal();

  CloudMessaging.internal() {
    _firebaseMessaging = FirebaseMessaging.instance;
    initLocationNotifications();
    _firebaseMessaging.subscribeToTopic("driver");
    FirebaseMessaging.onMessage.listen((event) {
      showNotification(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      processNotification(message.data);
    });
  }

  setContext(BuildContext context) {
    this._context = context;
  }

  Future<void> pushToken() async {
    _firebaseMessaging.getToken().then((token) async {});
  }

  void showNotification(RemoteMessage message) async {
    printInfo(info: message.toString());
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.aridev.teachers_app',
      'Flutter chat demo',
      channelDescription: 'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.high,
      priority: Priority.high,
      ongoing:
          message.data.containsKey('type') && message.data['type'] == 'order'
              ? true
              : false,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification.title,
      message.notification.body,
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  initLocationNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onSelectIosLocalNotification,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectLocalNotification,
    );
  }

  Future onSelectLocalNotification(String payload) async {
    if (payload != null) {
      await processNotification(json.decode(payload));
    }
    //await Navigator.push(_context,CupertinoPageRoute(builder: (context) => SecondScreen(payload)),);
  }

  Future<void> showNewOrderDialog(Map<String, dynamic> payload) async {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getUiWidth(10)),
          ),
          child: NewOrderDialog(
            notification: NewOrderNotification.fromJson(payload),
          ),
        );
      },
    );
  }

  // showLocalNotification(Map<String, dynamic> payload) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     '2',
  //     'Driver',
  //     'Harkat Driver App',
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     ticker: 'ticker',
  //     enableVibration: true,
  //     visibility: NotificationVisibility.Public,
  //     additionalFlags: payload.containsKey('type') && payload['type'] == 'order'
  //         ? Int32List.fromList([4])
  //         : null,
  //   );
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await _flutterLocalNotificationsPlugin.show(
  //       0,
  //       payload['notification']['title'] == null
  //           ? payload['data']['title']
  //           : payload['notification']['title'],
  //       payload['notification']['title'] == null
  //           ? payload['data']['body']
  //           : payload['notification']['body'],
  //       platformChannelSpecifics,
  //       payload: json.encode(payload));
  // }

  Future<dynamic> onSelectIosLocalNotification(
      int id, String a, String b, String c) async {
    print("OnIos Notification");
  }

  Future<void> processNotification(Map<String, dynamic> msg) async {
    Navigator.of(_context).popUntil((route) => route.isFirst);
    if (msg.containsKey('type')) {
      if (msg['type'].toString() == 'new_order') {
        await showNewOrderDialog(msg);
      } else if (msg['type'].toString() == 'order') {
        Get.to(() => TrackOrderScreen(orderId: msg['id']));
      } else if (msg['type'].toString() == 'complaint') {
        Get.to(() => SuggestionChatScreen(suggestionId: msg['id']));
      }
    } else if (msg['data'].containsKey('url')) {
      print("Process Notification URL $msg");
    }
    print("Process Notification $msg");
  }
}
