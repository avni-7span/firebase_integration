import 'dart:async';
import 'package:firebase/firebase%20functions/firebase_functions.dart';
import 'package:firebase/validators/validators.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  StreamController<String> emailStreamController = StreamController<String>();
  StreamController<String> passwordStreamController =
      StreamController<String>();

  String currentEmail = '';
  String currentPassword = '';

  @override
  void initState() {
    super.initState();
    emailStreamController.stream.listen(
      (email) {
        currentEmail = email;
      },
    );
    passwordStreamController.stream.listen(
      (password) {
        currentPassword = password;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailStreamController.close();
    passwordStreamController.close();
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
          key: formKey,
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
                    emailStreamController.sink.add(email);
                  },
                  decoration: const InputDecoration(hintText: 'Enter Email : '),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: Validators.passwordValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (password) {
                    passwordStreamController.sink.add(password);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Create Account Password : '),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String finalEmail =
                          await emailStreamController.stream.last;
                      String finalPassword =
                          await passwordStreamController.stream.last;
                      print(
                          'final email : $finalEmail , final pass : $finalPassword');
                      //FirebaseFunctions.createUser(finalEmail,finalPassword);
                    }
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
