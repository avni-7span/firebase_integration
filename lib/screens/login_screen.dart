import 'dart:async';
import 'package:firebase/firebase%20functions/firebase_functions.dart';
import 'package:firebase/screens/profile_screen.dart';
import 'package:firebase/screens/sign_up_screen.dart';
import 'package:firebase/validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String currentEmail = '';
  String _currentPassword = '';

  //final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _emailStreamController.stream.listen(
      (email) {
        currentEmail = email;
      },
    );
    _passwordStreamController.stream.listen(
      (password) {
        _currentPassword = password;
      },
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      } else {
        //print('==');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong')));
      }
    });
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Enter Email'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: Validators.passwordValidator,
                  obscureText: true,
                  onChanged: (password) {
                    _passwordStreamController.sink.add(password);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    label: Text('Enter Password'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseFunctions.loginUser(
                            currentEmail, _currentPassword);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not log it')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter valid Information'),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                InkWell(
                  child: const Text(
                    'Create a new account?',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
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
