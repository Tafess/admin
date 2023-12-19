// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import

import 'dart:io';

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/primary_button.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
    required,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
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
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  // TextEditingController description = TextEditingController();
  CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Product edit')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                    radius: 55,
                    child: Icon(Icons.camera_alt),
                  ),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Image.file(image!),
                  ),
                ),
          SizedBox(height: 12),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Product name'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField(
            dropdownColor: Colors.white,
            value: _selectedCategory,
            hint: Text(
              'Select category',
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            items: appProvider.getCategoryList.map((CategoryModel val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val.name,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: description,
            minLines: 2,
            maxLines: 10,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Product discription'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Price',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
        //       child: PrimaryButton(
        //           onPressed: () async {
        //             if (image == null ||
        //                 _selectedCategory == null ||
        //                 name.text.isEmpty ||
        //                 description.text.isEmpty ||
        //                 price.text.isEmpty) {
        //               showMessage('Please Enter values');
        //             } else if (image != null) {
        //               appProvider.addProduct(
        //                 image!,
        //                 name.text,
        //                 description.text,
        //                 _selectedCategory!.id,
        //                 price.text.toString(),
        //                 price.text.toString(),
        //               );
        //               showMessage('Product successfully Added');
        //               setState(() {
        //                 image = null;
        //                 name.clear();
        //                 description.clear();
        //                 _selectedCategory = null;
        //                 price.clear();
        //               });
        //             }

        //             //   appProvider.updateUserInfoFirebase(
        //             //   context, userModel, image);
        //           },
        //           title: 'Add'))
       ) ],
      ),
    );
  }
}
