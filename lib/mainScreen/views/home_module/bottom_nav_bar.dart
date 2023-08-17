import 'package:flutter_login/mainScreen/views/home_module/matches_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_nav_controller.dart';
import 'chat_screen.dart';
import 'home_screen.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);
  final _controller = Get.put(BottomNavController());
  final screens = [
     HomeScreen(),
     MatchesScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(
            ()=> IndexedStack(
          index: _controller.selectedIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
            ()=> BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) {
            _controller.changeIndex(index);
          },
          currentIndex: _controller.selectedIndex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              //  backgroundColor: darkGreen,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Match",
              //  backgroundColor: darkPink,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outlined),
              label: "Chat",
              // backgroundColor: darkblue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: "Profile",
              // backgroundColor: darkblue,
            ),
          ],
        ),
      ),
    );
  }
}
