import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/View/Add%20TP/add_tp.dart';
import 'package:rxroute_test/View/homeView/Doctor/add_doctor.dart';
import 'package:rxroute_test/View/homeView/chemist/add_chemist.dart';
import 'package:rxroute_test/View/homeView/chemist/chemistList.dart';
import 'package:rxroute_test/View/homeView/chemist/chemist_list.dart';
import 'package:rxroute_test/View/homeView/widgets/CustomDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Util/Utils.dart';
import '../../app_colors.dart';
import '../../res/app_url.dart';
import '../events/events.dart';
import '../events/widgets/eventCardWidget.dart';
import '../notification/notification.dart';
import 'Doctor/doctors_list.dart';
import 'Expense/expense_approvals.dart';
import 'Expense/expense_request.dart';
import 'Leave/LeaveRequest.dart';
import 'Leave/leaveApprovals.dart';

class HomeViewRep extends StatefulWidget {
  const HomeViewRep({super.key});

  @override
  State<HomeViewRep> createState() => _HomeViewRepState();
}

class _HomeViewRepState extends State<HomeViewRep> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> list_of_doctors = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // To handle loading state
  bool _isSearching = false;


  Future<dynamic> totaldoctorscount() async {
    String url = AppUrl.totaldoctorscount;

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      // print(jsonEncode(data));
      print('${response.statusCode}');
      print('${response.body}');
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> searchdoctors() async {
    String url = AppUrl.searchdoctors;
    Map<String, dynamic> data = {
      "searchData": _searchController.text
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
        print('filtered list : $responseData');
        setState(() {
          list_of_doctors = responseData['data'];
          _isSearching = true;
        });
        if (responseData['data'].isEmpty) {
          getdoctors();
        }
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> getdoctors() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uniqueId = preferences.getString('uniqueID');
    String url = AppUrl.getdoctors;
    Map<String, dynamic> data = {
      "rep_UniqueId": uniqueId
    };

    try {
      if (preferences.getString('uniqueID')!.isEmpty) {
        Utils.flushBarErrorMessage('Please login again!', context);
        return;
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('$data');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('doctors list : $responseData');
        setState(() {
          list_of_doctors = responseData['data'];
          _isLoading = false;
        });
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data: $e');
    }
  }

  _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      getdoctors();
    } else {
      searchdoctors();
    }
  }

  Future<dynamic> totalrepcount() async {
    String url = AppUrl.totalrepcount;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Parsed Response Data: $responseData'); // Added print statement
        return responseData;
      } else {
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      print('Exception: $e'); // Added print statement for exceptions
      throw Exception('Failed to load data: $e');
    }
  }
  Future<void>refreshfunction()async{
    await totalrepcount();
    await totaldoctorscount();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totaldoctorscount();
    totalrepcount();
    _searchController.addListener(_onSearchChanged);
    getdoctors(); // Fetch the initial list of doctors
  }
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      key: _scaffoldKey,
      drawer:  CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading:InkWell(
            onTap: (){
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(Icons.menu)),
        actions: [
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Notifications(),));
              },
              child: const Icon(Icons.notifications_active,color: AppColors.primaryColor,size: 35,)),
          const SizedBox(width: 20,),
        ],
        title: const Text('RXRoute',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor2
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddDoctor(),));
        },
        child: const Row(
          children: [
            Icon(Icons.add,color: AppColors.whiteColor,),
            SizedBox(width: 10,),
            Text('Add Doctor',style: TextStyle(
              color: AppColors.whiteColor
            ),),
          ],
        ),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: refreshfunction,
        child: SingleChildScrollView(
          child: SafeArea(
            child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset('assets/icons/settings.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 155,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      height: 120,
                                      width: 224,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Total Doctor',style: TextStyle(color: AppColors.whiteColor,fontSize:14,fontWeight: FontWeight.w600),),
                                            FutureBuilder(
                                              future: totaldoctorscount(),
                                              builder: (context,snapshot) {
                                                if(snapshot.connectionState == ConnectionState.waiting){
                                                  return Center(child: CircularProgressIndicator(backgroundColor: AppColors.whiteColor,),);
                                                }else if(snapshot.hasError){
                                                  return Center(child: Text('Some error occured !',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400)),);
                                                }else if(snapshot.hasData){
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${snapshot.data['get_count']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 28,fontWeight: FontWeight.w600),),
                                                      Text('Updated : ${snapshot.data['lastDrAddedDate']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400),),
                                                    ],
                                                  );
                                                }
                                                return Text('Some error occured , Please restart your application !',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400));
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      height: 120,
                                      width: 224,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: FutureBuilder(
                                          future: totalrepcount(),
                                          builder: (context,snapshot) {
                                            if(snapshot.connectionState == ConnectionState.waiting){
                                              return Center(child: CircularProgressIndicator(backgroundColor: AppColors.whiteColor,),);
                                            }else if(snapshot.hasError){
                                              return Center(child: Text('Some error happened !',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400)),);
                                            }else if(snapshot.hasData){
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Total Employee',style: TextStyle(color: AppColors.whiteColor,fontSize:14,fontWeight: FontWeight.w600),),
                                                  Text('${snapshot.data['get_count']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 28,fontWeight: FontWeight.w600),),
                                                  Text('Updated : ${snapshot.data['lastRepAddedDate']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400),),
                                                ],
                                              );
                                            }
                                            return Text('Some error occured , Please restart your application !',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400)) ;
                                          }
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    crossAxisCount: 4,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorsList(),));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Image.asset('assets/icons/dctlist.png')),
                            const Column(
                              children: [
                                Text('Doctors',style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                                Text('List',style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                              ],
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveApprovals(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/lvapprove.png')),
                              const Column(
                                children: [
                                  Text('My',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Leaves',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaveApplyPage(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/lvrequest.png')),
                              const Column(
                                children: [
                                  Text('Leave',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Request',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseRequestPage(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/tp.png')),
                              const Column(
                                children: [
                                  Text('Expense',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Request',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseApprovals(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/expense.png')),
                              const Column(
                                children: [
                                  Text('My',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Expenses',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddChemist(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/chemist.png')),
                              const Column(
                                children: [
                                  Text('Add',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Chemist',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTravelPlan(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/tp.png')),
                              const Column(
                                children: [
                                  Text('Travel',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('Plan',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Chemistlist(),));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset('assets/icons/chemist_list.png')),
                              const Column(
                                children: [
                                  Text('Chemist',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  Text('List',style: TextStyle(
                                      fontWeight: FontWeight.w600
                                  ),),
                                ],
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
                      const Text('Todays Events',style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Events(eventType: 'Todays Events'),));
                        },
                        child: const Text('See all',style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            decoration: TextDecoration.underline),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const EventCardWidget(),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Upcoming Events',style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Events(eventType: 'Upcoming Events'),));
                        },
                        child: const Text('See all',style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            decoration: TextDecoration.underline),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0,top: 10,bottom: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hey !',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 12),),
                              const Text('Its Heleena Hills Birthday !',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 12),),
                              const Text('Wish her all the Best',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 12)),
                              const SizedBox(height: 30,),
                              const Row(
                                children: [
                                  CircleAvatar(radius: 25,),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Dr.Helena Hills',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 12)),
                                      Text('Pediatrition',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 9)),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                width: 130,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor2,
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Notify me',style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 12)),
                                        SizedBox(width: 10,),
                                        Icon(Icons.notifications_active,color: AppColors.whiteColor,),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 70,
                          width: 100,
                          decoration: const BoxDecoration(
                              color:AppColors.primaryColor2,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21),topRight: Radius.circular(6))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset('assets/icons/cake.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 70,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

