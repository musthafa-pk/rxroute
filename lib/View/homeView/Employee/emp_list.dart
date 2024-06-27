import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxroute_test/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Util/Routes/routes_name.dart';
import '../../../Util/Utils.dart';
import '../../../res/app_url.dart';
import 'emp_details.dart';

class EmpList extends StatefulWidget {
  const EmpList({super.key});

  @override
  State<EmpList> createState() => _EmpListState();
}


class _EmpListState extends State<EmpList> {
  List<dynamic> employeesList = [];

  Future<dynamic> getemployees() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userID = preferences.getString('userID');
    String url = AppUrl.get_employee;
    Map<String, dynamic> data = {
      "manager_id": int.parse(userID.toString())
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(userID);
      print(response.body);
      print('st:${response.statusCode}');
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('employee list : $responseData');
        employeesList.clear();
        employeesList.addAll(responseData['data']);
        return employeesList;
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dynamic> deleteemployee(String empID) async {
    String url = AppUrl.delete_employee;
    Map<String, dynamic> data = {
      "rep_id": int.parse(empID.toString())
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('status code :${response.statusCode}');
      if (response.statusCode == 200) {
        var responsdata = jsonDecode(response.body);
        Navigator.pushNamed(context, RoutesName.successsplash);
        Utils.flushBarErrorMessage('${responsdata['message']}', context);
        getemployees();
      } else {
        var responseData = jsonDecode(response.body);
        Utils.flushBarErrorMessage('${responseData['message']}', context);
        throw Exception('Failed to load data (status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: const Text('Employee list',style: TextStyle(),),
        centerTitle: true,
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
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
              Expanded(
                child: FutureBuilder(
                  future: getemployees(),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.hasError){
                      return Center(child: Text('Some error occured !'),);
                    }else if(snapshot.hasData){
                      var snapdata = snapshot.data!;
                      return ListView.builder(
                          itemCount: snapdata.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  EmpDetails(empID: snapdata['id'],),));
                              },
                              child: ListTile(
                                leading:  CircleAvatar(
                                  child: Text('${snapdata[index]['name'][0]}'),
                                ),
                                title: Text('${snapdata[index]['name']}'),
                                subtitle: Text('${snapdata[index]['email']}'),
                                trailing: PopupMenuButton<String>(
                                  color: AppColors.whiteColor,
                                  onSelected: (String result){
                                    if(result == 'edit'){
                                      print('Edit action');
                                    }else if(result == 'delete'){
                                      _showDeleteConfirmationDialog(context, '${snapdata[index]['name']}','${snapdata[index]['id']}');
                                    }
                                  }, itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value:  'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value:  'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ),
                            );
                          }
                      );
                    }
                    return Text("Some error occured, Please restart your application ! ");
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void >_showDeleteConfirmationDialog(BuildContext context, String employeeName,String empID)async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Doctor"),
          content: Text("Do you want to delete $employeeName from the list?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: ()async {
                await deleteemployee(empID);
              },
            ),
          ],
        );
      },
    );
  }
}
