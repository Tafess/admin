// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:admin/constants/constants.dart';
import 'package:admin/constants/custome_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  ////////////////////
  final FirebaseStorage _storage = FirebaseStorage.instance;
  dynamic _newImage;

  String? fileName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _newImage = result.files.first.bytes;
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

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: Image.network(
                          categoryData['image'],
                        ),
                      ),
                      Text(
                        categoryData['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      onPressed: () {
                        _editCategory(context, categoryData);
                      },
                      icon: Icon(Icons.edit_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editCategory(BuildContext context, QueryDocumentSnapshot categoryData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _nameController = TextEditingController(
          text: categoryData['name'],
        );

        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          title: Text('Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: 200,
                  child: _newImage != null
                      ? InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: Image.memory(
                            _newImage,
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
                              child: Image.network(categoryData['image'])),
                        ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  //  decoration: InputDecoration(labelText: 'Category Name'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            CustomButton(
              title: 'Update',
              width: 120,
              height: 30,
              color: Colors.blue,
              onPressed: () {
                _updateCategory(context, categoryData, _nameController.text);
              },
            )
          ],
        );
      },
    );
  }

  void _updateCategory(BuildContext context, QueryDocumentSnapshot categoryData,
      String newName) async {
    String imageUrl = await uploadCategoryImageToStorage(_newImage!);
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryData.id)
        .update({
      'name': newName,
      'image': imageUrl,
    });
    showSnackBarMessage(
      message: 'Category Successfully Updated',
      label: 'Ok',
      color: Colors.green.shade400,
      margin: 16,
      context: context,
    );

    Navigator.of(context).pop();
  }
}





