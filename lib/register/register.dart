import 'package:flutter/material.dart';
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
    String url = "http://192.168.56.1/flutter_login/register.php";
    String saveUsernameUrl =
        "http://192.168.56.1/flutter_login/save_username.php";

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
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Please complete your',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'biodata correctly',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your name',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                      controller: name,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your E-Mail',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                      controller: email,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Create your Password',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                      controller: password,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Re-Type your Password',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        } else if (val != password.text) {
                          return 'password not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF3F60A0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        bool password = formKey.currentState!.validate();
                        if (password) {
                          sign_up();
                          // After signing up, redirect to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        }
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
