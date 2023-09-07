import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/api.dart';
import 'package:flutter_login/internship/internship.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UniversityScreen extends StatefulWidget {
  const UniversityScreen({Key? key}) : super(key: key);

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  String _selectedItem = '';
  final _formKey = GlobalKey<FormState>();
  List<String> universities = [];

  Future<void> saveUniversity(String university) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/save_university.php'),
      body: {
        'university': university,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == 1) {
        print(jsonResponse['message']);
      } else {
        print(jsonResponse['message']);
      }
    } else {
      throw Exception('Failed to save university');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUniversities().then((result) {
      setState(() {
        universities = result;
      });
    });
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
                Text(
                  " WHAT'S your University? ",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                AutocompleteTextField(
                  items: universities,
                  decoration: const InputDecoration(
                      labelText: 'Select University',
                      border: OutlineInputBorder()),
                  validator: (val) {
                    if (universities.contains(val)) {
                      return null;
                    } else {
                      return 'Invalid University';
                    }
                  },
                  onItemSelect: (selected) {
                    setState(() {
                      _selectedItem = selected;
                      print("Selected University: $selected");
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String message = 'Form invalid';
                    if (_formKey.currentState?.validate() ?? false) {
                      message = 'Form valid';

                      // Save the selected university
                      await saveUniversity(_selectedItem);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InternshipScreen(),
                        ),
                      );
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                  ),
                  child: const Text("Continue"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchUniversities() async {
    final response = await http
        .get(Uri.parse('$apiEndpoint/university.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print("Fetched Universities: $jsonResponse");
      return jsonResponse.cast<String>();
    } else {
      throw Exception('Failed to load universities from server');
    }
  }
}

class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  const AutocompleteTextField(
      {Key? key,
      required this.items,
      required this.onItemSelect,
      this.decoration,
      this.validator})
      : super(key: key);

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<String> _filteredItems;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Autocomplete Initialized with Items: ${widget.items}");
    _filteredItems = widget.items;

    // Create an initial overlay entry
    _overlayEntry = _createOverlayEntry();

    _focusNode.addListener(() {
      // Only remove the overlay entry when focus is lost and it's currently displayed
      if (!_focusNode.hasFocus && (_overlayEntry?.mounted ?? false)) {
        _overlayEntry!.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onFieldChange,
        decoration: widget.decoration?.copyWith(
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      _onFieldChange(
                          ''); // call this to handle clearing the overlay as well
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }

  void _onFieldChange(String val) {
    setState(() {
      if (val == '') {
        _filteredItems = widget.items;
        if (_overlayEntry?.mounted ?? false) {
          _overlayEntry!.remove();
        }
      } else {
        _filteredItems = widget.items
            .where(
                (element) => element.toLowerCase().contains(val.toLowerCase()))
            .toList();

        // Check if there are items to display in the overlay
        if (_filteredItems.isNotEmpty) {
          if (_overlayEntry?.mounted ?? false) {
            _overlayEntry!.markNeedsBuild();
          } else {
            _overlayEntry = _createOverlayEntry();
            if (_focusNode.hasFocus) {
              Overlay.of(context)?.insert(_overlayEntry!);
            }
          }
        } else if (_overlayEntry?.mounted ?? false) {
          _overlayEntry!.remove();
        }
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached || _controller.text.isEmpty) {
      return OverlayEntry(builder: (context) => Container());
    }
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            _controller.text = item;
                            _focusNode.unfocus();
                            widget.onItemSelect(item);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ));
  }
}
