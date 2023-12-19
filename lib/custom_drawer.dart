// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/routes.dart';
import 'package:admin/screens/category_view.dart';
import 'package:admin/screens/order_list.dart';
import 'package:admin/screens/dashboard_screen.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:flutter/material.dart';
import 'package:side_bar_custom/side_bar_custom.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
// ... (previous code)

class _CustomDrawerState extends State<CustomDrawer> {
  final pages = const [
    Dashboard(),
    CategoryViewScreen(),
    ProductView(),
    UserViewScreen(),
    UserViewScreen(),
    UserViewScreen(),
    OrderListView(title: 'All')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(children: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.menu, color: Colors.white)),
          SizedBox(width: 10),
          Text('Dashboard'),
        ]),
      ),
      body: SideBar(
        children: pages,
        items: [
          SideBarItem(
            text: "Dashboard",
            icon: Icons.home,
            tooltipText: "Dashboard page",
          ),
          SideBarItem(
            text: "Categories",
            icon: Icons.category,
          ),
          SideBarItem(
            text: "Products",
            icon: Icons.shop_2,
          ),
          SideBarItem(
            text: "Sellers",
            icon: Icons.group,
          ),
          SideBarItem(
            text: "Delivery",
            icon: Icons.delivery_dining,
          ),
          SideBarItem(
            text: "Customers",
            icon: Icons.person,
          ),
          SideBarItem(
            text: "Orders",
            icon: Icons.circle,
          ),
        ],
        config: SideBarConfig(
            enablePageView: true,
            backgroundColor: Colors.grey.shade200,
            selectedIconColor: Colors.green,
            unselectedBoxColor: Colors.white,
            selectedBoxColor: Colors.white,
            unselectedIconColor: Colors.grey,
            unselectedTextStyle: TextStyle(fontWeight: FontWeight.normal),
            dividerColor: Colors.black,
            iconSize: 30
            // sideBarAnimationDuration: Duration(seconds: 1),
            // sideBarCurve: Curves.bounceInOut
            ),
      ),
    );
  }
}
