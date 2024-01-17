// ignore_for_file: use_build_context_synchronously, unnecessary_cast

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

//---------------------------------------------------------------------------
  Future<CustomerModel> getCustomerInfo() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection('customers').doc().get();
    return CustomerModel.fromJson(querySnapshot.data()!);
  }

//--------------------------------------------------------------------------------------
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

//-------------------------------------------------------------------------
  Future<CategoryModel> addSingleCategory(
      Uint8List imageBytes, String name) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firebaseFirestore.collection('categories').doc();

      String imageUrl = await FirebaseStorageHelper.instance
              .uploadCategoryImage(reference.id, Uint8List.fromList(imageBytes))
          as String;

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
      print('Error updating employee: $e');
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
        _firebaseFirestore.collection('orderssss');
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
            .collection('orderssss')
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
