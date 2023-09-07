import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  // Observables for the name and type
  RxString name = "".obs;
  RxString type = "".obs;

  // You can add methods to update the name and type values, 
  // if needed. For example:
  void updateName(String newName) {
    name.value = newName;
  }

  void updateType(String newType) {
    type.value = newType;
  }
}
