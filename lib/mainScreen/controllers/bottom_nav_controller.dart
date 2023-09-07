import 'package:get/get.dart';

import 'home_screen_controller.dart';

class BottomNavController extends GetxController{
  var selectedIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    
    if(selectedIndex.value==1 && Get.isRegistered<HomeScreenController>()){
      Get.find<HomeScreenController>().getLocalData();

    }
  }

}