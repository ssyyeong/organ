import 'package:flutter/material.dart';
import 'package:organ/custom/bottom_navigation.dart';

import 'package:organ/screen/matching/matching_screen.dart';
import 'package:organ/screen/my_page/my_page_screen.dart';
import 'package:organ/screen/program/program_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _widgetOptions = [
    const MyPageScreen(),
    const ProgramScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: _widgetOptions.elementAt(_currentIndex)),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
