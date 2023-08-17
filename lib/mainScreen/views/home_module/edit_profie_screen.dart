import 'package:flutter/material.dart';
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
  late Future<String?> _usernameFuture;

  Future<String> fetchSelectedUniversity() async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1/flutter_login/fetch_selected_university.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse["selected"];
    } else {
      throw Exception('Failed to load selected university');
    }
  }

  Future<String?> fetchLastAddedTypeOfWork() async {
    final response = await http.get(Uri.parse(
        'http://192.168.56.1/flutter_login/fetch_selected_typelist.php'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("item")) {
          return jsonResponse["item"];
        } else if (jsonResponse.containsKey("error")) {
          print("Error from server: ${jsonResponse["error"]}");
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
    _usernameFuture = fetchUsername();
    _universitiesFuture = fetchUniversities();
    _typeOfWorksFuture = fetchTypeOfWorks();
  }

  void _initializeData() async {
    try {
      _selectedUniversity = await fetchSelectedUniversity();
      String? typeOfWork = await fetchLastAddedTypeOfWork();
      if (typeOfWork != null) _selectedTypeOfWork = typeOfWork;
      _selectedUsername = await fetchUsername();
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
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/save_username.php'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("name")) {
        return jsonResponse["name"];
      }
    }
    return null;
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
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  onPressed: _saveProfile,
                  child: Text('Save'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _saveProfile() {
    // โค้ดสำหรับการบันทึกข้อมูล
    print('Username: ${_usernameController.text}');
    print('Selected University: $_selectedUniversity');
    print('Selected Type of Work: $_selectedTypeOfWork');
  }
}
