// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/theme.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/screens/category_view.dart';
import 'package:admin/screens/dashboard_screen.dart';
import 'package:admin/screens/delivery_mans.dart';
import 'package:admin/screens/home_page.dart';
import 'package:admin/screens/orders_screen.dart';
import 'package:admin/screens/product_view.dart';
import 'package:admin/screens/sellers_view.dart';
import 'package:admin/screens/user_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard',
        theme: themeData,
        home: Builder(
          builder: (context) {
            return Scaffold(
              key: _key,
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Text(_getTitleByIndex(_controller.selectedIndex)),
              ),
              drawer: ExampleSidebarX(controller: _controller),
              body: Expanded(
                child: Row(
                  children: [
                    ExampleSidebarX(controller: _controller),
                    Expanded(
                      child: Column(
                        children: [
                          _controller == 0 ? SizedBox.fromSize() : Dashboard(),
                          Expanded(
                            child: _ScreensExample(
                              controller: _controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExampleSidebarX extends StatefulWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<ExampleSidebarX> createState() => _ExampleSidebarXState();
}

class _ExampleSidebarXState extends State<ExampleSidebarX> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.black,
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/belkis1.jpg',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              Text(
                'Admin Name',
                style: TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
              Text(
                'Admin@gmail.com                ',
                style: TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
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
        SidebarXItem(label: "Delivery", icon: Icons.delivery_dining),
        SidebarXItem(label: "Customers", icon: Icons.person),
        SidebarXItem(label: "Orders", icon: Icons.circle),
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
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          // final pageTitle = _getTitleByIndex(controller.selectedIndex);
          switch (controller.selectedIndex) {
            case 0:
              return HomePageScreen();
            case 1:
              return CategoryScreen();
            case 2:
              return ProductView();
            case 3:
              return SellersView();
            case 4:
              return DeliveryMansView();
            case 5:
              return UserViewScreen();
            case 6:
              return OrdersScreen();
            default:
              return Container();
          }
        });
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





// class SideMenu extends StatefulWidget {
//   static const String id = 'side-menu';
//   const SideMenu({Key? key}) : super(key: key);

//   @override
//   State<SideMenu> createState() => _SideMenuState();
// }

// class _SideMenuState extends State<SideMenu> {
//   Widget _selectedScreen = const HomePage();

//   screenSelector(item) {
//     switch (item.route) {
//       case HomePage.id:
//         setState(() {
//           _selectedScreen = const HomePage();
//         });
//         break;
//       case CategoryViewScreen.id:
//         setState(() {
//           _selectedScreen = const CategoryViewScreen();
//         });
//         break;
//       case OrderListView.id:
//         setState(() {
//           _selectedScreen = const OrderListView(
//             title: 'Completed',
//           );
//         });
//         break;
//       case ProductView.id:
//         setState(() {
//           _selectedScreen = const ProductView();
//         });
//         break;
//       case UserViewScreen.id:
//         setState(() {
//           _selectedScreen = const UserViewScreen();
//         });
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdminScaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Shop App Admin',
//           style: TextStyle(letterSpacing: 1),
//         ),
//       ),
//       sideBar: SideBar(
//         items: const [
//           AdminMenuItem(
//             title: 'Home',
//             route: HomePage.id,
//             icon: Icons.dashboard_rounded,
//           ),
//           AdminMenuItem(
//             title: 'Categories',
//             route: CategoryViewScreen.id,
//             icon: Icons.dashboard_rounded,
//           ),
//           AdminMenuItem(
//             title: 'Order Lists',
//             icon: Icons.category,
//             children: [
//               AdminMenuItem(
//                 title: 'Completed Order',
//                 route: OrderListView.id,
//               ),
//               AdminMenuItem(
//                 title: 'pending order',
//                 route: ProductView.id,
//               ),
//               AdminMenuItem(
//                 title: 'Delivery',
//                 route: UserViewScreen.id,
//               ),
//             ],
//           ),
//         ],
//         selectedRoute: SideMenu.id,
//         onSelected: (item) {
//           screenSelector(item);
//         },
//         header: Container(
//           height: 50,
//           width: double.infinity,
//           color: const Color(0xff444444),
//           child: const Center(
//             child: Text(
//               'Menu',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         footer: Container(
//           height: 50,
//           width: double.infinity,
//           color: const Color(0xff444444),
//           child: Center(
//             child: Text(
//               DateTimeFormat.format(DateTime.now(),
//                   format: AmericanDateFormats.dayOfWeek),
//               style: const TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: _selectedScreen,
//       ),
//     );
//   }
// }

