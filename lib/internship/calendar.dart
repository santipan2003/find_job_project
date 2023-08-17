import 'package:flutter/material.dart';
import 'package:flutter_login/typelist/typelist_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _selectedItem = '';
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController _dateRangeController = TextEditingController();

  void _navigateToTypeListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TypeListScreen(), // Replace 'TypeListPage()' with the actual widget for the Type List page.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          Text(
                            "Select Time to Internship",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Select Time',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) {
                                  // Add your validation logic here if needed
                                  // Return null if the value is valid, or an error message string if invalid.
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    _selectedItem = val;
                                  });
                                },
                                controller: _dateRangeController,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () {
                                    showCustomDateRangePicker(
                                      context,
                                      dismissible: true,
                                      endDate: endDate,
                                      startDate: startDate,
                                      maximumDate: DateTime.now().add(const Duration(days: 365)),
                                      minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                                      onApplyClick: (s, e) {
                                        setState(() {
                                          startDate = s;
                                          endDate = e;
                                          _dateRangeController.text = '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';
                                        });
                                      },
                                      onCancelClick: () {
                                        setState(() {
                                          startDate = null;
                                          endDate = null;
                                          _dateRangeController.clear();
                                        });
                                      },
                                      primaryColor: Colors.black, // Add primaryColor argument
                                      backgroundColor: Colors.white, // Add backgroundColor argument
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200], // Change the button color to gray
                                      borderRadius: BorderRadius.circular(10.0), // Rounded rectangle shape
                                    ),
                                    child: Icon(Icons.calendar_month_outlined, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              String message = 'Form invalid';
                              if (_formKey.currentState?.validate() ?? false) {
                                message = 'Form valid';
                                _navigateToTypeListPage();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                            },
                            child: const Text("Continue"),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
