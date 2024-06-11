import 'package:flutter/material.dart';

class AddTravelPlan extends StatefulWidget {
  const AddTravelPlan({super.key});

  @override
  State<AddTravelPlan> createState() => _AddTravelPlanState();
}

class _AddTravelPlanState extends State<AddTravelPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Add TP'),
      ),
    );
  }
}
