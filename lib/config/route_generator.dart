import 'package:flutter/material.dart';
import 'package:organ/screen/login_screen.dart';
import 'package:organ/screen/change_password_screen.dart';
import 'package:organ/screen/matching_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/changePassword':
        return MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        );
      case '/matching':
        return MaterialPageRoute(builder: (context) => const MatchingScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
