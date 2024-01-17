import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/constants/custom_snackbar.dart';
import 'package:admin/constants/custome_button.dart';
import 'package:admin/constants/custom_text.dart';
import 'package:admin/views/screens/main_app_screen.dart';

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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
        title: text(
            title: 'WELCOME TO BELKIS ONLINE MARKTPLACE',
            size: 24,
            color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/belkis1.jpg',
                height: 150,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _sendPasswordResetEmail();
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty) {
                          customSnackbar(
                            context: context,
                            message: 'Please enter your email address',
                          );
                        } else if (_passwordController.text.isEmpty) {
                          customSnackbar(
                            context: context,
                            message: 'Please enter your password',
                          );
                        } else {
                          await _signInWithEmailAndPassword();
                        }
                      },
                      title: 'Login',
                    ),
                  ),
                ],
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
          backgroundColor: Colors.green.shade300,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainAppScreen()),
          (route) => false,
        );
      } else {
        customSnackbar(
          context: context,
          message: 'You are not authorized as an admin',
        );
        setState(() {
          _errorText = 'You are not authorized as an admin.';
        });
      }
    } on FirebaseAuthException catch (e) {
      customSnackbar(
        context: context,
        message: 'Some error occurred. Try again',
      );
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

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      customSnackbar(
        context: context,
        message: 'Password reset email sent. Check your email.',
        backgroundColor: Colors.green.shade300,
      );
    } on FirebaseAuthException catch (e) {
      customSnackbar(
        context: context,
        message: 'Failed to send password reset email. ${e.message}',
      );
    }
  }
}
