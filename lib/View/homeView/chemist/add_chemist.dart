import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxroute_test/constants/styles.dart';
import 'package:rxroute_test/constants/widgets/customButton.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Util/Routes/routes_name.dart';
import '../../../Util/Utils.dart';
import '../../../app_colors.dart';
import '../../../res/app_url.dart';

class AddChemist extends StatefulWidget {
  const AddChemist({super.key});

  @override
  State<AddChemist> createState() => _AddChemistState();
}

class _AddChemistState extends State<AddChemist> {

  final TextEditingController buildingName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController licencenumber = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController wedding_date = TextEditingController();

  Future<dynamic> addchemist() async {
    print('add chemi called...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userID = preferences.getString('userID');
    String? uniqueID = preferences.getString('uniqueID');
    String url = AppUrl.add_chemist;
    Map<String, dynamic> data = {
      "created_by":int.parse(userID.toString()),
      "building_name":buildingName.text,
      "mobile":phone.text,
      "email":email.text,
      "lisence_no":licencenumber.text,
      "address":address.text,
      "date_of_birth":dob.text,
      // "anniversary_date":"02-05-2024",
      "uniqueId":uniqueID
    };
    try {
      print(jsonEncode(data));
      print('try working..');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('bdy:$data');
      print('stcode:${response.statusCode}');
      print('rsp:${response.body}');
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.successsplash, (route) => true,);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage('${e.toString()}', context);
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        title: const Text(
          'Add Chemist',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){
              print('pressed..');
              // add validation
              addchemist();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Submit',style: text50014,),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(width: 1,color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(6)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Cancel',style: text50014primary,),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Building Name',style: text50014black,),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.textfiedlColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                              child: TextFormField(
                                controller: buildingName,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                    hintStyle: text50010tcolor2,
                                    hintText: 'Building Name',
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mobile',style: text50014black,),
                          SizedBox(height: 10,),
                          Container(
                              decoration: BoxDecoration(
                                color: AppColors.textfiedlColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,hintStyle: text50010tcolor2,
                                    hintText: 'Phone Number',
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email(Optional)',style: text50014black,),
                    SizedBox(height: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: text50010tcolor2,
                              hintText: 'eg:abc@gmail.com',
                              contentPadding: EdgeInsets.only(left: 10)
                          ),
                        )),
                    SizedBox(height: 10,),
                    Text('License Number',style: text50014black,),
                    SizedBox(height: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: licencenumber,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                            hintStyle: text50010tcolor2,
                            hintText: 'eg:123456789',
                            contentPadding: EdgeInsets.only(left: 10)
                          ),
                        )),
                    SizedBox(height: 10,),
                    Text('Date of Birth',style: text50014black,),
                    SizedBox(height: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          controller: dob,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            hintText: 'Birth day',
                            hintStyle: text50010tcolor2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(
                              Icons.cake_outlined,
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
                                dob.text = formattedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if(value! == null && value.isEmpty){
                              Utils.flushBarErrorMessage('Select date first', context,);
                            }
                            return null;
                          },
                          // validator: (value) => value!.isEmpty ? 'Select Date' : null,
                        ),),
                    SizedBox(height: 10,),
                    Text('Address',style: text50014black,),
                    SizedBox(height: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: address,
                          maxLines: 3,
                          maxLength: 118,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                            counterText: '',
                              hintStyle: text50010tcolor2,
                              hintText: 'address',
                              contentPadding: EdgeInsets.only(left: 10)
                          ),
                        )),
                    SizedBox(height: 10,),
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
