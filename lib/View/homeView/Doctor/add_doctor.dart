import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:rxroute_test/Util/Routes/routes_name.dart';
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/View/homeView/Employee/add_rep.dart';
import 'package:rxroute_test/constants/styles.dart';
import 'package:rxroute_test/widgets/customDropDown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../app_colors.dart';
import '../../../defaultButton.dart';
import '../../../res/app_url.dart';

class AddDoctor extends StatefulWidget {
  @override
  _AddDoctorState createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define controllers for each form field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _visitsController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weddingDateController = TextEditingController();



  // Dropdown data and selected values
  List<Product> products = [
    Product('Product 1'),
    Product('Product 2'),
    Product('Product 3'),
    Product('Product 4'),
    Product('Product 5'),
    Product('Product 6'),
    Product('Product 7'),
    Product('Product 8'),
    Product('Product 9'),
    Product('Product 10'),
    // Add more products as needed
  ];

  List<Chemist> chemists = [
    Chemist('Chemist 1'),
    Chemist('Chemist 2'),
    Chemist('Chemist 3'),
    Chemist('Chemist 4'),
    Chemist('Chemist 5'),
    Chemist('Chemist 6'),
    Chemist('Chemist 7'),
    Chemist('Chemist 8'),
    Chemist('Chemist 9'),
    Chemist('Chemist 10'),
    // Add more products as needed
  ];

  List<Product> selectedProducts = [];
  String selectedProductsText = '';
  List<Chemist> selectedChemist = [];
  String selectedChemistsText = '';


  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _qualificationController.dispose();
    _genderController.dispose();
    _specializationController.dispose();
    _mobileController.dispose();
    _visitsController.dispose();
    _dobController.dispose();
    _weddingDateController.dispose();
    super.dispose();
  }

  Future<dynamic> fetchchemists() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uniqueID = preferences.getString('uniqueID');

    String url = AppUrl.add_doctor_rep;
    Map<String, dynamic> data = {
      "uniqueId":"Rep1234"
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
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      Utils.flushBarErrorMessage('${e.toString()}', context);
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dynamic> adddoctors() async {
    print('add doc called...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uniqueID = preferences.getString('uniqueID');

    String url = AppUrl.add_doctor_rep;
    Map<String, dynamic> data = {
      "name": _nameController.text,
      "qualification": _qualificationController.text,
      "gender": _genderController.text,
      "specialization": _specializationController.text,
      "mobile": _mobileController.text,
      "visits": int.parse(_visitsController.text),
      "dob": _dobController.text,
      "wedding_date": _weddingDateController.text,
      "products": products,
      "chemist": chemists,
      "created_UniqueId":uniqueID
    };

    try {
      print('in try');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('st code :${response.statusCode}');
      print('${jsonEncode(data)}');
      print('${response.body}');
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.successsplash, (route) => false,);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        return responseData;
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      Utils.flushBarErrorMessage('${e.toString()}', context);
      throw Exception('Failed to load data: $e');
    }
  }

  // Future<List<HeadQuart>> fetchHeadQuarts() async {
  //   final response = await http.get(Uri.parse(AppUrl.abiip));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body)['data'];
  //     return data.map((json) => HeadQuart.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load headquarters');
  //   }
  // }
  //address widgets
  final List<FieldEntry> fields = [FieldEntry()];

  Future<void> fetchLatLon(String placeName, TextEditingController latController, TextEditingController lonController) async {
    try {
      final coordinates = await getLatLon(placeName);
      setState(() {
        latController.text = coordinates['lat']!;
        lonController.text = coordinates['lon']!;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, String>> getLatLon(String placeName) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = data[0]['lat'];
        final lon = data[0]['lon'];
        return {'lat': lat, 'lon': lon};
      } else {
        throw Exception('Place not found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> fetchSuggestions(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) => item['display_name']).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  void addField() {
    setState(() {
      fields.add(FieldEntry());
    });
  }

  void removeField(int index) {
    setState(() {
      fields.removeAt(index);
    });
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
          'Add Doctor',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    contentPadding: EdgeInsets.only(left: 10),
                                    // labelText: 'Name',
                                  hintText: 'Name',
                                  hintStyle: text50010tcolor2
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                            ),
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
                                    // labelText: 'Qualification',,
                                    hintText: 'Qualification',
                                    hintStyle: text50010tcolor2,
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a qualification';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
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
                          Text('Gender',style: text50012black,),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.textfiedlColor,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: CustomDropdown(
                              options: ['Male','Female','Other'],
                              onChanged: (value){
                                _genderController.text = value.toString();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mobile Number',style: text50012black,),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: TextFormField(
                                controller: _mobileController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 10),
                                    // labelText: 'Mobile',
                                  hintStyle: text50010tcolor2,
                                  hintText: 'Mobile Number',
                                  counterText: ''
                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a mobile number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Specialisation',style: text50012black,),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: TextFormField(
                          controller: _specializationController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              // labelText: 'Specialization',
                            hintText: 'Specialisation',
                            hintStyle: text50010tcolor2
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a specialization';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visit Type',style: text50012black,),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.textfiedlColor,
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: CustomDropdown(
                          options: ['Core','Super Core','Important'],
                          onChanged: (value) {
                            _visitsController.text = value.toString();
                          },
                        )
                      ),
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
                            Text('Date of birth',style: text50012black,),
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
                                  hintText: 'Birth day',
                                  hintStyle: text50010tcolor2,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
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
                                      _dobController.text = formattedDate;
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
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Wedding Date',style: text50012black,),
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
                                controller: _weddingDateController,
                                decoration: InputDecoration(
                                  hintText: 'Wedding date',
                                  hintStyle: text50010tcolor2,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.event,
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
                                      _weddingDateController.text = formattedDate;
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
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Products',style: text50012black,),
                      SizedBox(height: 10,),
                      productwidget1(context),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chemists',style: text50012black,),
                      SizedBox(height: 10,),
                      chemistwidget1(context),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text('Addresses',style: text50012black,),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(width: 1,color: Colors.grey)
                          ),
                    height: 300,
                      child: addresswidget(context)),
                  // Container(
                  //   height: 300,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(6),
                  //       border: Border.all(width: 1,color: Colors.grey)
                  //     ),
                  //     child: AddressAddingWidget()),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data'))
                              );
                              adddoctors();
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
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Defaultbutton(
                            text: 'Cancel',
                            bgColor: AppColors.whiteColor,
                            bordervalues: Border.all(width: 1, color: AppColors.primaryColor),
                            textstyle: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget productwidget1(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.textfiedlColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              List<Product>? result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProductSelectionDialog(
                    products: products,
                    initiallySelectedProducts: selectedProducts,
                  );
                },
              );

              if (result != null) {
                setState(() {
                  selectedProducts = result;
                  selectedProductsText = selectedProducts.map((p) => p.name).join(', ');
                });
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              border: InputBorder.none,
              // labelText: 'Products',
              hintStyle: text50010tcolor2,
              hintText: 'select products',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            controller: TextEditingController(text: selectedProductsText),
          ),
        ),
      ],
    );
  }

  @override
  Widget chemistwidget1(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.textfiedlColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextFormField(
            readOnly: true,
            onTap: () async {
              List<Chemist>? result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ChemistSelectionDialog(
                    chemists: chemists,
                    initiallySelectedChemists: selectedChemist,
                  );
                },
              );

              if (result != null) {
                setState(() {
                  selectedChemist = result;
                  selectedChemistsText = selectedChemist.map((p) => p.name).join(', ');
                });
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              // labelText: 'Chemists',
              hintText: 'select chemists',
              hintStyle: text50010tcolor2,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            controller: TextEditingController(text: selectedProductsText),
          ),
        ),
      ],
    );
  }

  @override
  Widget addresswidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle_outline_sharp,color: AppColors.primaryColor,),
                onPressed: addField,
              ),
              IconButton(
                icon: Icon(Icons.remove_circle_outline,color: AppColors.primaryColor,),
                onPressed: fields.length > 1 ? () => removeField(fields.length - 1) : null,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: TypeAheadField(
                                controller: fields[index].placeController,
                                suggestionsCallback: (pattern) async {
                                  return await fetchSuggestions(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                onSelected: (String value) {
                                  fields[index].placeController.text = value;
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.location_on,color: AppColors.primaryColor,),
                            onPressed: () {
                              fetchLatLon(fields[index].placeController.text, fields[index].latController, fields[index].lonController);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: TextField(
                                controller: fields[index].latController,
                                decoration: InputDecoration(
                                    labelText: 'Latitude',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                                readOnly: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: TextField(
                                controller: fields[index].lonController,
                                decoration: InputDecoration(
                                    labelText: 'Longitude',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 10)
                                ),
                                readOnly: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  Product(this.name);
}
class Chemist {
  final String name;
  Chemist(this.name);
}



class ProductSelectionDialog extends StatefulWidget {
  final List<Product> products;
  final List<Product> initiallySelectedProducts;

  const ProductSelectionDialog({
    required this.products,
    required this.initiallySelectedProducts,
  });

  @override
  _ProductSelectionDialogState createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  late List<Product> selectedProducts;

  @override
  void initState() {
    super.initState();
    selectedProducts = List.from(widget.initiallySelectedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Products'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            Product product = widget.products[index];
            bool isSelected = selectedProducts.contains(product);
            return ListTile(
              title: Text(product.name),
              trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedProducts.remove(product);
                  } else {
                    selectedProducts.add(product);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedProducts);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class ChemistSelectionDialog extends StatefulWidget {
  final List<Chemist> chemists;
  final List<Chemist> initiallySelectedChemists;

  const ChemistSelectionDialog({
    required this.chemists,
    required this.initiallySelectedChemists,
  });

  @override
  _ChemistSelectionDialogState createState() => _ChemistSelectionDialogState();
}

class _ChemistSelectionDialogState extends State<ChemistSelectionDialog> {
  late List<Chemist> selectedChemists;

  @override
  void initState() {
    super.initState();
    selectedChemists = List.from(widget.initiallySelectedChemists);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Chemists'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.chemists.length,
          itemBuilder: (context, index) {
            Chemist chemist = widget.chemists[index];
            bool isSelected = selectedChemists.contains(chemist);
            return ListTile(
              title: Text(chemist.name),
              trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedChemists.remove(chemist);
                  } else {
                    selectedChemists.add(chemist);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedChemists);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}