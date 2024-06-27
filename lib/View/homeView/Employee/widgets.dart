import 'package:flutter/material.dart';
import 'package:rxroute_test/constants/styles.dart';

class EmpDetailsWidgets{

  static Widget BasicInfo(List<dynamic> doctordetails) {
    return  Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information'),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                  Text('${doctordetails[0]['doc_name']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
                  Text('${doctordetails[0]['gender'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qualification',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                  Text('${doctordetails[0]['doc_qualification'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date of Birth',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
                  Text('${doctordetails[0]['date_of_birth'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone number',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
                  Text('${doctordetails[0]['mobile'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('Designation',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
              //     Text('${doctordetails[0]['designation']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
              //   ],
              // ),
            ],
          ),
          Text('Email',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12),),
          Text('${doctordetails[0]['email'] ?? "N/A"}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
          Text('Nationality',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
          Text('${doctordetails[0]['nationality'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
          Text('Address',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),
          Text('${doctordetails[0]['address'] ?? 'N/A'}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
        ],
      ),
    );
  }

  static Widget Documents(List<dynamic> doctordetails) {
    return  Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Documents'),
          SizedBox(height: 10,),
          Text('Products',style: text60014black),

          ListView.builder(
            shrinkWrap: true,
            itemCount: doctordetails[0]['products'].length,
            itemBuilder: (context,index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${doctordetails[0]['products'][index]['product']}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12))
              );
            }
          ) ,
          Text('Chemists'),
          Expanded(
            child: ListView.builder(
              itemCount: doctordetails[0]['chemist'].length,
              itemBuilder: (context,index) {
                return Text('${doctordetails[0]['chemist'][0]['address']}');
              }
            ),
          )
        ],
      ),
    );
  }

  static Widget Notes(List<dynamic> doctordetails) {
    return  Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notes'),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}