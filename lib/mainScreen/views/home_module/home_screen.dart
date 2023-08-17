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
  final _controller = Get.put(HomeScreenController(),permanent: true);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 0),
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
                             decoration: const BoxDecoration(
                               color: Colors.red,
                               shape: BoxShape.circle

                             ),
                             child: const SizedBox(
                                 width: 20,
                                 height: 20,
                                 child: Icon(Icons.person)),
                           ),
                           const SizedBox(width: 10,),
                           const Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Good Morning",
                                   style: TextStyle(fontWeight: FontWeight.w200,fontSize: 14),),
                                 Text("Pawan Kumar", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),)
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
             const Icon(Icons.drag_handle_rounded ),

           ],
         ),
       ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 50,top: 20),
              child: Obx(
                ()=> SwipableStack(
                  itemCount: _controller.items.length,
                  detectableSwipeDirections: const {
                    SwipeDirection.right,
                    SwipeDirection.left,
                    SwipeDirection.up,
                    SwipeDirection.down,
                  },
                  controller: _controller.stackController,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: (index, direction) {
                    if (kDebugMode) {
                      print('$index, $direction');
                      if(direction ==SwipeDirection.right){
                        _controller.addDataToLocalDb(_controller.items[index]);
                      }
                    }
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  builder: (context, properties) {
                    final itemIndex = properties.index % _controller.items.length;
                    var data =  _controller.items[itemIndex];

                    return Stack(
                      children: [
                        ExampleCard(
                          name: data.name??"",
                          assetPath: data.image??"",
                          age:  data.age??"",
                          title: data.title??"",
                          location: data.location??"",
                        ),
                        if (properties.stackIndex == 0 && properties.direction != null)
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
            onRewindTap:  _controller.stackController.rewind,
            canRewind:  _controller.stackController.canRewind,
          ),
        ],
      ),

    );
  }
}
