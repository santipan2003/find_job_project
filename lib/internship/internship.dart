import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_login/internship/calendar.dart';

class InternshipScreen extends StatefulWidget {
  @override
  _InternshipScreenState createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  List<String> _selectedTalents = [];
  List<String> _talents = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _autocompleteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTalents();
  }

  Future<void> _fetchTalents() async {
    final response = await http
        .get(Uri.parse("http://192.168.56.1/flutter_login/talent.php"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _talents = data.map((e) => e['name'].toString()).toList();
      });
    } else {
      print(
          "Failed to load talents from server. Status code: ${response.statusCode}");
    }
  }

  void _showTalentsList(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _talents.length,
          itemBuilder: (context, index) {
            final talent = _talents[index];
            return ListTile(
              title: Text(talent),
              onTap: () {
                _addTalent(talent);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _addTalent(String talent) {
    if (!_selectedTalents.contains(talent) && _selectedTalents.length < 5) {
      setState(() {
        _selectedTalents.add(talent);
        _autocompleteController.text = talent; // ตั้งค่าใหม่สำหรับ controller
      });
      print("Selected talent: $talent");
      print("All selected talents: $_selectedTalents");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("WHAT'S your Talent?",
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 20),
                AutocompleteTextField(
                  controller: _autocompleteController,
                  items: _talents
                      .where((talent) => !_selectedTalents.contains(talent))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Talent',
                    labelStyle: TextStyle(
                      color:
                          Colors.black87, // เปลี่ยนความเข้มของข้อความ labelText
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0, // เปลี่ยนความหนาของเส้นกรอบ
                        color: Colors.black87, // เปลี่ยนสีของเส้นกรอบ
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.black87,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  onItemSelect: (selected) => _addTalent(selected),
                  initialValue:
                      _selectedTalents.isNotEmpty ? _selectedTalents.last : '',
                  // ตั้งค่า initial value เป็น talent ล่าสุดที่ถูกเลือก หรือ empty string ถ้าไม่มีการเลือก
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 4.0),
                          textStyle: TextStyle(fontSize: 18),
                          elevation: 10,
                          primary: Color.fromARGB(255, 255, 255, 255),
                        ),
                        onPressed: _selectedTalents.length >= 5
                            ? null
                            : () {
                                _showTalentsList(context);
                              },
                        icon: Icon(Icons.add),
                        label: Text("Add Talent"),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 4.0),
                          textStyle: TextStyle(fontSize: 18),
                          elevation: 10,
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CalendarScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Form invalid')));
                          }
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_selectedTalents.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selected Talents:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _selectedTalents.length,
                        itemBuilder: (context, index) {
                          return Text(_selectedTalents[index]);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final InputDecoration decoration;
  final String initialValue;
  final TextEditingController controller;

  const AutocompleteTextField({
    required this.items,
    required this.onItemSelect,
    required this.decoration,
    required this.controller,
    this.initialValue = '',
  });

  @override
  _AutocompleteTextFieldState createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return widget.items.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase()) ||
              option.contains(textEditingValue.text.toUpperCase());
        });
      },
      onSelected: (String selection) {
        widget.onItemSelect(selection);
        _controller.clear();
        print("Selected talent from Autocomplete: $selection");
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return GestureDetector(
          onTap: () {
            _showTalentsList(context);
          },
          child: TextField(
            controller: _controller,
            focusNode: focusNode,
            decoration: widget.decoration,
            readOnly: true, // This ensures the soft keyboard doesn't pop up
          ),
        );
      },
    );
  }

  void _showTalentsList(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final talent = widget.items[index];
            return ListTile(
              title: Text(talent),
              onTap: () {
                widget.onItemSelect(talent);
                Navigator.pop(context);
              },
            );
          },  
        );
      },
    );
  }
}

