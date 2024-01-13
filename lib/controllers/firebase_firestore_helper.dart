// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/firebase_storage_helper.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/models/employee_model.dart';
import 'package:admin/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // Future<List<CategoryModel>> getCategories() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collection('categories').get();
  //     List<CategoryModel> categoriesList = querySnapshot.docs
  //         .map((e) => CategoryModel.fromJson(e.data()))
  //         .toList();
  //     return categoriesList; // Return the mapped categoriesList
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

  // Future<List<ProductModel>> getBestProducts() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collectionGroup('products').get();
  //     List<ProductModel> productModelList = querySnapshot.docs
  //         .map((e) => ProductModel.fromJson(e.data()))
  //         .toList();
  //     return productModelList; // Return the mapped productModelList
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

  // Future<List<ProductModel>> getCategoryViewProduct(String id) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection('categories')
  //             .doc(id)
  //             .collection('products')
  //             .get();
  //     List<ProductModel> productModelList = querySnapshot.docs
  //         .map((e) => ProductModel.fromJson(e.data()))
  //         .toList();
  //     return productModelList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

  Future<CustomerModel> getCustomerInfo() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection('customers').doc().get();
    return CustomerModel.fromJson(querySnapshot.data()!);
  }

  // Future<bool> uploadOrderedProductFirebase(
  //     List<ProductModel> list, BuildContext context, String payment) async {
  //   try {
  //     ShowLoderDialog(context);
  //     double totalPrice = 0.0;
  //     for (var element in list) {
  //       totalPrice += element.price * element.quantity;
  //     }
  //     DocumentReference documentReference = _firebaseFirestore
  //         .collection('userOrders')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('orders')
  //         .doc();
  //     DocumentReference admin =
  //         _firebaseFirestore.collection('orders').doc(documentReference.id);
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     admin.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userid': uid,
  //       'orderId': admin.id,
  //       'sellerId': uid,
  //     });

  //     documentReference.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userId': uid,
  //       'orderId': documentReference.id,
  //       'sellerId': uid,
  //     });
  //     showMessage('Ordered Successfully');
  //     Navigator.of(context, rootNavigator: true).pop();

  //     return true;
  //   } catch (e) {
  //     showMessage(e.toString());

  //     Navigator.of(context, rootNavigator: true).pop();

  //     return false;
  //   }
  // }

  ///////// get order user //////

  // Future<List<OrderModel>> getUserOrder() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection('userOrders')
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .collection('orders')
  //             .get();

  //     List<OrderModel> orderList = querySnapshot.docs
  //         .map((element) => OrderModel.fromJson(element.data()))
  //         .toList();

  //     return orderList;
  //   } catch (error) {
  //     showMessage(error.toString());

  //     return [];
  //   }
  // }

  // void updateTokenFromFirebase() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   if (token != null) {
  //     await _firebaseFirestore
  //         .collection('sellers')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({'notificationToken': token});
  //   }
  // }

  // Future<void> updateOrder(OrderModel orderModel, String status) async {
  //   try {
  //     DocumentSnapshot orderSnapshot = await _firebaseFirestore
  //         .collection('orders')
  //         .doc(orderModel.orderId)
  //         .get();

  //     if (orderSnapshot.exists) {
  //       String userIdFromDatabase = orderSnapshot['userId'];

  //       await _firebaseFirestore
  //           .collection('userOrders')
  //           .doc(userIdFromDatabase)
  //           .collection('orders')
  //           .doc(orderModel.orderId)
  //           .update({'status': status});

  //       await _firebaseFirestore
  //           .collection('orders')
  //           .doc(orderModel.orderId)
  //           .update({'status': status});
  //     } else {
  //       print('Document does not exist.');
  //     }
  //   } catch (e) {
  //     print('Error updating order: $e');
  //     print(orderModel.orderId);
  //   }
  // }

  // Future<List<EmployeeModel>> getUserList() async {
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await _firebaseFirestore.collection('employees').get();
  //   return querySnapshot.docs
  //       .map((e) => EmployeeModel.fromJson(e.data()))
  //       .toList();
  // }

  // Future<List<CategoryModel>> getcategories() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collection('categories').get();
  //     List<CategoryModel> categoriesList = querySnapshot.docs
  //         .map((e) => CategoryModel.fromJson(e.data()))
  //         .toList();
  //     return categoriesList;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     return [];
  //   }
  // }

  // Future<String> deleteSingleUser(String id) async {
  //   try {
  //     _firebaseFirestore.collection('customers').doc(id).delete();
  //     return 'Successfully deleted';
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

////// £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
  ///
  ///

  // Future<void> updateUser(EmployeeModel customerModel) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('customers')
  //         .doc(customerModel.id)
  //         .update(customerModel.toJson());
  //   } catch (e) {}
  // }

  Future<String> deleteSingleCategory(String id) async {
    try {
      await _firebaseFirestore.collection('categories').doc(id).delete();

      //  await Future.delayed(const Duration(seconds: 3), () {});
      return 'Successfully deleted';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleCategory(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection('categories')
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

  Future<CategoryModel> addSingleCategory(
      Uint8List imageBytes, String name) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firebaseFirestore.collection('categories').doc();
      // print('Document Reference ID: ${reference.id}');

      String imageUrl = await FirebaseStorageHelper.instance
              .uploadCategoryImage(reference.id, Uint8List.fromList(imageBytes))
          as String;

      // print('Image uploaded to Storage. URL: $imageUrl');

      CategoryModel addCategory =
          CategoryModel(image: imageUrl, id: reference.id, name: name);
      await reference.set(addCategory.toJson());
      print('Category information saved to Firestore.');

      return addCategory;
    } catch (e) {
      print('Error in addSingleCategory: $e');
      rethrow;
    }
  }

  ///////// products /////////////
  ///
  // Future<List<ProductModel>> getProducts() async {
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await _firebaseFirestore.collectionGroup('products').get();
  //   List<ProductModel> productList =
  //       querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
  //   return productList;
  // }

  // Future<String> deleteProduct(String categoryId, String productId) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('categories')
  //         .doc(categoryId)
  //         .collection('products')
  //         .doc(productId)
  //         .delete();

  //     await Future.delayed(const Duration(seconds: 1), () {});
  //     return 'Successfully deleted';
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  // Future<void> updateSingleProduct(ProductModel productModel) async {
  //   try {
  //     DocumentReference productRef = _firebaseFirestore
  //         .collection('categories')
  //         .doc(productModel.categoryId)
  //         .collection('products')
  //         .doc(productModel.id);

  //     DocumentSnapshot productSnapshot = await productRef.get();

  //     if (productSnapshot.exists) {
  //       await productRef.update(productModel.toJson());
  //       showMessage('Udated successfully');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------

/////////////////  end   ///////////////////  ////end///////

  // Future<List<OrderModel>> getPendingOrders() async {
  //   QuerySnapshot<Map<String, dynamic>> pendingOrders = await _firebaseFirestore
  //       .collection('orders')
  //       .where('status', isEqualTo: 'pending')
  //       .get();

  //   List<OrderModel> pendingOrderList =
  //       pendingOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
  //   return pendingOrderList;
  // }

  // Future<List<OrderModel>> getDeliveryOrders() async {
  //   QuerySnapshot<Map<String, dynamic>> pendingOrders = await _firebaseFirestore
  //       .collection('orders')
  //       .where('status', isEqualTo: 'delivery')
  //       .get();

  //   List<OrderModel> getDeliveryOrders =
  //       pendingOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
  //   return getDeliveryOrders;
  // }

  /////                      seller
  ///
  ///
  ///

  // Stream<List<EmployeeModel>> getSellersStream({bool? approved, String? role}) {
  //   Query query = FirebaseFirestore.instance.collection('sellers');
  //   if (approved != null) {
  //     query = query.where('approved', isEqualTo: approved);
  //   }

  //   if (role != null) {
  //     query = query.where('role', isEqualTo: role);
  //   }
  //   return query.snapshots().map((querySnapshot) {
  //     List<EmployeeModel> employeeModels = querySnapshot.docs
  //         .map((doc) =>
  //             EmployeeModel.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //     return employeeModels;
  //   });
  // }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  ///----------------------------------------------------------------new ----------------------------------------------------------------




//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Stream<List<CategoryModel>> getCategories() {
    CollectionReference<Map<String, dynamic>> ordersCollection =
        _firebaseFirestore.collection('categories');

    return ordersCollection.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> ordersSnapshot) => ordersSnapshot
              .docs
              .map((e) => CategoryModel.fromJson(e.data()))
              .toList(),
        );
  }

//--------------------------------------------------------------------------------------------------------------------------------
  Stream<List<EmployeeModel>> getEmployeesStream(
      {bool? approved, String? role}) {
    Query query = FirebaseFirestore.instance.collection('employees');
    if (approved != null) {
      query = query.where('approved', isEqualTo: approved);
    }

    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    return query.snapshots().map((querySnapshot) {
      List<EmployeeModel> employeeModels = querySnapshot.docs
          .map((doc) =>
              EmployeeModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return employeeModels;
    });
  }

//------------------------------------------------------------------------------------------------

  Future<void> updateEmployee(EmployeeModel employee) async {
    try {
      DocumentReference<Map<String, dynamic>> sellerRef =
          _firebaseFirestore.collection('employees').doc(employee.employeeId);
      await sellerRef.update({'approved': employee.approved});
    } catch (e) {
      print('Error updating seller: $e');
    }
  }
//----------------------------------------------------------------customers 

  Stream<List<CustomerModel>> getCustomers() {
    CollectionReference<Map<String, dynamic>> ordersCollection =
        _firebaseFirestore.collection('customers');

    return ordersCollection.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> ordersSnapshot) => ordersSnapshot
              .docs
              .map((e) => CustomerModel.fromJson(e.data()))
              .toList(),
        );
  }



  //----------------------------------------------------------------  --------------------------------
  Stream<List<OrderModel>> getOrderListStream({String? status}) {
    CollectionReference<Map<String, dynamic>> ordersCollection =
        _firebaseFirestore.collection('orders');
    Query<Map<String, dynamic>> query = status != null
        ? ordersCollection.where('status', isEqualTo: status)
        : ordersCollection;

    return query.snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> ordersSnapshot) => ordersSnapshot
              .docs
              .map((e) => OrderModel.fromJson(e.data()!))
              .toList(),
        );
  }
//---------------------------------------------------------------------------------------------------

  Future<List<OrderModel>> getCompletedOrderList() async {
    QuerySnapshot<Map<String, dynamic>> completedOrders =
        await _firebaseFirestore
            .collection('orders')
            .where('status', isEqualTo: 'completed')
            .get();

    List<OrderModel> completedOrderList =
        completedOrders.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

//------------------------------------------------------------------------------------------------------
  Stream<List<ProductModel>> getProducts() {
    return _firebaseFirestore
        .collectionGroup('products')
        .snapshots()
        .map((querySnapshot) {
      List<ProductModel> productList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productList;
    });
  }
}
