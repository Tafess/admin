// ignore_for_file: use_build_context_synchronously

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/routes.dart';
import 'package:admin/models/admin_model.dart';
import 'package:admin/views/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      ShowLoderDialog(context);

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Routes.instance
          .pushAndRemoveUntil(widget: HomepageScreen(), context: context);
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      showMessage(error.code.toString());
      return false;
    }
  }

  Future<bool> signUp(
    String firetName,
    String middleName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
    BuildContext context,
  ) async {
    try {
      ShowLoderDialog(context);

      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      AdminModel adminModel = AdminModel(
        id: userCredential.user!.uid,
        firstName: firetName,
        middleName: middleName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        profileImage: null,
      );
      Routes.instance.push(widget: HomepageScreen(), context: context);

      _firestore
          .collection('admin')
          .doc(adminModel.id)
          .set(adminModel.toJson());
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      showMessage(error.code.toString());
      return false;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      ShowLoderDialog(context);

      // Get the current user
      User? user = _auth.currentUser;

      // Create a credential using the user's email and password
      AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!, password: oldPassword);

      // Reauthenticate the user with the credential
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      Navigator.of(context, rootNavigator: true).pop();
      showMessage('Password changed');
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.message!);
      return false;
    }
  }
}
