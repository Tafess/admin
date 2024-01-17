// Import statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategoryScreen extends StatefulWidget {
  final QueryDocumentSnapshot categoryData;

  const EditCategoryScreen({Key? key, required this.categoryData})
      : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.categoryData['name'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(
                widget.categoryData['image'],
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateCategory();
              },
              child: Text('Update Category'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCategory() async {
    String newName = _nameController.text;

    // Update the category details in Firestore
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryData.id)
        .update({
      'name': newName,
      // You can update other fields as needed
    });

    Navigator.of(context).pop(); // Close the edit screen
  }
}


