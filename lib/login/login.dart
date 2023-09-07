// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_login/api.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_login/register/user.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> sign_in() async {
    String url = "$apiEndpoint/login.php";

    try {
      final response = await http.post(Uri.parse(url), body: {
        'password': password.text,
        'email': email.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data == "Error") {
          Navigator.pushNamed(context, 'login');
        } else {
          await User.setSignin(true);
          Navigator.pushNamed(context, 'university');
        }
      } else {
        // Handle the case when the server returns a non-200 status code
        print("Server returned status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle other exceptions that might occur during the network request or JSON decoding
      print("Error during sign up: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            shrinkWrap: true,
            children: [
              SizedBox(height: 60),
              Center(
                child: Image.network(
                  'https://img.imgbiz.com/file/imgbiz2/logo14.png',
                  height: 350,
                ), // Adjust the image size as required
              ),
              SizedBox(height: 60),
              _buildTextField(
                controller: email,
                hint: 'Phone number, email or username',
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: password,
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  bool valid = formKey.currentState!.validate();
                  if (valid) {
                    sign_in();
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {}, // TODO: Implement Forgot password function
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
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
    );
  }

  // Helper function for TextFormFields
  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon,
      bool isPassword = false}) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
    );
  }
}
