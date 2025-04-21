import 'package:flutter/material.dart';
import 'package:organ/screen/auth/login_screen.dart';
import 'package:organ/config/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
