import 'package:flutter/material.dart';
import 'package:organ/screen/auth/bussiness_info_screen.dart';
import 'package:organ/screen/auth/login_screen.dart';
import 'package:organ/screen/auth/change_password_screen.dart';
import 'package:organ/screen/matching/matching_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/changePassword':
        return MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        );
      case '/businessInfo':
        return MaterialPageRoute(
          builder: (context) => const BussinessInfoScreen(),
        );
      case '/matching':
        return MaterialPageRoute(builder: (context) => const MatchingScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
