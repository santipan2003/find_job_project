import 'package:flutter/material.dart';
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

  // ตัวแปรสำหรับเก็บข้อมูลสำหรับ Dropdowns
  List<String> universities = [];
  List<String> typeOfWorks = [];

  // กำหนดตัวแปรสำหรับเก็บ Future
  late Future<List<String>> _universitiesFuture;
  late Future<List<String>> _typeOfWorksFuture;

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

  Future<bool> _deleteProfile() async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1/flutter_login/user_info.php'),
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
        .get(Uri.parse('http://192.168.56.1/flutter_login/university.php'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load universities');
    }
  }

  Future<List<String>> fetchTypeOfWorks() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/typelist.php'));
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
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
                TextField(
                  controller: _usernameController,
                  onChanged: (text) {
                    setState(() {
                      _selectedUsername = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: _selectedUsername != null &&
                            _selectedUsername!.isNotEmpty
                        ? _selectedUsername
                        : null,
                    hintText: 'Username',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
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
                  onPressed: (_selectedUsername != null &&
                          _selectedTypeOfWork != null &&
                          _selectedUniversity != null)
                      ? () {
                          Navigator.pop(context, {
                            'name': _selectedUsername!,
                            'university': _selectedUniversity!,
                            'type': _selectedTypeOfWork!,
                          });
                        }
                      : null, // this will disable the button if any of the fields are null
                  child: Text('Save'),
                ),
                SizedBox(height: 0),
                SizedBox(
                    height:
                        16), // เพิ่ม spacing ระหว่างปุ่ม Save และ Delete Profile
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
      Uri.parse('http://192.168.56.1/flutter_login/user_info.php'),
      body: {
        'name': _selectedUsername,
        'type': _selectedTypeOfWork,
        'university': _selectedUniversity,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
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
