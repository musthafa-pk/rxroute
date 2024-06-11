import 'package:flutter/material.dart';
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/View/homeView/Leave/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_colors.dart';

class LeaveApprovals extends StatefulWidget {
  const LeaveApprovals({super.key});

  @override
  State<LeaveApprovals> createState() => _LeaveApprovalsState();
}

class _LeaveApprovalsState extends State<LeaveApprovals> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<Widget> _tabs = [
    const Tab(text: 'Approved'),
    const Tab(text: 'Rejected'),
    const Tab(text: 'Pending'),
  ];

  List<Widget> _pages = [];



  SharedPreferences? preferences;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

     _pages = [
      LeaveApprovalsWidgets.approved('Rep123'),
      LeaveApprovalsWidgets.rejected('Rep123'),
      LeaveApprovalsWidgets.pending('Rep123'),
    ];
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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: const Text('Leave Approvals', style: TextStyle(color: Colors.black)),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Colors.black,
          indicatorColor: Colors.green,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
