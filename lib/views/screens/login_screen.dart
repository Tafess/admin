// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:admin/constants/custom_snackbar.dart';
import 'package:admin/constants/custome_button.dart';
import 'package:admin/constants/routes.dart';
import 'package:admin/constants/custom_text.dart';
import 'package:admin/views/screens/main_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          centerTitle: true,
          title: text(
              title:
                  'Welcome to Belkis marketplace Login with your account to continue ',
              color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 300, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.0),
                      Container(
                          height: 150,
                          width: 600,
                          child: Image.asset('assets/images/shopMouse.jpg')),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16.0),
                      CustomButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            customSnackbar(
                                context: context,
                                message: 'Please enter your email address');
                          } else if (_passwordController.text.isEmpty) {
                            customSnackbar(
                                context: context,
                                message: 'Please enter your password');
                          } else {
                            await _signInWithEmailAndPassword();
                          }
                        },
                        title: 'Login',
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        _errorText,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      bool isAdmin = await _checkAdmin(userCredential.user?.uid ?? '');

      if (isAdmin) {
        customSnackbar(
            context: context,
            message: 'You are successfully logged in',
            backgroundColor: Colors.green.shade300);

        Routes.instance
            .pushAndRemoveUntil(widget: MainAppScreen(), context: context);
      } else {
        customSnackbar(
            context: context, message: 'You are not authorized as an admin');
        setState(() {
          _errorText = 'You are not authorized as an admin.';
        });
      }
    } on FirebaseAuthException catch (e) {
      customSnackbar(
          context: context, message: 'Some eror is occured Try again');
      setState(() {
        _errorText = e.message ?? 'An error occurred';
      });
    }
  }

  Future<bool> _checkAdmin(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('admin').doc(userId).get();

      return snapshot.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
