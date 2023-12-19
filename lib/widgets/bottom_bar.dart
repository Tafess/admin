// ignore_for_file: prefer_const_constructors, unused_import

import 'package:admin/constants/routes.dart';
import 'package:admin/screens/category_view.dart';
import 'package:admin/screens/order_list.dart';
import 'package:admin/screens/dashboard_screen.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarXExampleApp extends StatelessWidget {
  SidebarXExampleApp({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SidebarX Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: white,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
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
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
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
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 30,
            ),
          ),
        );
      },
      items: const [
        SidebarXItem(
          label: "Dashboard",
          icon: Icons.home,
        ),
        SidebarXItem(label: "Categories", icon: Icons.category),
        SidebarXItem(
          label: "Products",
          icon: Icons.shop_2,
        ),
        SidebarXItem(
          label: "Sellers",
          icon: Icons.group,
        ),
        SidebarXItem(
          label: "Delivery",
          icon: Icons.delivery_dining,
        ),
        SidebarXItem(
          label: "Customers",
          icon: Icons.person,
        ),
        SidebarXItem(
          label: "Orders",
          icon: Icons.circle,
        ),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;
  @override
  Widget build(BuildContext context) {
    switch (controller.selectedIndex) {
      case 0:
        return Dashboard();
      case 1:
        return CategoryViewScreen();
      case 2:
        return ProductView();
      case 3:
        return UserViewScreen();
      case 4:
        return UserViewScreen();
      case 5:
        return UserViewScreen();
      case 6:
        return OrderListView(title: 'All');
      default:
        return Container();
    }
  }
}

String _getTitleByIndex(int index) {
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
      return 'Delivery';
    case 5:
      return 'Customers';
    case 6:
      return 'Orders';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
