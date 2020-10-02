import 'package:flutter/material.dart';
import 'package:harkat_app/screens/change_password/change_password_screen.dart';
import 'package:harkat_app/screens/home/home_screen.dart';
import 'package:harkat_app/screens/reset_password/reset_password_screen.dart';
import 'package:harkat_app/screens/suggestion/suggestion_screen.dart';

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
      case '/changepassword':
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
        break;
      case '/suggestion':
        return MaterialPageRoute(builder: (_) => SuggestionScreen());
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
