import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/app_colors.dart';
import 'package:rxroute_test/res/app_url.dart';
import 'package:rxroute_test/widgets/customDropDown.dart';
class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({super.key});

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {

  final _myformKey = GlobalKey<FormState>();

  List<String> leaveTypeOptions = ['Casual Leave', 'Sick Leave',];
  String? selectedLeaveType;

  TextEditingController reasonController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInput2 = TextEditingController();

  String? leaveType;
  ///Leave Balance

  @override
  void initState() {
    super.initState();
  }

  Future<void> applyLeave() async {
    Map<String, dynamic> data = {
        "requester_id":2,
        "requester_uniqueId":"Rep1234",
        "reason":reasonController.text,
        "to_date":dateInput2.text,
        "from_date":dateInput.text,
        "type":selectedLeaveType.toString()
    };
    try {
      print(jsonEncode(data));
      final response = await http.post(
        Uri.parse(AppUrl.apply_leave),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );


      print(response.statusCode);
      if (response.statusCode == 200) {
        var responses = jsonDecode(response.body);
        print('responses:${responses['message']}');
        Navigator.pop(context);
        Utils.flushBarErrorMessage('${responses['message']}', context);
      } else {
        var responses = jsonDecode(response.body);
        print('responses:${responses['message']}');
        Utils.flushBarErrorMessage('${responses['message']}', context);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Utils.flushBarErrorMessage('${e.toString()}', context);
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: const Text('Leave request',style: TextStyle(),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color:AppColors.primaryColor, // Replace with your desired color
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(onTap: (){
              Navigator.pop(context);
            },
                child: const Icon(Icons.arrow_back, color: Colors.white)), // Adjust icon color
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _myformKey,
            child: Column(
              children: [
                const SizedBox(height: 30,),

                Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Leave Type', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: CustomDropdown(options: leaveTypeOptions,
                                    onChanged:(value){
                                      setState(() {
                                        selectedLeaveType = value.toString();
                                      });
                                    }),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,right: 10,left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('From Date', style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: 150,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          controller: dateInput,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                            filled: true,
                                            fillColor: Colors.grey.shade100,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide.none,
                                            ),
                                            suffixIcon: const Icon(
                                              Icons.arrow_drop_down,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime currentDate = DateTime.now();
                                            DateTime firstDate = DateTime(currentDate.year, currentDate.month - 1, 1);
                                            DateTime initialDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day - 1);
                                            DateTime lastDate = DateTime(currentDate.year, currentDate.month + 2, 0); // Last day of the next month

                                            DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              firstDate: firstDate,
                                              initialDate: currentDate,
                                              lastDate: lastDate,
                                              builder: (BuildContext context, Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light().copyWith(
                                                      primaryColor: AppColors.primaryColor,
                                                      hintColor: AppColors.primaryColor,
                                                      colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
                                                  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                ),
                                                child: child!,
                                                );
                                              },
                                            );

                                            if (pickedDate != null) {
                                              // Change the format of the date here
                                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                              setState(() {
                                                dateInput.text = formattedDate;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if(value! == null && value.isEmpty){
                                              // Utils.flushBarErrorMessage('Select date first', context, lightColor);
                                            }
                                            return null;
                                          },
                                          // validator: (value) => value!.isEmpty ? 'Select Date' : null,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 5,
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('To Date', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 150,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color:  Colors.black,
                                          fontSize: 14,
                                        ),
                                        controller: dateInput2,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                          filled: true,
                                          fillColor: Colors.grey.shade100,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: const Icon(
                                            Icons.arrow_drop_down,
                                            size: 25,
                                            color: Colors.black,
                                          ),
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime currentDate = DateTime.now();
                                          DateTime firstDate = DateTime(currentDate.year, currentDate.month - 1, 1);
                                          DateTime initialDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day - 1);
                                          DateTime lastDate = DateTime(currentDate.year, currentDate.month + 2, 0); // Last day of the next month

                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            firstDate: firstDate,
                                            initialDate: currentDate,
                                            lastDate: lastDate,
                                            builder: (BuildContext context, Widget? child) {
                                              return Theme(
                                                data: ThemeData.light().copyWith(
                                                  primaryColor: AppColors.primaryColor,
                                                  hintColor: AppColors.primaryColor2,
                                                  colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
                                                  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );


                                          if (pickedDate != null) {
                                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                            setState(() {
                                              dateInput2.text = formattedDate;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if(value! == null &&  value.isEmpty){
                                            // Utils.flushBarErrorMessage('Please pick date first', context, lightColor);
                                          }
                                          return null;
                                        },
                                        // validator: (value) => value!.isEmpty ? 'Select Date' : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Reason', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 1.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.textfiedlColor,
                                ),
                                child: TextFormField(
                                  maxLines: 15,
                                  controller: reasonController,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // Utils.flushBarErrorMessage('Fill this field!', context, lightColor);
                                    }
                                    return null; // Add return statement to avoid errors
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Colors.transparent),
                                    ),
                                    hintText: 'Write your reason here...',
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                          ],
                        ),
                      ),


                    ],
                  ),
                ),



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
                            if (_myformKey.currentState!.validate()) {
                              // Map data = {
                              //   "staff_id": Utils.empId,
                              //   "leave_type": selectedLeaveType.toString(),
                              //   "remarks": reasonController.text.toString(),
                              //   "from_date": dateInput.text.toString(),

//   "to_date": dateInput2.text.toString(),
                            //   // "name": "$firstname $lastname"
                            // };
                            if (selectedLeaveType != null &&
                            dateInput.text.isNotEmpty &&
                            dateInput2.text.isNotEmpty &&
                            reasonController.text.isNotEmpty) {
                              applyLeave();
                            } else {
                            // Show an error message or alert indicating that all required fields must be filled.
                              Utils.flushBarErrorMessage('Please fill all fields to apply leave', context);
                            }
                          }
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
            ),
          ),
        ),
      ),
    );
  }
}