import 'dart:async';
import 'package:firebase/firebase%20functions/firebase_functions.dart';
import 'package:firebase/screens/profile_screen.dart';
import 'package:firebase/screens/sign_up_screen.dart';
import 'package:firebase/validators/validators.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final StreamController<String> _emailStreamController =
      StreamController<String>();
  final StreamController<String> _passwordStreamController =
      StreamController<String>();

  String _currentEmail = '';
  String _currentPassword = '';

  @override
  void initState() {
    super.initState();

    _emailStreamController.stream.listen(
      (email) {
        _currentEmail = email;
      },
    );
    _passwordStreamController.stream.listen(
      (password) {
        _currentPassword = password;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in '),
        backgroundColor: Colors.blueAccent,
      ),
      // backgroundColor: Colors.white70,
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: Validators.emailValidator,
                  onChanged: (email) {
                    _emailStreamController.sink.add(email);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(hintText: 'Enter Email : '),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: Validators.passwordValidator,
                  onChanged: (password) {
                    _passwordStreamController.sink.add(password);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(hintText: 'Enter Password : '),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFunctions.loginUser(
                          _currentEmail, _currentPassword);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    } else {
                      const SnackBar(
                        content: Text('Enter valid Information'),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: const Text(
                    'Create a new account?',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
