import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  static Future<void> createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Exception aavyu : $e');
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          // await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('user not found');
      } else if (e.code == 'wrong-password') {
        print('wrong password');
      }
    }
    return null;
  }
}
