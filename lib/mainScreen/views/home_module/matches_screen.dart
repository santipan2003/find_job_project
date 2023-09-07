import 'package:flutter/material.dart';
import 'package:flutter_login/mainScreen/views/home_module/chat_screen.dart';
import 'package:get/get.dart';

import '../../controllers/home_screen_controller.dart';

class MatchesScreen extends StatelessWidget {
  MatchesScreen({super.key});
  final _homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    _homeController.getLocalData();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "CHAT SCREEN",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () => _homeController.localList.isNotEmpty
              ? ListView.builder(
                  itemCount: _homeController.localList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = _homeController.localList[index];
                    return Card(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                userName: data.name,
                                userImage: data.image,
                              ),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // แก้ไขที่นี่
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(data.image ?? ""),
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  // ใช้ Expanded ด้วย เพื่อให้ Column ทั้งหมดมีความยืดหยุ่นตามความสูงของ Row
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(data.name ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("You : Send Message 1 Minute ago")
                                      // คุณสามารถเพิ่มส่วนอื่น ๆ ที่คุณต้องการใน children ของ Column ได้ที่นี่
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                )
              : const Center(
                  child: Text("No users found!"),
                ),
        ));
  }
}
