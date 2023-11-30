// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/theme.dart';
import 'package:admin/custom_drawer.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard',
        theme: themeData,
        home: CustomDrawer(),
      ),
    );
  }
}








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

