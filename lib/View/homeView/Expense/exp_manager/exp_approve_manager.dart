import 'package:flutter/material.dart';
import 'package:rxroute_test/Util/Utils.dart';
import 'package:rxroute_test/View/homeView/Expense/exp_manager/exp_approval_mngr_widgets.dart';
import 'package:rxroute_test/View/homeView/Expense/widgets.dart';

import '../../../../app_colors.dart';
//accept or reject
class ExpenseApprovalsManager extends StatefulWidget {
  const ExpenseApprovalsManager({super.key});

  @override
  State<ExpenseApprovalsManager> createState() => _ExpenseApprovalsManagerState();
}

class _ExpenseApprovalsManagerState extends State<ExpenseApprovalsManager> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<Widget> _tabs = [
    const Tab(text: 'Accepted'),
    const Tab(text: 'Rejected'),
    const Tab(text: 'Pending'),
  ];

  final List<Widget> _pages = [
    ExpenseApprovalManagerWidgets.approved("${Utils.uniqueID}"),
    ExpenseApprovalManagerWidgets.rejected("${Utils.uniqueID}"),
    ExpenseApprovalManagerWidgets.pending("${Utils.uniqueID}"),
  ];

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
        title: const Text('Approve Expenses', style: TextStyle(color: Colors.black)),
        centerTitle: true,
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
