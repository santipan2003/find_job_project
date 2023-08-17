import 'package:flutter/material.dart';
import 'package:flutter_login/internship/internship.dart';
import 'package:flutter_login/internship/internship_time.dart';
import 'package:flutter_login/mainScreen/views/home_module/chat_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/edit_profie_screen.dart';
import 'package:flutter_login/typelist/typelist_screen.dart';
import 'package:flutter_login/university_screen/unv_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(flex: 1),
            CircleAvatar(
              radius: 50.0,
              backgroundImage:
                  NetworkImage('assets/logo4.png'),
            ),  
            SizedBox(height: 20.0),
            Text(
              'Username',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          selectedUniversity: "Some University Name",  // Provide the university name here
        ),
      ),
    );
  },
  child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              child: Text('Message'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
