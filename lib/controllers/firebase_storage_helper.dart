import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadUserImage(String userId, File image) async {
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadCategoryImage(String categoryId, File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot taskSnapshot =
        await _storage.ref('$categoryId/$fileName').putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadProductImage(String categoryId, File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot taskSnapshot =
        await _storage.ref('$categoryId/productId/$fileName').putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }


  Future<String> uploadSellerImage(String userId, File image) async {
    TaskSnapshot taskSnapshot = await _storage.ref(userId).putFile(image);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
