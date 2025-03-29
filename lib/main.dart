import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudramitra/users/Authentication/login_page.dart';
//import 'package:mudramitra/second_page.dart'; // Import SecondPage

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MudraMitra', // Change to your app's title
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
    builder: (context,dataSnapShot)
    {
      return LoginPage();
      }, future: null,
    ),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => LoginPage(),
       // '/second': (context) => SecondPage(),
      // },
    );
  }
}