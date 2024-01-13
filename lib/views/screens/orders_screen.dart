// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/controllers/firebase_storage_helper.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/views/screens/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  Future<void> refreshOrders() async {
    // AppProvider appProvider = Provider.of<AppProvider>(
    //   context as BuildContext,
    // );
    _firestoreHelper.getOrderListStream(status: 'completed');
    _firestoreHelper.getOrderListStream(status: 'pending');
    _firestoreHelper.getOrderListStream(status: 'delivery');
    // await appProvider.getCompletedOrderList();
    // await appProvider.getPendingOrders();
    // await appProvider.getDeliveryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 10, color: Colors.blue)),
            labelPadding: EdgeInsets.symmetric(horizontal: 100),
            tabs: [
              Tab(
                child: Text('All Orders ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Pending',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Delivery',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Completed',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refreshOrders,
          child: const TabBarView(
            children: [
              OrderListView(title: 'All'),
              OrderListView(title: 'Pending'),
              OrderListView(title: 'Delivery'),
              OrderListView(title: 'Completed'),
            ],
          ),
        ),
      ),
    );
  }
}