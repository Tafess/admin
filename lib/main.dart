// ignore_for_file: unused_import

import 'package:admin/firebase_options.dart';
import 'package:admin/views/screens/dashboard_screen.dart';
import 'package:admin/views/screens/home_page.dart';
import 'package:admin/views/screens/main_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/views/screens/login_screen.dart';
import 'package:admin/constants/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard',
        theme: themeData,
        home: const LoginScreen(),
      ),
    );
  }
}
