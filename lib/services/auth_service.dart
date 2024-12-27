import 'package:orlogo/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var db = Db();
  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required double balance,
    required double income,
    required double expenses,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      Map<String, dynamic> userData = {
        'email': email,
        'username': username,
        'balance': balance,
        'income': income,
        'expenses': expenses,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(userData);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: "Sign-up failed: ${e.message}",
      );
    }
  }

  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific errors for sign in, and throw exception with the error message
      throw FirebaseAuthException(
        code: e.code,
        message: "Sign-in failed: ${e.message}",
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Listen to auth changes (e.g., user sign in or sign out)
  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }
}
