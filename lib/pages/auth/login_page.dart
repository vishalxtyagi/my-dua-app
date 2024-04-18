import 'dart:developer';

import 'package:dua/pages/auth/forgot_password_page.dart';
import 'package:dua/pages/auth/signup_page.dart';
import 'package:dua/pages/home_page.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/utils/auth.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  final Widget? redirectTo;

  const LoginPage({super.key, this.redirectTo});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthProvider authProvider;
  late AudioProvider audioProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _credentials = {
    'username': '',
    'password': ''
  };

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      login(_credentials,
          onSuccess: (userId) {
            log('User ID: $userId');
            authProvider.updateUserId(userId);
            audioProvider.clearAll();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Login'),
                  content: Text('You\'ve been logged in successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (widget.redirectTo != null) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => widget.redirectTo!),
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                                (route) => false,
                          );
                        }
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );          },
          onError: (message) {
            // Show alert dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Login'),
                  content: Text(formatHeading(message)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)
                  ),
                fillColor: Colors.white,
                filled: true
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _credentials['username'] = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                      fillColor: Colors.white,
                      filled: true
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _credentials['password'] = value!;
                  },
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'By logging in, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Color(0xFF008080),
                          decoration: TextDecoration.underline,
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                FilledButton(
                  onPressed: _submitForm,
                  child: Text('Login', style: TextStyle(fontSize: 15)),
                ),
                SizedBox(height: 50),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF008080),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign up link press
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // Handle forgot password link press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    'Forgot your Password?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}