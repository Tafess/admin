// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/routes.dart';
import 'package:admin/screens/category_view.dart';
import 'package:admin/screens/completed_order_list.dart';
import 'package:admin/screens/home_page.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
// ... (previous code)

class _CustomDrawerState extends State<CustomDrawer> {
  bool showTitles = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Drawer(
          child: Column(
            children: [
              Container(
                height: 70,
                width: 250,
                color: Colors.white,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            showTitles = !showTitles;
                          });
                        },
                        color: Colors.black,
                      ),
                      //  if (showTitles)
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final drawerWidth = constraints.maxWidth;

                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.black12,
                        width: showTitles ? 250 : 50,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: drawerItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(drawerItems[index].icon),
                              title: showTitles
                                  ? Text(
                                      drawerItems[index].title,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : null,
                              onTap: () {
                                Routes.instance.push(
                                  widget: drawerItems[index].widget,
                                  context: context,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ... (rest of the code)

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget widget;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

List<DrawerItem> drawerItems = [
  DrawerItem(
    title: 'Dashboard',
    icon: Icons.home,
    widget: HomePage(),
  ),
  DrawerItem(
    title: 'Categories',
    icon: Icons.category,
    widget: CategoryViewScreen(),
  ),
  DrawerItem(
    title: 'Products',
    icon: Icons.sell,
    widget: ProductView(),
  ),
  DrawerItem(
    title: 'Sellers',
    icon: Icons.group,
    widget: CategoryViewScreen(),
  ),
  DrawerItem(
    title: 'Buyers',
    icon: Icons.shop,
    widget: UserViewScreen(),
  ),
  DrawerItem(
    title: 'Orders',
    icon: Icons.circle,
    widget: OrderListView(title: 'Completed'),
  ),
  DrawerItem(
    title: 'Delivery',
    icon: Icons.delivery_dining,
    widget: OrderListView(title: 'Completed'),
  ),
];
