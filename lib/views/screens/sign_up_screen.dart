// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:admin/constants/custom_snackbar.dart';
import 'package:admin/constants/custome_button.dart';
import 'package:admin/controllers/firebase_auth_helper.dart';
import 'package:admin/models/admin_model.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AdminModel adminModel = AdminModel();
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool hasCapital = false;
  bool hasSmall = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;
  bool isPasswordFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 400.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  controller: firstName,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Middle Name'),
                  controller: middleName,
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  controller: lastName,
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: email,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    // Add additional email validation if needed
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  controller: phoneNumber,
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: password,
                  onChanged: (value) {
                    setState(() {
                      hasCapital = RegExp(r'[A-Z]').hasMatch(value);
                      hasSmall = RegExp(r'[a-z]').hasMatch(value);
                      hasDigit = RegExp(r'[0-9]').hasMatch(value);
                      hasSpecialChar =
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
                    });
                  },
                  validator: (value) {
                    if (!hasCapital ||
                        !hasSmall ||
                        !hasDigit ||
                        !hasSpecialChar) {
                      return 'Password must have at least one capital letter, one small letter, one digit, and one special character';
                    }
                    // Add additional password validation if needed
                    return null;
                  },
                  onTap: () {
                    setState(() {
                      isPasswordFocused = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      isPasswordFocused = false;
                    });
                  },
                ),
                if (isPasswordFocused)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStrengthIndicator('Capital', hasCapital),
                      _buildStrengthIndicator('Small', hasSmall),
                      _buildStrengthIndicator('Digit', hasDigit),
                      _buildStrengthIndicator('Special', hasSpecialChar),
                    ],
                  ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  controller: confirmPassword,
                  validator: (value) {
                    if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        await _authHelper.signUp(
                          firstName.text,
                          middleName.text,
                          lastName.text,
                          email.text,
                          phoneNumber.text,
                          password.text,
                          context,
                        );
                        customSnackbar(
                          context: context,
                          message: 'Successfully Created ',
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                  child: Text('Create Admin Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthIndicator(String label, bool isMet) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: isMet ? Colors.green : Colors.red),
        ),
        Container(
          width: 20,
          height: 5,
          color: isMet ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
