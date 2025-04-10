import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tas/screens/filter_screen.dart';
import 'package:tas/screens/home_screen.dart';
import 'cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
