// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:admin/constants/constants.dart';
// import 'package:admin/constants/primary_button.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class AddCategory extends StatefulWidget {
//   const AddCategory({
//     super.key,
//   });

//   @override
//   State<AddCategory> createState() => _AddCategoryState();
// }

// class _AddCategoryState extends State<AddCategory> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   dynamic _image;

//   String? fileName;
//   late String categoryName;

//   _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.image);
//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//         fileName = result.files.first.name;
//       });
//     }
//   }

//   uploadCategoryImage(dynamic image) async {
//     Reference ref = _storage.ref().child('CategoryImages').child(fileName!);
//     UploadTask uploadTask = ref.putData(image);
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   uploadCategory() async {
//     // EasyLoading.show();
//     if (_formKey.currentState!.validate()) {
//       String imageUrl = await uploadCategoryImage(_image!);
//       await _firestore.collection('categories').doc(fileName).set(
//         {
//           'image': imageUrl,
//           'categoryName': categoryName,
//         },
//       ).whenComplete(() {
//         // EasyLoading.dismiss();
//         setState(() {
//           _image = null;
//           _formKey.currentState!.reset();
//         });
//       });
//     } else {
//       print('OH Bad Guy');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Row(children: [
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding: const EdgeInsets.all(10),
//                     child: const Text(
//                       'Category',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 36,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 140,
//                           width: 140,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Colors.grey.shade800),
//                           ),
//                           child: _image != null
//                               ? Image.memory(
//                                   _image,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Center(
//                                   child: Text('Category Image'),
//                                 ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: ContinuousRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20)),
//                             backgroundColor: Colors.blue.shade700,
//                           ),
//                           onPressed: () {
//                             _pickImage();
//                           },
//                           child: Text(
//                             'Upload Image',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Flexible(
//                     child: SizedBox(
//                       width: 180,
//                       child: TextFormField(
//                         onChanged: (value) {
//                           categoryName = value;
//                         },
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter category Name ';
//                           }
//                           return null;
//                         },
//                         decoration:
//                             InputDecoration(hintText: 'Enter Category Name'),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: ContinuousRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       backgroundColor: Colors.blue.shade400,
//                     ),
//                     onPressed: () {
//                       uploadCategory();
//                     },
//                     child: Text(
//                       'Save',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ]),
//                 Divider(
//                   color: Colors.grey,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Categories',
//                       style:
//                           TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             )));
//   }
// }
// //   dynamic _image;

// //   String? fileName;
// //   late String categoryName;

// //   _pickImage() async {
// //     FilePickerResult? result = await FilePicker.platform
// //         .pickFiles(allowMultiple: false, type: FileType.image);
// //     if (result != null) {
// //       setState(() {
// //         _image = result.files.first.bytes;
// //         fileName = result.files.first.name;
// //       });
// //     }
// //   }

// //   File? image;
// //   TextEditingController name = TextEditingController();

// //   void takePicture() async {
// //     XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
// //     if (value != null) {
// //       setState(() {
// //         image = File(value.path);
// //       });
// //     }
// //   }

// //   void showAddCategoryDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Add Category'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Column(
// //                 children: [
// //                   Container(
// //                     height: 140,
// //                     width: 140,
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade300,
// //                       borderRadius: BorderRadius.circular(10),
// //                       border: Border.all(color: Colors.grey.shade800),
// //                     ),
// //                     child: _image != null
// //                         ? Image.memory(
// //                             _image,
// //                             fit: BoxFit.cover,
// //                           )
// //                         : Center(
// //                             child: Text('Category Image'),
// //                           ),
// //                   ),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       shape: ContinuousRectangleBorder(
// //                           borderRadius: BorderRadius.circular(20)),
// //                       backgroundColor: Colors.blue.shade700,
// //                     ),
// //                     onPressed: () {
// //                       _pickImage();
// //                     },
// //                     child: Text(
// //                       'Upload Image',
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: name,
// //                 decoration: const InputDecoration(
// //                   fillColor: Colors.white,
// //                   filled: true,
// //                   hintText: 'Category name',
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               PrimaryButton(
// //                 onPressed: () async {
// //                   if (_image == null || name.text.isEmpty) {
// //                     Navigator.of(context).pop();
// //                   } else {
// //                     AppProvider appProvider =
// //                         Provider.of<AppProvider>(context, listen: false);
// //                     appProvider.addCategory(_image!, name.text);
// //                     showMessage('Category successfully added');
// //                     Navigator.of(context).pop();
// //                   }
// //                 },
// //                 title: 'Add',
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Category Add')),
// //       body: ListView(
// //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
// //         children: [
// //           CupertinoButton(
// //             onPressed: () {
// //               showAddCategoryDialog(context);
// //             },
// //             child: Container(
// //               height: 140,
// //               width: 140,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey.shade300,
// //                 borderRadius: BorderRadius.circular(10),
// //                 border: Border.all(color: Colors.grey.shade800),
// //               ),
// //               child: _image != null
// //                   ? Image.memory(
// //                       _image,
// //                       fit: BoxFit.cover,
// //                     )
// //                   : Center(
// //                       child: Text('Category Image'),
// //                     ),
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: name,
// //             decoration: const InputDecoration(
// //               fillColor: Colors.white,
// //               filled: true,
// //               hintText: 'Category name',
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           PrimaryButton(
// //             onPressed: () async {
// //               showAddCategoryDialog(context);
// //             },
// //             title: 'Add',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }















// // // ignore_for_file: use_build_context_synchronously

// // import 'dart:io';

// // import 'package:admin/constants/constants.dart';
// // import 'package:admin/constants/primary_button.dart';
// // import 'package:admin/provider/app_provider.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:provider/provider.dart';


// // class AddCategory extends StatefulWidget {
// //   const AddCategory({
// //     super.key,
// //   });

// //   @override
// //   State<AddCategory> createState() => _AddCategoryState();
// // }

// // class _AddCategoryState extends State<AddCategory> {
// //   File? image;
// //   void takePicture() async {
// //     XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
// //     if (value != null) {
// //       setState(() {
// //         image = File(value.path);
// //       });
// //     }
// //   }

// //   TextEditingController name = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     AppProvider appProvider = Provider.of<AppProvider>(
// //       context,
// //     );
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Category add')),
// //       body: ListView(
// //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
// //         children: [
// //           image == null
// //               ? CupertinoButton(
// //                   onPressed: () {
// //                     takePicture();
// //                   },
// //                   child: const CircleAvatar(
// //                       backgroundColor: Colors.grey,
// //                       radius: 50,
// //                       child: Icon(Icons.camera_alt)),
// //                 )
// //               : CupertinoButton(
// //                   onPressed: () {
// //                     takePicture();
// //                   },
// //                   child: CircleAvatar(
// //                     radius: 55,
// //                     backgroundImage: FileImage(image!),
// //                   ),
// //                 ),
// //           const SizedBox(height: 12),
// //           TextFormField(
// //             controller: name,
// //             decoration: const InputDecoration(
// //                 fillColor: Colors.white,
// //                 filled: true,
// //                 hintText: 'Category name'),
// //           ),
// //           const SizedBox(height: 20),
// //           SizedBox(
// //               child: PrimaryButton(
// //                   onPressed: () async {
// //                     if (image == null && name.text.isEmpty) {
// //                       Navigator.of(context).pop();
// //                     } else if (image != null && name.text.isNotEmpty) {
// //                       appProvider.addCategory(image!, name.text);
// //                       showMessage('Category successfuly add');
// //                       setState(() {
// //                         image = null;
// //                         name.clear();
// //                       });
// //                     }
// //                   },
// //                   title: 'Add'))
// //         ],
// //       ),
// //     );
// //   }
// // }
