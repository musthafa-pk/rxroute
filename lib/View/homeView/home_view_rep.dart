import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/View/Add%20TP/add_tp.dart';
import 'package:rxroute_test/View/homeView/Doctor/add_doctor.dart';
import 'package:rxroute_test/View/homeView/chemist/add_chemist.dart';
import 'package:rxroute_test/View/homeView/widgets/CustomDrawer.dart';
import 'package:http/http.dart' as http;
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


  Future<dynamic> totaldoctorscount() async {
    String url = AppUrl.totaldoctorscount;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        // body: jsonEncode(data),
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

  Future<dynamic> totalrepcount() async {
    String url = AppUrl.totalrepcount;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        // body: jsonEncode(data),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDoctor(),));
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
      body: SingleChildScrollView(
        child: SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5,color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                            height: 25,width: 25,
                            child: Image.asset('assets/icons/settings.png')),
                      ),
                    )
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
                                                return Center(child: CircularProgressIndicator(),);
                                              }else if(snapshot.hasError){
                                                return Center(child: Text('Some error occured !'),);
                                              }else if(snapshot.hasData){
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('${snapshot.data['get_count']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 28,fontWeight: FontWeight.w600),),
                                                    Text('Updated : ${snapshot.data['lastDrAddedDate']}',style: TextStyle(color: AppColors.whiteColor,fontSize: 12,fontWeight: FontWeight.w400),),
                                                  ],
                                                );
                                              }
                                              return Text('Some error occured , Please restart your application !');
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
                                            return Center(child: CircularProgressIndicator(),);
                                          }else if(snapshot.hasError){
                                            return Center(child: Text('Some error happened !'),);
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
                                          return Text('Some error occured , Please restart your application !') ;
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
                                Text('Leave',style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                                Text('Approvals',style: TextStyle(
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
                            Expanded(child: Image.asset('assets/icons/expreq.png')),
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
                            Expanded(child: Image.asset('assets/icons/expapprove.png')),
                            const Column(
                              children: [
                                Text('Expense',style: TextStyle(
                                    fontWeight: FontWeight.w600
                                ),),
                                Text('Approvals',style: TextStyle(
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
    );
  }
}

