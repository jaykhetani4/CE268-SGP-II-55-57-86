import 'package:flutter/material.dart';
import 'package:mudramitra/login_page.dart';
//import 'package:mudramitra/second_page.dart'; // Import SecondPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title', // Change to your app's title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
       // '/second': (context) => SecondPage(),
      },
    debugShowCheckedModeBanner: false,

    );
  }
}