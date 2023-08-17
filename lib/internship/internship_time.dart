import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/internship/internship.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

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
                  " Select the Date ",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Text("Select Date"),
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Selected Date: ${_selectedDate!.toLocal()}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String message = 'Form invalid';
                    if (_formKey.currentState?.validate() ?? false) {
                      message = 'Form valid';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InternshipScreen()),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: const Text("Continue"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
