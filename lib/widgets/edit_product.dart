// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:admin/constants/constants.dart';
// import 'package:admin/constants/primary_button.dart';
// import 'package:admin/controllers/firebase_storage_helper.dart';
// import 'package:admin/models/product_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';


// class EditProduct extends StatefulWidget {
//   final ProductModel productModel;
//   final int index;
//   const EditProduct(
//       {super.key, required this.productModel, required this.index});

//   @override
//   State<EditProduct> createState() => _EditProductState();
// }

// class _EditProductState extends State<EditProduct> {
//   File? image;
//   void takePicture() async {
//     XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (value != null) {
//       setState(() {
//         image = File(value.path);
//       });
//     }
//   }

//   TextEditingController name = TextEditingController();
//   TextEditingController description = TextEditingController();
//   TextEditingController quantity = TextEditingController();
//   TextEditingController price = TextEditingController();
//   // TextEditingController description = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );
//     return Scaffold(
//       appBar: AppBar(title: const Text('Product edit')),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         children: [
//           image == null
//               ? widget.productModel.image.isNotEmpty
//                   ? InkWell(
//                       onTap: () {
//                         takePicture();
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 200,
//                         child: Image.network(widget.productModel.image),
//                       ),
//                     )
//                   : CupertinoButton(
//                       onPressed: () {
//                         takePicture();
//                       },
//                       child: const CircleAvatar(
//                         radius: 55,
//                         child: Icon(Icons.camera_alt),
//                       ),
//                     )
//               : CupertinoButton(
//                   onPressed: () {
//                     takePicture();
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 200,
//                     child: Image.file(image!),
//                   ),
//                 ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: name,
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: widget.productModel.name),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: description,
//             minLines: 2,
//             maxLines: 10,
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: widget.productModel.description),
//           ),
//           const SizedBox(height: 12),
//           TextFormField(
//             controller: price,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: 'ETB  ${widget.productModel.price.toString()}'),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//               child: PrimaryButton(
//                   onPressed: () async {
//                     if (image == null &&
//                         name.text.isEmpty &&
//                         description.text.isEmpty &&
//                         price.text.isEmpty) {
//                       showMessage('Please Enter values');
//                     } else if (image != null) {
//                       String imageUrl = await FirebaseStorageHelper.instance
//                           .uploadUserImage(widget.productModel.id, image!);
//                       ProductModel productModel = widget.productModel.copyWith(
//                         image: imageUrl,
//                         name: name.text.isEmpty ? null : name.text,
//                         description:
//                             description.text.isEmpty ? null : description.text,
//                         price: double.tryParse(price.text),
//                       );

//                       appProvider.updateProductList(widget.index, productModel);
//                       showMessage('Product successfuly updated');
//                     } else {
//                       ProductModel productModel = widget.productModel.copyWith(
//                         name: name.text.isEmpty ? null : name.text,
//                         description:
//                             description.text.isEmpty ? null : description.text,
//                         price: double.tryParse(price.text),
//                       );
//                       appProvider.updateProductList(widget.index, productModel);
//                       showMessage('Product successfully updated');
//                     }
//                     Navigator.of(context).pop();
//                     //   appProvider.updateUserInfoFirebase(
//                     //   context, userModel, image);
//                   },
//                   title: 'Update'))
//         ],
//       ),
//     );
//   }
// }
