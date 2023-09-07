import 'package:flutter/material.dart';
import 'package:flutter_login/api.dart';
import 'package:flutter_login/mainScreen/controllers/profile_screen_controller.dart';
import 'package:flutter_login/mainScreen/views/home_module/chat_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/edit_profie_screen.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String?> universityNameFuture;
  late Future<String?> usernameFuture;
  late Future<String?> typeOfWorkFuture;
  late Future<String?> talentFuture;

  final _profileController = Get.find<ProfileScreenController>();

  Future<String> fetchSelectedUniversity() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["university"];
    } else {
      throw Exception('Failed to load selected university');
    }
  }

  Future<String?> fetchUsernameFromServer() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Received JSON: $jsonResponse"); // debug statement
        if (jsonResponse.containsKey("error")) {
          print("Error: ${jsonResponse["error"]}");
        } else if (jsonResponse.containsKey("name")) {
          return jsonResponse["name"];
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        print("Raw response: ${response.body}");
      }
    }
    return null;
  }

  Future<String?> fetchLastAddedTypeOfWork() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
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

  Future<String?> fetchTalentFromServer() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("talent")) {
          return jsonResponse["talent"];
        } else if (jsonResponse.containsKey("error_talent")) {
          print("Error from server: ${jsonResponse["error_talent"]}");
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    universityNameFuture = fetchSelectedUniversity();
    usernameFuture = fetchUsernameFromServer();
    typeOfWorkFuture = fetchLastAddedTypeOfWork();
    talentFuture = fetchTalentFromServer();
  }

  void _updateProfileData(Map<String, String> newData) {
    setState(() {
      // Update the values with the new data
      usernameFuture = Future<String>.value(newData['name']);
      universityNameFuture = Future<String>.value(newData['university']);
      typeOfWorkFuture = Future<String>.value(newData['type']);
    });
    _profileController.updateName(newData['name'] ?? "ชื่อใหม่");
    _profileController.updateType(newData['type'] ?? "ประเภทใหม่");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50.0),
              CircleAvatar(
                radius: 70.0,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(
                    'https://sv1.ap-rup.com/2023/08/27/259265130_1021835818596931_7462365712314598608_n.jpeg'),
              ),
              SizedBox(height: 10.0),
              FutureBuilder<String?>(
                future: usernameFuture, // ใช้ Future ของ username
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error fetching username");
                    }
                    return Text(
                      snapshot.data ?? "No Username",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 50.0),
                  Icon(
                    Icons
                        .school, // Example icon for university. You can use any other icon if you prefer.
                    color:
                        Colors.grey, // Choose the color that suits your design.
                  ),
                  SizedBox(
                      width:
                          5.0), // Adds a little space between the icon and the text.
                  Expanded(
                    child: FutureBuilder<String?>(
                      future: universityNameFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text("Error fetching university name");
                          }
                          return Text(
                            ': ${snapshot.data ?? "No University Name"}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 0.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 50.0),
                  Icon(
                    Icons.work, // Icon representing work.
                    color: Colors
                        .grey, // You can customize the color as per your design.
                  ),
                  SizedBox(
                      width:
                          5.0), // Provides some space between the icon and the text.
                  Expanded(
                    child: FutureBuilder<String?>(
                      future:
                          typeOfWorkFuture, // Using the Future for typeOfWork.
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text("Error fetching type of work");
                          }
                          return Text(
                            ': ${snapshot.data ?? "No Type of Work"}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),

              FutureBuilder<String?>(
                future: talentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text(
                        "Error fetching talent",
                        style: TextStyle(
                            color: Colors.red.shade600, fontSize: 16.0),
                      );
                    } else if (snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      List<String> talents = snapshot.data!.split(',');
                      List<Color> colors = [
                        Colors.blue.shade700,
                        Colors.red.shade700,
                        Colors.green.shade700,
                        Colors.orange.shade700,
                        Colors.purple.shade700,
                        Colors.yellow.shade700,
                        Colors.pink.shade700,
                        Colors.teal.shade700,
                        Colors.brown.shade700,
                        Colors.deepPurple.shade700,
                      ];

                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Wrap(
                            spacing: 10.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment
                                .center, // Align the chips to the center
                            children: talents.asMap().entries.map((entry) {
                              int idx = entry.key;
                              String talent = entry.value;
                              return Chip(
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                label: Text(
                                  talent.trim(),
                                  style: TextStyle(
                                      color: Colors
                                          .black, // changed color to black
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                  overflow: TextOverflow.visible,
                                ),
                                backgroundColor: Colors.white,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  }
                  return SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                      strokeWidth: 2.0,
                    ),
                  );
                },
              ),

              SizedBox(height: 0.0),

              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // This will center the children horizontally.
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            selectedUniversity: "Some University Name",
                          ),
                        ),
                      );

                      if (result != null) {
                        _updateProfileData(result);
                      }
                    },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade500,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5.0,
                    ),
                  ),

                  SizedBox(
                      width:
                          20.0), // This will give a horizontal space between the buttons
                ],
              ),

              SizedBox(height: 20.0), // Add some spacing after the button

              // Image widget

              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.95, // 95% of screen width
                          child: Image.network(
                            'https://cdn.pic.in.th/file/picinth/White-simple-student-cv-resume67609905dcead5d5.jpeg?fbclid=IwAR2Tezz_NG65slEnDBmZ4rl3_tOGjqsAuiu7AmuYPJbGoTREn3OWPicnBOk',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width *
                      0.9, // ขนาดของรูปภาพในหน้าแรก
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      'https://cdn.pic.in.th/file/picinth/White-simple-student-cv-resume67609905dcead5d5.jpeg?fbclid=IwAR2Tezz_NG65slEnDBmZ4rl3_tOGjqsAuiu7AmuYPJbGoTREn3OWPicnBOk',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
