import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:http/http.dart' as http;
import 'package:mudramitra/api_connections/api_connection.dart';
// Import the login_page.dart file
import '../model/user.dart';
import 'login_page.dart';




class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var nameController=TextEditingController();
  var mobileNumberController=TextEditingController();
  var parentMobileNumberController=TextEditingController();
  var passwordController=TextEditingController();
  var isObsecure = true.obs;

  validateUserMobileNumber() async
  {
    try
        {
          var res= await http.post(
            Uri.parse(API.validateMobileNumber),
            body:
              {
                'mobile_number': mobileNumberController.text.trim(),
              }
          );
          if(res.statusCode==200) //from flutter app the connection to api to server success
              {
            var resBodyOfValidateMobileNumber = jsonDecode(res.body);
            if (resBodyOfValidateMobileNumber['mobileNumberFound'] == true)
              {
                  Fluttertoast.showToast(
                  msg: "Phone Number is already in use . Try Another Number.");
              }
            else
              {
                //register and save new user record to database
                registerAndSaveUserRecord();

              }
          }

        }
        catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }

  }
  registerAndSaveUserRecord() async {
    User userModel = User(
      nameController.text.trim(),
      mobileNumberController.text.trim(),
      parentMobileNumberController.text.trim(),
      passwordController.text.trim(),
    );

    print(jsonEncode(userModel.toJson())); // Debugging

    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userModel.toJson()),
      );

      print("Response Status: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var resBodyOfSignUP = jsonDecode(res.body);

        if (resBodyOfSignUP['success'] == true) {
          Fluttertoast.showToast(msg: "Congratulations! You have signed up successfully.");
        } else {
          Fluttertoast.showToast(msg: "Error Occurred: ${resBodyOfSignUP['message']}");
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
      backgroundColor: const Color(0xFFFFD54F), // Yellow background color
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Light bulb icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // App name
                  const Text(
                    'MudraMitra',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign Up text
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Name field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      validator: (val) => val == ""?"Please write name":null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.amberAccent,
                        ),
                        hintText:'Name',
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
                  // Mobile number field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: mobileNumberController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == ""?"Please write phone number":null,
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
                  // Parent's mobile number field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: parentMobileNumberController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == ""?"Please enter Parent's phone number":null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.amberAccent,
                        ),
                        hintText: "Parent's Mobile Number",
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


                  // Password field
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

                  const SizedBox(height: 32),
                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle sign up logic
                          //validates the phone number
                          validateUserMobileNumber();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Already have account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Have Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}