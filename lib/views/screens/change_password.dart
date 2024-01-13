// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:admin/constants/custom_snackbar.dart';
import 'package:admin/constants/custome_button.dart';
import 'package:admin/controllers/firebase_auth_helper.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool hasCapital = false;
  bool hasSmall = false;
  bool hasDigit = false;
  bool hasSpecialChar = false;
  bool isPasswordFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isOldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isOldPasswordVisible = !isOldPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !isOldPasswordVisible,
                controller: oldPasswordController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your old password';
                  }
                  // Add additional validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !isNewPasswordVisible,
                controller: newPasswordController,
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
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !isConfirmPasswordVisible,
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  if (Form.of(context).validate()) {
                    bool success = await _authHelper.changePassword(
                        oldPasswordController.text,
                        newPasswordController.text,
                        context);

                    if (success) {
                      customSnackbar(
                          context: context,
                          message: 'Password changed successfully',
                          backgroundColor: Colors.green);
                      Navigator.of(context).pop();
                    } else {
                      customSnackbar(
                          context: context,
                          message: 'Failed to change password',
                          backgroundColor: Colors.green);
                    }
                  }
                },
                title: 'Change Password',
              ),
            ],
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
