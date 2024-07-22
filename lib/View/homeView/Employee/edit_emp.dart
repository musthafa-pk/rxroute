import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxroute_test/Util/Routes/routes_name.dart';
import 'package:rxroute_test/constants/styles.dart';
import 'package:rxroute_test/widgets/customDropDown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Util/Utils.dart';
import '../../../app_colors.dart';
import '../../../defaultButton.dart';
import '../../../res/app_url.dart';
import '../home_view_rep.dart';

class EditRep extends StatefulWidget {
  String uniqueID;
  int userID;
  EditRep({required this.uniqueID,required this.userID,super.key});

  @override
  State<EditRep> createState() => _EditRepState();
}

class _EditRepState extends State<EditRep> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _confirmPasswordController = TextEditingController();

  String _gender = '';

  List<Officer> _officers = [];
  String? _selectedReportingOfficer;

  Headquarter? selectedHeadquarter;

  String? fileName;

  Future<dynamic> fetchemployeedata() async {
    print('caledd....');
    var data = {
      "uniqueId":widget.uniqueID
    };
    String url = AppUrl.single_employee_details; // Replace with your actual API URL
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
    body: jsonEncode(data),
    );
    try{
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var data = responseData['data'][0];
        _nameController.text = data['name'];
        _qualificationController.text = data['qualification'];
        _dobController.text = data['date_of_birth'];
        _nationalityController.text = data['Nationality'];
        _mobileController.text = data['mobile'];
        _emailController.text = data['email'];
        _designationController.text = data['designation'];
        _passwordController.text = data['password'];
        _addressController.text = data['address'] ?? 'N/A';
        _gender = data['gender'];
        // _selectedReportingOfficer = data['reporting_officer'];
        return responseData['data'];
      } else {
        throw Exception('Failed to load ');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<Headquarter>> fetchHeadquarters() async {
    String url = AppUrl.list_headqrts; // Replace with your actual API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> headquartersJson = data['data'];
      return headquartersJson.map((json) => Headquarter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load headquarters');
    }
  }

  Future<List<Officer>> fetchofficers() async {
    String url = AppUrl.managers_list; // Replace with your actual API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var officersJson = data['data'] as List;
      List<Officer> officers = officersJson.map((officer) => Officer.fromJson(officer)).toList();
      return officers;
    } else {
      throw Exception('Failed to load headquarters');
    }
  }

  void _loadOfficers() async {
    try {
      List<Officer> officers = await fetchofficers();
      setState(() {
        _officers = officers;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> edit_empoyee() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? myid = preferences.getString('userID');
    String? uniqueID = preferences.getString('uniqueID');
    // if (_passwordController.text != _confirmPasswordController.text) {
    //   Utils.flushBarErrorMessage('Passwords do not match', context);
    //   return;
    // }

    String url = AppUrl.edit_employee;
    Map<String, dynamic> data = {
      "repId":widget.userID,
      "name":_nameController.text,
      "gender":_gender,
      "dob":_dobController.text,
      "nationality":_nationalityController.text,
      "mobile":_mobileController.text,
      "email":_emailController.text,
      "designation":_designationController.text,
      "qualification":_qualificationController.text,
      "reporting_officer":_selectedReportingOfficer,
      "password":_passwordController.text,
      "type":_designationController.text,
      "address":_addressController.text,
      "headquarters":selectedHeadquarter,
      "modified_by":int.parse(myid.toString())
    };

    try {
      print('sending...:${jsonEncode(data)}');
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
        var responseData = jsonDecode(response.body);
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.successsplash, (route) => false,);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
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
    _qualificationController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    // _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchHeadquarters();
    _loadOfficers();
    super.initState();
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ProfileIconWidget(userName: Utils.userName![0].toString().toUpperCase() ?? 'N?A',),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Edit Employee',
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
                  edit_empoyee();
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
          child: FutureBuilder(
            future:fetchemployeedata(),
            builder: (context,snapshot) {
             if(snapshot.connectionState == ConnectionState.waiting){
               return Center(child:CircularProgressIndicator(),);
             }else if(snapshot.hasError){
               return Center(child: Text('Some error occured !'),);
             }else if(snapshot.hasData){
               return Form(
                 key: _formKey,
                 child: ListView(
                   children: [
                     Row(
                       children: [
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Name',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                 decoration: BoxDecoration(
                                     color: AppColors.textfiedlColor,
                                     borderRadius: BorderRadius.circular(6)
                                 ),
                                 child: TextFormField(
                                   controller: _nameController,
                                   decoration: InputDecoration(
                                       border: InputBorder.none,
                                       hintStyle: text50010tcolor2,
                                       hintText: 'Name'
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Qualification',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                 decoration: BoxDecoration(
                                     color: AppColors.textfiedlColor,
                                     borderRadius: BorderRadius.circular(6)
                                 ),
                                 child: TextFormField(
                                   controller: _qualificationController,
                                   decoration: InputDecoration(
                                       border: InputBorder.none,
                                       hintText: 'qualification',
                                       hintStyle: text50010tcolor2
                                   ),
                                 ),
                               )
                             ],
                           ),
                         )
                       ],
                     ),
                     Row(
                       children: [
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Gender',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                   decoration: BoxDecoration(
                                       color: AppColors.textfiedlColor,
                                       borderRadius: BorderRadius.circular(6)
                                   ),
                                   child: CustomDropdown(
                                     hintText: _gender,
                                     options: ['Male','Female','Other'],
                                     onChanged: (value) {
                                       _gender = value.toString();
                                     },
                                   )
                               )
                             ],
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Mobile',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                 decoration: BoxDecoration(
                                     color: AppColors.textfiedlColor,
                                     borderRadius: BorderRadius.circular(6)
                                 ),
                                 child: TextFormField(
                                   controller: _mobileController,
                                   keyboardType: TextInputType.phone,
                                   maxLength: 10,
                                   decoration: InputDecoration(
                                       contentPadding: EdgeInsets.only(left: 10),
                                       border: InputBorder.none,
                                       hintText: 'Mobile Number',
                                       hintStyle: text50010tcolor2,
                                       counterText: ''
                                   ),
                                 ),
                               )
                             ],
                           ),
                         )
                       ],
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Email',style: text50012black,),
                         SizedBox(height: 10,),
                         Container(
                           decoration: BoxDecoration(
                               color: AppColors.textfiedlColor,
                               borderRadius: BorderRadius.circular(6)
                           ),
                           child: TextFormField(
                             controller: _emailController,
                             keyboardType: TextInputType.emailAddress,
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                 contentPadding: EdgeInsets.only(left: 10),
                                 hintText: 'email',
                                 hintStyle: text50010tcolor2,
                                 counterText: ''
                             ),
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Nationality',style: text50012black,),
                         SizedBox(height: 10,),
                         Container(
                           decoration: BoxDecoration(
                               color: AppColors.textfiedlColor,
                               borderRadius: BorderRadius.circular(6)
                           ),
                           child: TextFormField(
                             controller: _nationalityController,
                             keyboardType: TextInputType.emailAddress,
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: 'Nationality',
                                 hintStyle: text50010tcolor2,
                                 contentPadding: EdgeInsets.only(left: 10),
                                 counterText: ''
                             ),
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Row(
                       children: [
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Date of Birth',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                 decoration: BoxDecoration(
                                     color: AppColors.textfiedlColor,
                                     borderRadius: BorderRadius.circular(6)
                                 ),
                                 child: TextFormField(
                                   style: const TextStyle(
                                     color: Colors.black,
                                     fontSize: 14,
                                   ),
                                   controller: _dobController,
                                   decoration: InputDecoration(
                                     hintStyle: text50010tcolor2,
                                     hintText: 'Birth day',
                                     isDense: true,
                                     contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                     filled: true,
                                     fillColor: Colors.grey.shade100,
                                     border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(10),
                                       borderSide: BorderSide.none,
                                     ),
                                     suffixIcon: const Icon(
                                       Icons.cake,
                                       size: 25,
                                       color: Colors.black,
                                     ),
                                   ),
                                   readOnly: true,
                                   onTap: () async {
                                     DateTime currentDate = DateTime.now();
                                     DateTime firstDate = DateTime(1500);
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
                                       // Change the form  at of the date here
                                       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                       setState(() {
                                         _dobController.text = formattedDate;
                                       });
                                     }
                                   },
                                   validator: (value) {
                                     if(value! == null && value.isEmpty){
                                       Utils.flushBarErrorMessage('Select birth day', context,);
                                     }
                                     return null;
                                   },
                                   // validator: (value) => value!.isEmpty ? 'Select Date' : null,
                                 ),
                               )
                             ],
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           flex: 3,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Designation',style: text50012black,),
                               SizedBox(height: 10,),
                               Container(
                                   decoration: BoxDecoration(
                                       color: AppColors.textfiedlColor,
                                       borderRadius: BorderRadius.circular(6)
                                   ),
                                   child: CustomDropdown(
                                     options: ['Reporter','Manager'],
                                     onChanged: (value) {
                                       if(value == 'Reporter'){
                                         _designationController.text = "rep";
                                       }else if(value == 'Manager'){
                                         _designationController.text = value.toString();
                                       }
                                       // _designationController.text = value.toString();
                                     },
                                   )
                               )
                             ],
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Reporting Officer',style:text50012black,),
                         SizedBox(height: 10,),
                         Container(
                           decoration: BoxDecoration(
                               color: AppColors.textfiedlColor,
                               borderRadius: BorderRadius.circular(6)
                           ),
                           child: CustomDropdown(
                             options:_officers.map((officer)=> officer.name).toList(),
                             onChanged: (value) {
                               setState(() {
                                 _selectedReportingOfficer = _officers.firstWhere((officer) => officer.name == value).id.toString();
                               });
                             },
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Password',style: text50012black,),
                         SizedBox(height: 10,),
                         Container(
                           decoration: BoxDecoration(
                               color: AppColors.textfiedlColor,
                               borderRadius: BorderRadius.circular(6)
                           ),
                           child: TextFormField(
                             controller: _passwordController,
                             keyboardType: TextInputType.emailAddress,
                             decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: 'Password',
                                 hintStyle: text50010tcolor2,
                                 contentPadding: EdgeInsets.only(left: 10),
                                 counterText: ''
                             ),
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Head Quarters',style: text50012black,),
                         SizedBox(height: 10,),
                         FutureBuilder<List<Headquarter>>(
                           future: fetchHeadquarters(),
                           builder: (context, snapshot) {
                             if (snapshot.connectionState == ConnectionState.waiting) {
                               return Center(child: CircularProgressIndicator());
                             } else if (snapshot.hasError) {
                               return Center(child: Text('Error: ${snapshot.error}'));
                             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                               return Center(child: Text('No Headquarters Available'));
                             } else {
                               return Container(
                                 decoration: BoxDecoration(
                                   color: AppColors.textfiedlColor,
                                 ),
                                 child: CustomDropdownHeadQrt(
                                   options: snapshot.data!,
                                   selectedHeadquarter: selectedHeadquarter,
                                   onChanged: (value) {
                                     setState(() {
                                       selectedHeadquarter = value;
                                     });
                                   },
                                 ),
                               );
                             }
                           },
                         )
                       ],
                     ),
                     SizedBox(height: 10,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Personal Address',style: text50014black,),
                         Container(
                           decoration: BoxDecoration(
                             color: AppColors.textfiedlColor,
                             borderRadius: BorderRadius.circular(6),
                           ),
                           child: TextFormField(
                             controller: _addressController,
                             maxLines: 3,
                             maxLength: 118,
                             decoration: InputDecoration(
                                 contentPadding: EdgeInsets.only(left: 10),
                                 border: InputBorder.none,
                                 hintText: 'Personel Address',
                                 counterText: '',
                                 hintStyle: text50010tcolor2
                             ),
                           ),
                         ),
                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           InkWell(
                               onTap:pickFile,
                               child: Container(
                                 width: MediaQuery.of(context).size.width/1.1,
                                 decoration: BoxDecoration(
                                     color: AppColors.textfiedlColor,
                                     borderRadius: BorderRadius.circular(6)
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.file_present),
                                       SizedBox(width: 10,),
                                       Text('Add documents',style: text50012black,),
                                       SizedBox(width: 10,),
                                       fileName != null ? Icon(Icons.verified,color: AppColors.primaryColor,) : Icon(Icons.verified,color: Colors.grey,),
                                     ],
                                   ),
                                 ),
                               )),
                         ],
                       ),
                     ),
                     SizedBox(height: 100,),
                   ],
                 ),
               );
             }
             return Center(child: Text('Some error occured , Please restart your application'),);
            }
          ),
        ),
      ),
    );
  }

}
// class AddressAddingWidget extends StatefulWidget {
//   const AddressAddingWidget({super.key});
//
//   @override
//   State<AddressAddingWidget> createState() => _AddressAddingWidgetState();
// }
//
// class _AddressAddingWidgetState extends State<AddressAddingWidget> {
//   final List<FieldEntry> fields = [FieldEntry()];
//
//   Future<void> fetchLatLon(String placeName, TextEditingController latController, TextEditingController lonController) async {
//     try {
//       final coordinates = await getLatLon(placeName);
//       setState(() {
//         latController.text = coordinates['lat']!;
//         lonController.text = coordinates['lon']!;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<Map<String, String>> getLatLon(String placeName) async {
//     final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       if (data.isNotEmpty) {
//         final lat = data[0]['lat'];
//         final lon = data[0]['lon'];
//         return {'lat': lat, 'lon': lon};
//       } else {
//         throw Exception('Place not found');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   Future<List<String>> fetchSuggestions(String query) async {
//     final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       return data.map<String>((item) => item['display_name']).toList();
//     } else {
//       throw Exception('Failed to load suggestions');
//     }
//   }
//
//   void addField() {
//     setState(() {
//       fields.add(FieldEntry());
//     });
//   }
//
//   void removeField(int index) {
//     setState(() {
//       fields.removeAt(index);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.add_circle_outline_sharp,color: AppColors.primaryColor,),
//                 onPressed: addField,
//               ),
//               IconButton(
//                 icon: Icon(Icons.remove_circle_outline,color: AppColors.primaryColor,),
//                 onPressed: fields.length > 1 ? () => removeField(fields.length - 1) : null,
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: fields.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.textfiedlColor,
//                                 borderRadius: BorderRadius.circular(6)
//                               ),
//                               child: TypeAheadField(
//                                   controller: fields[index].placeController,
//                                 suggestionsCallback: (pattern) async {
//                                   return await fetchSuggestions(pattern);
//                                 },
//                                 itemBuilder: (context, suggestion) {
//                                   return ListTile(
//                                     title: Text(suggestion),
//                                   );
//                                 },
//                                  onSelected: (String value) {
//                                 fields[index].placeController.text = value;
//                               },
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           IconButton(
//                             icon: Icon(Icons.location_on,color: AppColors.primaryColor,),
//                             onPressed: () {
//                               fetchLatLon(fields[index].placeController.text, fields[index].latController, fields[index].lonController);
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.textfiedlColor,
//                                 borderRadius: BorderRadius.circular(6)
//                               ),
//                               child: TextField(
//                                 controller: fields[index].latController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Latitude',
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 10)
//                                 ),
//                                 readOnly: true,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: AppColors.textfiedlColor,
//                                 borderRadius: BorderRadius.circular(6)
//                               ),
//                               child: TextField(
//                                 controller: fields[index].lonController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Longitude',
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(left: 10)
//                                 ),
//                                 readOnly: true,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FieldEntry {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
}
class Headquarter {
  final int id;
  final String headquarterName;
  final String subHeadquarter;

  Headquarter({
    required this.id,
    required this.headquarterName,
    required this.subHeadquarter,
  });

  factory Headquarter.fromJson(Map<String, dynamic> json) {
    return Headquarter(
      id: json['id'],
      headquarterName: json['headquarter_name'].trim(),
      subHeadquarter: json['sub_headquarter'].trim(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Headquarter &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CustomDropdownHeadQrt extends StatelessWidget {
  final List<Headquarter> options;
  final Function(Headquarter?) onChanged;
  final Headquarter? selectedHeadquarter;

  const CustomDropdownHeadQrt({
    Key? key,
    required this.options,
    required this.onChanged,
    this.selectedHeadquarter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<Headquarter>(
        hint: Text('Select Headquarter'),
        value: selectedHeadquarter,
        items: options.map((Headquarter headquarter) {
          return DropdownMenuItem<Headquarter>(
              value: headquarter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${headquarter.headquarterName}  ${headquarter.subHeadquarter}'),
                  // Text('${headquarter.subHeadquarter}'),
                ],
              )
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
class Officer {
  final int id;
  final String name;

  Officer({required this.id, required this.name});

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      id: json['id'],
      name: json['name'],
    );
  }
}