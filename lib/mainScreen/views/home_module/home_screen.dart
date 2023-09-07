import 'package:flutter_login/api.dart';
import 'package:flutter_login/mainScreen/controllers/profile_screen_controller.dart';
import 'package:flutter_login/mainScreen/views/home_module/chat_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/match_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/swipe_widgets/bottom_button.dart';
import 'package:flutter_login/mainScreen/views/home_module/swipe_widgets/card_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../controllers/home_screen_controller.dart';
import 'swipe_widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = Get.put(HomeScreenController(), permanent: true);
  final _profileController =
      Get.put(ProfileScreenController(), permanent: true);

  @override
  void initState() {
    super.initState();
    fetchDataFromServer(); // ดึงข้อมูลเมื่อเริ่มต้นหน้านี้
  }

  Future<Map<String, String?>> fetchDataFromServer() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Entire JSON response: $jsonResponse");

        // Storing the values into the ProfileScreenController.
        _profileController.updateName(jsonResponse["name"]);
        _profileController.updateType(jsonResponse["type"]);
        print(
            'Stored name in ProfileScreenController: ${_profileController.name.value}');
        print(
            'Stored type in ProfileScreenController: ${_profileController.type.value}');

        // Expecting the latest (maximum ID) 'name' and 'type' from user_info.php
        return {"name": jsonResponse["name"], "type": jsonResponse["type"]};
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }
    return {"name": null, "type": null};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.network(
                            'https://sv1.ap-rup.com/2023/08/27/259265130_1021835818596931_7462365712314598608_n.jpeg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Morning",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 14,
                              ),
                            ),
                            Obx(
                              () {
                                final nameFromServer =
                                    _profileController.name.value;
                                if (nameFromServer != null &&
                                    nameFromServer.isNotEmpty) {
                                  return Text(
                                    'Hello $nameFromServer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  );
                                } else {
                                  return Text("No name available");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              )),
              const Icon(Icons.drag_handle_rounded),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 50, top: 20),
              child: Obx(
                () => SwipableStack(
                  itemCount: _controller.items.length,
                  detectableSwipeDirections: const {
                    SwipeDirection.right,
                    SwipeDirection.left,
                    SwipeDirection.up,
                    SwipeDirection.down,
                  },
                  controller: _controller.stackController,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: (index, direction) async {
                    if (kDebugMode) {
                      print('$index, $direction');

                      String? currentItemTitle = _controller.items[index].title;
                      String? currentItemName = _controller.items[index].name;

                      // Fetch name and type from server using fetchDataFromServer()
                      String? nameFromServer = _profileController.name.value;
                      String? typeFromServer = _profileController.type.value;

                      // Print the values for debugging
                      print('Latest Name from server: $nameFromServer');
                      print('Latest Type from server: $typeFromServer');
                      print('Current item title: $currentItemTitle');

                      if (typeFromServer != null) {
                        bool isMatched = typeFromServer == currentItemTitle;
                        _controller.isMatched.value = isMatched;

                        if (isMatched && direction == SwipeDirection.right) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MatchScreen(
                                userName: currentItemName,
                                userImage: _controller.items[index].image,
                              ),
                            ),
                          );

                          _controller
                              .addDataToLocalDb(_controller.items[index]);
                        }
                      }
                    }
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  builder: (context, properties) {
                    final itemIndex =
                        properties.index % _controller.items.length;
                    var data = _controller.items[itemIndex];

                    return Stack(
                      children: [
                        ExampleCard(
                          name: data.name ?? "",
                          assetPath: data.image ?? "",
                          age: data.age ?? "",
                          title: data.title ?? "",
                          location: data.location ?? "",
                        ),
                        if (properties.stackIndex == 0 &&
                            properties.direction != null)
                          CardOverlay(
                            swipeProgress: properties.swipeProgress,
                            direction: properties.direction!,
                          )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          BottomButtonsRow(
            onSwipe: (direction) {
              _controller.stackController.next(swipeDirection: direction);
            },
            onRewindTap: _controller.stackController.rewind,
            canRewind: true,
          ),
        ],
      ),
    );
  }
}
