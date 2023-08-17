import 'package:flutter_login/mainScreen/Utills/helpers/db_repositories/user_repo.dart';
import 'package:flutter_login/mainScreen/models/user_model.dart';
import 'package:get/get.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreenController extends GetxController {
  late final SwipableStackController stackController;
  late UserRepository _repository;
  RxList<UserModel> items = RxList();
  RxList<UserModel> localList = RxList();
  RxString userName = "".obs;

  @override
  void onInit() {
    stackController = SwipableStackController();
    _repository = UserRepository();
    loadItems();
    super.onInit();
  }

  
  addDataToLocalDb(UserModel model) {
    _repository.createUser(model);
  }

  getLocalData() async {
    localList.clear();
    localList.value = await _repository.getAllUsers();
    localList.refresh();
  }

  loadItems() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/getusers.php'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == 1) {
        List<UserModel> loadedItems = [];

        for (var user in jsonResponse['users']) {
          loadedItems.add(UserModel(
              id: int.parse(user['id']),
              name: user['name'],
              age: user['age'],
              image: user['image'],
              location: user['location'],
              title: user['title']));
        }

        items.clear();
        items.assignAll(loadedItems);
        items.refresh();
      } else {
        // Handle no data found or any other error
        print(jsonResponse['message']);
      }
    } else {
      print('Failed to load users from server');
    }
  }
}
