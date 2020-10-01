import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/routes.dart';
import 'package:harkat_app/screens/home/home_screen.dart';
import 'package:harkat_app/screens/signin/signin_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/theme.dart';
import 'package:provider/provider.dart';

import 'providers/location_service_provider.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FCMHelper.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // FCMHelper.configLocalNotifications();

  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // var initializationSettingsAndroid =
  //     new AndroidInitializationSettings('app_icon');
  // var initializationSettingsIOS = new IOSInitializationSettings();
  // var initializationSettings = new InitializationSettings(
  //     initializationSettingsAndroid, initializationSettingsIOS);
  // flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(EasyLocalization(
    supportedLocales: [Locale('en', 'US'), Locale('ar', 'AE')],
    path: 'assets/translations', // <-- change patch to your
    fallbackLocale: Locale('en', 'US'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Harkat',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: AppPage(),
        onGenerateRoute: RouterGenerator.generateRoute,
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<UserRepository>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return Splash();
          case Status.Unauthenticated:
          case Status.Authenticating:
            return SigninScreen();
          case Status.Authenticated:
            return HomeScreen(
              user: user.user,
            );
        }
      },
    );
    // return HomeScreen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("App Inactive");
        break;
      case AppLifecycleState.paused:
        print("App Paused");
        break;
      case AppLifecycleState.resumed:
        print("App Resumed");
        break;
      case AppLifecycleState.detached:
        print("App Detached");
        break;
    }
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          height: getUiWidth(200),
          width: getUiHeight(200),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
