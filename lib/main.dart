import 'package:orlogo/Screens/Addexpense.dart';
import 'package:orlogo/Screens/Detail.dart';
import 'package:orlogo/Screens/HomePage.dart';
import 'package:orlogo/Screens/Login.dart';
import 'package:orlogo/Screens/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orlogo/Screens/Home.dart';
import 'package:orlogo/Screens/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/register': (context) => const RegistrationPage(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Homepage(),
        '/addexpense': (BuildContext context) => const AddExpensePage(),
      },
    );
  }
}
