import 'package:flutter/material.dart';
import 'package:flutter_login/mainScreen/views/home_module/chat_screen.dart';
import 'package:flutter_login/mainScreen/views/home_module/edit_profie_screen.dart';
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

  Future<String> fetchSelectedUniversity() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/user_info.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["university"];
    } else {
      throw Exception('Failed to load selected university');
    }
  }

  Future<String?> fetchUsernameFromServer() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/user_info.php'));
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

  Future<String?> fetchTalentFromServer() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/user_info.php'));
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
                backgroundImage: NetworkImage(
                    'https://cdn.nba.com/headshots/nba/latest/1040x760/2544.png'),
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
              FutureBuilder<String?>(
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
              SizedBox(height: 0.0),
              FutureBuilder<String?>(
                future: typeOfWorkFuture, // ใช้ Future ของ typeOfWork
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
              FutureBuilder<String?>(
                future: talentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error fetching talent");
                    }
                    return Text(
                      ': ${snapshot.data ?? "No Talent"}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 10.0),

              SizedBox(height: 10.0),
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
                        setState(() {
                          usernameFuture = Future.value(result['name']);
                          universityNameFuture =
                              Future.value(result['university']);
                          typeOfWorkFuture = Future.value(result['type']);
                        });
                      }
                    },
                    child: Text('Setting Profile'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0), // Added padding for aesthetics.
                    ),
                  ),
                  SizedBox(
                      width:
                          20.0), // This will give a horizontal space between the buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: Text('Message'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0), // Added padding for aesthetics.
                    ),
                  ),
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
