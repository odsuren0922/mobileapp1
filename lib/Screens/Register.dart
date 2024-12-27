import 'package:orlogo/services/auth_service.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Assuming this imports the Login screen

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _authService = AuthService(); // Instantiate AuthService
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Call the signUp method from AuthService
        UserCredential? userCredential =
            await _authService.signUpWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _nameController.text.trim(),
          balance: 0.0,
          income: 0.0,
          expenses: 0.0,
        );
        if (userCredential != null) {
          // Successfully signed up
          print("User signed up: ${userCredential.user?.email}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Амжилттай бүртгэгдлээ!')),
          );
          // Clear fields after successful registration
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Алдаа гарлаа')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Алдаа гарлаа')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header Section
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00BFA6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Тавтай морилно уу?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Орлого, зарлагаа хянахад тань тусална',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Form Fields
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 30),
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Бүтэн нэр',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Нэр оруулна уу' : null,
                      ),
                      const SizedBox(height: 15),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Имэйл',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value!.contains('@')
                            ? null
                            : 'Зөв имэйл оруулна уу',
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Нууц үг',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value!.length < 6
                            ? 'Нууц үг 6-аас дээш тэмдэгттэй байх ёстой'
                            : null,
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Нууц үгээ дахин',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) => value == _passwordController.text
                            ? null
                            : 'Нууц үг таарахгүй байна',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Register Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 15),
                      ),
                      onPressed: _signUp,
                      child: const Text(
                        'Бүртгүүлэх',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add navigation logic for rights info
                      },
                      child: const Text(
                        'Хэрэглэгчийн эрхтэй юу?',
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
          ),
        ),
      ),
    );
  }
}
