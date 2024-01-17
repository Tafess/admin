// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:admin/constants/constants.dart';
import 'package:admin/views/widgets/category_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _image;

  String? fileName;
  late String categoryName;
  TextEditingController nameContorller = TextEditingController();

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  uploadCategoryImageToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('CategoryImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('Dounload url= $downloadUrl');
    return downloadUrl;
  }

  uploadCategory() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = await uploadCategoryImageToStorage(_image!);
      String docId = _firestore.collection('categories').doc().id;
      await _firestore.collection('categories').doc().set(
        {
          'id': docId,
          'image': imageUrl,
          'name': categoryName,
        },
      );

      nameContorller.text = '';
      setState(() {
        _image = null;
      });

      showSnackBarMessage(
        context: context,
        message: 'Category Successfully Added',
        label: 'Ok',
        color: Colors.green.shade400,
        margin: 10,
      );
    } else {
      print('OH Bad Guy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: _image == null ? 140 : 300,
                          width: _image == null ? 140 : 300,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                            //   border: Border.all(color: Colors.grey.shade800),
                          ),
                          child: _image != null
                              ? InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Image.memory(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Positioned(
                                  right: 3,
                                  bottom: 20,
                                  child: FloatingActionButton(
                                      backgroundColor: Colors.white70,
                                      onPressed: () {
                                        _pickImage();
                                      },
                                      child: Icon(Icons.add_a_photo)),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: nameContorller,
                        onChanged: (value) {
                          categoryName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter category Name ';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: 'Enter Category Name'),
                      ),
                    ),
                    SizedBox(height: 12),
                    if (_image != null)
                      TextButton(
                          onPressed: () {
                            uploadCategory();
                          },
                          child: Text(
                            'Save Category',
                            style: TextStyle(color: Colors.green),
                          ))
                  ],
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: CategoryWidget()),
          ],
        ),
      ),
    );
  }
}







