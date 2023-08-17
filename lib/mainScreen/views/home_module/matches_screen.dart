import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_screen_controller.dart';

class MatchesScreen extends StatelessWidget {
   MatchesScreen({super.key});
  final _homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    _homeController.getLocalData();
    return  Scaffold(
      appBar: AppBar(title: const Text("Favourites",
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
      centerTitle: true,
    ),

      body: Obx(
        ()=> _homeController.localList.isNotEmpty?ListView.builder(
          itemCount: _homeController.localList.length,
          itemBuilder: (BuildContext context, int index) {
            var data = _homeController.localList[index];
            return Card(
              margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                children: [
                 Container(
                   height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    //  borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                        image: NetworkImage(data.image??""),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 26,
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("YOU HAVE MATCHING "),
                      Text("WITH"),
                      Text(data.name??""),
                      
                    ],
                  )

                ],
                ),
              ),
            );

          },):const Center(
          child: Text("No users found!"),

        ),
      )
    );
  }
}
