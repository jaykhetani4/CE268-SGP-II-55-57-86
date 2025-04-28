import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
//import 'package:shared_preferences/shared_preferences.dart'; // Import for storing user_id
import 'package:mudramitra/api_connections/api_connection.dart';
import 'package:mudramitra/dashboard.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUser() async {
    if (mobileNumberController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter both mobile number and password.");
      return;
    }

    try {
      var res = await http.post(
        Uri.parse(API.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_mobile_num": mobileNumberController.text.trim(),
          "user_password": passwordController.text.trim(),
        }),
      );

      print("Response Status: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);

        if (resBody['success'] == true) {
          int userId = resBody['user_id']; // Extract user_id

          Fluttertoast.showToast(msg: "Welcome, ${resBody['user_name']}!");

          // Navigate to MudraDashboard and pass user_id
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MudraDashboard(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: resBody['message']);
        }
      } else {
        Fluttertoast.showToast(msg: "Server Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      Fluttertoast.showToast(msg: "Exception: ${e.toString()}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD54F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      'MudraMitra',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // Mobile Number Input
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == "" ? "Please enter phone number" : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: Colors.amberAccent),
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Input
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Obx(
                        () => TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: isObsecure.value,
                      validator: (val) => val == "" ? "Please enter Password" : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.vpn_key_sharp, color: Colors.amberAccent),
                        suffixIcon: Obx(
                              () => GestureDetector(
                            onTap: () {
                              isObsecure.value = !isObsecure.value;
                            },
                            child: Icon(
                              isObsecure.value ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        hintText: 'Password',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forget Password?', style: TextStyle(color: Colors.black87)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('SIGN IN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
