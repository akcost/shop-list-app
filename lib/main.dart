import 'package:flutter/material.dart';
import 'package:shop_list_app/screens/shopping_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShoppingListScreen(),
    );
  }
}