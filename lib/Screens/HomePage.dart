import 'package:orlogo/Screens/Addexpense.dart';
import 'package:orlogo/Screens/CardDetails.dart';
import 'package:orlogo/Screens/Dashboard.dart';
import 'package:orlogo/Screens/Detail.dart';
import 'package:orlogo/Screens/MainPage.dart';
import 'package:orlogo/Widgets/bottomnav.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Mainpage(),
    AddExpensePage(),
    DashboardPage(),
    CardDetailsPage(),
  ];

  void _onItemTorlogoed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: const Bottom(),
    );
  }
}
