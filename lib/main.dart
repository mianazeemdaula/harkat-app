import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/routes.dart';
import 'package:harkat_app/screens/customer/home/customer_home_screen.dart';
import 'package:harkat_app/screens/customer/vehicles/vehicle_types.dart';
import 'package:harkat_app/screens/home/home_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:harkat_app/theme.dart';
import 'package:provider/provider.dart';
import 'helpers/messages.dart';
import 'providers/pick_drop_order_prodiver.dart';
import 'screens/user_type_screen/user_type_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider(
          create: (context) => PickDropOrderProvider(),
        )
      ],
      child: GetMaterialApp(
        title: 'Harkat',
        translations: Messages(), // your translations
        locale: Locale('en', 'US'),
        fallbackLocale: Locale('ar', 'AE'),
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: AppPage(),
        onGenerateRoute: RouterGenerator.generateRoute,
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
      ),
    );
  }
}

class HarkatSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomSplash(
      home: AppPage(),
      duration: 5,
      imagePath: "assets/images/logo.png",
    );
  }
}

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Selector<UserRepository, Status>(
        builder: (context, value, child) {
          switch (value) {
            case Status.Uninitialized:
              return Splash();
              break;
            case Status.Unauthenticated:
            case Status.Authenticating:
              return UserTypeScreen();
            case Status.DriverAuth:
              return VehicleTypeScreen();
            case Status.CustomerAuth:
              return CustomerHomeScreen();
          }
          return Splash();
        },
        selector: (context, value) => value.status);
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          height: getUiWidth(250),
          width: getUiHeight(250),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
