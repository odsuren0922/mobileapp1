import 'package:flutter/material.dart';
import 'package:orlogo/Screens/Login.dart';
import 'package:orlogo/Screens/Register.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F7), // Background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  // 3D Illustration Placeholder
                  SizedBox(
                    height: 250,
                    child: Image.asset(
                        'lib/assets/images/Group.png'), // Add your illustration here
                  ),
                  const SizedBox(height: 20),
                  // Title Text
                  const Text(
                    'Ухаалаг Зарцуулж\nИлүү Хэмнэе',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(84, 19, 139, 123),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                      },
                      child: const Text(
                        'Эхлэх',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Footer Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add navigation logic for rights info
                        },
                        child: const Text(
                          'Харилцагчийн Эрх Бий Юу?',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const Text('|', style: TextStyle(color: Colors.black45)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Нэвтрэх',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
