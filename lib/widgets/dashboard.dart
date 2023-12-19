// ignore_for_file: unused_import

import 'package:admin/constants/routes.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/category_view.dart';
import 'package:admin/screens/order_list.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:admin/widgets/single_dash_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTotals extends StatefulWidget {
  const AdminTotals({
    Key? key,
    required this.appProvider,
  }) : super(key: key);

  final AppProvider appProvider;

  @override
  State<AdminTotals> createState() => _AdminTotalsState();
}

class _AdminTotalsState extends State<AdminTotals> {
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

  Future<void> _showUserInfoDialog(
      {BuildContext? context,
      IconData? icon,
      String? title,
      String? subtitle}) async {
    return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(icon),
              Text('Total $title'),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.grey.shade300,
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.verified_user_outlined,
                          title: 'Users',
                          subtitle:
                              widget.appProvider.getUserList.length.toString(),
                        );
                      },
                      icon: Icons.verified_user_outlined,
                      title: 'Users',
                      subtitle:
                          widget.appProvider.getUserList.length.toString(),
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.category,
                          title: 'Category',
                          subtitle: widget.appProvider.getCategoryList.length
                              .toString(),
                        );
                      },
                      icon: Icons.category,
                      title: 'Category',
                      subtitle:
                          widget.appProvider.getCategoryList.length.toString(),
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.shop_2,
                          title: 'Products',
                          subtitle:
                              widget.appProvider.getProducts.length.toString(),
                        );
                      },
                      icon: Icons.shop_2,
                      title: 'Products',
                      subtitle:
                          widget.appProvider.getProducts.length.toString(),
                    ),
                    SingleDashItem(
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
                      subtitle: 'ETB ${widget.appProvider.getTotalEarnings}',
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.pending,
                          title: 'All orders',
                          subtitle: widget.appProvider.getAllOrderList.length
                              .toString(),
                        );
                      },
                      icon: Icons.pending,
                      title: 'All orders',
                      subtitle:
                          widget.appProvider.getAllOrderList.length.toString(),
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.pending,
                          title: 'Pending order',
                          subtitle: widget
                              .appProvider.getPendingOrderList.length
                              .toString(),
                        );
                      },
                      icon: Icons.pending,
                      title: 'Pending order',
                      subtitle: widget.appProvider.getPendingOrderList.length
                          .toString(),
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.disc_full,
                          title: 'Completed order',
                          subtitle: widget.appProvider.getCompletedOrder.length
                              .toString(),
                        );
                      },
                      icon: Icons.disc_full,
                      title: 'Completed order',
                      subtitle: widget.appProvider.getCompletedOrder.length
                          .toString(),
                    ),
                    SingleDashItem(
                      onPressed: () {
                        _showUserInfoDialog(
                          context: context,
                          icon: Icons.delivery_dining,
                          title: 'Delivered order',
                          subtitle: widget
                              .appProvider.getDeliveryOrderList.length
                              .toString(),
                        );
                      },
                      icon: Icons.delivery_dining,
                      title: 'Delivered order',
                      subtitle: widget.appProvider.getDeliveryOrderList.length
                          .toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
