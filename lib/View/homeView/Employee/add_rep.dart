import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Util/Utils.dart';
import '../../../app_colors.dart';
import '../../../defaultButton.dart';
import '../../../res/app_url.dart';

class AddRep extends StatefulWidget {
  const AddRep({super.key});

  @override
  State<AddRep> createState() => _AddRepState();
}

class _AddRepState extends State<AddRep> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _gender = 'male';
  String _selectedQualification = 'bsc';
  int _selectedReportingOfficer = 1;

  List<String> qualifications = ['bsc', 'msc', 'phd'];
  List<int> reportingOfficers = [1, 2, 3, 4];

  Future<void> addEmployee() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int myid = int.parse(preferences.getString('userID').toString());
    if (_passwordController.text != _confirmPasswordController.text) {
      Utils.flushBarErrorMessage('Passwords do not match', context);
      return;
    }

    String url = AppUrl.add_employee;
    Map<String, dynamic> data = {
      "name": _nameController.text,
      "gender": _gender,
      "dob": _dobController.text,
      "nationality": _nationalityController.text,
      "mobile": _mobileController.text,
      "email": _emailController.text,
      "designation": _designationController.text,
      "qualification": _selectedQualification,
      "reporting_officer": _selectedReportingOfficer,
      "created_by": myid,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('bdy${data}');
      print('stcode:${response.statusCode}');
      print('${response.body}');

      if (response.statusCode == 200) {
        Utils.flushBarErrorMessage('Employee added successfully!', context);
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
      }
    } catch (e) {
      Utils.flushBarErrorMessage('Failed to load data: $e', context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Add Employee',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  addEmployee();
                }
              },
              child: Defaultbutton(
                text: 'Submit',
                bgColor: AppColors.primaryColor,
                textstyle: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Defaultbutton(
                text: 'Cancel',
                bgColor: AppColors.primaryColor,
                textstyle: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                buildTextFormField(_nameController, 'Name'),
                buildGenderRadioButtons(),
                buildTextFormField(_dobController, 'DOB'),
                buildTextFormField(_nationalityController, 'Nationality'),
                buildTextFormField(_mobileController, 'Phone'),
                buildTextFormField(_emailController, 'Email'),
                buildTextFormField(_designationController, 'Designation'),
                buildDropdownFormField(
                  'Qualification',
                  _selectedQualification,
                  qualifications,
                      (String? newValue) {
                    setState(() {
                      _selectedQualification = newValue!;
                    });
                  },
                ),
                buildDropdownFormField(
                  'Reporting Officer',
                  _selectedReportingOfficer.toString(),
                  reportingOfficers.map((int value) => value.toString()).toList(),
                      (String? newValue) {
                    setState(() {
                      _selectedReportingOfficer = int.parse(newValue!);
                    });
                  },
                ),
                buildTextFormField(_passwordController, 'Password', obscureText: true),
                buildTextFormField(_confirmPasswordController, 'Confirm Password', obscureText: true),
                SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget buildGenderRadioButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender'),
          Row(
            children: [
              Radio<String>(
                value: 'male',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const Text('Male'),
              Radio<String>(
                value: 'female',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdownFormField(String labelText, String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentValue,
            isDense: true,
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
