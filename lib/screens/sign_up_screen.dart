import 'dart:async';
import 'package:firebase/firebase%20functions/firebase_functions.dart';
import 'package:firebase/screens/login_screen.dart';
import 'package:firebase/validators/validators.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  void dispose() {
    super.dispose();
    _emailStreamController.close();
    _passwordStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextField(
                  decoration: InputDecoration(hintText: 'Enter your name :'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: Validators.emailValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (email) {
                    _emailStreamController.sink.add(email);
                  },
                  decoration: const InputDecoration(hintText: 'Enter Email : '),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: Validators.passwordValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (password) {
                    _passwordStreamController.sink.add(password);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Create Account Password : '),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFunctions.createUser(
                          _currentEmail, _currentPassword);
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
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
