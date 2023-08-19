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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeScreenController(), permanent: true);

  Future<String?> fetchLastAddedTypeOfWork() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/user_info.php'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("type")) {
          return jsonResponse["type"];
        } else if (jsonResponse.containsKey("error")) {
          print("Error from server: ${jsonResponse["error"]}");
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }
    return null;
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
                        child: SizedBox(
                            width: 20, height: 20, child: Icon(Icons.person)),
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
                                  fontWeight: FontWeight.w200, fontSize: 14),
                            ),
                            Obx(() => Text(_controller.userName.value,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)))
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

                      // Assuming each item has a 'title' property, fetch it like this:
                      String? currentItemTitle = _controller.items[index].title;
                      String? currentItemName = _controller.items[index].name;

                      // Fetch talent from server
                      String? typeFromServer = await fetchLastAddedTypeOfWork();

                      // Print the values
                      print('Type from server: $typeFromServer');
                      print('Current item title: $currentItemTitle');

                      if (direction == SwipeDirection.right) {
                        if (typeFromServer == currentItemTitle) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'MATCHING',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  content: Text(
                                     'You have Matching With ${currentItemName}!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        _controller.addDataToLocalDb(_controller.items[index]);
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
            canRewind: _controller.stackController.canRewind,
          ),
        ],
      ),
    );
  }
}
