// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/primary_button.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class AddCategory extends StatefulWidget {
  const AddCategory({
    super.key,
  });

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
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
      appBar: AppBar(title: const Text('Category add')),
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
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: FileImage(image!),
                  ),
                ),
          const SizedBox(height: 12),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Category name'),
          ),
          const SizedBox(height: 20),
          SizedBox(
              child: PrimaryButton(
                  onPressed: () async {
                    if (image == null && name.text.isEmpty) {
                      Navigator.of(context).pop();
                    } else if (image != null && name.text.isNotEmpty) {
                      appProvider.addCategory(image!, name.text);
                      showMessage('Category successfuly add');
                      setState(() {
                        image = null;
                        name.clear();
                      });
                    }
                  },
                  title: 'Add'))
        ],
      ),
    );
  }
}
