import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/View/homeView/Employee/widgets.dart';
import 'package:rxroute_test/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../../Util/Utils.dart';
import '../../../res/app_url.dart';

class EmpDetails extends StatefulWidget {
  int empID;
   EmpDetails({required this.empID,super.key});

  @override
  State<EmpDetails> createState() => _EmpDetailsState();
}

class _EmpDetailsState extends State<EmpDetails> {

  List<dynamic> empDetails = [];

  final List<Widget> _tabs = [
    const Tab(text: 'Basic information'),
    const Tab(text: 'Documents'),
    const Tab(text: 'Notes'),
  ];



  Future<dynamic> single_employee_details() async {
    String url = AppUrl.single_employee_details;
    Map<String,dynamic> data = {
      "dr_id":widget.empID
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
        empDetails.clear();
        empDetails.addAll(responseData['data']);
        return empDetails;
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
    print('emp id:${widget.empID}');
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width/3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: (){},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call, color: AppColors.whiteColor),
                SizedBox(width: 10),
                Text('Call', style: TextStyle(color: AppColors.whiteColor)),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: const Text('Employee Details', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: single_employee_details(),
            builder: (context,snapshot) {
              final List<Widget> _pages = [
                EmpDetailsWidgets.BasicInfo(snapshot.data),
                const Center(child: Text('Search Page')),
                const Center(child: Text('Profile Page')),
              ];
              return Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 50,
                    ),
                    title: const Text('Helena Hills', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MA, MSC', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                        Text('Representative', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/icons/edit.png'),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TabBar(
                    tabs: _tabs,
                    labelColor: Colors.black,
                    indicatorColor: Colors.green,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _pages,
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
