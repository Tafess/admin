// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/primary_button.dart';
import 'package:admin/controllers/firebase_storage_helper.dart';
import 'package:admin/models/user_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditUser extends StatefulWidget {
  final UserModel userModel;
  final int index;
  const EditUser({super.key, required this.userModel, required this.index});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('User edit')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 50,
                      child: Icon(Icons.camera_alt)),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(
                    image!,
                  ),
                ),
          const SizedBox(height: 12),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: widget.userModel.name),
          ),
          const SizedBox(height: 20),
          SizedBox(
              child: PrimaryButton(
                  onPressed: () async {
                    if (image == null && name.text.isEmpty) {
                      Navigator.of(context).pop();
                    } else if (image != null) {
                      String imageUrl = await FirebaseStorageHelper.instance
                          .uploadUserImage(widget.userModel.id, image!);
                      UserModel userModel = widget.userModel.copyWith(
                        image: imageUrl,
                        name: name.text.isEmpty ? null : name.text,
                      );
                      appProvider.updateUserList(widget.index, userModel);
                      showMessage('user successfuly updated');
                    } else {
                      UserModel userModel = widget.userModel.copyWith(
                        name: name.text.isEmpty ? null : name.text,
                      );
                      appProvider.updateUserList(widget.index, userModel);
                      showMessage('user successfuly updated');
                    }
                    Navigator.of(context).pop();
                    //   appProvider.updateUserInfoFirebase(
                    //   context, userModel, image);
                  },
                  title: 'Update'))
        ],
      ),
    );
  }
}
