// ignore_for_file: unused_import

import 'package:admin/constants/routes.dart';
import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/models/product_model.dart';
import 'package:admin/models/employee_model.dart';
import 'package:admin/models/customer_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/views/widgets/single_dash_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class TotalCounts extends StatefulWidget {
  const TotalCounts({
    Key? key,
    required this.appProvider,
  }) : super(key: key);
  final AppProvider appProvider;

  @override
  State<TotalCounts> createState() => _TotalCountsState();
}

class _TotalCountsState extends State<TotalCounts> {
  final FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();

  bool isloading = false;

  void getData() async {
    setState(() {
      isloading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.callBackFunction();
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> _showUserInfoDialog({
    BuildContext? context,
    IconData? icon,
    String? title,
    String? subtitle,
  }) async {
    return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(icon),
              Text('Total No of $title'),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle!),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget employeesStreamBuilder(
    IconData icon,
    String title,
    String role, {
    bool withApproved = false,
  }) {
    return StreamBuilder<List<EmployeeModel>>(
      stream: role.isEmpty
          ? _firestore.getEmployeesStream()
          : (withApproved
              ? _firestore.getEmployeesStream(role: role, approved: true)
              : _firestore.getEmployeesStream(role: role)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget ordersStreamBuilder(
    IconData icon,
    String title,
    String status,
  ) {
    return StreamBuilder<List<OrderModel>>(
      stream: status.isEmpty
          ? _firestore.getOrderListStream()
          : _firestore.getOrderListStream(status: status),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget categoriesStreamBuilder(
    IconData icon,
    String title,
  ) {
    return StreamBuilder<List<CategoryModel>>(
      stream: _firestore.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget productsStreamBuilder(
    IconData icon,
    String title,
  ) {
    return StreamBuilder<List<ProductModel>>(
      stream: _firestore.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget customersStreamBuilder(
    IconData icon,
    String title,
  ) {
    return StreamBuilder<List<CustomerModel>>(
      stream: _firestore.getCustomers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
          ),
          TouchMouseScrollable(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              child: Container(
                color: Colors.blue.shade400,
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: categoriesStreamBuilder(
                              Icons.category, 'Categories')),
                      Expanded(
                          child: productsStreamBuilder(
                              Icons.shop_2_rounded, 'Products')),
                      Expanded(
                          child: employeesStreamBuilder(
                              Icons.person, 'All employees', '')),
                      Expanded(
                          child: employeesStreamBuilder(
                              Icons.person, 'Sellers', 'seller')),
                      Expanded(
                        child: employeesStreamBuilder(
                            Icons.person, 'Delivery Mans', 'delivery'),
                      ),
                      Expanded(
                          child: customersStreamBuilder(
                              Icons.person, 'Customers')),
                      Expanded(
                        child: SingleDashItem(
                          onPressed: () {
                            _showUserInfoDialog(
                              context: context,
                              icon: Icons.money,
                              title: 'Earnings',
                              subtitle:
                                  'ETB ${widget.appProvider.getTotalEarnings}',
                            );
                          },
                          icon: Icons.money,
                          title: 'Earnings',
                          subtitle:
                              'ETB ${widget.appProvider.getTotalEarnings}',
                        ),
                      ),
                      Expanded(
                          child:
                              ordersStreamBuilder(Icons.pending, 'Orders', '')),
                      Expanded(
                        child: ordersStreamBuilder(
                            Icons.pending, 'Pending order', 'pending'),
                      ),
                      Expanded(
                        child: ordersStreamBuilder(
                            Icons.disc_full, 'Completed order', 'completed'),
                      ),
                      Expanded(
                        child: ordersStreamBuilder(Icons.delivery_dining,
                            'Delivery order', 'delivery'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  // Flexible(
                      //   child: SingleDashItem(
                      //     onPressed: () {
                      //       _showUserInfoDialog(
                      //         context: context,
                      //         icon: Icons.verified_user_outlined,
                      //         title: 'Users',
                      //         subtitle: widget.appProvider.getUserList.length
                      //             .toString(),
                      //       );
                      //     },
                      //     icon: Icons.verified_user_outlined,
                      //     title: 'Users',
                      //     subtitle:
                      //         widget.appProvider.getUserList.length.toString(),
                      //   ),
                      // ),
                      // Flexible(
                      //   child: SingleDashItem(
                      //     onPressed: () {
                      //       _showUserInfoDialog(
                      //         context: context,
                      //         icon: Icons.category,
                      //         title: 'Categories',
                      //         subtitle: widget
                      //             .appProvider.getCategoryList.length
                      //             .toString(),
                      //       );
                      //     },
                      //     icon: Icons.category,
                      //     title: 'Categories',
                      //     subtitle: widget.appProvider.getCategoryList.length
                      //         .toString(),
                      //   ),
                      // ),
                      // Flexible(
                      //   child: SingleDashItem(
                      //     onPressed: () {
                      //       _showUserInfoDialog(
                      //         context: context,
                      //         icon: Icons.shop_2,
                      //         title: 'Products',
                      //         subtitle: widget.appProvider.getProducts.length
                      //             .toString(),
                      //       );
                      //     },
                      //     icon: Icons.shop_2,
                      //     title: 'Products',
                      //     subtitle:
                      //         widget.appProvider.getProducts.length.toString(),
                      //   ),
                      // ),

                   