import 'package:flutter/material.dart';
import 'package:flutter_login/api.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/mainScreen/views/home_module/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final String selectedUniversity;

  EditProfileScreen({required this.selectedUniversity});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();

  // ตัวแปรสำหรับเก็บค่าที่เลือกจาก Dropdowns
  String? _selectedUniversity;
  String? _selectedTypeOfWork;
  String? _selectedUsername;
  String? _currentTalent;
  

  // ตัวแปรสำหรับเก็บข้อมูลสำหรับ Dropdowns
  List<String> universities = [];
  List<String> typeOfWorks = [];

  // กำหนดตัวแปรสำหรับเก็บ Future
  late Future<List<String>> _universitiesFuture;
  late Future<List<String>> _typeOfWorksFuture;

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

  Future<bool> _deleteProfile() async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/user_info.php'),
      body: {
        'delete': 'true',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("success")) {
        return true;
      } else {
        print("Error deleting profile: ${jsonResponse["error_delete"]}");
      }
    } else {
      print('Failed to delete profile. Status code: ${response.statusCode}');
    }
    return false;
  }

  Future<bool> _updateUserInfo(
      String name, String type, String university) async {
    // Ensure that none of the parameters are null or empty before making the request
    if (name.isEmpty || type.isEmpty || university.isEmpty) {
      
      print('One or more values are empty');
      return false;
    }

    // Ensure talent is also not empty since the server requires it
    if (_currentTalent == null) {
      print("Talent value is empty or not fetched");
      return false;
    }

    print('Sending name: $name'); // Debug
    print('Sending type: $type'); // Debug
    print('Sending university: $university'); // Debug

    final response = await http.post(
      Uri.parse('$apiEndpoint/user_info.php'),
      body: {
        'name': name,
        'type': type,
        'university': university,
        'talent': _currentTalent!,
      },
    );

    print("Server Response: ${response.body}"); // Debug

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("success")) {
        return true;
      } else if (jsonResponse.containsKey("error_post_data")) {
        print("Error updating profile: ${jsonResponse["error_post_data"]}");
      } else if (jsonResponse.containsKey("error")) {
        print("Error updating profile: ${jsonResponse["error"]}");
      } else {
        print("Unknown error while updating profile.");
      }
    }
    return false; // Default return value
  }

  Future<String?> fetchTalent() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/user_info.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("talent")) {
        return jsonResponse["talent"];
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchSelectedUniversity().then((value) {
      setState(() {
        _selectedUniversity = value;
      });
    });
    fetchLastAddedTypeOfWork().then((value) {
      setState(() {
        if (value != null) {
          _selectedTypeOfWork = value;
        }
      });
    });
    fetchUsernameFromServer().then((username) {
      if (username != null) {
        setState(() {
          _selectedUsername = username;
        });
      }
    });
    fetchTalent().then((value) {
      setState(() {
        _currentTalent = value;
      });
    });

    _universitiesFuture = fetchUniversities();
    _typeOfWorksFuture = fetchTypeOfWorks();
  }

  void _initializeData() async {
    try {
      _selectedUniversity = await fetchSelectedUniversity();
      String? typeOfWork = await fetchLastAddedTypeOfWork();
      if (typeOfWork != null) _selectedTypeOfWork = typeOfWork;
      setState(() {});
    } catch (e) {
      print('Error initializing data: $e');
    }
    _universitiesFuture = fetchUniversities();
    _typeOfWorksFuture = fetchTypeOfWorks();
  }

  Future<List<String>> fetchUniversities() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/university.php'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load universities');
    }
  }

  Future<List<String>> fetchTypeOfWorks() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/typelist.php'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load type of works');
    }
  }

  Future<String?> fetchUsername() async {
    // Add your logic here
    return null; // Sample return value, replace with actual implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<List<String>>>(
        future: Future.wait([_universitiesFuture, _typeOfWorksFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            universities = snapshot.data![0];
            typeOfWorks = snapshot.data![1];
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Input สำหรับ Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: '$_selectedUsername',
                    labelText: 'Username ',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    _selectedUsername = text;
                  },
                ),

                SizedBox(height: 16),
                // Dropdown สำหรับ University
                DropdownButtonFormField(
                  value: _selectedUniversity,
                  hint: Text('Select University'),
                  items: universities.map((university) {
                    return DropdownMenuItem(
                      value: university,
                      child: Text(university),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversity = value as String?;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'University',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Dropdown สำหรับ Type of Work
                DropdownButtonFormField(
                  value: _selectedTypeOfWork,
                  hint: Text('Select Type of Work'),
                  items: typeOfWorks.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeOfWork = value as String?;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type of Work',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () async {
                    bool isUpdated = await _updateUserInfo(
                      _selectedUsername!,
                      _selectedTypeOfWork!,
                      _selectedUniversity!,
                    );

                    if (isUpdated) {
                      print("Successfully updated user information");

                      Navigator.pop(context, {
                        'name': _selectedUsername!,
                        'type': _selectedTypeOfWork!,
                        'university': _selectedUniversity!,
                      });
                    } else {
                      print("Error updating user information");
                    }
                  },
                  child: Text('Save'),
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // แสดง AlertDialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Delete Account'),
                          content: Text('คุณจะลบ Account จริงหรือไม่?'),
                          actions: [
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                // ปิด dialog เมื่อผู้ใช้กดปุ่ม No
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                bool isDeleted = await _deleteProfile();
                                if (isDeleted) {
                                  // Navigate to the login screen after successful deletion.
                                  // Make sure you've imported the login screen at the top.
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => login()));
                                } else {
                                  // You can show a message to the user or handle the error in other ways.
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Delete Profile'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors
                        .red, // เปลี่ยนสีปุ่มเป็นสีแดงเพื่อเตือนความระมัดระวัง
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _saveProfile() async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/user_info.php'),
      body: {
        'name': _selectedUsername,
        'type': _selectedTypeOfWork,
        'university': _selectedUniversity,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Print the saved values
      print("Saved Name: $_selectedUsername");
      print("Saved Type: $_selectedTypeOfWork");
      print("Saved University: $_selectedUniversity");

      if (jsonResponse.containsKey("error_user_info")) {
        print("Error updating profile: ${jsonResponse["error_user_info"]}");
      } else {
        Navigator.pushReplacement(
          // using pushReplacement to replace current screen
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      }
    } else {
      print('Failed to save profile. Status code: ${response.statusCode}');
    }
  }
}
