// ignore_for_file: prefer_const_constructors

import 'package:admin/custom_drawer.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/widgets/single_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class OrderListView extends StatelessWidget {
  static const String id = 'order-list-view';
  final String title;

  const OrderListView({super.key, required this.title});

  List<OrderModel> getCompletedOrder(AppProvider appProvider) {
    if (title == 'Pending') {
      return appProvider.getAllOrderList;
    } else if (title == 'Completed') {
      return appProvider.getCompletedOrder;
    } else if (title == 'Canceled') {
      return appProvider.getCanceledOrderList;
    } else if (title == 'Delivery') {
      return appProvider.getDeliveryOrderList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${title} orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getCompletedOrder(appProvider).isEmpty
            ? Center(
                child: Text('${title} list is empty'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: getCompletedOrder(appProvider).length,
                itemBuilder: (context, index) {
                  OrderModel orderModel = getCompletedOrder(appProvider)[index];
                  return SingleOrderWidget(orderModel: orderModel);
                },
              ),
      ),
    );
  }
}
