import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxroute_test/View/MarkasVisited/markasVisited.dart';
import 'package:rxroute_test/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:rxroute_test/constants/styles.dart';
import '../../../Util/Routes/routes_name.dart';
import '../../../Util/Utils.dart';
import '../../../res/app_url.dart';
import '../Employee/widgets.dart';

class DoctorDetails extends StatefulWidget {
  int doctorID;
  DoctorDetails({required this.doctorID,super.key});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabs = [
    const Tab(text: 'Basic information'),
    const Tab(text: 'Documents'),
    const Tab(text: 'Notes'),
  ];


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
      print('single doctor details called');
      print('${response.statusCode}');
      print('${response.body}');
      print('bdy:${data}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        doctorDetails.clear();
        doctorDetails.addAll(responseData['data']);
        return doctorDetails;
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
  void initState() {
    super.initState();
    print('doctor id :${widget.doctorID}');
    single_doctordetails();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: InkWell(
        onTap: (){
          print('ddtls:${doctorDetails[0]['products']}');
          // Navigator.pushNamed(context, RoutesName.markasvisited,arguments: doctorDetails);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MarkAsVisited(doctorID: widget.doctorID,products: doctorDetails[0]['products'],),));
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(6)),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Mark as Visited',
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: const Text('Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: single_doctordetails(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text(
                'Some error occured , please restart your application${snapshot.data}'),);
          } else if (snapshot.hasData) {
            print('${snapshot.data}');
            final List<Widget> _pages = [
              EmpDetailsWidgets.BasicInfo(snapshot.data),
              EmpDetailsWidgets.Documents(snapshot.data),
              EmpDetailsWidgets.Notes(snapshot.data),
            ];
            var snapdata = snapshot.data[0];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     CircleAvatar(
                      backgroundColor:AppColors.primaryColor,
                        radius: 35,
                    child: Text('${snapdata['doc_name'][0]}',style: text70014,),),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${snapdata['doc_name']}',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        Text(
                          '${snapdata['doc_qualification']}',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                        Text(
                          '${snapdata['specialization']}',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset('assets/icons/edit.png'),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Divider(
                    color: AppColors.dividerColor,
                    thickness: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports',
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  labelColor: Colors.black,
                  indicatorColor: Colors.green,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _pages,
                  ),
                ),

              ],
            );
          }
          return Text('Some error occured please restart your application');
        }
      ),
    );
  }
}