// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/primary_button.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/widgets/single_category_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryViewScreen extends StatefulWidget {
  static const String id = 'category-view-screen';
  const CategoryViewScreen({Key? key});

  @override
  State<CategoryViewScreen> createState() => _CategoryViewScreenState();
}

class _CategoryViewScreenState extends State<CategoryViewScreen> {
  File? image;

  TextEditingController name = TextEditingController();

  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                      radius: 55,
                      backgroundImage: FileImage(image!),
                    ),
              const SizedBox(height: 12),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Category name',
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onPressed: () async {
                  if (image == null || name.text.isEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    AppProvider appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    appProvider.addCategory(image!, name.text);
                    showMessage('Category successfully added');
                    Navigator.of(context).pop();
                  }
                },
                title: 'Add',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white.withOpacity(0.9),
          appBar: AppBar(
            toolbarHeight: 40,
            title: const Text('categories'),
            actions: [
              IconButton(
                onPressed: () {
                  showAddCategoryDialog(context);
                },
                icon: const Icon(Icons.add_circle),
              )
            ],
          ),
          // drawer: CustomDrawer(),
          body: Consumer<AppProvider>(
            builder: (context, value, child) {
              //   AppProvider appProvider = Provider.of<AppProvider>(context);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    GridView.builder(
                      padding: EdgeInsets.all(12),
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Disable GridView scrolling
                      itemCount: value.getCategoryList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                      ),
                      itemBuilder: (context, index) {
                        CategoryModel categoryModel =
                            value.getCategoryList[index];
                        return SingleCategoryItem(
                          singleCategory: categoryModel,
                          index: index,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 3,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              showAddCategoryDialog(context);
            },
            child: Text(
              '+',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
