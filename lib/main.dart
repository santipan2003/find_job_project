import 'package:flutter/material.dart';
import 'package:flutter_login/internship/calendar.dart';
import 'package:flutter_login/internship/internship.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/mainScreen/views/home_module/bottom_nav_bar.dart';
import 'package:flutter_login/signOut/home.dart';
import 'package:flutter_login/typelist/typelist_screen.dart';
import 'package:flutter_login/register/register.dart';
import 'package:flutter_login/university_screen/unv_screen.dart';
import 'package:flutter_login/mainScreen/Utills/helpers/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 89, 6, 245)),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: BottomNavBar(),
      routes: {
        'register': (context) => const register(),
        'home': (context) => const homepage(),
        'login': (context) => const login(),
        'university': (context) => const UniversityScreen(),
        'internship': (context) => InternshipScreen(),
        'calendar': (context) => const CalendarScreen(),
        'type': (context) => const TypeListScreen(),
        'main': (context) => BottomNavBar(),
      },
    );
  }
}
