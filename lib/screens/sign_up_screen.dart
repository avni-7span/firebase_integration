import 'dart:async';
import 'package:firebase/firebase%20functions/firebase_functions.dart';
import 'package:firebase/screens/login_screen.dart';
import 'package:firebase/screens/profile_screen.dart';
import 'package:firebase/validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController confirmPassController = TextEditingController();

  String _currentEmail = '';
  String _currentPassword = '';
  bool isLoading = false;

  User? user;

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
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _passwordStreamController.close();
    super.dispose();
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: Validators.nameValidator,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter your name'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validators.emailValidator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (email) {
                      _emailStreamController.sink.add(email);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter Email '),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: Validators.passwordValidator,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (password) {
                      _passwordStreamController.sink.add(password);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Create Account Password '),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPassController,
                    validator: (value) => Validators.confirmPasswordValidator(
                      password: _currentPassword,
                      confirmPassword: value ?? '',
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Confirm Password : '),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _currentPassword == confirmPassController.text &&
                            _currentEmail !=
                                FirebaseAuth.instance.currentUser?.email) {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseFunctions.createUser(
                              _currentEmail, _currentPassword);
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Signed Up Successfully'),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_currentEmail ==
                                      FirebaseAuth.instance.currentUser?.email
                                  ? 'Account already exists'
                                  : _currentPassword ==
                                          confirmPassController.text
                                      ? 'Please complete sign up process'
                                      : 'Please Confirm password'),
                            ),
                          );
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                  // const SizedBox(height: 10),
                  // if (isLoading) const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
