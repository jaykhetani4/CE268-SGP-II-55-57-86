import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mudramitra/api_connections/api_connection.dart';
import 'package:get/get.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

 @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
{
  final _formKey = GlobalKey<FormState>();
  var mobileNumberController=TextEditingController();
  var passwordController=TextEditingController();
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
          Fluttertoast.showToast(msg: "Welcome, ${resBody['user_name']}!");
          // Navigate to home page or dashboard
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
      backgroundColor: Color(0xFFFFD54F), // Yellow background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child:Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo and App Name
                Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'MudraMitra',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Sign In Text
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                // Mobile Number TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == ""?"Please enter phone number":null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.amberAccent,
                      ),
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password TextField
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child :Obx(
                            ()=>TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: isObsecure.value,
                              validator: (val) => val == ""?"Please enter Password":null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.vpn_key_sharp,
                              color: Colors.amberAccent,
                            ),
                            suffixIcon: Obx(
                                    ()=>GestureDetector(
                                  onTap: ()
                                  {
                                    isObsecure.value= !isObsecure.value;

                                  },
                                  child: Icon(
                                    isObsecure.value ?Icons.visibility_off :Icons.visibility,
                                    color: Colors.black,
                                  ),
                                )
                            ),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        )
                    )
                ),
                const SizedBox(height: 8),
                // Forget Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate())
                      {
                        loginUser();
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Bottom Image and Create Account Link
                Column(
                  children: [
                    Image.asset(
                      'assets/images/people_illustration.png', // Add this image to your assets
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()
                              ),
                            );
                          },
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )

        ),
      ),
    );
  }
}