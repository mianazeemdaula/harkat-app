import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harkat_app/model/new_order_notification.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/widgets/new_order_dialog.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   print("onBackground: $message");
//   if (message.containsKey('data')) {
//     print("Data Message");
//     // Handle data message
//     var scheduledNotificationDateTime =
//         DateTime.now().add(Duration(seconds: 2));
//     var vibrationPattern = Int64List(4);
//     vibrationPattern[0] = 0;
//     vibrationPattern[1] = 1000;
//     vibrationPattern[2] = 5000;
//     vibrationPattern[3] = 2000;

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your other channel id',
//         'your other channel name',
//         'your other channel description',
//         icon: 'secondary_icon',
//         // sound: RawResourceAndroidNotificationSound('slow_spring_board'),
//         // largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
//         vibrationPattern: vibrationPattern,
//         enableLights: true,
//         color: const Color.fromARGB(255, 255, 0, 0),
//         ledColor: const Color.fromARGB(255, 255, 0, 0),
//         ledOnMs: 1000,
//         ledOffMs: 500);
//     var iOSPlatformChannelSpecifics =
//         IOSNotificationDetails(sound: 'slow_spring_board.aiff');
//     var platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.schedule(
//         0,
//         'scheduled title',
//         'scheduled body',
//         scheduledNotificationDateTime,
//         platformChannelSpecifics);
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }

//   // Or do other work.
// }

class CloudMessaging {
  BuildContext _context;
  FirebaseMessaging _firebaseMessaging;

  static final CloudMessaging instance = CloudMessaging.internal();

  CloudMessaging.internal() {
    _firebaseMessaging = FirebaseMessaging();
    initLocationNotifications();
    _firebaseMessaging.subscribeToTopic("driver");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
        // showNewOrderDialog(message['data']);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        processNotification(message);
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        processNotification(message);
      },
    );
  }

  setContext(BuildContext context) {
    this._context = context;
  }

  Future<void> pushToken() async {
    _firebaseMessaging.getToken().then((token) async {});
  }

  void showNotification(Map<String, dynamic> message) async {
    print("Show notification method called");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.aridev.teachers_app'
          : 'com.aridev.teachers_app',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: message.containsKey('type') && message['type'] == 'order'
          ? true
          : false,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'].toString(),
        message['notification']['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  initLocationNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onSelectIosLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectLocalNotification);
  }

  Future onSelectLocalNotification(String payload) async {
    if (payload != null) {
      await processNotification(json.decode(payload));
    }
    //await Navigator.push(_context,CupertinoPageRoute(builder: (context) => SecondScreen(payload)),);
  }

  Future<void> showNewOrderDialog(Map<String, dynamic> payload) async {
    print("Payload : $payload");
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
    if (msg.containsKey('data')) {
      if (msg['data'].containsKey('type')) {
        if (msg['data']['type'].toString() == 'new_order') {
          await showNewOrderDialog(msg['data']);
        }
      } else if (msg['data'].containsKey('url')) {
        print("Process Notification URL $msg");
      }
    }
    print("Process Notification $msg");
  }
}
