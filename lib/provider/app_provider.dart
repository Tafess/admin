// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<EmployeeModel> _userList = [];
  List<CategoryModel> _categoryList = [];
  List<ProductModel> _productlist = [];
  List<OrderModel> _completedOrders = [];

  double _totalEarning = 0.0;
  Future<void> getCompletedOrderList() async {
    _completedOrders =
        await FirebaseFirestoreHelper.instance.getCompletedOrderList();
    for (var element in _completedOrders) {
      _totalEarning += element.totalprice;
    }
    notifyListeners();
  }

  Future<void> callBackFunction() async {
    await getCompletedOrderList();
  }

  List<EmployeeModel> get getUserList => _userList;
  double get getTotalEarnings => _totalEarning;
  List<CategoryModel> get getCategoryList => _categoryList;
  List<ProductModel> get getProducts => _productlist;
  List<OrderModel> get getCompletedOrder => _completedOrders;

}