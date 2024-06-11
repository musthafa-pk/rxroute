import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/Util/Routes/routes_name.dart';
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/View/homeView/chemist/chemist_list.dart';
import 'package:rxroute_test/View/homeView/widgets/customChip.dart';
import 'package:rxroute_test/app_colors.dart';
import 'package:rxroute_test/constants/styles.dart';
import 'package:rxroute_test/defaultButton.dart';
import 'package:rxroute_test/widgets/customDropDown.dart';
import 'package:http/http.dart' as http;
import '../../../res/app_url.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specialisationController = TextEditingController();

  final FocusNode nameNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode specialisationNode = FocusNode();

  DateTime? dob;
  DateTime? wedding_date;

  String? qualification;
  String? visitType;
  String? gender;

  int selectedIndex = 0;
  var selectedchemist = ['Diwagar','Chemford','Swathy Medicals','PRC Medicals','YMC Medicals'];
  var selectedproducts = ['Amitriptyline','Acetaminophen','Atorvastatin','Cephalexin','Ciprofloxacin','Doxycycline'];

  Future<dynamic> adddoctor() async {
    String url = AppUrl.getdoctors;
    Map<String, dynamic> data = {
      "name":nameController.text,
      "qualification":qualification.toString(),
      "gender":gender,
      "specialization":specialisationController.text,
      "mobile":phoneController.text,
      "visits":visitType,
      "dob":dob,
      "wedding_date":wedding_date,
      "products":[
        {
          "id":4,
          "product":"paracetamol"
        },
        {
          "id":27,
          "product":"Amoxicillin"
        }
      ],
      "chemist":[
        {
          "address":"Aster Pharmacy - West Hill",
          "pincode":"673005"
        }
      ],
      "created_UniqueId":2
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
        Navigator.pushNamed(context, RoutesName.splash);
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
    final formKeyAddDoctor = GlobalKey<FormState>();
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width/3,
            child: InkWell(
              onTap: (){
                if(formKeyAddDoctor.currentState!.validate()){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));
                }
              },
              child: Defaultbutton(
                text: 'Submit',
                bgColor: AppColors.primaryColor,
                textstyle: const TextStyle(
                color: AppColors.whiteColor,
                fontSize:14,
              ),),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width/3,
            child: Defaultbutton(
              text: 'Cancel',
              bgColor: AppColors.whiteColor,
              bordervalues: Border.all(width: 1,color: AppColors.primaryColor),
              textstyle: const TextStyle(
              color: AppColors.primaryColor,
              fontSize:14,
            ),),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              key: formKeyAddDoctor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Name',style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                              ),),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: TextFormField(
                                  controller: nameController,
                                  focusNode: nameNode,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintText:'Enter your name',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                  // onFieldSubmitted: (v){
                                  //   Utils.fieldFocusChange(context, nameNode, phoneNode);
                                  // },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Qualification',),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.textfiedlColor,
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: CustomDropdown(
                                    options: const ['MA','MBBS'],
                                  onChanged: (value){
                                        qualification = value.toString();
                                  },
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Gender'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: CustomDropdown(
                                  value: gender,
                                  options: const ['Male','Female','Other'],
                                  onChanged: (value) {
                                      gender = value;
                                  },
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mobile'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  controller: phoneController,
                                  focusNode: phoneNode,
                                  onFieldSubmitted: (value){
                                    Utils.fieldFocusChange(context, phoneNode, specialisationNode);
                                  },
                                  validator: (value) {
                                    if(value == null || value.isEmpty){
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText:'Enter phone',
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Specialisation'),
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColors.textfiedlColor
                        ),
                        child: TextFormField(
                          controller: specialisationController,
                          focusNode: specialisationNode,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                              hintText:'Enter your specialisation',
                              border: InputBorder.none
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Visit Type'),
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColors.textfiedlColor
                        ),
                        child: CustomDropdown(
                          value: visitType,
                          options: const ['Importent(2)','Core(3)','Super Core(4)'],
                          onChanged: (value){
                              visitType = value;
                          },
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/2,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date of Birth'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText:'date picker',
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Wedding Date'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText:'date picker',
                                      border: InputBorder.none
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address'),
                      Row(children: [
                        Icon(Icons.add_circle_outline_sharp),
                        SizedBox(width: 10,),
                        Icon(Icons.remove_circle_outline),
                      ],),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('City name'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText:'city name',
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: const Icon(Icons.pin_drop_rounded)
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Latitude'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText:'Latitude',
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Longitude'),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.textfiedlColor
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText:'longitude',
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //show only if chemist selectd....
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0,bottom: 10),
                        child: Text('Chemist',style: text50014black,),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        children:List<Widget>.generate(selectedchemist.length, (index){
                          return Customchip(
                              label: selectedchemist[index],
                            bgcolor: AppColors.textfiedlColor,
                            txtstyle: text40014bordercolor,
                          );
                        }),
                      ),
                    ],
                  ),
                  //show only if product selected
                  const SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0,bottom: 10),
                        child: Text('Products',style: text50014black,),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        children:List<Widget>.generate(selectedchemist.length, (index){
                          return Customchip(
                            label: selectedchemist[index],
                            bgcolor: AppColors.textfiedlColor,
                            txtstyle: text40014bordercolor,
                          );
                        }),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          adddoctor();
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2.5,
                          child: Defaultbutton(
                            isICon: false,
                              btnIcon: Icons.add,
                              btnIconColor: AppColors.whiteColor,
                              bgColor: AppColors.primaryColor,
                              textstyle: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),
                              text: 'Add Doctor'
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.5,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChimistList(),));
                          },
                          child: Defaultbutton(
                            isICon: false,
                              btnIcon: Icons.add,
                              btnIconColor: AppColors.whiteColor,
                              bgColor: AppColors.primaryColor,
                              textstyle: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),
                              text: 'Link Chemist'
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
