// ignore_for_file: prefer_const_constructors

import 'package:admin/views/screens/category_view.dart';
import 'package:admin/views/screens/delivery_mans.dart';
import 'package:admin/views/screens/home_page.dart';
import 'package:admin/views/screens/orders_screen.dart';
import 'package:admin/views/screens/product_view.dart';
import 'package:admin/views/screens/sellers_view.dart';
import 'package:admin/views/screens/customer_view.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomeSideBar extends StatefulWidget {
  const CustomeSideBar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<CustomeSideBar> createState() => _CustomeSideBarState();
}

class _CustomeSideBarState extends State<CustomeSideBar> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.black,
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.black),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(0, 27, 2, 2),
                ),
                child: ClipOval(
                  child: currentUser?.photoURL != null
                      ? Image.network(
                          currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        )
                      : const Icon(Icons.person,
                          size: 70, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              Text(
                currentUser?.displayName ?? 'Belkis Market Administrator',
                style: TextStyle(
                  color: Color.fromARGB(255, 26, 1, 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                currentUser?.email ?? 'BelkisAdmin@gmail.com',
                style: TextStyle(
                  color: Color.fromARGB(255, 39, 6, 6),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
      items: const [
        SidebarXItem(label: "Dashboard", icon: Icons.home),
        SidebarXItem(label: "Categories", icon: Icons.category),
        SidebarXItem(label: "Products", icon: Icons.shop_2),
        SidebarXItem(label: "Sellers", icon: Icons.group),
        SidebarXItem(label: "Delivery Mans", icon: Icons.delivery_dining),
        SidebarXItem(label: "Customers", icon: Icons.person),
        SidebarXItem(label: "Orders", icon: Icons.circle),
        SidebarXItem(label: "Logout", icon: Icons.logout),
      ],
    );
  }
}

class MainScreens extends StatelessWidget {
  const MainScreens({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return HomepageScreen();
          case 1:
            return CategoryScreen();
          case 2:
            return const ProductView();
          case 3:
            return const SellersView();
          case 4:
            return const DeliveryMansView();
          case 5:
            return const CustomerViewScreen();
          case 6:
            return const OrdersScreen();
          case 7:
          default:
            return Container();
        }
      },
    );
  }
}

String getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'Categories';
    case 2:
      return 'Products';
    case 3:
      return 'Sellers';
    case 4:
      return 'Delivery Mans';
    case 5:
      return 'Customers';
    case 6:
      return 'Orders';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFFEFEFF4); // A light neutral color
const scaffoldBackgroundColor =
    Color.fromARGB(255, 209, 198, 198); // White background
const accentCanvasColor = Color(0xFF42A5F5); // An accent color
const white = Color(0xFFFFFFFF); // White
final actionColor = Color(0xFF3F51B5); // A darker shade of primary color
final divider = Divider(
    color: Colors.black.withOpacity(0.1), height: 1);  // A subtle divider color