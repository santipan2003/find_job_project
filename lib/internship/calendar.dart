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
        builder: (context) => TypeListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimationLimiter(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // ใส่สีขาวให้กับ Container
                borderRadius: BorderRadius.circular(10),
              
              ),
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Select Time',
                                  labelStyle: TextStyle(
                                      color:
                                          Colors.black54), // เปลี่ยนสีของ label
                                  hintStyle: TextStyle(
                                      color:
                                          Colors.black38), // เปลี่ยนสีของ hint
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey[
                                          300]!, // เปลี่ยนสีของขอบเป็นสีเทาอ่อน
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width:
                                          2, // เพิ่มความหนาของขอบเมื่อ focused
                                    ),
                                  ),
                                ),
                                validator: (val) {
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
                                right: 10,
                                top: 15,
                                child: InkWell(
                                  onTap: () {
                                    showCustomDateRangePicker(
                                      context,
                                      dismissible: true,
                                      endDate: endDate,
                                      startDate: startDate,
                                      maximumDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      minimumDate: DateTime.now()
                                          .subtract(const Duration(days: 365)),
                                      onApplyClick: (s, e) {
                                        setState(() {
                                          startDate = s;
                                          endDate = e;
                                          _dateRangeController.text =
                                              '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}';
                                        });
                                      },
                                      onCancelClick: () {
                                        setState(() {
                                          startDate = null;
                                          endDate = null;
                                          _dateRangeController.clear();
                                        });
                                      },
                                      primaryColor: Colors.black,
                                      backgroundColor: Colors.white,
                                    );
                                  },
                                  child: Icon(Icons.calendar_month_outlined,
                                      color: Colors.black),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical:
                                      12), // เพิ่ม padding ให้ปุ่มใหญ่ขึ้น
                              elevation: 5, // เพิ่มเงาให้ปุ่ม
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight
                                      .bold), // ให้ตัวอักษรในปุ่มใหญ่ขึ้นและหนาขึ้น
                            ),
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