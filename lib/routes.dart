import 'package:flutter/material.dart';
import 'package:harkat_app/screens/home/home_screen.dart';
import 'package:harkat_app/screens/reset_password/reset_password_screen.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
        break;
      case '/resetpassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
        break;
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SafeArea(child: Text('Route Error')),
          ),
        );
    }
  }
}
