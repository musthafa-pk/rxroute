import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/constants/styles.dart';

import '../../Util/Utils.dart';
import '../../app_colors.dart';
import '../../res/app_url.dart';
import 'package:http/http.dart' as http;

class MarkAsVisited extends StatefulWidget {
  int doctorID;
  MarkAsVisited({required this.doctorID,Key? key}) : super(key: key);

  @override
  State<MarkAsVisited> createState() => _MarkAsVisitedState();
}

class _MarkAsVisitedState extends State<MarkAsVisited> {
  bool _isChecked = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _remarks = '';

  List<dynamic> doctorDetails = [];

  Future<dynamic> single_doctordetails() async {
    String url = AppUrl.single_doctor_details;
    Map<String,dynamic> data = {
      "dr_id":widget.doctorID
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        doctorDetails.clear();
        doctorDetails.addAll(responseData['data']);
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage('${e.toString()}', context);
      throw Exception('Failed to load data: $e');
    }
  }


  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Mark as visited',
          style: TextStyle(),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor, // Replace with your desired color
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ), // Adjust icon color
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: single_doctordetails(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return Center(child: Text('Some error happend !'),);
              }else if(snapshot.hasData){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.whiteColor,
                          activeColor: AppColors.primaryColor,
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        Text('Offline reporting'),
                      ],
                    ),
                    Visibility(
                      visible: _isChecked,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _pickDate,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Select Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                child: Text(
                                  _selectedDate == null
                                      ? 'No date selected'
                                      : _selectedDate!.toLocal().toString().split(' ')[0],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: _pickTime,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Select Time',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                child: Text(
                                  _selectedTime == null
                                      ? 'No time selected'
                                      : _selectedTime!.format(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Products'),
                    SizedBox(height: 10),
              Text('${doctorDetails[0]['products'][0]['product']}',style: text50014black,),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Text('${doctorDetails[0]['products']}');
                      },),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        _remarks = value;
                      },
                      maxLines: 3,
                      maxLength: 362,
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        counterText: '', // Hide character count
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                                side: const BorderSide(color:AppColors.primaryColor), // Sets the border color
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                // if (_myformKey.currentState!.validate()) {
                                // Map data = {
                                //   "staff_id": Utils.empId,
                                //   "leave_type": selectedLeaveType.toString(),
                                //   "remarks": reasonController.text.toString(),
                                //   "from_date": dateInput.text.toString(),

                                //   "to_date": dateInput2.text.toString(),
                                //   // "name": "$firstname $lastname"
                                // };
                                // if (selectdDoctor != null &&
                                //     dateInput.text.isNotEmpty &&
                                //     amount.text.isNotEmpty &&
                                //     reasonController.text.isNotEmpty) {
                                // Proceed with leave application
                                // applyleave(context);

                                // } else {
                                // Show an error message or alert indicating that all required fields must be filled.
                                // Utils.flushBarErrorMessage('Please fill in all required fields', context, Colors.red);
                                // }
                                // leaveApplication.leaveAppApi(jsonEncode(data), context);

                                // }

                                // _showMaterialDialog();
                                // showAboutDialog(context: context);

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  maximumSize: const Size(100, 40),
                                  minimumSize: const Size(100, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text(
                                'Submit',
                                style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.whiteColor),
                              )),

                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text('Some error occured , Please restart !'),);
            }
          ),
        ),
      ),
    );
  }
}
