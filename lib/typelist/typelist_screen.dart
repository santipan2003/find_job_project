import 'package:flutter/material.dart';
import 'package:flutter_login/mainScreen/views/home_module/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TypeListScreen extends StatefulWidget {
  const TypeListScreen({Key? key}) : super(key: key);

  @override
  State<TypeListScreen> createState() => _TypeListScreenState();
}

class _TypeListScreenState extends State<TypeListScreen> {
  String _selectedItem = '';
  Future<List<String>> fetchTypeList() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/flutter_login/typelist.php'));

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load type list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: fetchTypeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return Form(
              //key: _formKey,
              // Uncomment the line above if you use the form key
              child: Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Type of Work ",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 20),
                      AutocompleteTextField(
                        items: snapshot.data!,
                        selectedItem: _selectedItem,
                        decoration: const InputDecoration(
                          labelText: 'Select your Work',
                          border: OutlineInputBorder(),
                        ),
                        onItemSelect: (selected) {
                          setState(() {
                            _selectedItem = selected;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavBar()),
                          );
                        },
                        child: const Text("Continue"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Rest of your code remains unchanged...

class AutocompleteTextField extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelect;
  final String? selectedItem;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;

  const AutocompleteTextField({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onItemSelect,
    this.decoration,
    this.validator,
  }) : super(key: key);

  @override
  State<AutocompleteTextField> createState() => _AutocompleteTextFieldState();
}

class _AutocompleteTextFieldState extends State<AutocompleteTextField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<String> _filteredItems;
  final TextEditingController _controller;
  _AutocompleteTextFieldState() : _controller = TextEditingController();

  Future<void> saveToDatabase(String item) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1/flutter_login/save_typelist.php'),
      body: {'item': item},
    );
    if (response.statusCode != 200) {
      print('Failed to save data: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = [];
    _controller.text = widget.selectedItem ?? '';
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _filteredItems = widget.items;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      } else if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
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
              labelText: _controller.text.isEmpty ? 'Select your Work' : '',
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    ),
            ) ??
            InputDecoration(
              labelText: _controller.text.isEmpty ? 'Select your Work' : '',
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    ),
            ),
        validator: widget.validator,
      ),
    );
  }

  void _onFieldChange(String val) {
    setState(() {
      if (val == '') {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where(
                (element) => element.toLowerCase().contains(val.toLowerCase()))
            .toList();
      }

      // Remove the overlay entry if it exists
      _overlayEntry?.remove();

      // Check if the focus node is focused and if there are filtered items
      if (_focusNode.hasFocus && _filteredItems.isNotEmpty) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
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
                      setState(() {
                        _controller.text = item;
                        _filteredItems = widget.items;
                      });
                      _focusNode.unfocus();
                      widget.onItemSelect(item);
                      print("Selected item from Database: $item");

                      // Save to database
                      saveToDatabase(item);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
