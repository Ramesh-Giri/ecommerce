import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/customer_home.dart';
import 'package:multi_store_app/main_screens/supplier_home.dart';

import 'auth/customer_signup.dart';
import 'main_screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_register': (context) => const CustomerRegister(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Multi-Store',
      initialRoute: '/welcome_screen',
    );
  }
}
