import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/View/events/widgets/eventCardWidget.dart';
import 'package:rxroute_test/constants/styles.dart';
import 'package:rxroute_test/res/app_url.dart';

import '../../app_colors.dart';
import 'package:http/http.dart' as http;

class Events extends StatefulWidget {
  String eventType;
  Events({required this.eventType,super.key});

  @override
  State<Events> createState() => _EventsState();
}


class _EventsState extends State<Events> {

  List<dynamic> myevents = [];

  Future<dynamic> getEvents() async {
    final url = Uri.parse(AppUrl.getEvents);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        var responseData = jsonDecode(response.body);
        myevents.clear();
        myevents.addAll(responseData['todayEvents']);
        print('myevents:$myevents');
        // return json.decode(response.body);
        return myevents;
      } else {
        // If the server returns an error, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
        title: Text(
          widget.eventType.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child:Column(
          children: [
            FutureBuilder(
              future: getEvents(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasError){
                  return Center(child: Text('Some error occured !'),);
                }else if(snapshot.hasData){
                  return ListView.builder(
                  shrinkWrap: true,
                      itemCount: snapshot.data[0]['todayBirthday'].length,
                      itemBuilder: (context,index) {
                        var snapdata = snapshot.data[0]['todayBirthday'];
                        return Column(
                          children: [
                            Text('Birthday\'s',style:text60017black),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                        top: 10,
                                        bottom: 10,
                                        right: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hey !',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'Its ${snapdata[index]['doc_name']}\'s Birthday !',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Text(
                                            'Wish an all the Best',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.whiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            children: [
                                              CircleAvatar(radius: 25,child: Text('${snapdata[index]['doc_name'][0].toString().toUpperCase()}'),),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${snapdata[index]['doc_name']}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.whiteColor,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapdata[index]['doc_qualification']}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.whiteColor,
                                                      fontSize: 9,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          InkWell(
                                            onTap: ()async{

                                            },
                                            child: SizedBox(
                                              width: 130,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor2,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Notify me',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Icon(
                                                        Icons.notifications_active,
                                                        color: AppColors.whiteColor,
                                                      ),
                                                    ],
                                                  ),
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
                                        color: AppColors.primaryColor2,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(21),
                                          topRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Image.asset('assets/icons/cake.png'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                  );
                }else{
                  return Center(child: Text('No Data'),);
                }
                return Center(child: Text('Some error occured !,Please restart your application.'),);
              }
            ),
            SizedBox(height: 10,),
            FutureBuilder(
                future: getEvents(),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasError){
                    return Center(child: Text('Some error occured !'),);
                  }else if(snapshot.hasData){
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data[0]['todayAnniversary'].length,
                        itemBuilder: (context,index) {
                          var snapdata = snapshot.data[0]['todayAnniversary'];
                          return Column(
                            children: [
                              Text('Anniversary\'s',style:text60017black),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 25.0,
                                          top: 10,
                                          bottom: 10,
                                          right: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Hey !',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Its ${snapdata[index]['doc_name']}\'s Anniversary !',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Text(
                                              'Wish an all the Best',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.whiteColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                CircleAvatar(radius: 25,child: Text('${snapdata[index]['doc_name'][0].toString().toUpperCase()}'),),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${snapdata[index]['doc_name']}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.whiteColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${snapdata[index]['doc_qualification']}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.whiteColor,
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            InkWell(
                                              onTap: ()async{

                                              },
                                              child: SizedBox(
                                                width: 130,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryColor2,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Notify me',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: AppColors.whiteColor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons.notifications_active,
                                                          color: AppColors.whiteColor,
                                                        ),
                                                      ],
                                                    ),
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
                                          color: AppColors.primaryColor2,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(21),
                                            topRight: Radius.circular(6),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Icon(Icons.people_alt_outlined,color: AppColors.whiteColor,size: 30,),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                    );
                  }else{
                    return Center(child: Text('No Data'),);
                  }
                  return Center(child: Text('Some error occured !,Please restart your application.'),);
                }
            ),
          ],
        )
      ),
    );
  }
}
