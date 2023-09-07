import 'package:flutter/material.dart';
import 'package:flutter_login/api.dart';
import 'package:flutter_login/login/login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> sign_up() async {
    String url = "$apiEndpoint/register.php";
    String saveUsernameUrl =
        "$apiEndpoint/save_username.php";

    try {
      final response = await http.post(Uri.parse(url), body: {
        'name': name.text,
        'password': password.text,
        'email': email.text,
      });

      final saveUsernameResponse =
          await http.post(Uri.parse(saveUsernameUrl), body: {
        'name': name.text,
      });

      if (saveUsernameResponse.statusCode == 200) {
        var saveData = json.decode(saveUsernameResponse.body);
        if (saveData == "Username Saved") {
          print("Username saved successfully");
        } else {
          print("Error saving username");
        }
      } else {
        print(
            "Server returned status code: ${saveUsernameResponse.statusCode}");
      }

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data == "Error") {
          Navigator.pushNamed(context, 'register');
        } else {
          // Send the username to save_username.php
          final saveUsernameResponse =
              await http.post(Uri.parse(saveUsernameUrl), body: {
            'name': name.text,
          });

          // Handle response from save_username.php here if necessary

          await User.setSignin(true);
          Navigator.pushNamed(context, 'login');
        }
      } else {
        print("Server returned status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during sign up: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 // Your logo
                const SizedBox(height: 175),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please complete your details below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    hintText: 'Your name',
                  ),
                  validator: (val) => val!.isEmpty ? 'Empty' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    hintText: 'Your E-Mail',
                  ),
                  validator: (val) => val!.isEmpty ? 'Empty' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    hintText: 'Create your Password',
                  ),
                  validator: (val) => val!.isEmpty ? 'Empty' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFFAFAFA),
                    hintText: 'Re-Type your Password',
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return 'Empty';
                    if (val != password.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sign_up();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
